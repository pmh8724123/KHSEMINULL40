package com.kh.cam.report.model.vo;


import java.util.Date;

import lombok.Data;


@Data
public class Report {
	private int reportNo;
	private int boardMem;
	private int reasonNo;
	private String reasonContent;
	private String targetType;
	private int targetNo;
	private Date createDate;
	
	private String reasonName;
	
	private String contentType;
	private String writerName;
	private Date contentCreateDate;
	private String reportMemName;
	private int boardNo;
	private Date reportDate;
	private String uniName;
}
