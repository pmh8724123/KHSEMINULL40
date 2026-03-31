package com.kh.cam.notice.controller;

import java.util.List;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.notice.model.service.NoticeService;
import com.kh.cam.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
@Slf4j
public class NoticeController {

	private final NoticeService nService;
	
	@GetMapping("/list")
	public String noticeList(Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Member member = user.getMember();
		
		List<Notice> noticeList = nService.selectNoticeList(member.getUniNo());
		
		model.addAttribute("noticeList", noticeList);
		
		return "notice/notice";
	}
	
}
