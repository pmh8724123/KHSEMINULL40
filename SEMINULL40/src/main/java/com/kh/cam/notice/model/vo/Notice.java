package com.kh.cam.notice.model.vo;

import java.sql.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Notice {
	private int noticeNo;
	private int uniNo;
	private String noticeTitle;
	private String noticeContent;
	private Date createDate;
	private char status;
}
