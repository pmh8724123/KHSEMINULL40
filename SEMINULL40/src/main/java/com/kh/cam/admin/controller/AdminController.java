package com.kh.cam.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.admin.model.service.AdminService;
import com.kh.cam.board.model.vo.Board;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;
import com.kh.cam.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

	private final AdminService adminService;

	// 관리자 메인
	@GetMapping("/main")
	public String adminMain(Model model) {
		// 로그인한 관리자 정보에서 uniNo 가져오기
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
								  .getPrincipal();
		int uniNo = user.getMember().getUniNo();
		
		// 통계 데이터 조회
		Map<String, Object> counts = adminService.selectDashboardCounts(uniNo);
		
		// 최근 신고 목록 조회
		List<Map<String,Object>> reports = adminService.selectRecentReports(uniNo);
		
		// 데이터 전달
		model.addAttribute("counts", counts);
		model.addAttribute("reports", reports);
		model.addAttribute("loginUser", user.getMember());
		
		return "admin/adminMain";
	}

// ---------------------회원관리----------------------------------
	// 회원 상태 관리 조회
	@GetMapping("/memberStatus")
	public String memberStatus(@RequestParam(value = "condition", required = false) String condition,
			@RequestParam(value = "keyword", required = false) String keyword, Model model) {

		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int uniNo = user.getMember().getUniNo();

		List<Member> list = adminService.selectMemberList(uniNo, condition, keyword);

		model.addAttribute("list", list);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("loginUser", user.getMember());

		return "admin/memberStatus";
	}

	// 회원 상태 변경
	@PostMapping("member/status")
	public String updateMemberStatus(int memNo, String status, RedirectAttributes ra) {

		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int uniNo = user.getMember().getUniNo();
		int result = adminService.updateMemberStatus(memNo, status, uniNo);

		if (result > 0) {
	        if ("Y".equals(status)) {
	            ra.addFlashAttribute("msg", "회원이 정상 처리되었습니다.");
	            ra.addFlashAttribute("type", "success");
	        } else if ("B".equals(status)) {
	            ra.addFlashAttribute("msg", "회원이 정지 처리되었습니다.");
	            ra.addFlashAttribute("type", "error");
	        } else if ("N".equals(status)) {
	            ra.addFlashAttribute("msg", "회원이 탈퇴 처리되었습니다.");
	            ra.addFlashAttribute("type", "error");
	        }
	    } else {
	        ra.addFlashAttribute("msg", "해당 학교 관리자만 처리할 수 있습니다.");
	        ra.addFlashAttribute("type", "error");
	    }

		return "redirect:/admin/memberStatus";
	}


