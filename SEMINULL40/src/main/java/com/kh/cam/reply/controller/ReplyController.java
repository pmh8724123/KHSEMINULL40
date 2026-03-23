package com.kh.cam.reply.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.cam.member.model.vo.Member; // 본인의 Member VO 경로로 확인하세요
import com.kh.cam.reply.model.service.ReplyService;
import com.kh.cam.reply.model.vo.Reply;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/reply")
@Slf4j 
public class ReplyController {
    
    @Autowired
    private ReplyService replyService;

    @PostMapping("/insert")
    public String insertReply(Reply r, HttpSession session) {
        
        // 1. 세션에서 로그인 정보 가져오기 시도
        Member loginUser = (Member)session.getAttribute("loginUser");
        
        // 2. 로그인이 되어 있다면 세션 정보로 작성자 세팅
        if(loginUser != null) {
            r.setReplyWriter(String.valueOf(loginUser.getMemNo()));
        } 
        // 로그인이 안 되어 있어도 r.getReplyWriter()에 값이 있다면(JSP에서 보냈다면) 통과
        
        log.info("최종 등록 시도 데이터: {}", r);

        // 작성자 정보와 게시글 번호가 모두 있는지 최종 확인
        if(r.getReplyWriter() == null || r.getBoardNo() == 0) {
            log.warn("필수 데이터(작성자 또는 게시글번호)가 누락되었습니다.");
            return "fail";
        }

        try {
            int result = replyService.insertReply(r);
            return result > 0 ? "success" : "fail";
        } catch (Exception e) {
            log.error("DB 에러: {}", e.getMessage());
            return "fail";
        }
    }
    
    @GetMapping("/list")
    public List<Reply> selectReplyList(int boardNo){
    	List<Reply> list = replyService.selectReplyList(boardNo);
    	log.info("조회된 댓글 목록: {}", list);
    	return list;
    }
    
    @PostMapping("/delete")
    public String deleteReply(int replyNo) {
    	// 여기서 현재 로그인한 사용자와 댓글 작성자가 같은지 체크하는 로직이 필요
    	int result = replyService.deleteReply(replyNo);
    	return result > 0? "success" : "fail";
    }
    
    
    
    
    
}