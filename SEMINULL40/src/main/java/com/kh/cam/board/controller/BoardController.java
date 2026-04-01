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
	
	@GetMapping("/list")
	public String boardList(
	        @RequestParam(value="category", required=false, defaultValue="all") String category,
	        Model model) {
	    
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    int uniNo = 0;
	    if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
	        uniNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getUniNo();
	    }

	    // 1. 카테고리 목록 동적 조회 (화면 탭 구성용)
	    List<Map<String, Object>> catList = boardService.selectCategoryList(uniNo);
	    model.addAttribute("catList", catList);

	    // 2. 게시글 목록 조회
	    Map<String, Object> params = new HashMap<>();
	    params.put("category", category);
	    params.put("uniNo", uniNo);

	    List<Board> list = boardService.selectBoardList(params);
	    model.addAttribute("boardList", list);
	    model.addAttribute("cur", category);
	    
	    return "board/board";
	}
	
	// 글쓰기 폼 전송
	@GetMapping("/write")
	public String writeForm(@RequestParam(value="category", required=false) String category, Model model) {
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    int uniNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getUniNo();
	    
	    // 카테고리 목록을 가져와서 select 박스에 뿌려줌
	    model.addAttribute("catList", boardService.selectCategoryList(uniNo));
	    return "board/writeBoard";
	}
	
	// [등록] 카테고리 로직 보강
	@PostMapping("/insert.bo")
	public String insertBoard(Board b, 
	                          @RequestParam(value="category") String category, 
	                          @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, 
	                          HttpSession session) {
	    
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    if(auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
	        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
	        b.setBoardWriter(userDetails.getMember().getMemNo()); 
	        b.setUniNo(userDetails.getMember().getUniNo()); 
	        
	        // 중요: 화면에서 '자유게시판'이라는 글자가 직접 넘어오므로 바로 세팅
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
	    return (result > 0) ? "redirect:/board/list?category=" + category : "common/errorPage";
	}

	@GetMapping("/updateForm")
	public String updateForm(@RequestParam("boardno") int boardNo, Model model) {
		model.addAttribute("b", boardService.selectBoard(boardNo));
		model.addAttribute("list", boardService.selectAttachmentList(boardNo));
		return "board/writeBoard";		
	}
	
	// [수정] 카테고리 및 학교정보 로직 추가
	@PostMapping("/update.bo")
	public String updateBoard(Board b, 
	                          @RequestParam(value="category", defaultValue="free") String category, // category 파라미터 추가
                              @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, 
			                  @RequestParam(value="deleteFileNos", required=false) String deleteFileNos, 
			                  HttpSession session) {
		
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if(auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            b.setBoardWriter(userDetails.getMember().getMemNo());
            b.setUniNo(userDetails.getMember().getUniNo()); // 매퍼 서브쿼리용 학교번호
            
            // 카테고리 매핑 (수정 시에도 필수)
            String categoryName = "자유게시판"; 
            if("qna".equals(category)) categoryName = "질문답변";
            else if("accident".equals(category)) categoryName = "사건사고";
            b.setCategoryName(categoryName);
        }

		List<Attachment> list = new ArrayList<>();
		if(upfiles != null) {
			String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
			for(MultipartFile f : upfiles) {
				if(!f.getOriginalFilename().equals("")) {
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
		return (result > 0) ? "redirect:/board/detail?boardno=" + b.getBoardNo() : "common/errorPage";
	}
	
	@PostMapping("/delete")
	public String deleteBoard(@RequestParam("boardno") int boardNo, Model model) {
	    // 여기서 넘겨주는 boardNo가 매퍼의 #{boardNo}와 연결됩니다.
	    int result = boardService.deleteBoard(boardNo); 
	    
	    if(result > 0) return "redirect:/board/list";
	    else {
	        model.addAttribute("errorMsg", "게시글 삭제 실패");
	        return "common/errorPage";
	    }
	}
	
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
	public String insertReport(@RequestParam Map<String, Object> map, HttpSession session) {
	    
	    // 세션에서 로그인 유저 객체를 꺼내오는 방식 (본인 프로젝트의 세션 키값을 확인하세요)
	    // 보통 loginUser나 member 등의 이름으로 저장되어 있습니다.
	    Member loginUser = (Member)session.getAttribute("loginUser");
	    
	    if(loginUser != null) {
	        map.put("reportMem", loginUser.getMemNo()); // 로그인한 사람의 진짜 번호 넣기
	    } else {
	        map.put("reportMem", 1); // 로그인 안 되어있으면 임시로 1번 (테스트용)
	    }

	    return (boardService.insertReport(map) > 0) ? "success" : "fail";
	}
}