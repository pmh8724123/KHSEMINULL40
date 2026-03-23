package com.kh.cam.board.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.board.model.vo.Board;

public interface BoardDao {

	int insertBoard(SqlSessionTemplate sqlSession, Board b);

	int insertFiles(SqlSessionTemplate sqlSession, Attachment at);

	List<Board> selectBoardList(SqlSessionTemplate sqlSession, String category);

	int increaseCount(SqlSessionTemplate sqlSession, int boardNo);

	Board selectBoard(SqlSessionTemplate sqlSession, int boardNo);

	int updateBoard(SqlSessionTemplate sqlSession, Board b);

	int checkLike(SqlSessionTemplate sqlSession, Map<String, Object> map);

	int selectLikeCount(SqlSessionTemplate sqlSession, int boardNo);

	void deleteLike(SqlSessionTemplate sqlSession, Map<String, Object> map);

	void insertLike(SqlSessionTemplate sqlSession, Map<String, Object> map);


}