package com.kh.cam.mypage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Friends;


@Repository
public class FriendsDaoImpl implements FriendsDao {
	
    @Autowired
    private SqlSessionTemplate sqlSession;
	
	@Override
	public List<Friends> getFriendList(int memberNo) {
		return sqlSession.selectList("getFriendList", memberNo);
	}

	@Override
	public List<Friends> getPendingList(int memberNo) {
        return sqlSession.selectList("getPendingList", memberNo);
	}

}
