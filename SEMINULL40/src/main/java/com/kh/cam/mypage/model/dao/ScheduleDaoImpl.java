package com.kh.cam.mypage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ScheduleDaoImpl implements ScheduleDao {

	private final SqlSessionTemplate sqlSession;

	@Override
	public List<Schedule> selectScheduleList(int memNo) {
		return sqlSession.selectList("schedule.selectList", memNo);
	}

	@Override
	public int deleteSchedule(Schedule searchKey) {
		return sqlSession.delete("schedule.deleteSchedule", searchKey);
	}

	@Override
	public void insertSchedule(Schedule vo) {
		sqlSession.insert("schedule.insertSchedule", vo);
	}

	@Override
	public List<Lecture> searchLecture(String keyword) {
		return sqlSession.selectList("schedule.searchLecture", keyword);
	}

}
