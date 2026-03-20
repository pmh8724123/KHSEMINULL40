// controller/AttendanceController.java
package com.kh.cam.mypage.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.kh.cam.mypage.model.service.AttendanceService;

import java.util.Map;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    // SecurityContextHolder에서 직접 memNo 꺼내기
    // @AuthenticationPrincipal 대신 사용 (인터페이스 직접 주입 오류 방지)
    private int getMemNo() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        // getUsername()이 memNo 숫자 문자열을 반환한다고 하셨으므로 int로 파싱
        return Integer.parseInt(auth.getName());
    }

    // GET /attendance/status : 페이지 로드 시 출석 상태 조회
    @GetMapping("/status")
    @ResponseBody
    public Map<String, Object> status() {
        return attendanceService.getAttendanceStatus(getMemNo());
    }

    // POST /attendance/check : 출석 체크 실행
    @PostMapping("/check")
    @ResponseBody
    public Map<String, Object> check() {
        return attendanceService.doCheck(getMemNo());
    }
}