package com.kh.cam.admin.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.admin.model.dao.AdminDao;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService{
	
	private final AdminDao adminDao;
	
	// 회원 상태 관리
	@Override
	public List<Member> selectMemberList(int uniNo, String condition, String keyword) {
		
	    Map<String, Object> map = new HashMap<>();
	    map.put("uniNo", uniNo);
	    
	    if(condition != null && !condition.isEmpty()) {
	        map.put("condition", condition);
	    }

	    if(keyword != null && !keyword.isEmpty()) {
	        map.put("keyword", keyword);
	    }
	    

	    return adminDao.selectMemberList(map);
	}
	
	@Override
	@Transactional
	public int updateMemberStatus(int memNo, String status, int uniNo) {
	    
	    int result = adminDao.updateMemberStatus(memNo, status, uniNo);
	    
	    if (result <= 0) {
	        return result;
	    }

	    if ("Y".equals(status)) {
	        int count = adminDao.countAuthority(memNo, "ROLE_USER", uniNo);

	        if (count == 0) {
	            adminDao.insertAuthority(memNo, "ROLE_USER", uniNo);
	        }
	    } else if ("B".equals(status) || "N".equals(status)) {
	        adminDao.deleteAuthority(memNo, "ROLE_USER", uniNo);
	    }

	    return result;
	}
	
	/*
	 * @Override public int deleteMember(int memNo) { return
	 * adminDao.deleteMember(memNo); }
	 */
	
	// 회원 승인관리 리스트
	@Override
	public List<Member> selectMemberJoinList(int uniNo, String condition, String keyword) {
		Map<String, Object> map = new HashMap<>();
		
		map.put("uniNo", uniNo);
	    map.put("condition", condition);
	    map.put("keyword", keyword);

	    return adminDao.selectMemberJoinList(map);
	}

	@Override
	@Transactional
	public int approveMember(int memNo, int uniNo) {

	    // 중복 체크
	    if(adminDao.countAuthority(memNo, "ROLE_USER", uniNo) > 0) {
	        return 0;
	    }

	    return adminDao.insertAuthority(memNo, "ROLE_USER", uniNo);
	}
	
	@Override
	public int deleteMemberJoin(int memNo) {
		return adminDao.deleteMemberJoin(memNo);
	}
	
	// 학과 관리
	@Override
	public List<Department> selectDepartmentList() {
		return adminDao.selectDepartmentList();
	}
	
	@Override
	public int updateDepartment(Department dept) {
		return adminDao.updateDepartment(dept);
	}
	
	@Override
	public int deleteDepartment(Department deptNo) {
		return adminDao.deleteDepartment(deptNo);
	}
	
	@Override
	public int insertDepartment(Department dept) {
		return adminDao.insertDepartment(dept);
	}
	
	@Override
	public List<Lecture> selectLectureList() {
		return adminDao.selectLectureList();
	}

	// 강의 관리
	@Override
	public int insertLecture(Lecture lecture) {
		return adminDao.insertLecture(lecture);
	}

	@Override
	public int deleteLecture(Lecture lectureNo) {
		return adminDao.deleteLecture(lectureNo);
	}

	

	
	

	

	

	

	

}
