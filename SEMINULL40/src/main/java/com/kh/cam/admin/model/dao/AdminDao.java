package com.kh.cam.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

public interface AdminDao {
	
	// 회원 상태관리
	List<Member> selectMemberList(Map<String, Object> map);

	int updateMemberStatus(@Param("memNo") int memNo, @Param("status") String status, @Param("uniNo") int uniNo);
	
	/* int deleteMember(int memNo); */
	
	// 회원 승인관리
	List<Member> selectMemberJoinList(Map<String, Object> map);

	int updateMemberJoin(@Param("memNo") int memNo, @Param("status") String status, @Param("uniNo") int uniNo);
	
	int deleteMemberJoin(int memNo);
	
	// 권한관리
	int insertAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);

	int countAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);
	
	int deleteAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);
	
	
	// 학과관리
	List<Department> selectDepartmentList();
	
	int insertDepartment(Department dept);
	
	int updateDepartment(Department dept);
	
	int deleteDepartment(Department deptNo);
	
	// 강의관리
	List<Lecture> selectLectureList();

	int insertLecture(Lecture lecture);

	int deleteLecture(Lecture lectureNo);





	



	


}
