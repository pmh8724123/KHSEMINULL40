package com.kh.cam.reply.model.service;

import java.util.List;

import com.kh.cam.reply.model.vo.Reply;

public interface ReplyService {

	List<Reply> selectReplyList(int bno);

	int insertReply(Reply r);

	int deleteReply(int replyNo);


}
