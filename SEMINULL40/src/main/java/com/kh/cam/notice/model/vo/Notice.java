package com.kh.cam.notice.model.vo;

import java.sql.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Notice {
	private int noticeNo;
	private int ubtypeNo;
	private String boardTitle;
	private String boardContent;
	private int boardWriter;
	private int viewCount;
	private Date createDate;
	private String status;
	
	private String categoryName;
	private int likeCount;
}
