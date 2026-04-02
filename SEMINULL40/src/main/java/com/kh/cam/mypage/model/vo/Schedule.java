package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Schedule {

	private int scheduleNo;
	private int schtitleNo;
    private int memNo;
    private Integer lectureNo; // null 가능성이 있으므로 Wrapper 타입 사용
    private int scheduleDay;
    
    // 30분 단위마다 숫자로 저장함. 0 = 9:00 , 1 = 9:30...
    private int startTime;
    private int endTime; 
    
    
    private String schtitleName;
    private String lectureName;
    
    
}
