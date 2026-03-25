package com.kh.cam.member.model.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Member {
	
	// Member 기본 정보
	private int memNo;
	private String memId;
	private String memPw;
	private String memName;
	private int deptNo;
	private int studentNo;
	private String phone;
	private Date createDate;
	private char status;
	
	// 대학 정보
	private int uniNo;
	private String uniName;
	
	// 학과 정보
	private String deptName;
	
	// 권한 정보
	private List<Authority> authorities;
	
}
