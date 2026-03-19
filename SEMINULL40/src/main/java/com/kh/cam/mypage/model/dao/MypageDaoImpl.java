package com.kh.cam.mypage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Friends;

@Repository
public class MypageDaoImpl implements MypageDao{

    @Autowired
    private SqlSessionTemplate session;

	@Override
	public List<Friends> selectFriendList(int memNo) {
		return session.selectList("mypage.selectFriendList");
	}
}
