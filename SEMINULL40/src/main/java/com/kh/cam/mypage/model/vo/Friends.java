package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Friends {
	
	// 둘 다 회원 번호 참조
    private int senderNo;      // 보내는 사람 번호
    private int receiverNo; // 받는 사람 번호
    private String status;     // 친구 상태인지 아닌지 
	
    
    // MEMBER 테이블 JOIN으로 가져올 값
    // MEMBER 테이블의 memNo(회원 번호) 참조
    private int friendNo;     // 상대방 회원 번호 (화면 표시용)
    // MEMBER 테이블의 memName(회원 이름) 참조
    private String friendName;   // 상대방 이름 (화면 표시용)
    // MEMBER 테이블의 onlineStatus(온라인 여부) 참조
    private String onlineStatus; // 온라인 여부 ('O': 온라인, 'F': 오프라인)
    

    // 친구 추가 검색 시 사용
    // MEMBER 테이블의 memNo(회원 번호) 참조
    private int memNo;       // 검색된 회원 번호
    // MEMBER 테이블의 memName(회원 이름) 참조
    private String memName;     // 검색된 회원 이름
    // DB 값 아님 - 이미 친구 신청했는지 화면 표시용 플래그
    private boolean requested;   // true: 이미 신청함, false: 신청 안 함
}
