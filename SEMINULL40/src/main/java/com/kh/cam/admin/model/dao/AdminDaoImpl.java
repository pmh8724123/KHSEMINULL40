package com.kh.cam.admin.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class AdminDaoImpl implements AdminDao {

	private final SqlSessionTemplate session;

	// 회원 상태 관리
	@Override
	public List<Member> selectMemberList(Map<String, Object> map) {
		return session.selectList("admin.selectMemberList", map);
	}

	@Override
	public int updateMemberStatus(int memNo, String status, int uniNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("memNo", memNo);
		map.put("status", status);
		map.put("uniNo", uniNo);

		return session.update("admin.updateMemberStatus", map);
	}

	// 권한관리

	@Override
	public int insertAuthority(int memNo, String authority, int uniNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("memNo", memNo);
		map.put("authority", authority);
		map.put("uniNo", uniNo);

		return session.insert("admin.insertAuthority", map);
	}

	@Override
	public int countAuthority(int memNo, String authority, int uniNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("memNo", memNo);
		map.put("authority", authority);
		map.put("uniNo", uniNo);

		return session.selectOne("admin.countAuthority", map);
	}

	@Override
	public int deleteAuthority(int memNo, String authority, int uniNo) {
		Map<String, Object> map = new HashMap<>();

		map.put("memNo", memNo);
		map.put("authority", authority);
		map.put("uniNo", uniNo);
		
		return session.delete("admin.deleteAuthority", map);
	}

	/*
	 * @Override public int deleteMember(int memNo) { int result =
	 * session.delete("admin.deleteMember", memNo);
	 * 
	 * if (result > 0) { // 성공 } else { // 실패 처리 } return result; }
	 */

	// 회원 승인관리
	@Override
	public List<Member> selectMemberJoinList(Map<String, Object> map) {
		return session.selectList("admin.selectMemberJoinList", map);
	}

	@Override
	public int updateMemberJoin(int memNo, String status, int uniNo) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("memNo", memNo);
	    map.put("status", status);
	    map.put("uniNo", uniNo);

	    return session.update("admin.updateMemberJoin", map);
	}
	
	@Override
	public int rejectMemberJoin(int memNo) {
		return session.update("admin.rejectMemberJoin", memNo);
	}

	// 학과관리
	@Override
	public List<Department> selectDepartmentList(Map<String, Object> map) {
		return session.selectList("admin.selectDepartmentList", map);
	}

	@Override
	public int insertDepartment(Department dept) {
		return session.insert("admin.insertDepartment", dept);
	}

	@Override
	public int updateDepartment(Department dept) {
		return session.update("admin.updateDepartment", dept);
	}

	@Override
	public int deleteDepartment(Department deptNo) {
		return session.delete("admin.deleteDepartment", deptNo);
	}

	// 강의관리
	@Override
	public List<Lecture> selectLectureList() {
		return session.selectList("admin.selectLectureList");
	}

	@Override
	public int insertLecture(Lecture lecture) {
		return session.insert("admin.insertLecture", lecture);
	}

	@Override
	public int deleteLecture(Lecture lectureNo) {
		return session.delete("admin.deleteLecture", lectureNo);
	}

	

}
