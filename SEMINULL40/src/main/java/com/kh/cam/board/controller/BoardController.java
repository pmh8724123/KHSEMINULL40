package com.kh.cam.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // 추가됨

import com.kh.cam.board.model.service.BoardService;
import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.board.model.vo.Board;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@Slf4j
public class BoardController {
	
	@Autowired
	private BoardService boardService; 
	
	// 게시글 목록
	@GetMapping("/list")
	public String boardList(
	        @RequestParam(value="category", required=false, defaultValue="all") String category,
	        Model model) {
	    
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    int uniNo = 0;
	    if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
	        uniNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getUniNo();
	    }

	    List<Map<String, Object>> catList = boardService.selectCategoryList(uniNo);
	    model.addAttribute("catList", catList);

	    Map<String, Object> params = new HashMap<>();
	    params.put("category", category);
	    params.put("uniNo", uniNo);

	    List<Board> list = boardService.selectBoardList(params);
	    model.addAttribute("boardList", list);
	    model.addAttribute("cur", category);
	    
	    return "board/board";
	}
	// 게시글 작성
	@GetMapping("/write")
	public String writeForm(@RequestParam(value="category", required=false) String category, Model model) {
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    int uniNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getUniNo();
	    
	    model.addAttribute("catList", boardService.selectCategoryList(uniNo));
	    return "board/writeBoard";
	}
	
	// [등록] RedirectAttributes 추가하여 한글 인코딩 문제 해결
	@PostMapping("/insert.bo")
	public String insertBoard(Board b, 
	                          @RequestParam(value="category") String category, 
	                          @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, 
	                          HttpSession session,
	                          RedirectAttributes rdAttr) { // 파라미터 추가
	    
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    if(auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
	        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
	        b.setBoardWriter(userDetails.getMember().getMemNo()); 
	        b.setUniNo(userDetails.getMember().getUniNo()); 
	        b.setCategoryName(category); 
	    } else {
	        return "redirect:/member/login.me"; 
	    }

	    List<Attachment> list = new ArrayList<>();
	    if(upfiles != null) {
	        String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
	        makeDirectory(savePath);
	        for(MultipartFile f : upfiles) {
	            if(f != null && !f.getOriginalFilename().equals("")) {
	                String changeName = saveFile(f, savePath);
	                Attachment at = new Attachment();
	                at.setOriginName(f.getOriginalFilename());
	                at.setChangeName(changeName);
	                at.setTargetType("BOARD");
	                list.add(at);
	            }
	        }
	    }

	    int result = boardService.insertBoard(b, list);
	    
	    if(result > 0) {
	        // RedirectAttributes를 사용하면 한글 인코딩을 자동으로 처리함
	        rdAttr.addAttribute("category", category);
	        return "redirect:/board/list";
	    } else {
	        return "common/errorPage";
	    }
	}
	// 게시글 수정 
	@GetMapping("/updateForm")
	public String updateForm(@RequestParam("boardno") int boardNo, Model model) {
		// 1. 수정할 게시글 상세 정보 조회
		Board b = boardService.selectBoard(boardNo);
		
		// 2. 카테고리 목록을 불러오기 위해 학교 번호(uniNo) 가져오기
		// 게시글 정보(b)에 담긴 uniNo를 쓰거나, 로그인한 사용자의 uniNo를 씁니다.
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		int uniNo = 0;
		if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
			uniNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getUniNo();
		}
		
		// 3. ⭐ 이 코드가 추가되어야 카테고리가 나옵니다! ⭐
		List<Map<String, Object>> catList = boardService.selectCategoryList(uniNo);
		model.addAttribute("catList", catList);
		
		// 4. 기존 데이터 담기
		model.addAttribute("b", b);
		model.addAttribute("list", boardService.selectAttachmentList(boardNo));
		
		return "board/writeBoard";		
	}
	
	@PostMapping("/update.bo")
	public String updateBoard(Board b, 
	                          @RequestParam(value="category") String category, // defaultValue 제거 (필수값)
	                          @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, 
			                  @RequestParam(value="deleteFileNos", required=false) String deleteFileNos, 
			                  HttpSession session) {
		
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if(auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            b.setBoardWriter(userDetails.getMember().getMemNo());
            b.setUniNo(userDetails.getMember().getUniNo()); 
            
            // 🔥 [수정] 복잡한 if-else 제거. 
            // JSP에서 넘어온 카테고리 이름(BTYPE_NAME)을 그대로 저장합니다.
            b.setCategoryName(category);
        }

		List<Attachment> list = new ArrayList<>();
		if(upfiles != null) {
			String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
			for(MultipartFile f : upfiles) {
				// 파일이 실제로 첨부되었을 때만 처리
				if(f != null && !f.getOriginalFilename().equals("")) {
					String changeName = saveFile(f, savePath);
					Attachment at = new Attachment();
					at.setOriginName(f.getOriginalFilename());
					at.setChangeName(changeName);
					at.setTargetType("BOARD");
					at.setTargetNo(b.getBoardNo());
					list.add(at);
				}
			}
		}	

		int result = boardService.updateBoard(b, list, deleteFileNos);
		
		// 성공 시 상세페이지로 리다이렉트
		return (result > 0) ? "redirect:/board/detail?boardno=" + b.getBoardNo() : "common/errorPage";
	}
	// 게시글 삭제
	@PostMapping("/delete")
	public String deleteBoard(@RequestParam("boardno") int boardNo, Model model) {
	    int result = boardService.deleteBoard(boardNo); 
	    
	    if(result > 0) return "redirect:/board/list";
	    else {
	        model.addAttribute("errorMsg", "게시글 삭제 실패");
	        return "common/errorPage";
	    }
	}
	// 게시글 상세보기
	@GetMapping("/detail")
	public String boardDetail(@RequestParam("boardno") int boardNo, HttpServletRequest request, HttpServletResponse response, Model model) {
		Board b = boardService.selectBoard(boardNo);
		List<Attachment> list = boardService.selectAttachmentList(boardNo);
		
		if(b == null) {
			model.addAttribute("errorMsg", "존재하지 않는 게시글입니다.");
			return "common/errorPage";
		}
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		int loginUserNo = 0;
		if(auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
			loginUserNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getMemNo();
		}
		
		if(loginUserNo != b.getBoardWriter()) {
			Cookie[] cookies = request.getCookies();
			Cookie viewCookie = null;
			if(cookies != null) {
				for(Cookie c : cookies) {
					if(c.getName().equals("view_board_" + boardNo)) {
						viewCookie = c;
						break;
					}
				}
			}
			if(viewCookie == null) {
				int result = boardService.increaseCount(boardNo);
				if(result > 0) {
					b.setViewCount(b.getViewCount() + 1);
					Cookie newCookie = new Cookie("view_board_" + boardNo, "true");
					newCookie.setMaxAge(24 * 60 * 60);
					newCookie.setPath("/");
					response.addCookie(newCookie);
				}
			}
		}
		model.addAttribute("b", b);
		model.addAttribute("list", list);
		return "board/boardDetail";		
	}
	// 파일 저장
	private void makeDirectory(String path) {
	    File dir = new File(path);
	    if(!dir.exists()) dir.mkdirs();
	}

	private String saveFile(MultipartFile upfile, String savePath) {
	    String originName = upfile.getOriginalFilename();
	    String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	    int ranNum = (int)(Math.random() * 90000 + 10000);
	    String ext = originName.substring(originName.lastIndexOf("."));
	    String changeName = currentTime + ranNum + ext;
	    try {
	        upfile.transferTo(new File(savePath + changeName));
	    } catch (IOException e) {
	        log.error("파일 저장 오류: {}", e.getMessage());
	    }
	    return changeName;
	}
	// 좋아요 입력
	@ResponseBody
	@PostMapping(value = "/like", produces = "text/html; charset=UTF-8")
	public String boardLike(int boardNo, int memNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("boardNo", boardNo);
		map.put("memNo", memNo);
		if(boardService.checkLike(map) > 0) {
			boardService.deleteLike(map);
			return "delete";
		} else {
			boardService.insertLike(map);
			return "insert";
		}
	}
		
	@ResponseBody
	@GetMapping("/likeCount")
	public int getLikeCount(int boardNo) {
		return boardService.selectLikeCount(boardNo);
	}
	
	@GetMapping("/report")
	public String report(@RequestParam("boardNo") int boardNo, Model model) {
		model.addAttribute("boardNo", boardNo);
		return "board/boardReport";		
	}
	
	@ResponseBody
	@PostMapping(value = "/report", produces = "text/html; charset=UTF-8")
	public String insertReport(@RequestParam Map<String, Object> map) {
		CustomUserDetails loginUser = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
	    map.put("reportMem", loginUser.getMember().getMemNo()); 
	    

	    return (boardService.insertReport(map) > 0) ? "success" : "fail";
	}
}