package com.kh.cam.member.model.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Member{
	
	// Member 기본 정보
	private int memNo;
	private String memId;
	private String memPw;
	private String memName;
	private Integer deptNo;
	private String strStudentNo;
	private String studentNo;
	private String phone;
	private Date createDate;
	private char status;
	
	// 대학 정보
	private Integer uniNo;
	private String uniName;
	
	// 학과 정보
	private String deptName;
	
	// 권한 정보
	private List<Authority> authorities;
	
}
