package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Lecture {
	
	// 강의 번호
	private int lectureNo;
	
	// 학과 번호
	private int deptNo;

	// 강의 제목
	private String lectureName;

	// 교수 이름
	private String professorName;
	
	// 강의장
	private String lectureRoom;
	
	
}
