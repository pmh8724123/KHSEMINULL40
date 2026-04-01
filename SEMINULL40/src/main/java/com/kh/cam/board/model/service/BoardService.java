package com.kh.cam.board.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.board.model.vo.Board;

public interface BoardService {

	int insertBoard(Board b, List<Attachment> list);

	List<Board> selectBoardList(Map<String, Object> params);

	int increaseCount(int boardNo);

	Board selectBoard(int boardNo);

	int updateBoard(Board b, List<Attachment> list, String deleteFileNos);

	int checkLike(Map<String, Object> map);

	int selectLikeCount(int boardNo);

	void deleteLike(Map<String, Object> map);

	void insertLike(Map<String, Object> map);

	int insertReport(Map<String, Object> map);

	ArrayList<Attachment> selectAttachmentList(int boardNo);

	int deleteBoard(int boardNo);


	
}