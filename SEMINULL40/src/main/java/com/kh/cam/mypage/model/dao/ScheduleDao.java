package com.kh.cam.mypage.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

public interface ScheduleDao {

	List<Schedule> selectScheduleList(int memNo);

	int deleteSchedule(Schedule searchKey);
	int deleteScheduleTitle(Schedule target);

	int insertSchedule(Schedule vo);

	List<Lecture> searchLecture(Map<String, Object> map);

	int insertScheduleTitle(Schedule schedule);



}
