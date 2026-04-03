package com.kh.cam.member.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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
	public Member loadUserByUsername(String username) {
		return session.selectOne("member.loadUserByUsername", username);
	}

	@Override
	public String selectMemId(Member m) {
		return session.selectOne("member.selectMemId", m);
	}

	@Override
	public int updateMember(Member inputMember) {
		return session.update("member.updateMember", inputMember);
	}

	@Override
	public List<Map<String, Object>> selectDeptListBySetting(int myDeptNo) {
		return session.selectList("member.selectDeptListBySetting", myDeptNo);
	}

	@Transactional
	@Override
	public int deleteMember(int memNo) {
		
//		session.delete("member.deleteAuthorities", memNo);
//		session.delete("member.deleteFriends", memNo);
//		session.delete("member.deleteAttendance", memNo);
//		session.delete("member.deleteUserpoint", memNo);
//		session.delete("member.deleteSchedule", memNo);

		
		return session.update("member.deleteMember", memNo);
		
	}
	
	public void insertAtt(int memNo) {
		session.insert("member.insertAtt", memNo);
	}

}
