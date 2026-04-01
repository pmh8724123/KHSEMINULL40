package com.kh.cam.assessment.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LectureVO {
    private int lectureNo;
    private String lectureName;
    private String professorName;
    private int uniNo;
}