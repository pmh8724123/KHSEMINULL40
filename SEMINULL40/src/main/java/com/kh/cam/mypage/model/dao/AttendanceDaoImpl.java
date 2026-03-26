package com.kh.cam.mypage.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public class AttendanceDaoImpl implements AttendanceDao{

	
	
    @Autowired
    private SqlSessionTemplate sqlSession;

    // 오늘 출석 여부 확인 (1: 출석함 / 0: 안 함)
    public int selectAttendCnt(int memNo) {
        Integer cnt = sqlSession.selectOne("attendance.selectAttendCnt", memNo);
    	return (cnt == null) ? 0 : cnt;
    }

    // 출석 INSERT
    public int updateAttend(int memNo) {
        return sqlSession.update("attendance.updateAttend", memNo);
    }

	@Override
	public int checkToday(int memNo) {
		return sqlSession.selectOne("attendance.checkToday", memNo);
	}

	@Override
	public int insertAttendance(int memNo) {
		return sqlSession.insert("attendance.insertAttendance", memNo);
	}

	@Override
	public int getTotalCount(int memNo) {
		return sqlSession.selectOne("attendance.getTotalCount", memNo);
	}


}
