package com.kh.cam.assessment.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.assessment.model.dao.AssessmentDao;
import com.kh.cam.assessment.model.vo.Assessment;

@Service
public class AssessmentServiceImpl implements AssessmentService {

	@Autowired
	private AssessmentDao assessmentDao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public Assessment getLectureInfo(int lectureNo) {
		return assessmentDao.getLectureInfo(sqlSession, lectureNo);
	}

}
