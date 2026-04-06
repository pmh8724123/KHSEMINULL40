// controller/AttendanceController.java
package com.kh.cam.mypage.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.mypage.model.service.AttendanceService;
import com.kh.cam.mypage.model.vo.Attendance;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/attendance")
@RequiredArgsConstructor
@Slf4j
public class AttendanceController {
    
    private final AttendanceService attService;

    @PostMapping("/updateAtt")
    public String updateAtt(RedirectAttributes ra) {
    	CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    	int memNo = user.getUserno();

    	
    	int result = attService.checkIn(memNo); // 포인트 로직이 포함된 checkIn 호출
        
        if(result > 0) {
            ra.addFlashAttribute("message", "출석 체크 완료! 포인트가 지급되었습니다.");
        } else {
            ra.addFlashAttribute("message", "출석 체크 실패!");
        }
    	
    	return "redirect:/mypage?category=attendance";
    }
 
}