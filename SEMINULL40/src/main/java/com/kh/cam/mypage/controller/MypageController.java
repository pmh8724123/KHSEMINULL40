package com.kh.cam.mypage.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.cam.mypage.model.service.MypageService;
import com.kh.cam.mypage.model.vo.Friends;

@Controller
@RequestMapping("/member")
public class MypageController {
	
	@Autowired
	private MypageService mypageService;
	

	@RequestMapping("/mypage")
	public String mypage() {
		
	/*
	@GetMapping("/")	
	public String mypage(HttpSession session, Model model){

		// 로그인 기능이 생기면 실험 가능
	    Member loginUser =
	        (Member)session.getAttribute("loginUser");

	    int memberNo = loginUser.getMemberNo();

	    List<Friends> friendList =
	        mypageService.selectFriendList(memberNo);

	    model.addAttribute("friendList", friendList);
*/
	    return "/member/mypage";
	}
	
}
