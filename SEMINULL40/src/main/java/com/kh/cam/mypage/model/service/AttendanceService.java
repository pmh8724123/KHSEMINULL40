package com.kh.cam.mypage.model.service;

import java.util.Map;


public interface AttendanceService {

    // 페이지 로드 시 출석 상태 조회
    // 반환: { checkedToday(boolean), currentDay(int) }
    Map<String, Object> getAttendanceStatus(int memNo);

    // 출석 체크 실행
    // 반환: { success(boolean), currentDay(int), message(String) }
    Map<String, Object> doCheck(int memNo);
}