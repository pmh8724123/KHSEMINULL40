package com.kh.cam.admin.model.dao;

import java.util.List;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminDao {

	List<Member> selectMemberList();

	int updateMemberStatus(int memNo, String status);
	
	List<Member> selectMemberJoinList();

	int updateMemberJoin(int memNo, String status);
	
	List<Department> selectDepartmentList();
	
	int insertDepartment(Department dept);

	List<Lecture> selectLectureList();

	int insertLecture(Lecture lec);

	


}
