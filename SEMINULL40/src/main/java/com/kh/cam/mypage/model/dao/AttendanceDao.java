package com.kh.cam.mypage.model.dao;

import java.util.Map;

import com.kh.cam.mypage.model.vo.Attendance;

public interface AttendanceDao {
	
	int insertAtt(int memNo);
	
	Attendance selectAtt(int memNo);
	
	int updateAtt(int memNo);

	void updateUserPoint(Map<String, Object> map);

}