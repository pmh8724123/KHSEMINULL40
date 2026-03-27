package com.kh.cam.mypage.model.dao;

import com.kh.cam.mypage.model.vo.Attendance;

public interface AttendanceDao {
	
	int insertAtt(int memNo);
	
	Attendance selectAtt(int memNo);
	
	int updateAtt(int memNo);

}