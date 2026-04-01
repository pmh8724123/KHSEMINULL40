package com.kh.cam.assessment.model.service;

import java.util.List;

import com.kh.cam.assessment.model.vo.Assessment;
import com.kh.cam.assessment.model.vo.LectureVO;

public interface AssessmentService {
    Assessment getLectureInfo(int lectureNo);
    List<Assessment> selectLectureListByKeyword(String keyword, int uniNo);
    List<Assessment> selectLectureList(String keyword);
    int insertAssessment(Assessment asse);

    // [추가] 실시간 검색용 메서드
    List<LectureVO> searchLectures(int uniNo, String keyword);
}