package com.kh.cam.notice.model.service;

import java.util.List;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.notice.model.vo.Notice;

public interface NoticeService {

	List<Notice> selectNoticeList(Integer uniNo);

	int insertNotice(Notice notice, List<Attachment> list);

	Notice selectNotice(int noticeNo);

	int updateNotice(Notice notice);

	int deleteNotice(int noticeNo);

	List<Attachment> selectAttList(int noticeNo);

}
