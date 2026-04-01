package com.kh.cam.assessment.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;

import com.kh.cam.assessment.model.vo.Assessment;
import com.kh.cam.assessment.model.vo.LectureVO;

public interface AssessmentDao {
    List<Assessment> selectLectureList(SqlSessionTemplate sqlSession, String keyword);
    Assessment getLectureInfo(SqlSessionTemplate sqlSession, int lectureNo);
    List<Assessment> selectLectureListByKeyword(SqlSessionTemplate sqlSession, Map<String, Object> map);
    int insertAssessment(SqlSessionTemplate sqlSession, Assessment asse);
    
    // [추가] 강의 검색용
    List<LectureVO> searchLectures(SqlSessionTemplate sqlSession, Map<String, Object> map);
}