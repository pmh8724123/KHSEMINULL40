package com.kh.cam.assessment.model.dao;

import org.mybatis.spring.SqlSessionTemplate;

import com.kh.cam.assessment.model.vo.Assessment;

public interface AssessmentDao {

	Assessment getLectureInfo(SqlSessionTemplate sqlSession, int lectureNo);

}
