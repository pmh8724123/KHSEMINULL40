package com.kh.cam.admin.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.admin.model.dao.AdminDao;
import com.kh.cam.board.model.vo.Board;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.dao.MemberDao;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.report.model.vo.Report;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService{
	
	private final AdminDao adminDao;
	private final MemberDao mDao;
	private final BCryptPasswordEncoder pwEncoder;
	
	// 회원 상태 관리
	@Override
	public List<Member> selectMemberList(int uniNo, String condition, String keyword) {
		
	    Map<String, Object> map = new HashMap<>();
	    map.put("uniNo", uniNo);
	    
	    if(condition != null && !condition.isEmpty()) {
	        map.put("condition", condition);
	    }

	    if(keyword != null && !keyword.isEmpty()) {
	        map.put("keyword", keyword);
	    }
	    

	    return adminDao.selectMemberList(map);
	}
	
	@Override
	@Transactional
	public int updateMemberStatus(int memNo, String status, int uniNo) {
	    
	    int result = adminDao.updateMemberStatus(memNo, status, uniNo);
	    
	    if (result <= 0) {
	        return result;
	    }

	    if ("Y".equals(status)) {
	        int count = adminDao.countAuthority(memNo, "ROLE_USER", uniNo);

	        if (count == 0) {
	            adminDao.insertAuthority(memNo, "ROLE_USER", uniNo);
	        }
	    } else if ("B".equals(status) || "N".equals(status)) {
	        adminDao.deleteAuthority(memNo, "ROLE_USER", uniNo);
	    }

	    return result;
	}
	
	// 회원 승인관리 리스트
	@Override
	public List<Member> selectMemberJoinList(int uniNo, String condition, String keyword) {
		Map<String, Object> map = new HashMap<>();
		
		map.put("uniNo", uniNo);
	    map.put("condition", condition);
	    map.put("keyword", keyword);

	    return adminDao.selectMemberJoinList(map);
	}

	@Override
	@Transactional
	public int approveMember(int memNo, int uniNo) {

	    // 중복 체크
	    if(adminDao.countAuthority(memNo, "ROLE_USER", uniNo) > 0) {
	        return 0;
	    }

	    return adminDao.insertAuthority(memNo, "ROLE_USER", uniNo);
	}
	
	@Override
	public int rejectMemberJoin(int memNo) {
		return adminDao.rejectMemberJoin(memNo);
	}
	
	// 학과 관리
	@Override
	public List<Department> selectDepartmentList(int uniNo, String condition, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("uniNo", uniNo);
		
		 if(condition != null && !condition.isEmpty()) {
		        map.put("condition", condition);
		    }

		    if(keyword != null && !keyword.isEmpty()) {
		        map.put("keyword", keyword);
		    }
		
		return adminDao.selectDepartmentList(map);
	}
	
	@Override
	public int updateDepartment(Department dept) {
		return adminDao.updateDepartment(dept);
	}
	
	@Override
	public int deleteDepartment(Department deptNo) {
		return adminDao.deleteDepartment(deptNo);
	}
	
	@Override
	public int insertDepartment(Department dept) {
		return adminDao.insertDepartment(dept);
	}
	
	// 강의관리
	@Override
	public List<Lecture> selectLectureList(int uniNo, String condition, String keyword) {
		Map<String, Object> map = new HashMap<>();
	    map.put("uniNo", uniNo);
	    
	    if(condition != null && !condition.isEmpty()) {
	        map.put("condition", condition);
	    }

	    if(keyword != null && !keyword.isEmpty()) {
	        map.put("keyword", keyword);
	    }
	    
		return adminDao.selectLectureList(map);
	}

	@Override
	public int insertLecture(Lecture lecture) {
		return adminDao.insertLecture(lecture);
	}
	
	@Override
	public int updateLecture(Lecture lecture) {
		return adminDao.updateLecture(lecture);
	}

	@Override
	public int deleteLecture(int lectureNo) {
		return adminDao.deleteLecture(lectureNo);
	}
	
	// 게시판 관리
	@Override
	public List<Board> selectBoardList(int uniNo, String condition, String keyword) {
		
		Map<String, Object> map = new HashMap<>();
	    map.put("uniNo", uniNo);
	    
	    if(condition != null && !condition.isEmpty()) {
	        map.put("condition", condition);
	    }

	    if(keyword != null && !keyword.isEmpty()) {
	        map.put("keyword", keyword);
	    }
	    
	    return adminDao.selectBoardList(map);
	}


	
	/* 대학 정보 조회 */
	@Override
	public List<University> selectUniList(Map<String, Object> param) {
		return adminDao.selectUniList(param);
	}

	@Override
	@Transactional
	public void insertUni(University uni) {
		adminDao.insertUni(uni);
		
		Department dept = new Department();
		dept.setUniNo(uni.getUniNo());
		dept.setDeptName("공통교양");
		
		adminDao.insertDepartment(dept);
		
		Member member = new Member();
		member.setMemId(uni.getMemId());
	    member.setMemPw(pwEncoder.encode(uni.getMemId() + "00"));
	    member.setMemName(uni.getMemName());
	    member.setDeptNo(dept.getDeptNo());
		
	    mDao.insertMember(member);
	    
	    adminDao.insertAuthority(member.getMemNo(), "ROLE_USER", uni.getUniNo());
	    adminDao.insertAuthority(member.getMemNo(), "ROLE_ADMIN", uni.getUniNo());
	}

	@Override
	public void updateUni(University uni) {
		adminDao.updateUni(uni);
	}

	@Override
	public void updateUniStatus(University uni) {
		uni.setStatus(uni.getStatus() == 'Y' ? 'N' : 'Y');
		adminDao.updateUniStatus(uni);
	}

	@Override
	public List<Report> selectReportList(int uniNo) {
		return adminDao.selectReportList(uniNo);
	}

	@Override
	public int deleteReport(int reportNo) {
		return adminDao.deleteReport(reportNo);
	}

	@Override
	public Map<String, Object> selectDashboardCounts(int uniNo) {
		return adminDao.selectDashboardCounts(uniNo);
	}

	@Override
	public List<Map<String, Object>> selectRecentReports(int uniNo) {
		return adminDao.selectRecentReports(uniNo);
	}

}
