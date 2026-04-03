package com.kh.cam.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;

public interface MemberService extends UserDetailsService {

	int insertMember(Member member);

	List<University> selectUniList();

	List<Department> selectDeptList(int uniId);

	String selectMemId(Member m);

	Member selectMemById(String memId);

	int updateMember(Member inputMember);

	List<Map<String, Object>> selectDeptListBySetting(int myDeptNo);

	int deleteMember(int memNo);
	void sendSms(String phone);

	void register(Member member);


}
