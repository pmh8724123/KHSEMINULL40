package com.kh.cam.assessment.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.assessment.model.vo.Assessment;
import com.kh.cam.assessment.model.vo.LectureVO;

@Repository
public class AssessmentDaoImpl implements AssessmentDao {

	@Override
	public List<Assessment> selectLectureList(SqlSessionTemplate sqlSession, Map<String, Object> map) {
	    return sqlSession.selectList("assessment.selectLectureList", map);
	}

    @Override
    public Assessment getLectureInfo(SqlSessionTemplate sqlSession, int lectureNo) {
        return sqlSession.selectOne("assessment.getLectureInfo", lectureNo);
    }

    @Override
    public List<Assessment> selectLectureListByKeyword(SqlSessionTemplate sqlSession, Map<String, Object> map) {
        return sqlSession.selectList("assessment.selectLectureListByKeyword", map);
    }

    @Override
    public int insertAssessment(SqlSessionTemplate sqlSession, Assessment asse) {
        return sqlSession.insert("assessment.insertAssessment", asse);
    }
    
    @Override
    public List<LectureVO> searchLectures(SqlSessionTemplate sqlSession, Map<String, Object> map) {
        return sqlSession.selectList("assessment.searchLectures", map);
    }
}