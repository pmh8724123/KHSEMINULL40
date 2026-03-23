package com.kh.cam.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.cam.admin.model.serivce.AdminService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {
	
	private final AdminService adminService;
	
	// 관리자 로그인
    @GetMapping("")
    public String adminLogin() {
        return "admin/adminLogin";
    }
	
	// 관리자 메인
    @GetMapping("/main")
    public String adminMain() {
        return "admin/adminMain";
    }
// ---------------------회원관리----------------------------------
    // 회원 상태 관리
    @GetMapping("/memberStatus")
    public String memberStatus() {
        return "admin/memberStatus";
    }
    
    // 회원 가입 관리
    @GetMapping("/memberJoin")
    public String adminMemberJoin() {
        return "admin/memberJoin";
    }
    
// ---------------------학교관리----------------------------------
    // 학과 관리
    @GetMapping("/department")
    public String adminDepartment() {
        return "admin/department";
    }
    
    // 수업 관리
    @GetMapping("/class")
    public String adminClass() {
    	return "admin/class";
    }
    
// ---------------------게시판 관리----------------------------------
    // 공지사항
    @GetMapping("/notice")
    public String adminNotice() {
    	return "admin/notice";
    }
    
    // 게시판 관리
    @GetMapping("/board")
    public String adminBoard() {
    	return "admin/board";
    }
    
    // 댓글 관리
    @GetMapping("/reply")
    public String adminReply() {
    	return "admin/reply";
    }
    
// ---------------------신고관리----------------------------------
    // 신고 관리
    @GetMapping("/report")
    public String report() {
        return "admin/report";
    }
    
    
	
	
}

