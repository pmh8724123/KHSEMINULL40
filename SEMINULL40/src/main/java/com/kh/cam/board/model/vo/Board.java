package com.kh.cam.board.model.vo;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Board {
	private int boardNo;
	private int ubtypeNo;
	private String boardTitle;
	private String boardContent;
	private int boardWriter;
	private String boardWriterName;
	private int viewCount;
	private Date createDate;
	private String status;
	
	private String categoryName;
	private int likeCount;
}