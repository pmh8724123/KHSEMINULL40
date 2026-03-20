package com.kh.cam.mypage.model.service;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.mypage.model.dao.AttendanceDao;


@Service
public class AttendanceServiceImpl implements AttendanceService{
	
	@Autowired
	private AttendanceDao attendanceDao;
	
    // 페이지 로드 시 출석 상태 반환
    @Override
    public Map<String, Object> getAttendanceStatus(int memNo) {
        Map<String, Object> result = new HashMap<>();

        // 오늘 출석 여부
        boolean checkedToday = attendanceDao.selectTodayAttendance(memNo) > 0;

        // 최근 7일 날짜로 연속 일차 계산
        List<Date> dates = attendanceDao.selectRecentDates(memNo);
        int currentDay   = calcCurrentDay(dates, checkedToday);

        result.put("checkedToday", checkedToday);
        result.put("currentDay",   currentDay);
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> doCheck(int memNo) {
        Map<String, Object> result = new HashMap<>();

        // 서버에서 중복 출석 재확인 (동시 요청 방어)
        if (attendanceDao.selectTodayAttendance(memNo) > 0) {
            result.put("success", false);
            result.put("message", "오늘은 이미 출석했습니다.");
            return result;
        }

        // 출석 INSERT
        attendanceDao.insertAttendance(memNo);

        // INSERT 후 갱신된 날짜 목록으로 일차 재계산
        List<Date> dates = attendanceDao.selectRecentDates(memNo);
        int currentDay   = calcCurrentDay(dates, true);

        result.put("success",    true);
        result.put("currentDay", currentDay);
        return result;
    }
    
    
    // ── 연속 출석 일차 계산 헬퍼 ─────────────────────
    // dates    : 최근 7일 출석 날짜 목록 (최신순)
    // checkedToday : 오늘 출석 여부
    // 반환     : 현재까지 연속 출석한 일수
    private int calcCurrentDay(List<Date> dates, boolean checkedToday) {
        if (dates == null || dates.isEmpty()) return 0;

        // 날짜를 "yyyy-M-d" 문자열 Set으로 변환 (빠른 조회)
        Set<String> dateSet = new HashSet<>();
        for (Date d : dates) {
            dateSet.add(toDateKey(d));
        }

        // 오늘부터 거꾸로 연속 일수 카운트
        Calendar cal = Calendar.getInstance();
        // 오늘 출석 안 했으면 어제부터 카운트
        if (!checkedToday) cal.add(Calendar.DATE, -1);

        int count = 0;
        for (int i = 0; i < 7; i++) {
            if (dateSet.contains(toDateKey(cal.getTime()))) {
                count++;
                cal.add(Calendar.DATE, -1); // 하루씩 뒤로
            } else {
                break; // 연속이 끊기면 중단
            }
        }
        return count;
    }

    // Date → "yyyy-M-d" 문자열 변환 (날짜 비교 키)
    private String toDateKey(Date d) {
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        return c.get(Calendar.YEAR)
             + "-" + (c.get(Calendar.MONTH) + 1)
             + "-" + c.get(Calendar.DATE);
    }
}


