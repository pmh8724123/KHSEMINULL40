package com.kh.cam.reply.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;

import com.kh.cam.reply.model.vo.Reply;


public interface ReplyDao {

	List<Reply> selectReplyList(SqlSessionTemplate sqlSession, int bno);

	int insertReply(SqlSessionTemplate sqlSession, Reply r);

	int deleteReply(SqlSessionTemplate sqlSession, int replyNo);

}
