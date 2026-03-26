package com.kh.cam.mypage.model.service;

import org.springframework.stereotype.Service;

import com.kh.cam.mypage.model.dao.AttendanceDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Service
@RequiredArgsConstructor
@Slf4j
public class AttendanceServiceImpl implements AttendanceService{
	
	private final AttendanceDao attendanceDao;

	@Override
	public int updateAttend(int memNo) {
		return attendanceDao.updateAttend(memNo);
	}

	@Override
	public int selectAttendCnt(int memNo) {
		return attendanceDao.selectAttendCnt(memNo);
	}

	@Override
	public int checkToday(int memNo) {
		return attendanceDao.checkToday(memNo);
	}

	
	@Override
	public int insertAttendance(int memNo) {
	    // 1. 오늘 이미 했는지 확인
	    int check = attendanceDao.checkToday(memNo);
	    
	    if (check == 0) {
	        // 2. insert 실행 (성공 시 1 반환)
	        int result = attendanceDao.insertAttendance(memNo);
	        
	        if(result > 0) {
	            // 3. 성공했다면 전체 카운트를 가져와서 컨트롤러에 전달
	            return attendanceDao.getTotalCount(memNo);
	        }
	    }
	    // 이미 했거나 insert 실패 시 0 반환
	    return 0;
	}


	

}
