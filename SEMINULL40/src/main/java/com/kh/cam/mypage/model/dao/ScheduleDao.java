package com.kh.cam.mypage.model.dao;

import java.util.List;

import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

public interface ScheduleDao {

	List<Schedule> selectScheduleList(int memNo);

	int deleteSchedule(Schedule searchKey);

	void insertSchedule(Schedule vo);

	List<Lecture> searchLecture(String keyword);

}
