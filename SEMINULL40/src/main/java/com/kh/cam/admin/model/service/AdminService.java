package com.kh.cam.admin.model.service;

import java.util.List;
import java.util.Map;

import com.kh.cam.board.model.vo.Board;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.report.model.vo.Report;

public interface AdminService {

	// 회원 상태 관리
	List<Member> selectMemberList(int uniNo, String condition, String keyword);
	
	int updateMemberStatus(int memNo, String status, int uniNo);
	
	/* int deleteMember(int memNo); */
	
	
	// 회원 승인 관리
	List<Member> selectMemberJoinList(int uniNo, String condition, String keyword);
	
	int approveMember(int memNo, int uniNo);
	
	int rejectMemberJoin(int memNo);

	// 학과 관리
	List<Department> selectDepartmentList(int uniNo, String condition, String keyword);

	int insertDepartment(Department dept);
	
	int updateDepartment(Department dept);

	int deleteDepartment(Department deptNo);
	
	// 강의 관리
	List<Lecture> selectLectureList(int uniNo, String condition, String keyword);

	int insertLecture(Lecture lecture);

	int updateLecture(Lecture lecture);
	
	int deleteLecture(int lectureNo);
	
	// 게시판 관리
	List<Board> selectBoardList(int uniNo, String condition, String keyword);

	// 학교관리
	List<University> selectUniList(Map<String, Object> param);

	void insertUni(University uni);

	void updateUni(University uni);

	void updateUniStatus(University uni);

	List<Report> selectReportList(int uniNo);

	int deleteReport(int reportNo);

	Map<String, Object> selectDashboardCounts(int uniNo);

	List<Map<String, Object>> selectRecentReports(int uniNo);

}
