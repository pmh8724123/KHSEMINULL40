package com.kh.cam.mypage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Friends;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor

public class MypageDaoImpl implements MypageDao{

    private final SqlSessionTemplate session;

	@Override
	public List<Friends> selectFriendList(int memNo) {
		return session.selectList("mypage.selectFriendList");
	}
}
