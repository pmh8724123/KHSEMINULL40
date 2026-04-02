package com.kh.cam.mypage.model.service;

import java.util.List;

import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

public interface ScheduleService {


	int saveSchedule(List<Schedule> list, int schtitleNo, int memNo);


	List<Schedule> selectScheduleList(int memNo);

	List<Lecture> searchLecture(String keyword);

	int deleteEntireTable(Schedule target);

	int insertScheduleTitle(Schedule schedule);



}
