package com.kh.cam.member.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberDTO {
	
	private int memNo;
	private String memId;
	private String memName;
	private int deptNo;
	private String phone;
	private String email;
	private Date createDate;
	private char status;
	
	private String deptName;
	private String uniName;
	private int uniNo;
	
}
