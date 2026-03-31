package com.kh.cam.notice.model.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.cam.notice.model.dao.NoticeDao;
import com.kh.cam.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {
	
	private final NoticeDao nDao;
	
	@Override
	public List<Notice> selectNoticeList(Integer uniNo) {
		return nDao.selectNoticeList(uniNo);
	}	
	
}
