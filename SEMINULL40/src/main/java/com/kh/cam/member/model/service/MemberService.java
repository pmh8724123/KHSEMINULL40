package com.kh.cam.member.model.service;

import java.util.List;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;

public interface MemberService {

	int insertMember(Member member);

	List<University> selectUniList();

	List<Department> selectDeptList(int uniId);

	Member loginMember(Member m);

}
