package com.kh.cam.admin.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminDao {
	
	// 회원 상태관리
	List<Member> selectMemberList(Map<String, Object> map);

	int updateMemberStatus(int memNo, String status);
	
	int deleteMember(int memNo);
	
	// 회원 승인관리
	List<Member> selectMemberJoinList();

	int updateMemberJoin(int memNo, String status);
	
	// 학과관리
	List<Department> selectDepartmentList();
	
	int insertDepartment(Department dept);
	
	int updateDepartment(Department dept);
	
	int deleteDepartment(Department deptNo);
	
	// 강의관리
	List<Lecture> selectLectureList();

	int insertLecture(Lecture lec);

	



	


}
