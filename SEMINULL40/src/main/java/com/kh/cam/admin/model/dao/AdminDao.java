package com.kh.cam.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.cam.board.model.vo.Board;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.report.model.vo.Report;

public interface AdminDao {
	
	// 회원 상태관리
	List<Member> selectMemberList(Map<String, Object> map);

	int updateMemberStatus(@Param("memNo") int memNo, @Param("status") String status, @Param("uniNo") int uniNo);
	
	int deleteBoardLikeByMemNo(int memNo);
	int deleteReplyLikeByMemNo(int memNo);
	int deleteReplyByMemNo(int memNo);
	int deleteBoardByMemNo(int memNo);
	int deleteReportByMemNo(int memNo);
	int deleteAuthoritiesByMemNo(int memNo);
	int deleteAttendanceByMemNo(int memNo);
	int deleteUserPointByMemNo(int memNo);
	int deleteLectureAssessmentByMemNo(int memNo);
	int deleteScheduleByMemNo(int memNo);
	int deleteFriendsByMemNo(int memNo);
	int deleteMemberByMemNo(int memNo);
	
	// 회원 승인관리
	List<Member> selectMemberJoinList(Map<String, Object> map);

	int updateMemberJoin(@Param("memNo") int memNo, @Param("status") String status, @Param("uniNo") int uniNo);
	
	int rejectMemberJoin(int memNo);
	
	// 권한관리
	int insertAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);

	int countAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);
	
	int deleteAuthority(@Param("memNo") int memNo, @Param("authority") String authority, @Param("uniNo") int uniNo);
	
	
	// 학과관리
	List<Department> selectDepartmentList(Map<String, Object> map);
	
	int insertDepartment(Department dept);
	
	int updateDepartment(Department dept);
	
	int deleteDepartment(Department deptNo);
	
	// 강의관리
	List<Lecture> selectLectureList(Map<String, Object> map);

	int insertLecture(Lecture lecture);

	int updateLecture(Lecture lecture);
	
	int deleteLecture(int lectureNo);
	
	// 게시판관리
	List<Board> selectBoardList(Map<String, Object> map);
	
	
	// 학교관리
	List<University> selectUniList(Map<String, Object> param);

	int insertUni(University uni);

	void updateUni(University uni);

	void updateUniStatus(University uni);

	List<Report> selectReportList(int uniNo);

	int deleteReport(int reportNo);

	List<Map<String, Object>> selectRecentReports(int uniNo);

	Map<String, Object> selectDashboardCounts(int uniNo);


}
