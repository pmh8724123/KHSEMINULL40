package com.kh.cam.mypage.model.service;

import java.util.List;

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
	public List<Lecture> searchLecture(String keyword) {
	    return scheduleDao.searchLecture(keyword);
	}
	

	@Override
    @Transactional(rollbackFor = Exception.class)
    public void saveSchedule(int memNo, List<Schedule> newList) {
        if (newList == null || newList.isEmpty()) {
        	System.out.println("저장할 데이터가 비어있음");
            return; // 방어 코드: 데이터가 없으면 종료
        }

        // 1. 삭제 및 삽입을 위한 기준 객체 준비 (첫 번째 항목 활용)
        String currentTableTitle = newList.get(0).getScheduleTitle();
        System.out.println("회원번호: " + memNo + " | 시간표 제목: " + currentTableTitle);
        
        Schedule deleteTarget = new Schedule();
        deleteTarget.setMemNo(memNo);
        deleteTarget.setScheduleTitle(currentTableTitle);
        
        scheduleDao.deleteSchedule(deleteTarget); // 해당 유저의 '특정 시간표'만 전체 삭제
        System.out.println("기존 데이터 삭제 건수: " + deleteTarget);
        
        int insCount = 0;
        for (Schedule s : newList) {
            s.setMemNo(memNo);
            scheduleDao.insertSchedule(s);
            
            insCount++;
        }
        System.out.println("신규 데이터 삽입 건수: " + insCount);
        System.out.println("--- 저장 프로세스 종료 ---");
    }

	@Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteEntireTable(Schedule target) {
        // 보안 및 정확성을 위해 memNo와 scheduleTitle이 필수입니다.
        if (target.getMemNo() == 0 || target.getScheduleTitle() == null) {
            return 0; 
        }
        
        // DAO의 삭제 메서드 호출 (기존에 작성한 deleteSchedule 재활용)
        return scheduleDao.deleteSchedule(target);
    }


}
