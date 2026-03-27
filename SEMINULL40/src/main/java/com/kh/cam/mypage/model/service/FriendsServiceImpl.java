package com.kh.cam.mypage.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.mypage.model.dao.FriendsDao;
import com.kh.cam.mypage.model.vo.Friends;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FriendsServiceImpl implements FriendsService {

	@Autowired
	private FriendsDao friendsDao;

	@Override
	public List<Friends> getFriendList(int memberNo) {
		return friendsDao.getFriendList(memberNo);
	}

	// 이름으로 회원 검색
	// 검색 결과에서 이미 신청한 경우 requested 플래그 true 설정
	@Override
	public List<Friends> searchMember(int senderNo, String keyword) {
		List<Friends> list = friendsDao.searchMember(senderNo, keyword);
		
		Map<String, Object> map = new HashMap<>();
		// FRIEND 테이블 JOIN 결과의 status가 'Y'면 이미 신청한 것
		map.put("senderNo", senderNo); // XML의 #{senderNo}와 일치해야 함
	    map.put("keyword", keyword);   // XML의 #{keyword}와 일치해야 함
	    
	    // 네임스페이스가 "mypage"이므로 호출 시 주의
	    return friendsDao.searchMember(senderNo, keyword);
	}

	// 친구 요청
	// 중복 체크 후 FRIEND 테이블에 INSERT
	@Override
	public String insertFriendRequest(int senderNo, int receiverNo) {

		// FRIEND 테이블에서 양방향 중복 체크
		int count = friendsDao.checkAlreadyRequested(senderNo, receiverNo);
		if (count > 0) {
			return "already";
		}

		// FRIEND 테이블에 INSERT
		Friends fs = new Friends();
		fs.setSenderNo(senderNo); // 요청 보내는 사람 memNo
		fs.setReceiverNo(receiverNo); // 요청 받는 사람 memNo

		int result = friendsDao.insertFriendRequest(fs);
		return result > 0 ? "ok" : "fail";
	}

	// 수락 대기 중인 친구 요청 목록 조회
	// FRIEND 테이블에서 receiverNo = 내 memNo, status = 'N'인 목록
	@Override
	public List<Friends> getPendingList(int receiverNo) {
		return friendsDao.getPendingList(receiverNo);
	}

	// 친구 수락
	// FRIEND 테이블의 status 'N' → 'Y' UPDATE
	@Override
	public String acceptFriend(int senderNo, int receiverNo) {
		int result = friendsDao.acceptFriend(senderNo, receiverNo);
		return result > 0 ? "ok" : "fail";
	}

	// 친구 거절
	// FRIEND 테이블에서 해당 요청 DELETE
	@Override
	public String rejectFriend(int senderNo, int receiverNo) {
		int result = friendsDao.rejectFriend(senderNo, receiverNo);
		return result > 0 ? "ok" : "fail";
	}

}
