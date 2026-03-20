package com.kh.cam.mypage.model.service;

import java.util.List;

import com.kh.cam.mypage.model.vo.Friends;

public interface MypageService {
	
	List<Friends> selectFriendList(int senderNo);
	
}
