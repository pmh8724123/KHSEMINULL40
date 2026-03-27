package com.kh.cam.mypage.model.service;

import com.kh.cam.mypage.model.vo.Attendance;


public interface AttendanceService {

	int insertAtt(int memNo);

	Attendance selectAtt(int memNo);

	int updateAtt(int memNo);

}