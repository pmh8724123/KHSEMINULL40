package com.kh.cam.mypage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Friends;

<<<<<<< Updated upstream
@Repository
=======
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
>>>>>>> Stashed changes
public class MypageDaoImpl implements MypageDao{

    private final SqlSessionTemplate session;

	@Override
	public List<Friends> selectFriendList(int memNo) {
		return session.selectList("mypage.selectFriendList");
	}
}
