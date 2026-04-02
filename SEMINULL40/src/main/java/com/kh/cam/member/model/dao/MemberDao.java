package com.kh.cam.member.model.dao;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;

public interface MemberDao {

	int insertMember(Member member);

	List<University> selectUniList();

	List<Department> selectDeptList(int uniNo);

	Member loadUserByUsername(String username);

	String selectMemId(Member m);

	int updateMember(Member inputMember);

}
