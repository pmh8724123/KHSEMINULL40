package com.kh.cam.admin.model.service;

import java.util.List;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminService {

	// 회원 상태 관리
	List<Member> selectMemberList(int uniNo, String condition, String keyword);
	
	int updateMemberStatus(int memNo, String status);
	
	int deleteMember(int memNo);
	
	
	// 회원 승인 관리
	List<Member> selectMemberJoinList();
	

	int updateMemberJoin(int memNo, String status);
	

	// 학과 관리
	// List<Department> selectDepartmentList(int uniNo);
	List<Department> selectDepartmentList();

	int insertDepartment(Department dept);
	
	int updateDepartment(Department dept);

	int deleteDepartment(Department deptNo);
	
	// 강의 관리
	List<Lecture> selectLectureList();

	int insertLecture(Lecture lecture);

	int deleteLecture(Lecture lecNo);





}
