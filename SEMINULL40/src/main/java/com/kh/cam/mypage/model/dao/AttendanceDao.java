package com.kh.cam.mypage.model.dao;

import java.util.Date;
import java.util.List;

public interface AttendanceDao {
    int selectTodayAttendance(int memNo);
    
    List<Date> selectRecentDates(int memNo);
    
    void insertAttendance(int memNo);
    
}