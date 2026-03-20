package com.kh.cam.mypage.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.mypage.model.dao.FriendsDao;
import com.kh.cam.mypage.model.vo.Friends;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FriendsServiceImpl implements FriendsService{

	@Autowired
    private FriendsDao friendsDao;

    @Override
    public List<Friends> getFriendList(int memberNo) {
        return friendsDao.getFriendList(memberNo);
    }

    @Override
    public List<Friends> getPendingList(int memberNo) {
        return friendsDao.getPendingList(memberNo);
    }

}
