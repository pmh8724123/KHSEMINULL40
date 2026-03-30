package com.kh.cam.assessment.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Assessment {
	private int asseNo;
	private int memNo;
	private int lectureNo;
	private int homework;
	private int grade;
	private int totalScore;
	
	private String lectureName;
	private String professorName;
	private double avgScore;
	private int ReviewCount;
	private String uniName;
}
