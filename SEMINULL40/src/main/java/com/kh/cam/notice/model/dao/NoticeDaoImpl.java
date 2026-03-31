package com.kh.cam.notice.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Component;

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

}
