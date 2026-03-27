// controller/AttendanceController.java
package com.kh.cam.mypage.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.mypage.model.service.AttendanceService;

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
    	attService.updateAtt(memNo);
    	
    	return "redirect:/mypage?category=attendance";
    }
 
}