package com.kh.cam.mypage.controller;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.mypage.model.service.AttendanceService;
import com.kh.cam.mypage.model.service.FriendsService;
import com.kh.cam.mypage.model.service.ScheduleService;
import com.kh.cam.mypage.model.vo.Attendance;
import com.kh.cam.mypage.model.vo.Friends;
import com.kh.cam.mypage.model.vo.Schedule;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MypageController {

	private final AttendanceService attService;
	private final FriendsService fsService;
	private final ScheduleService sdService;

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
		
		case "friend" :
			friends(memNo, model);
			break;
			
		case "timetable" :
			timetable(memNo, model);
			break;
		
		case "setting" :
			setting(memNo, model);
			break;
		
		default : 
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
	
	public void friends(int memNo, Model model) {
		
		// 1. 서비스 호출 결과가 null일 경우를 대비해 빈 리스트로 초기화
		List<Friends> friendList = fsService.selectFriendList(memNo);
		
		// 확인용
		System.out.println("친구리스트 테스트용 : " + friendList);
		
		if (friendList == null) {
	        // null 대신 빈 리스트를 넣어 NPE 방지
	        friendList = new java.util.ArrayList<>(); 
	    }
		
		// 2. 리스트 내부에 객체는 있지만 필드값이 null인 경우를 방지하기 위해 
	    // 가공이 필요하다면 여기서 처리 (예: 이름이 없는 경우 "이름없음" 세팅)
	    for(Friends f : friendList) {
	        if(f.getFriendName() == null) {
	            f.setFriendName(""); // null 대신 빈 문자열 세팅
	        }
	    }
		
		model.addAttribute("friendList", friendList);
	}
	
	private void timetable(int memNo, Model model) {
        // 3. DB에서 해당 사용자의 시간표 리스트 가져오기
        List<Schedule> scheduleList = sdService.selectScheduleList(memNo);
        
        // 4. JSP에서 사용할 수 있도록 model에 담기
        // 구글 데이터 기반: JSON 형태로 넘기거나 객체 리스트로 전달
        model.addAttribute("scheduleList", scheduleList);
    }
	
	


	private void setting(int memNo, Model model) {
		
		
	}

}
