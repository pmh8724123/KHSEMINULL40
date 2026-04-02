	package com.kh.cam.mypage.model.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Attendance;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AttendanceDaoImpl implements AttendanceDao{

    private final SqlSessionTemplate session;
  
    @Override
	public int insertAtt(int memNo) {
		return session.insert("attendance.insertAtt", memNo);
	}
    
    @Override
	public Attendance selectAtt(int memNo) {
		return session.selectOne("attendance.selectAtt", memNo);
	}

    @Override
	public int updateAtt(int memNo) {
		return session.update("attendance.updateAtt", memNo);
	}

	@Override
	public void updateUserPoint(Map<String, Object> map) {
		session.update("attendance.updateUserPoint", map);
		
	}
    
}
