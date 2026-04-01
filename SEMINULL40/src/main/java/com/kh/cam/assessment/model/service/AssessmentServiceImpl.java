package com.kh.cam.assessment.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.cam.assessment.model.dao.AssessmentDao;
import com.kh.cam.assessment.model.vo.Assessment;
import com.kh.cam.assessment.model.vo.LectureVO;

@Service
public class AssessmentServiceImpl implements AssessmentService {

    @Autowired
    private AssessmentDao assessmentDao;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Override
    public List<Assessment> selectLectureList(String keyword) {
        return assessmentDao.selectLectureList(sqlSession, keyword);
    }

    @Override
    public Assessment getLectureInfo(int lectureNo) {
        return assessmentDao.getLectureInfo(sqlSession, lectureNo);
    }

    @Override
    public List<Assessment> selectLectureListByKeyword(String keyword, int uniNo) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("uniNo", uniNo);
        return assessmentDao.selectLectureListByKeyword(sqlSession, map);
    }

    @Override
    public int insertAssessment(Assessment asse) {
        return assessmentDao.insertAssessment(sqlSession, asse);
    }
    
    @Override
    public List<LectureVO> searchLectures(int uniNo, String keyword) {
        Map<String, Object> map = new HashMap<>();
        map.put("uniNo", uniNo);
        map.put("keyword", keyword);
        return assessmentDao.searchLectures(sqlSession, map); // DAO 호출
    }
    
}