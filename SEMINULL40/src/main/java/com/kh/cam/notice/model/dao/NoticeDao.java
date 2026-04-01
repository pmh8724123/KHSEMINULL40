package com.kh.cam.notice.model.dao;

import java.util.List;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.notice.model.vo.Notice;

public interface NoticeDao {

	List<Notice> selectNoticeList(Integer uniNo);

	int insertNotice(Notice notice);

	Notice selectNotice(int noticeNo);

	int updateNotice(Notice notice);

	int deleteNotice(int noticeNo);

	int insertFiles(Attachment at);

}
