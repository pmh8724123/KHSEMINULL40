package com.kh.cam.mypage.model.dao;

import java.util.Date;
import java.util.List;

public interface AttendanceDao {
    
    int updateAttend(int memNo);

	int selectAttendCnt(int memNo);
    
	int checkToday(int memNo);

	int insertAttendance(int memNo);

	int getTotalCount(int memNo);

}