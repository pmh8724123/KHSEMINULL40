package com.kh.cam.reply.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.reply.model.vo.Reply;

@Repository
public class ReplyDaoImpl implements ReplyDao {

	@Override
	public List<Reply> selectReplyList(SqlSessionTemplate sqlSession, int bno) {
		return sqlSession.selectList("reply.selectReplyList",bno);
	}

	@Override
	public int insertReply(SqlSessionTemplate sqlSession, Reply r) {
		return sqlSession.insert("reply.insertReply",r);
	}

	@Override
	public int deleteReply(SqlSessionTemplate sqlSession, int replyNo) {
		return sqlSession.update("reply.deleteReply",replyNo);
	}

}
