package com.kh.cam.mypage.model.service;

import java.util.List;

import com.kh.cam.mypage.model.vo.Friends;

public interface FriendsService {
    List<Friends> getFriendList(int memberNo);
    List<Friends> getPendingList(int memberNo);
}
