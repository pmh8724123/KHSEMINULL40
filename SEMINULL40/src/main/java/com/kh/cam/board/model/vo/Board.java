package com.kh.cam.board.model.vo;

import lombok.Data; // Lombok 사용 시

@Data
public class Board {
    private int boardNo;
    private int ubtypeNo;       // DB의 UBTYPE_NO 컬럼과 매칭
    private String boardTitle;
    private String boardContent;
    private int boardWriter;
    private int viewCount;
    private String createDate;
    private String status;
    
    // [가장 중요] DB 조인 결과인 카테고리 이름을 담기 위해 이 필드가 반드시 있어야 합니다!
    private String categoryName; 
    
    // [추가] 등록/수정 시 사용할 학교 번호
    private int uniNo;
    
    // [추가] 리스트에서 작성자 이름을 보여주기 위한 필드
    private String boardWriterName;
    
    // [추가] 좋아요 수
    private int likeCount;
}