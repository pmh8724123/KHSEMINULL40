package com.kh.cam.notice.model.dao;

import java.util.List;

import com.kh.cam.notice.model.vo.Notice;

public interface NoticeDao {

	List<Notice> selectNoticeList(Integer uniNo);

}
