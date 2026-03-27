package com.kh.cam.mypage.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Attendance {
	
	private int memNo;
	private Date attendDays;
	private int count;
	
}
