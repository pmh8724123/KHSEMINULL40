package com.kh.cam.mypage.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Lecture {
	
	private int lectureNo;
	private int deptNo;
	private String lectureName;
	private String professorName;
	
	
	private Date days;
	private Date startTime;
	private Date endTime;
	private String lectureRoom;
	
	private String deptName;
	private String uniName;
	
	
}
