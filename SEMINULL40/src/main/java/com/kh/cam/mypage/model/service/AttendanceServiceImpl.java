package com.kh.cam.mypage.model.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.mypage.model.dao.AttendanceDao;
import com.kh.cam.mypage.model.vo.Attendance;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService {

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

	@Transactional
	public int checkIn(int memNo) {
		// 1. 출석 업데이트 (count 증가)
		int result = attDao.updateAtt(memNo);
		
		
		if (result > 0) {
			// 2. 업데이트된 최신 정보 가져오기 (count 확인용)
			Attendance att = attDao.selectAtt(memNo);
			int count = att.getCount();

			// 3. 포인트 계산 (% 7 로직)
			int amount = 5; // 기본 5P
			int cycleDay = (count % 7 == 0) ? 7 : (count % 7);
			
			if (cycleDay == 5 || cycleDay == 6) {
	            amount = 10;
	        } else if (cycleDay == 7) {
	            amount = 50;
	        }

			// 4. 포인트 업데이트 (이제 DUAL 방식이라 무조건 들어감)
			Map<String, Object> map = new HashMap<>();
			map.put("memNo", memNo);
			map.put("amount", amount);
			attDao.updateUserPoint(map);
		}
		return result;
	}

}
