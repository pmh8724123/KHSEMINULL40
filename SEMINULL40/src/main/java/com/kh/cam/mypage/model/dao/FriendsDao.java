package com.kh.cam.mypage.model.dao;

import java.util.List;

import com.kh.cam.mypage.model.vo.Friends;

public interface FriendsDao {


	public List<Friends> getFriendList(int memberNo);

	public List<Friends> getPendingList(int memberNo);
	
}
