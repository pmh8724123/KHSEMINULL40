package com.kh.cam.admin.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.admin.model.service.AdminService;
import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.vo.Lecture;

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
	public String adminMain() {
		return "admin/adminMain";
	}

// ---------------------회원관리----------------------------------
	// 회원 상태 관리 조회
	@GetMapping("/memberStatus")
	public String memberStatus(
			@RequestParam(value="condition", required=false) String condition,
	        @RequestParam(value="keyword", required=false) String keyword,
	        Model model
			) {
		
		
		List<Member> list = adminService.selectMemberList(condition, keyword);

		model.addAttribute("list", list);
	    model.addAttribute("condition", condition);
	    model.addAttribute("keyword", keyword);

		return "admin/memberStatus";
	}

	// 회원 상태 변경
	@PostMapping("member/status")
	public String updateMemberStatus(int memNo, String status, RedirectAttributes ra) {

		adminService.updateMemberStatus(memNo, status);

		if ("Y".equals(status)) {
			ra.addFlashAttribute("msg", "회원이 활성화되었습니다.");
			ra.addFlashAttribute("type", "success");
		} else {
			ra.addFlashAttribute("msg", "회원이 정지되었습니다.");
			ra.addFlashAttribute("type", "error");
		}

		return "redirect:/admin/memberStatus";
	}
	
	// 회원 삭제
	@PostMapping("/member/delete")
	public String deleteMember(int memNo, RedirectAttributes ra) {

	    adminService.deleteMember(memNo);

	    ra.addFlashAttribute("msg", "회원이 삭제되었습니다.");
	    ra.addFlashAttribute("type", "error");

	    return "redirect:/admin/memberStatus";
	}
	

// ---------------------회원승인관리----------------------------------

	// 회원 가입 승인관리 조회
	@GetMapping("/memberJoin")
	public String adminMemberJoin(Model model) {
		List<Member> list = adminService.selectMemberJoinList();

		model.addAttribute("list", list);

		return "admin/memberJoin";
	}

	// 회원 가입 승인
	@PostMapping("member/join/approve")
	public String approveMemberJoin(int memNo, String status, RedirectAttributes ra) {

		adminService.updateMemberJoin(memNo, "Y");

			ra.addFlashAttribute("msg", "승인처리완료");
			ra.addFlashAttribute("type", "success");

		return "redirect:/admin/memberJoin";
	}
	
	// 회원 가입 거절/삭제
		@PostMapping("member/join/reject")
		public String rejectMemberJoin(int memNo, String status, RedirectAttributes ra) {

			adminService.deleteMember(memNo);

			ra.addFlashAttribute("msg", "승인거절");
			ra.addFlashAttribute("type", "error");

			return "redirect:/admin/memberJoin";
		}
	

// ---------------------학교관리----------------------------------
		/*
		 * // 학과 관리 조회
		 * 
		 * @GetMapping("/department") public String DepartmentList(Model
		 * model, @AuthenticationPrincipal CustomUserDetails user) {
		 * 
		 * int uniNo = user.getMember().getUniNo(); System.out.print(uniNo);
		 * List<Department> list = adminService.selectDepartmentList(uniNo);
		 * 
		 * model.addAttribute("list", list);
		 * 
		 * return "admin/department"; }
		 */
		
	// 학과 관리 조회
	@GetMapping("/department")
	public String DepartmentList(Model model) {
		
		List<Department> list = adminService.selectDepartmentList();
		
		model.addAttribute("list", list);

		return "admin/department";
	}

	// 학과 추가
	@PostMapping("/department/insert")
	public String insertDepartment(@ModelAttribute Department dept) {
		
		dept.setUniNo(1); // 테스트
		System.out.println("deptName: " + dept.getDeptName()); // 테스트
		System.out.println("uniNo: " + dept.getUniNo()); // 테스트

		adminService.insertDepartment(dept);
		
		return "redirect:/admin/department";
	}
	
	// 학과 수정
	@PostMapping("member/department/update")
	public String updateDepartment(Department dept,RedirectAttributes ra) {

		adminService.updateDepartment(dept);
		
		ra.addFlashAttribute("msg", "수정완료");
		ra.addFlashAttribute("type", "error");

		return "redirect:/admin/department";
	}

	// 수업 관리
	@GetMapping("/lecture")
	public String adminLecture(Model model) {
		List<Lecture> list = adminService.selectLectureList();

		model.addAttribute("list", list);

		return "admin/lecture";
	}

	// 강의 추가
	@PostMapping("/lecture/insert")
	public String insertLecture(@ModelAttribute Lecture lec) {

		adminService.insertLecture(lec);

		return "redirect:/admin/lecture";
	}

// ---------------------게시판 관리----------------------------------
	// 공지사항
	@GetMapping("/notice")
	public String adminNotice() {
		return "admin/notice";
	}

	// 게시판 관리
	@GetMapping("/adminBoard")
	public String adminBoard() {
		return "admin/adminBoard";
	}

	// 댓글 관리
	@GetMapping("/reply")
	public String adminReply() {
		return "admin/reply";
	}

// ---------------------신고관리----------------------------------
	// 신고 관리
	@GetMapping("/report")
	public String report() {
		return "admin/report";
	}

}
