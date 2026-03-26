package com.kh.cam.admin.model.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.cam.admin.model.dao.AdminDao;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.member.model.vo.MemberDTO;
import com.kh.cam.mypage.model.vo.Lecture;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService{
	
	private final AdminDao adminDao;

	@Override
	public List<Member> selectMemberList() {
		
		return adminDao.selectMemberList();
	}
	
	@Override
	public int updateMemberStatus(int memNo, String status) {
		return adminDao.updateMemberStatus(memNo, status);
	}
	
	@Override
	public List<Member> selectMemberJoinList() {
		return adminDao.selectMemberJoinList();
	}

	@Override
	public int updateMemberJoin(int memNo, String status) {
		return adminDao.updateMemberJoin(memNo, status);
	}

	@Override
	public List<Department> selectDepartmentList(int uniNo) {
		return adminDao.selectDepartmentList();
	}
	
	@Override
	public int insertDepartment(Department dept) {
		return adminDao.insertDepartment(dept);
	}

	@Override
	public List<Lecture> selectLectureList() {
		return adminDao.selectLectureList();
	}

	@Override
	public int insertLecture(Lecture lec) {
		return adminDao.insertLecture(lec);
	}

	

	

}
