package com.kh.cam.reply.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.reply.model.dao.ReplyDao;
import com.kh.cam.reply.model.vo.Reply;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Autowired
	private ReplyDao replyDao;
	
	@Autowired
	private SqlSessionTemplate sqlSession; // DAO로 넘겨줄 세션 객체

	@Override
	public List<Reply> selectReplyList(int bno) {
		// DAO에 세션과 게시글 번호를 전달하여 리스트를 받아옵니다.
		return replyDao.selectReplyList(sqlSession, bno);
	}

	@Override
	public int insertReply(Reply r) {
		return replyDao.insertReply(sqlSession, r);
	}

	@Override
	public int deleteReply(int replyNo) {
		return replyDao.deleteReply(sqlSession, replyNo);
	}

}