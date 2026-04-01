package com.kh.cam.assessment.model.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class Assessment {
    // LECTURE_ASSESSMENT 테이블 컬럼
    private int asseNo;
    private int memNo;      // MEMBER 테이블 참조
    private int lectureNo;  // LECTURE 테이블 참조
    private int homework;
    private int grade;
    private int totalScore; // DB의 TOTAL_SCORE와 매핑

    // 조인 및 통계를 위한 추가 필드
    private String lectureName;
    private String professorName;
    private String uniName;
    private int uniNo;
    private double avgScore;
    private int reviewCount;
}