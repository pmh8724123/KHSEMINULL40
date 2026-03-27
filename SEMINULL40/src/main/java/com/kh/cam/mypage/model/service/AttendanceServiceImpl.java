package com.kh.cam.mypage.model.service;

import org.springframework.stereotype.Service;

import com.kh.cam.mypage.model.dao.AttendanceDao;
import com.kh.cam.mypage.model.vo.Attendance;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService{
	
	private final AttendanceDao attDao;
	
	// 회원 출석정보 생성
	@Override
	public int insertAtt(int memNo) {
		return attDao.insertAtt(memNo);
	}

	@Override
	public Attendance selectAtt(int memNo) {
		return attDao.selectAtt(memNo);
	}
	
	@Override
	public int updateAtt(int memNo) {
		return attDao.updateAtt(memNo);
	}

}
