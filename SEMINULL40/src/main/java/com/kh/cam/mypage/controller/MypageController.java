package com.kh.cam.mypage.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.service.FriendsService;
import com.kh.cam.mypage.model.service.MypageService;
import com.kh.cam.mypage.model.vo.Friends;

@Controller
@RequestMapping("/member")
public class MypageController {
	
	@Autowired
	private MypageService mypageService;
	
	@Autowired
	private FriendsService friendsService;
	

	@RequestMapping("/mypage")
	public String mypage() {
		
	/*
	@GetMapping("/")	
	public String mypage(HttpSession session, Model model){

		// 로그인 기능이 생기면 실험 가능
	    Member loginUser =
	        (Member)session.getAttribute("loginUser");

	    int memNo = loginUser.getMemNo();

	    List<Friends> friendList =
	        mypageService.selectFriendList(memNo);

	    model.addAttribute("friendList", friendList);
*/
	    return "/member/mypage";
	}
	
	
	
	
	// 친구 목록이 있는 메인 페이지 컨트롤러 (기존 컨트롤러에 추가)
	@GetMapping("/main")  // 기존 URL에 맞게 수정
	public String main(HttpSession session, Model model) {

	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) return "redirect:/";

	    List<Friends> friendList = friendsService.getFriendList(loginUser.getMemNo());
	    model.addAttribute("friendList", friendList);

	    return "mypage"; // 뷰 이름
	}

	
	
}
