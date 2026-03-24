package com.kh.cam.admin.model.service;

import java.util.List;

import com.kh.cam.common.model.vo.DepartmentDTO;
import com.kh.cam.member.model.vo.MemberDTO;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminService {

	List<MemberDTO> selectMemberList();
	
	List<MemberDTO> selectMemberJoinList();
	
	int updateMemberStatus(int memNo, String status);

	int updateMemberJoin(int memNo, String status);

	List<DepartmentDTO> selectDepartmentList();

	List<Lecture> selectLectureList();

}
