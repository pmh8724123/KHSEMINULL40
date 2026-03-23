package com.kh.cam.member.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@RequiredArgsConstructor
@Slf4j
public class MemberDaoImpl implements MemberDao {

	private final SqlSessionTemplate session;
	
	@Override
	public int insertMember(Member member) {
		log.info(member.toString());
		return session.insert("member.insertMember", member);
	}

	@Override
	public List<University> selectUniList() {
		return session.selectList("member.selectUniList");
	}

	@Override
	public List<Department> selectDeptList(int uniNo) {
		return session.selectList("member.selectDeptList", uniNo);
	}

	@Override
	public Member loginMember(Member m) {
		return session.selectOne("member.loginMember", m);
	}

	@Override
	public Member loadUserByUsername(String username) {
		return session.selectOne("member.loadUserByUsername", username);
	}

}
