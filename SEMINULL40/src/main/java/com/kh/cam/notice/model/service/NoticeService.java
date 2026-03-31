package com.kh.cam.notice.model.service;

import java.util.List;

import com.kh.cam.notice.model.vo.Notice;

public interface NoticeService {

	List<Notice> selectNoticeList(Integer uniNo);

}
