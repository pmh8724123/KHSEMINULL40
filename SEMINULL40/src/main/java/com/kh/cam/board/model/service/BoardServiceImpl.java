package com.kh.cam.board.model.service;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.board.model.dao.BoardDao;
import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.board.model.vo.Board;

@Service
public class BoardServiceImpl implements BoardService {
    @Autowired private BoardDao boardDao;
    @Autowired private SqlSessionTemplate sqlSession;

    @Override
    @Transactional // 중요: 게시글은 성공하고 파일이 실패하면 롤백됨
    public int insertBoard(Board b, List<Attachment> list) {
        // 1. 게시글 insert (insert 후 b객체에 boardNo가 채워지도록 설정)
        int result = boardDao.insertBoard(sqlSession, b);
        
        // 2. 파일 insert
        if(result > 0 && !list.isEmpty()) {
            for(Attachment at : list) {
                at.setTargetNo(b.getBoardNo()); // 위에서 생성된 게시글 번호 대입
                result *= boardDao.insertFiles(sqlSession, at);
            }
        }
        return result;
    }

	@Override
	public List<Board> selectBoardList(String category) {
		return boardDao.selectBoardList(sqlSession, category);
	}

	@Override
	public int increaseCount(int boardNo) {
		return boardDao.increaseCount(sqlSession,boardNo);
	}

	@Override
	public Board selectBoard(int boardNo) {
		return boardDao.selectBoard(sqlSession, boardNo);
	}

	@Override
	public int updateBoard(Board b) {
		return boardDao.updateBoard(sqlSession, b);
	}

	@Override
	public int checkLike(Map<String, Object> map) {
		return boardDao.checkLike(sqlSession, map);

	}

	@Override
	public int selectLikeCount(int boardNo) {
		return boardDao.selectLikeCount(sqlSession, boardNo);
	}

	@Override
	public void deleteLike(Map<String, Object> map) {
		boardDao.deleteLike(sqlSession, map);
	}

	@Override
	public void insertLike(Map<String, Object> map) {
		boardDao.insertLike(sqlSession, map);
	}
}