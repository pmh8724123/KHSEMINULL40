package com.kh.cam.mypage.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.cam.mypage.model.vo.Friends;

@Repository
public class FriendsDaoImpl implements FriendsDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Friends> getFriendList(int memNo) {
		return sqlSession.selectList("friends.getFriendList", memNo);
	}


	
	// 수락 대기 중인 친구 요청 목록 조회
	// FRIEND 테이블에서 receiverNo = 내 memNo, status = 'N'인 목록
	@Override
	public List<Friends> getPendingList(int receiverNo) {
	    // receiverNo: 로그인한 사람의 memNo (내가 받은 요청만 조회)
	    return sqlSession.selectList("friends.getPendingList", receiverNo);
	}

	// 친구 수락
	// FRIEND 테이블의 status 'N' → 'Y' UPDATE
	@Override
	public int acceptFriend(int senderNo, int receiverNo) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("senderNo",   senderNo);   // 요청 보낸 사람 memNo
	    map.put("receiverNo", receiverNo); // 요청 받은 사람 memNo (내 memNo)
	    return sqlSession.update("friends.acceptFriend", map);
	}

	// 친구 거절
	// FRIEND 테이블에서 해당 요청 DELETE
	@Override
	public int rejectFriend(int senderNo, int receiverNo) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("senderNo",   senderNo);   // 요청 보낸 사람 memNo
	    map.put("receiverNo", receiverNo); // 요청 받은 사람 memNo (내 memNo)
	    return sqlSession.delete("friends.rejectFriend", map);
	}

	
	
	// 이름으로 회원 검색
	// MEMBER 테이블의 memName 컬럼 LIKE 검색
	@Override
	public List<Friends> searchMember(int senderNo, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("senderNo", senderNo); // 본인 제외 및 신청 여부 확인용
		map.put("keyword", keyword); // 검색어
		return sqlSession.selectList("friends.searchMember", map);
	}

	
	
	// 친구 요청 INSERT
	// FRIEND 테이블에 senderNo, receiverNo, status('N') 삽입
	@Override
	public int insertFriendRequest(Friends vo) {
		return sqlSession.insert("friends.insertFriendRequest", vo);
	}

	
	
	// 이미 친구 요청이 존재하는지 확인
	// 양방향 모두 체크 (중복 신청 방지)
	@Override
	public int checkAlreadyRequested(int senderNo, int receiverNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("senderNo", senderNo); // 요청 보내는 사람 memNo
		map.put("receiverNo", receiverNo); // 요청 받는 사람 memNo
		return sqlSession.selectOne("friends.checkAlreadyRequested", map);
	}

}
