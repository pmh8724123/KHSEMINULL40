package com.kh.cam.board.model.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository; // 추가

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.board.model.vo.Board;

@Repository
public class BoardDaoImpl implements BoardDao {

	@Override
	public int insertBoard(SqlSessionTemplate sqlSession, Board b) {
		return sqlSession.insert("board.insertBoard", b);
	}

	@Override
	public int insertFiles(SqlSessionTemplate sqlSession, Attachment at) {
		return sqlSession.insert("board.insertFiles", at);
	}

	@Override
	public List<Board> selectBoardList(SqlSessionTemplate sqlSession, String category) {
		return sqlSession.selectList("board.selectBoardList", category);
	}

	@Override
	public int increaseCount(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.update("board.increaseCount",boardNo);
	}

	@Override
	public Board selectBoard(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.selectOne("board.selectBoard",boardNo);
	}

	@Override
	public int updateBoard(SqlSessionTemplate sqlSession, Board b) {
		return sqlSession.update("board.updateBoard", b);
	}

	@Override
	public int checkLike(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectOne("board.checkLike", map);
	}

	@Override
	public int selectLikeCount(SqlSessionTemplate sqlSession, int boardNo) {
		return sqlSession.selectOne("board.selectLikeCount", boardNo);
	}

	@Override
	public void deleteLike(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		sqlSession.delete("board.deleteLike", map);
	}

	@Override
	public void insertLike(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		sqlSession.insert("board.insertLike", map);
	}

	@Override
	public int insertReport(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.insert("board.insertReport",map);
	}

	@Override
	public ArrayList<Attachment> selectAttachmentList(SqlSessionTemplate sqlSession, int boardNo) {
		return (ArrayList)sqlSession.selectList("board.selectAttachmentList", boardNo);
	}

	@Override
	public int deleteAttachment(SqlSessionTemplate sqlSession, int fileNo) {
		return sqlSession.delete("board.deleteAttachment", fileNo);
	}
}