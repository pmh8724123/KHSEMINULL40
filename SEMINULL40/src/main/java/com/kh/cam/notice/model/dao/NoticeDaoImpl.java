package com.kh.cam.notice.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Component;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class NoticeDaoImpl implements NoticeDao {

	private final SqlSessionTemplate session;
	
	@Override
	public List<Notice> selectNoticeList(Integer uniNo) {
		return session.selectList("notice.selectNoticeList", uniNo);
	}

	@Override
	public int insertNotice(Notice notice) {
		return session.insert("notice.insertNotice", notice);
	}

	@Override
	public Notice selectNotice(int noticeNo) {
		return session.selectOne("notice.selectNotice", noticeNo);
	}

	@Override
	public int updateNotice(Notice notice) {
		return session.update("notice.updateNotice", notice);
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return session.update("notice.deleteNotice", noticeNo);
	}

	@Override
	public int insertFiles(Attachment at) {
		return session.insert("notice.insertFiles", at);
	}

	@Override
	public List<Attachment> selectAttList(int noticeNo) {
		return session.selectList("notice.selectAttList", noticeNo);
	}

}
