package com.kh.cam.mypage.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.mypage.model.service.AttendanceService;
import com.kh.cam.mypage.model.service.FriendsService;
import com.kh.cam.mypage.model.service.MypageService;
import com.kh.cam.mypage.model.vo.Attendance;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MypageController {

	private final AttendanceService attService;

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@GetMapping("/mypage")
	public String mypage(@RequestParam(value = "category", required = false, defaultValue = "attendance") String category, Model model) {
		// 로그인한 사용자 정보 가져오기
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int memNo = user.getUserno();

		// 카테고리 전달
		model.addAttribute("category", category);

		// 카테고리 검사
		switch (category) {
		case "attendance" :
			attendance(memNo, model);
			break;
			
		}

		return "mypage/mypage";
	}

	private void attendance(int memNo, Model model) {
		// 출석 정보 가져오기
		Attendance att = attService.selectAtt(memNo);

		System.out.println(att.getAttendDays());

		// 출석일 비교
		String attDay = att.getAttendDays() != null ? sdf.format(att.getAttendDays()) : "0000-00-00";
		String today = sdf.format(new Date());
		Boolean checkedToday = attDay.equals(today);

		System.out.println(attDay);

		// 출석일수, 오늘 출석여부 전달
		model.addAttribute("attCnt", att.getCount());
		model.addAttribute("checkedToday", checkedToday);
	}
}
