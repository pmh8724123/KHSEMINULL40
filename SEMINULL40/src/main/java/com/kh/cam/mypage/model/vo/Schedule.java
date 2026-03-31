package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Schedule {

	
	private int scheduleNo;
    private int memNo;
    private Integer lectureNo; // null 가능성이 있으므로 Wrapper 타입 사용

    private String scheduleTitle;
    private int scheduleDay;
    
    // 30분 단위마다 숫자로 저장함. 0 = 9:00 , 1 = 9:30...
    private int startSlot;
    private int endSlot; 
    
    private String lectureName;
}
