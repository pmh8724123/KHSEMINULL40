package com.kh.cam.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Friends {
	
    private int memNo;      // 친구 번호
    private String memName; // 친구 이름
    private String profileImg; // 프로필
    private String status;     // 상태
	
}
