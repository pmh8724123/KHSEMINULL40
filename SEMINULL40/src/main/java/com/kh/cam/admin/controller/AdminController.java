package com.kh.cam.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin")
@Slf4j
@RequiredArgsConstructor
public class AdminController {
	
	
	
	// 관리자 메인
    @GetMapping("/main")
    public String adminMain() {
        return "admin/adminMain";
    }

    // 회원 상태 관리
    @GetMapping("/member/status")
    public String memberStatus() {
        return "admin/memberStatus";
    }

    // 회원 가입 관리
    @GetMapping("/member/join")
    public String memberJoin() {
        return "admin/memberJoin";
    }

    // 신고 관리
    @GetMapping("/report")
    public String report() {
        return "admin/report";
    }
	
	
}
