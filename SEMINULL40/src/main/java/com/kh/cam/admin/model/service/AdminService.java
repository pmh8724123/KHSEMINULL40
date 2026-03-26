package com.kh.cam.admin.model.service;

import java.util.List;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminService {

	List<Member> selectMemberList();
	
	List<Member> selectMemberJoinList();
	
	int updateMemberStatus(int memNo, String status);

	int updateMemberJoin(int memNo, String status);

	List<Department> selectDepartmentList(int uniNo);

	int insertDepartment(Department dept);

	List<Lecture> selectLectureList();

	int insertLecture(Lecture lec);


}
