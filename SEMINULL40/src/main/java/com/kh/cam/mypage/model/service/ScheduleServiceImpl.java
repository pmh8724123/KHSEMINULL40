package com.kh.cam.mypage.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.mypage.model.dao.ScheduleDao;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.mypage.model.vo.Schedule;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService{
	
	private final ScheduleDao scheduleDao;
	
	@Override
    public List<Schedule> selectScheduleList(int memNo) {
        return scheduleDao.selectScheduleList(memNo);
    }
	
	@Override
	public List<Lecture> searchLecture(Map<String, Object> map) {
	    return scheduleDao.searchLecture(map);
	}
	

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int saveSchedule(List<Schedule> list, int schtitleNo, int memNo) {
	    // 1. 해당 유저의 특정 시간표 상세 데이터만 우선 '전체 삭제'
	    // 리스트가 비어있어도(전체 삭제 시) 이 쿼리가 실행되어 DB가 비워집니다.
	    Schedule delParam = new Schedule();
	    delParam.setMemNo(memNo);
	    delParam.setSchtitleNo(schtitleNo);
	    scheduleDao.deleteSchedule(delParam);

	    // 2. 새로 넘어온 강의 리스트가 있다면 다시 삽입
	    int count = 0;
	    if (list != null && !list.isEmpty()) {
	        for (Schedule s : list) {
	            count += scheduleDao.insertSchedule(s);
	        }
	    }
	    return count;
	}
	

	@Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEntireTable(Schedule target) {
        // 보안 및 정확성을 위해 memNo와 scheduleTitle이 필수입니다.
        if (target.getMemNo() == 0 || target.getSchtitleNo() == 0) {
            return 0; 
        }
        scheduleDao.deleteSchedule(target);
        // DAO의 삭제 메서드 호출 (기존에 작성한 deleteSchedule 재활용)
        return scheduleDao.deleteScheduleTitle(target);
    }
	
	
	@Override
    @Transactional(rollbackFor = Exception.class)
    public int insertScheduleTitle(Schedule schedule) {
        // 제목 저장 후 MyBatis가 schedule 객체의 schTitleNo 필드에 PK를 채워줌
        return scheduleDao.insertScheduleTitle(schedule);
    }

}
