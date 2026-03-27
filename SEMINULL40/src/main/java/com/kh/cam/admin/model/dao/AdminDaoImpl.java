package com.kh.cam.admin.model.dao;

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
public class AdminDaoImpl implements AdminDao{
	
	private final SqlSessionTemplate session;

	// 회원 상태 관리
	@Override
	public List<Member> selectMemberList(Map<String, Object> map) {
	    return session.selectList("admin.selectMemberList", map);
	}
	
	@Override
	public int updateMemberStatus(int memNo, String status) {
		return session.update("admin.updateMemberStatus",
                Map.of("memNo", memNo, "status", status));
	}
	
	@Override
	public int deleteMember(int memNo) {
		int result = session.delete("admin.deleteMember", memNo);

		if(result > 0) {
		    // 성공
		} else {
		    // 실패 처리
		}
		return result;
	}
	
	// 회원 승인관리	
	@Override
	public List<Member> selectMemberJoinList() {
		return session.selectList("admin.selectMemberJoinList");
	}

	@Override
	public int updateMemberJoin(int memNo, String status) {
		return session.update("admin.updateMemberJoin",
                Map.of("memNo", memNo, "status", status));
	}
	// 학과관리
	@Override
	public List<Department> selectDepartmentList() {
		return session.selectList("admin.selectDepartmentList");
	}

	@Override
	public int insertDepartment(Department dept) {
		return session.insert("admin.insertDepartment", dept);
	}
	
	@Override
	public int updateDepartment(Department dept) {
		return session.update("admin.updateDepartment", dept);
	}
	
	// 강의관리	
	@Override
	public List<Lecture> selectLectureList() {
		return session.selectList("admin.selectLectureList");
	}

	@Override
	public int insertLecture(Lecture lec) {
		return session.insert("admin.insertLecture", lec);
	}


	
	
	
	

	
	
	
	
	
	
	
	
	
	
}
