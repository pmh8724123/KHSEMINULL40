package com.kh.cam.mypage.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.kh.cam.mypage.model.dao.MypageDao;
import com.kh.cam.mypage.model.vo.Friends;

public class MypageServiceImpl implements MypageService{

    @Autowired
    private MypageDao mypageDao;

	@Override
	public List<Friends> selectFriendList(int memNo) {
		return mypageDao.selectFriendList(memNo);
	}




}
