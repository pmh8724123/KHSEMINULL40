package com.kh.cam.assessment.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.assessment.model.vo.Assessment;

@Repository
public class AssessmentDaoImpl implements AssessmentDao {

	@Override
	public Assessment getLectureInfo(SqlSessionTemplate sqlSession, int lectureNo) {
		return sqlSession.selectOne("assessment.getLectureInfo",lectureNo);
	}

}
