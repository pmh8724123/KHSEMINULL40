package com.kh.cam.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date; // java.sql.Date 대신 java.util.Date를 사용하세요
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired; // 추가
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

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@Slf4j
public class BoardController {
	
	// 1. Service 주입 (이 부분이 있어야 BoardService.메소드 호출이 가능합니다)
	@Autowired
	private BoardService boardService; 

	@GetMapping("/list")
	public String boardList(
			@RequestParam(value="category", required=false, defaultValue="all") String category,
			Model model) {
		log.info("현재 선택된 카테고리: {}", category);
		
		List<Board> list = boardService.selectBoardList(category);
		
		model.addAttribute("boardList",list);
		model.addAttribute("cur",category);
		
		return "board/board";
	}
	
	@GetMapping("/write")
	public String writeForm(
			@RequestParam(value="category", required=false) String category,
			Model model) {
		log.info("글쓰기 진입 카테고리: {}", category);
		return "board/writeBoard";
	}
	
	@PostMapping("/insert.bo")
	public String insertBoard(Board b, String category, MultipartFile[] upfiles, HttpSession session) {
	    
	    // 카테고리 매핑 로직
	    int ubtypeNo = 1; 
	    if("qna".equals(category)) ubtypeNo = 2;
	    else if("notice".equals(category)) ubtypeNo = 3;
	    b.setUbtypeNo(ubtypeNo);

	    b.setBoardWriter(1); // 테스트용

	    List<Attachment> list = new ArrayList<>();
	    String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
	    
	    File dir = new File(savePath);
	    if(!dir.exists()) dir.mkdirs();

	    if(upfiles != null) {
		    for(MultipartFile f : upfiles) {
		        if(!f.getOriginalFilename().equals("")) {
		            String originName = f.getOriginalFilename();
		            String changeName = saveFile(f, savePath); 

		            Attachment at = new Attachment();
		            at.setOriginName(originName);
		            at.setChangeName(changeName);
		            at.setTargetType("BOARD");
		            list.add(at);
		        }
		    }
	    }

	    // 2. 주입받은 변수명(소문자 boardService)으로 호출해야 합니다.
	    int result = boardService.insertBoard(b, list);

	    if(result > 0) {
	        return "redirect:/board/list";
	    } else {
	        return "common/errorPage"; 
	    }
	}

	// 파일명 변경 및 서버 저장 메소드
	private String saveFile(MultipartFile upfile, String savePath) {
	    String originName = upfile.getOriginalFilename();
	    
	    // java.util.Date를 사용하여 현재 시간 구하기
	    String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	    int ranNum = (int)(Math.random() * 90000 + 10000);
	    String ext = originName.substring(originName.lastIndexOf("."));
	    
	    String changeName = currentTime + ranNum + ext;

	    try {
	        upfile.transferTo(new File(savePath + changeName));
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	    return changeName;
	}

	// 수정페이지로 이동 (기존 데이터 조회)
	@GetMapping("/updateForm")
	public String updateForm(@RequestParam("boardno")int boardNo, Model model) {
		
		Board b = boardService.selectBoard(boardNo);
		
		model.addAttribute("b",b);
		
		return "board/writeBoard";		
	}
	
	
	@PostMapping("/update.bo")
	public String updateBoard(Board b, HttpSession session) {
		
		System.out.println("수정 요청 게시글 정보" + b);
		
		int result = boardService.updateBoard(b);
		
		if(result > 0) {
			return "redirect:/board/detail?boardno=" + b.getBoardNo();
		}else {
			return "common/errorPage";
		}
	}
	
	
	// 게시판 상세보기
	@GetMapping("/detail")
	public String boardDetail(@RequestParam("boardno")int boardNo, Model model) {
		
		// 1. 조회수 증가 (Service에서 처리)
		int result = boardService.increaseCount(boardNo);
		
		if(result > 0) {
			// 2. 게시글 상세 정보 조회
			Board b = boardService.selectBoard(boardNo);
			
			// 3. 댓글 리스트 조회(나중에 구현)
			// List<Reply> rList = boardService.selectReplyList(boardNo);
			
			model.addAttribute("b",b);
			// model.addAttribute("rList",rList);
			
			return "board/boardDetail";
		}else {
			model.addAttribute("errorMsg","게시글 조회 실패");
			return "common/errorPage";
		}
		
	}
	
	// 좋아요 상태 확인(추가/삭제)
	@ResponseBody
	@PostMapping(value = "/like", produces = "text/html; charset=UTF-8")
	public String boardLike(int boardNo, int memNo) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("boardNo",boardNo);
		map.put("memNo", memNo);
		
		// 이미 좋아요를 눌렀는지 체크
		int check = boardService.checkLike(map);
		
		if(check > 0) {
			// 이미 했으면 삭제
			boardService.deleteLike(map);
			return "delete";
		}else {
			// 없으면 등록
			boardService.insertLike(map);
			return "insert";
		}
		
	}
		
	@ResponseBody
	@GetMapping("/likeCount")
	public int getLikeCount(int boardNo) {
		return boardService.selectLikeCount(boardNo);
	}
	
	
	
	
	
	
}