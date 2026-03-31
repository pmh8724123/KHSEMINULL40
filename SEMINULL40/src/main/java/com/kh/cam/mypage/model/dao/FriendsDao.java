package com.kh.cam.mypage.model.dao;

import java.util.List;

import com.kh.cam.mypage.model.vo.Friends;

public interface FriendsDao {

	// 수락된 친구 목록 조회 (내가 보낸 + 받은 요청 모두 포함)
	List<Friends> selectFriendList(int memNo);


	// 이름(keyword)으로 회원 검색
	// MEMBER 테이블의 memName 컬럼 LIKE 검색
	List<Friends> searchMember(int senderNo, String keyword);

	// 친구 요청 INSERT
	// FRIEND 테이블에 senderNo, receiverNo, status('N') 삽입
	int insertFriendRequest(Friends vo);

	// 이미 친구 요청이 존재하는지 확인
	// 중복 신청 방지용 (양방향 체크)
	int checkAlreadyRequested(int senderNo, int receiverNo);

	// 수락 대기 중인 친구 요청 목록 조회
	// FRIEND 테이블에서 receiverNo = 내 memNo, status = 'N'인 목록
	List<Friends> getPendingList(int receiverNo);

	// 친구 수락
	// FRIEND 테이블의 status 'N' → 'Y' UPDATE
	int acceptFriend(int senderNo, int receiverNo);

	// 친구 거절
	// FRIEND 테이블에서 해당 요청 DELETE
	int rejectFriend(int senderNo, int receiverNo);


	int deleteFriend(int senderNo, int receiverNo);
}
