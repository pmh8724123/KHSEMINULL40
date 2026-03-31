package com.kh.cam.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelExtensionsKt;
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
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		System.out.println(user.getMember().getMemName()+"/"+user.getAuthorities());
		
		
		
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
	public String insertBoard(Board b, MultipartFile[] upfiles, HttpSession session) {
	    // b.getUbtypeNo()에 JSP에서 선택한 1, 2, 3이 자동으로 들어옵니다.
	    b.setBoardWriter(1); // 로그인 기능 구현 전 테스트용

	    List<Attachment> list = new ArrayList<>();
	    if(upfiles != null) {
	        String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
	        makeDirectory(savePath); // 폴더 생성 공통 메서드 호출

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
	public String updateBoard(Board b, MultipartFile[] upfiles,
			  String deleteFileNos
			, HttpSession session) {
		
		List<Attachment> list = new ArrayList<>();
		
		// 새로운 첨부파일이 있는지 확인
		if(upfiles !=null) {
			String savePath = session.getServletContext().getRealPath("resources/upload_files/");
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
		// JSP에서 <select name="ubtypeNo"> 값을 보내므로 b.ubtypeNo에 자동 매핑됨
		int result = boardService.updateBoard(b, list, deleteFileNos);
		return (result > 0) ? "redirect:/board/detail?boardno=" + b.getBoardNo() : "common/errorPage";
	}
	
	// 게시글 삭제
	@GetMapping("/delete")
	public String deleteBoard(@RequestParam("boardno")int boardNo, HttpSession session, Model model) {
		
		// 1. 로그인 유저와 작성자 비교 로직 (나중)
		/*
		 * Member loginUser = (Member)session.getAttribute("loginUser");
		 * Board b = boardService.selectBoard(boardNo);
		 * if(loginUser == null || loginUser.getMemno() != b.getBoardWriter()){
		 * 	model.addAttribute("erroMsg", "삭제 권한이 없습니다.");
		 * 	return "common/errorPage";
		 * }
		 */
		
		// 2. 삭제 서비스 호출
		int result = boardService.deleteBoard(boardNo);
		
		if(result > 0) {
			// 삭제 성공시 리스트 페이지로 이동
			return "redirect:/board/list";
		}else {
			model.addAttribute("errorMsg","게시글 삭제 실패");
			return "common/errorPage";
		}
	}
	
	
	
	// 게시글 상세보기
	@GetMapping("/detail")
	public String boardDetail(@RequestParam("boardno") int boardNo, Model model) {
		if(boardService.increaseCount(boardNo) > 0) {
			model.addAttribute("b", boardService.selectBoard(boardNo));
			model.addAttribute("list", boardService.selectAttachmentList(boardNo));
			return "board/boardDetail";
		} else {
			model.addAttribute("errorMsg", "게시글 조회 실패");
			return "common/errorPage";
		}
	}

	// --- 공통 메서드 (중복 제거) ---

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