package com.kh.cam.mypage.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.mypage.model.dao.MypageDao;
import com.kh.cam.mypage.model.vo.Friends;

<<<<<<< Updated upstream
@Service

=======
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
>>>>>>> Stashed changes
public class MypageServiceImpl implements MypageService{

    private final MypageDao mypageDao;

	@Override
	public List<Friends> selectFriendList(int memNo) {
		return mypageDao.selectFriendList(memNo);
	}




}
