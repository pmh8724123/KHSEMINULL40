package com.kh.cam.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.mypage.model.service.ScheduleService;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/schedule")
public class ScheduleController {

	private final ScheduleService sdService;
	
	private int getMemNo() {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		
		int result = user.getUserno();

		return result;
	}
	
	// 1. 강의 검색 API
	@GetMapping(value="/searchLecture", produces="application/json; charset=UTF-8")
	@ResponseBody
	public List<Lecture> searchLecture(@RequestParam String keyword) {
	    return sdService.searchLecture(keyword);
	}
	


	@PostMapping("/save")
	@ResponseBody
	public Map<String, Object> save(@RequestBody List<Schedule> newList) {
		System.out.println("컨트롤러 접속 성공! 데이터 개수: " + (newList != null ? newList.size() : "null"));
	    Map<String, Object> map = new HashMap<>();
	    try {
	        // 1. 기존 시간표 삭제 (이때 scheduleMapper.deleteSchedule 호출)
	        sdService.saveSchedule(getMemNo(), newList);

	        log.info("시간표 저장 테스트 : {}", newList);
	        
	        map.put("success", true);
	    } catch (Exception e) {
	        map.put("success", false);
	        map.put("message", e.getMessage());
	    }
	    return map;
	}
	
	
	@PostMapping("/deleteTable")
	@ResponseBody
	public Map<String, Object> deleteTable(@RequestBody Schedule target) {
	    Map<String, Object> map = new HashMap<>();
	    try {
	        target.setMemNo(getMemNo()); // 현재 로그인한 유저 번호 세팅
	        
	        // 서비스의 기존 delete 로직 재활용
	        sdService.deleteEntireTable(target); 
	        
	        map.put("success", true);
	    } catch (Exception e) {
	        map.put("success", false);
	        map.put("message", e.getMessage());
	    }
	    return map;
	}
}
