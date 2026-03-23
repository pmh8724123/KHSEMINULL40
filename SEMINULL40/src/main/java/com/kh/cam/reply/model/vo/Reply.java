package com.kh.cam.reply.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Reply {
	private int replyNo;
	private int boardNo;
	private String replyContent;
	private String replyWriter;
	private Date createDate;
	private String status;
	
	private String userName;
}