// ---------------------회원승인관리----------------------------------

	// 회원 가입 승인관리 조회
	@GetMapping("/memberJoin")
	public String adminMemberJoin(@RequestParam(value = "condition", required = false) String condition,
			@RequestParam(value = "keyword", required = false) String keyword, Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int uniNo = user.getMember().getUniNo();

		List<Member> list = adminService.selectMemberJoinList(uniNo, condition, keyword);

		model.addAttribute("list", list);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("loginUser", user.getMember());

		return "admin/memberJoin";
	}

	// 회원 가입 요청 승인
	@PostMapping("member/join/approve")
	public String approveMember(int memNo, RedirectAttributes ra) {

		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int uniNo = user.getMember().getUniNo();

		int result = adminService.approveMember(memNo, uniNo);

		if (result > 0) {
			ra.addFlashAttribute("msg", "회원 가입이 승인되었습니다.");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "회원 가입 승인에 실패했습니다.");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/memberJoin";
	}

	// 회원 가입 거절/삭제
	@PostMapping("member/join/reject")
	public String rejectMemberJoin(@RequestParam("memNo") int memNo, RedirectAttributes ra) {

		int result = adminService.rejectMemberJoin(memNo);

		if(result > 0) {
			ra.addFlashAttribute("msg", "가입 거절 완료");
			ra.addFlashAttribute("type", "error");
		} else {
			ra.addFlashAttribute("msg", "가입 거절 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/memberJoin";
	}

// ---------------------학교관리----------------------------------

	// 학과 관리 조회
	@GetMapping("/department")
	public String DepartmentList(@RequestParam(value = "condition", required = false) String condition,
								 @RequestParam(value = "keyword", required = false) String keyword, 
								 Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		int uniNo = user.getMember().getUniNo();
		
		List<Department> list = adminService.selectDepartmentList(uniNo, condition, keyword);

		model.addAttribute("list", list);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("loginUser", user.getMember());

		return "admin/department";
	}

	// 학과 추가
	@PostMapping("/department/insert")
	public String insertDepartment(@ModelAttribute Department dept, RedirectAttributes ra) {
		
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		dept.setUniNo(user.getMember().getUniNo());
		
		int result = adminService.insertDepartment(dept);

		if (result > 0) {
			ra.addFlashAttribute("msg", "추가 성공");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "추가 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/department";
	}

	// 학과 수정
	@PostMapping("/department/update")
	public String updateDepartment(Department dept, RedirectAttributes ra) {

		int result = adminService.updateDepartment(dept);

		System.out.println("asdasdasd" + dept);

		if (result > 0) {
			ra.addFlashAttribute("msg", "수정 완료");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "수정 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/department";
	}

	// 학과 삭제
	@PostMapping("/department/delete")
	public String deleteDepartment(Department deptNo, RedirectAttributes ra) {

		int result = adminService.deleteDepartment(deptNo);

		if (result > 0) {
			ra.addFlashAttribute("msg", "삭제 완료");
			ra.addFlashAttribute("type", "error");
		} else {
			ra.addFlashAttribute("msg", "삭제 실패");
			ra.addFlashAttribute("type", "success");
		}

		return "redirect:/admin/department";
	}

	// 강의 관리
	@GetMapping("/lecture")
	public String adminLecture(@RequestParam(value = "condition", required = false) String condition,
								 @RequestParam(value = "keyword", required = false) String keyword, 
								 Model model) {
		
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		int uniNo = user.getMember().getUniNo();
		
		List<Lecture> list = adminService.selectLectureList(uniNo, condition, keyword);
		
		List<Department> deptList = adminService.selectDepartmentList(uniNo, null, null);
		
		model.addAttribute("list", list);
		model.addAttribute("deptList", deptList);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("loginUser", user.getMember());

		return "admin/lecture";
	}

	// 강의 추가
	@PostMapping("/lecture/insert")
	public String insertLecture(@ModelAttribute Lecture lecture, RedirectAttributes ra) {

		CustomUserDetails user =
				(CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

			if(user.getMember().getUniNo() == 0) {
				ra.addFlashAttribute("msg", "마스터는 강의를 추가할 수 없습니다.");
				ra.addFlashAttribute("type", "error");
				return "redirect:/admin/lecture";
			}
		
		int result = adminService.insertLecture(lecture);
		
		if (result > 0) {
			ra.addFlashAttribute("msg", "추가 성공");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "추가 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/lecture";
	}
	
	// 강의 변경
	@PostMapping("/lecture/update")
	public String updateLecture(@ModelAttribute Lecture lecture, RedirectAttributes ra) {
		CustomUserDetails user =
				(CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

			if(user.getMember().getUniNo() == 0) {
				ra.addFlashAttribute("msg", "마스터는 강의를 수정할 수 없습니다.");
				ra.addFlashAttribute("type", "error");
				return "redirect:/admin/lecture";
			}
		
		
		int result = adminService.updateLecture(lecture);

		if (result > 0) {
			ra.addFlashAttribute("msg", "수정 성공");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "수정 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/lecture";
	}
	
	// 강의 삭제
	@PostMapping("/lecture/delete")
	public String deleteLecture(int lectureNo, RedirectAttributes ra) {
		
		int result = adminService.deleteLecture(lectureNo);

		if (result > 0) {
			ra.addFlashAttribute("msg", "삭제 성공");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "삭제 실패");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/lecture";
	}

// ---------------------게시판 관리----------------------------------
	// 공지사항
	@GetMapping("/notice")
	public String adminNotice() {
		return "admin/notice";
	}

	// 게시판 관리
	@GetMapping("/board")
	public String adminBoardList(@RequestParam(value = "condition", required = false) String condition,
								 @RequestParam(value = "keyword", required = false) String keyword, 
								 Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		int uniNo = user.getMember().getUniNo();
		
		List<Board> list = adminService.selectBoardList(uniNo, condition, keyword);
		
		model.addAttribute("list", list);
	    model.addAttribute("condition", condition);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("loginUser", user.getMember());
		
		return "admin/adminBoard";
	}

// ---------------------신고관리----------------------------------
	// 신고 관리
	@GetMapping("/report")
	public String ReportList(Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		int uniNo = user.getMember().getUniNo();
		
		List<Report> list = adminService.selectReportList(uniNo);
		
		model.addAttribute("list", list);
		model.addAttribute("loginUser", user.getMember());
		
		return "admin/report";
	}
	
	@PostMapping("/report/delete")
	public String deleteReport(@RequestParam("reportNo") int reportNo,
			   RedirectAttributes ra) {
		int result = adminService.deleteReport(reportNo);
		
		if(result > 0) {
			ra.addFlashAttribute("msg", "신고 내역 삭제 완료");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "신고 내역 삭제 실패");
			ra.addFlashAttribute("type", "error");
		}
		return "redirect:/admin/report";
	}
	
	
// ---------------------마스터 계정 : 학교 관리------------------------
	@GetMapping("/university")
	public String university(@RequestParam(required = false, defaultValue = "all") String condition, @RequestParam(required = false) String keyword, Model model) {
		Map<String, Object> param = new HashMap<>();
		param.put("condition", condition);
		param.put("keyword", keyword);
		
		List<University> list = adminService.selectUniList(param);
		
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("list", list);
		
		return "admin/university";
	}
	
	@PostMapping("/university/insert")
	public String insertUni(@ModelAttribute University uni, RedirectAttributes ra) {
		System.out.println(uni);
		
		try {
	        adminService.insertUni(uni);

	        ra.addFlashAttribute("msg", "등록 성공");
	        ra.addFlashAttribute("type", "success");

	    } catch (Exception e) {
	    	e.printStackTrace();
	        ra.addFlashAttribute("msg", "등록 실패");
	        ra.addFlashAttribute("type", "error");
	    }

		return "redirect:/admin/university";
	}
	
	@PostMapping("/university/update")
	public String updateUni(@ModelAttribute University uni, RedirectAttributes ra) {
		try {
			adminService.updateUni(uni);
			
			ra.addFlashAttribute("msg", "수정 성공");
	        ra.addFlashAttribute("type", "success");
		}
		catch(Exception e) {
			ra.addFlashAttribute("msg", "수정 실패");
			ra.addFlashAttribute("type", "error");
		}
		
		return "redirect:/admin/university";
	}
	
	@PostMapping("university/changeStatus")
	public String updateUniStatus(@ModelAttribute University uni, RedirectAttributes ra) {
		try {
			adminService.updateUniStatus(uni);
			
			ra.addFlashAttribute("msg", "수정 성공");
	        ra.addFlashAttribute("type", "success");
		}
		catch(Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("msg", "수정 실패");
			ra.addFlashAttribute("type", "error");
		}
		
		return "redirect:/admin/university";
	}

}
