package com.kh.cam.mypage.model.service;

import java.util.Date;
import java.util.Map;


public interface AttendanceService {

	int updateAttend(int memNo);

	int selectAttendCnt(int memNo);

	int checkToday(int memNo);

	int insertAttendance(int memNo);

	



}