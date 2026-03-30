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
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.member.model.vo.CustomUserDetails; // [추가] 반드시 import 확인

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@Slf4j
public class BoardController {
	
	@Autowired
	private BoardService boardService; 

	// 게시글 목록 조회
	@GetMapping("/list")
	public String boardList(
			@RequestParam(value="category", required=false, defaultValue="all") String category,
			Model model) {
		List<Board> list = boardService.selectBoardList(category);
		model.addAttribute("boardList", list);
		model.addAttribute("cur", category);
		return "board/board";
	}
	
	// 글쓰기 페이지 이동
	@GetMapping("/write")
	public String writeForm(@RequestParam(value="category", required=false) String category) {
		return "board/writeBoard";
	}
	
	// 게시글 등록
	@PostMapping("/insert.bo")
	public String insertBoard(Board b, 
                              @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, // [수정] @RequestParam 추가
                              HttpSession session) {
	    
	    // 1. Spring Security에서 현재 인증된 유저 정보를 가져옵니다.
	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    Object principal = auth.getPrincipal();
	    
	    // 2. Principal 객체가 CustomUserDetails 타입인지 확인 후 형변환
	    // Member로 바로 형변환하면 ClassCastException이 발생하므로 단계를 거칩니다.
	    if(principal instanceof CustomUserDetails) {
	        CustomUserDetails userDetails = (CustomUserDetails) principal;
	        // CustomUserDetails 내부의 Member 객체에서 memNo를 추출하여 세팅
	        b.setBoardWriter(userDetails.getMember().getMemNo()); 
	    } else {
	        // 로그인 정보가 없으면 로그인 페이지로 리다이렉트
	        return "redirect:/member/login.me"; 
	    }

	    // --- 첨부파일 처리 로직 ---
	    List<Attachment> list = new ArrayList<>();
	    if(upfiles != null) {
	        String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
	        makeDirectory(savePath); 

	        for(MultipartFile f : upfiles) {
	            if(!f.getOriginalFilename().equals("")) {
	                String changeName = saveFile(f, savePath); 
	                Attachment at = new Attachment();
	                at.setOriginName(f.getOriginalFilename());
	                at.setChangeName(changeName);
	                at.setTargetType("BOARD");
	                list.add(at);
	            }
	        }
	    }

	    // DB 저장 실행
	    int result = boardService.insertBoard(b, list);
	    
	    return (result > 0) ? "redirect:/board/list" : "common/errorPage";
	}

	// 수정페이지 이동
	@GetMapping("/updateForm")
	public String updateForm(@RequestParam("boardno") int boardNo, Model model) {
		model.addAttribute("b", boardService.selectBoard(boardNo));
		model.addAttribute("list",boardService.selectAttachmentList(boardNo));
		return "board/writeBoard";		
	}
	
	// 게시글 수정
	@PostMapping("/update.bo")
	public String updateBoard(Board b, 
                              @RequestParam(value="upfiles", required=false) MultipartFile[] upfiles, // [수정] @RequestParam 추가
			                  @RequestParam(value="deleteFileNos", required=false) String deleteFileNos, // [수정] @RequestParam 추가
			                  HttpSession session) {
		
        // 수정 시에도 작성자 정보를 보강 (권한 확인용 등으로 필요할 수 있음)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if(auth.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            b.setBoardWriter(userDetails.getMember().getMemNo());
        }

		List<Attachment> list = new ArrayList<>();
		
		if(upfiles !=null) {
			String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
			for(MultipartFile f : upfiles) {
				if(!f.getOriginalFilename().equals("")) {
					String changeName = saveFile(f,savePath);
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
	
	// 게시글 삭제
	@GetMapping("/delete")
	public String deleteBoard(@RequestParam("boardno")int boardNo, HttpSession session, Model model) {
		int result = boardService.deleteBoard(boardNo);
		
		if(result > 0) {
			return "redirect:/board/list";
		}else {
			model.addAttribute("errorMsg","게시글 삭제 실패");
			return "common/errorPage";
		}
	}
	
	// 게시글 상세보기
	@GetMapping("/detail")
	public String boardDetail(@RequestParam("boardno") int boardNo,
			HttpServletRequest request,
			HttpServletResponse response,
			Model model) {
		// 게시글 상세 데이터 먼저 조회
		Board b = boardService.selectBoard(boardNo);
		List<Attachment> list = boardService.selectAttachmentList(boardNo);
		
		if(b == null) {
			model.addAttribute("errorMsg","존재하지 않는 게시글 입니다.");
			return "common/errorMsg";
		}
		
		// 로그인 유저 정보 가져오기
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		int loginUserNo = 0;
		if(auth !=null && auth.getPrincipal()instanceof CustomUserDetails) {
			loginUserNo = ((CustomUserDetails)auth.getPrincipal()).getMember().getMemNo();
		}
		
		// 조회수 증가 로직 (쿠키 사용) - 작성자가 아닐 때만
		if(loginUserNo != b.getBoardWriter()) {
			
			Cookie[] cookies = request.getCookies();
			Cookie viewCookie = null;
			
			// view_board_번호 형태의 쿠기가 있는지
			if(cookies != null) {
				for(Cookie c : cookies) {
					if(c.getName().equals("view_board_"+boardNo)) {
						viewCookie = c;
						break;
					}
				}
			}
			// 쿠키가 없다면
			if(viewCookie == null) {
				// 조회수 증가 DB 반영
				int result = boardService.increaseCount(boardNo);
				
				if(result > 0) {
					// 화면 즉시 반영
					b.setViewCount(b.getViewCount()+1);
					
					// 쿠키 생성
					Cookie newCookie = new Cookie("view_board_"+boardNo,"true");
					newCookie.setMaxAge(24*60*60);
					newCookie.setPath("/");
					response.addCookie(newCookie);
				}
			}
		}
		model.addAttribute("b",b);
		model.addAttribute("list",list);
		
		return "board/boardDetail";		
	}

	// --- 공통 메서드 ---
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

	// --- Ajax 응답 메서드들 ---
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
		return "board/report";		
	}
	
	@ResponseBody
	@PostMapping(value = "/report", produces = "text/html; charset=UTF-8")
	public String insertReport(@RequestParam Map<String, Object> map) {
	    map.put("reportMem", 1); // 테스트용 유저 번호
	    return (boardService.insertReport(map) > 0) ? "success" : "fail";
	}
}