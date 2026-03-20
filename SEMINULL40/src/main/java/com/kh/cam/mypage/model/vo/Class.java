package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Class {
	
	// 강의 번호
	private int classNo;
	
	// 학과 번호
	private int deptNo;

	// 강의 제목
	private String className;

	// 교수 이름
	private String professorName;
}
