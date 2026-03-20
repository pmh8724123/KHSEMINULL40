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
    public int selectTodayAttendance(int memNo) {
        return sqlSession.selectOne("selectTodayAttendance", memNo);
    }

    // 최근 7일 출석 날짜 목록 조회 (연속 일차 계산용)
    public List<Date> selectRecentDates(int memNo) {
        return sqlSession.selectList("selectRecentDates", memNo);
    }

    // 출석 INSERT
    public void insertAttendance(int memNo) {
        sqlSession.insert("insertAttendance", memNo);
    }
}
