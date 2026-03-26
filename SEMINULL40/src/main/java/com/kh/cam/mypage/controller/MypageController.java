package com.kh.cam.mypage.controller;

import java.util.Date;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.mypage.model.service.AttendanceService;
import com.kh.cam.mypage.model.service.FriendsService;
import com.kh.cam.mypage.model.service.MypageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/member")
public class MypageController {

	private final MypageService mypageService;
	
	private final MemberService mService;
	
	private final FriendsService fService;

	private final AttendanceService aService;
	
	
	private int getMemNo() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String memName = auth.getName();
		int result = mService.getMemNo(memName);
		log.info("값 : {}", result);
		
		
		return result;
	}
	
	// mypage 호출 시 기본 화면(출석 체크) 화면 띄움 
	@GetMapping("/mypage")
	public String mypage(Model model) {
		
		
		// 출석  불러오기 기능
		int result = aService.selectAttendCnt(getMemNo());
		
		log.info("값 2 : {}", result);

		model.addAttribute("attendCnt", result);
		
		
		// 친구 목록 불러오기 기능
		
		
		
		return "/member/mypage";
	}

	
	
	
	@RequestMapping("/withdraw")
	public String withdraw() {
		return "/member/withdraw";
	}

	
	
	
	
	/*
	 * @GetMapping("/") public String mypage(HttpSession session, Model model){
	 * 
	 * // 로그인 기능이 생기면 실험 가능 Member loginUser =
	 * (Member)session.getAttribute("loginUser");
	 * 
	 * int memNo = loginUser.getMemNo();
	 * 
	 * List<Friends> friendList = mypageService.selectFriendList(memNo);
	 * 
	 * model.addAttribute("friendList", friendList);
	 */	
	
	
	
	
	
	
	
	
	
	
	
	
	
//	// 친구 목록이 있는 메인 페이지 컨트롤러 (기존 컨트롤러에 추가)
//	@GetMapping("/main")  // 기존 URL에 맞게 수정
//	public String main(HttpSession session, Model model) {
//
//	    Member loginUser = (Member) session.getAttribute("loginUser");
//	    if (loginUser == null) return "redirect:/";
//
//	    List<Friends> friendList = friendsService.getFriendList(loginUser.getMemNo());
//	    model.addAttribute("friendList", friendList);
//
//	    return "mypage"; // 뷰 이름
//	}

}
