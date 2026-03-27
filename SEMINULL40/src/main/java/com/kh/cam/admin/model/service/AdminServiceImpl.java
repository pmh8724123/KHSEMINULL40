package com.kh.cam.admin.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

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
	public List<Member> selectMemberList(String condition, String keyword) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("condition", condition);
	    map.put("keyword", keyword);

	    return adminDao.selectMemberList(map);
	}
	
	@Override
	public int updateMemberStatus(int memNo, String status) {
		return adminDao.updateMemberStatus(memNo, status);
	}
	
	@Override
	public int deleteMember(int memNo) {
		return adminDao.deleteMember(memNo);
	}
	
	// 회원 승인 관리
	@Override
	public List<Member> selectMemberJoinList() {
		return adminDao.selectMemberJoinList();
	}

	@Override
	public int updateMemberJoin(int memNo, String status) {
		return adminDao.updateMemberJoin(memNo, status);
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
	
	/*
	 * // 학과 관리
	 * 
	 * @Override public List<Department> selectDepartmentList(int uniNo) { return
	 * adminDao.selectDepartmentList(); }
	 */
	
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
	public int insertLecture(Lecture lec) {
		return adminDao.insertLecture(lec);
	}

	

	

	

	

}
