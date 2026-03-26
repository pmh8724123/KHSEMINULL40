// controller/AttendanceController.java
package com.kh.cam.mypage.controller;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.mypage.model.service.AttendanceService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/attendance")
public class AttendanceController {

	private final AttendanceService attendanceService;

	private final MemberService mService;

	// SecurityContextHolder에서 직접 memNo 꺼내기
	// @AuthenticationPrincipal 대신 사용 (인터페이스 직접 주입 오류 방지)
	private int getMemNo() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String memName = auth.getName();
		int result = mService.getMemNo(memName);
		log.info("값 : {}", result);
		
		
		return result;
	}


	// POST /attendance/check : 출석 체크 실행
	@PostMapping("/check")
	@ResponseBody
	public String check(HttpSession session) {

//		Member memId = (Member) session.getAttribute("loginUser");
//		if (memId == null)
//			return "login_required";

		int memNo = getMemNo();

		// 1. 오늘 이미 출석했는지 확인 (0시 0분 0초 ~ 23시 59분 59초 사이 기록 조회)
		int alreadyChecked = attendanceService.checkToday(memNo);

		if (alreadyChecked > 0) {
			return "already_done";
		}

		// 2. 출석 데이터 삽입
		int totalCount = attendanceService.insertAttendance(memNo);

		if (totalCount > 0) {
			// 성공 시 총 출석 횟수를 포함해서 보냄
			return "success";
		}
		return "fail";
	}
	

}