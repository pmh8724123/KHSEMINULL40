package com.kh.cam.mypage.model.service;

import java.util.List;

import com.kh.cam.mypage.model.vo.Friends;

public interface FriendsService {

	List<Friends> getFriendList(int memNo);

	// 이름으로 회원 검색
	List<Friends> searchMember(int senderNo, String keyword);

	// 친구 요청
	// 반환값: "ok"(성공), "already"(중복), "fail"(실패)
	String insertFriendRequest(int senderNo, int receiverNo);

	
	
	// 수락 대기 중인 친구 요청 목록 조회
	List<Friends> getPendingList(int receiverNo);

	// 친구 수락
	// 반환값: "ok"(성공), "fail"(실패)
	String acceptFriend(int senderNo, int receiverNo);

	// 친구 거절
	// 반환값: "ok"(성공), "fail"(실패)
	String rejectFriend(int senderNo, int receiverNo);
}
