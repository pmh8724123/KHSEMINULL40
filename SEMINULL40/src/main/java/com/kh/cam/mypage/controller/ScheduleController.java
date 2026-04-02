package com.kh.cam.mypage.controller;

import java.util.ArrayList;
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
	
	
	@GetMapping("/friendSchedule")
	@ResponseBody
	public List<Schedule> getFriendSchedule(@RequestParam int friendNo) {
	    // 기존에 내 시간표 불러올 때 쓰던 Service의 selectList를 그대로 활용하세요.
	    // memNo 파라미터 자리에 friendNo를 넣어서 호출합니다.
	    List<Schedule> list = sdService.selectScheduleList(friendNo); 
	    return list;
	}
	


	@PostMapping("/save")
	@ResponseBody
	public Map<String, Object> saveSchedule(@RequestBody Map<String, Object> data) {
	    Map<String, Object> result = new HashMap<>();
	    
	    // 1. Spring Security 권장 방식의 사용자 정보 추출
	    CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    int memNo = user.getUserno();

	    try {
	        // 2. 페이로드에서 schtitleNo와 courses 분리
	        int schtitleNo = Integer.parseInt(data.get("schtitleNo").toString());
	        List<Map<String, Object>> courseList = (List<Map<String, Object>>)data.get("courses");
	        
	        // 3. VO 리스트 변환 (memNo와 schtitleNo를 모든 객체에 주입)
	        List<Schedule> list = new ArrayList<>();
	        if (courseList != null) {
	            for(Map<String, Object> item : courseList) {
	                Schedule s = new Schedule();
	                s.setMemNo(memNo);
	                s.setSchtitleNo(schtitleNo);
	                s.setLectureNo(Integer.parseInt(item.get("lectureNo").toString()));
	                s.setScheduleDay(Integer.parseInt(item.get("scheduleDay").toString()));
	                s.setStartTime(Integer.parseInt(item.get("startTime").toString()));
	                s.setEndTime(Integer.parseInt(item.get("endTime").toString()));
	                list.add(s);
	            }
	        }

	        // 4. 서비스 호출 (리스트가 비어도 schtitleNo와 memNo를 인자로 전달)
	        sdService.saveSchedule(list, schtitleNo, memNo);
	        result.put("success", true);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("success", false);
	    }
	    return result;
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
	
	
	@PostMapping("/insertTitle")
	@ResponseBody
	public Schedule insertTitle(@RequestBody Schedule schedule) {
	    schedule.setMemNo(getMemNo());
	    sdService.insertScheduleTitle(schedule); 
	    return schedule; // 여기에 생성된 schTitleNo가 담겨서 JSON으로 나감
	}
}
