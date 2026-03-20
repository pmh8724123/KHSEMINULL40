package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Friends {
	
	// 둘 다 회원 번호 참조
    private int senderNo;      // 보내는 사람 번호
    private String receiverNo; // 받는 사람 번호
    private String status;     // 친구 상태인지 아닌지 
	
    
    private int friendNo;    // 상대방 회원 번호 (표시용)
    private String friendName;  // 상대방 이름
    private String onlineStatus; // 온라인 여부: 'O' = 온라인, 'F' = 오프라인
}
