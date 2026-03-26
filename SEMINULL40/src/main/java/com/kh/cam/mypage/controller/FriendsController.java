package com.kh.cam.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.service.FriendsService;
import com.kh.cam.mypage.model.vo.Friends;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
public class FriendsController {
	
	
	private final FriendsService fService;
	private final MemberService mService;
	
	
	private int getMemNo() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String memName = auth.getName();
		int result = mService.getMemNo(memName);
		log.info("친구 값 : {}", result);
		
		
		return result;
	}

	// 친구 추가 페이지 이동
	@GetMapping("/addfriend")
	public String addFriend(HttpSession session) {

		// 세션에 로그인 정보가 없을때 로그인 창으로 보내기
//		if (session.getAttribute("loginUser") == null) {
//			return "redirect:/";
//		}
		return "friends/addfriend";
	}

	// 회원 검색 (Ajax GET)
	// MEMBER 테이블의 memName 컬럼 LIKE 검색 후 JSON 반환
	@GetMapping("/addfriend/search")
	@ResponseBody
	public List<Friends> searchMember(@RequestParam String keyword, HttpSession session) {

		// 세션에서 로그인한 사람의 memNo를 senderNo로 사용
		// Member loginUser = (Member) session.getAttribute("loginUser");
		return fService.searchMember(getMemNo(), keyword);
	}

	// 친구 신청 (Ajax POST)
	// FRIEND 테이블에 senderNo, receiverNo, status('N') INSERT
	@PostMapping("/addfriend/request")
	@ResponseBody
	public Map<String, String> friendRequest(@RequestBody Map<String, Integer> body, HttpSession session) {

		// 세션에서 로그인한 사람의 memNo를 senderNo로 사용
		// Member loginUser = (Member) session.getAttribute("loginUser");

		// body에서 receiverNo(요청 받는 사람 memNo) 꺼내서 전달
		String result = fService.insertFriendRequest(getMemNo(), body.get("receiverNo"));

		Map<String, String> response = new HashMap<>();
		response.put("result", result);

		// 중복 신청인 경우 메시지 추가
		if ("already".equals(result)) {
			response.put("message", "이미 친구 신청을 보냈습니다.");
		}
		return response;
	}

	
	
	
	
	// 친구 수락 페이지 이동
	// FRIEND 테이블에서 내가 받은 대기 중인 요청 목록 조회 후 전달
	@GetMapping("/acceptfriend")
	public String acceptFriend(HttpSession session, Model model) {

		//if (session.getAttribute("loginUser") == null) {
		//	return "redirect:/";
		//}

		// Member loginUser = (Member) session.getAttribute("loginUser");

		// 내 memNo를 receiverNo로 사용해서 대기 목록 조회
		List<Friends> pendingList = fService.getPendingList(getMemNo());
		model.addAttribute("pendingList", pendingList);

		return "friends/acceptfriend";
	}

	// 친구 수락 (Ajax POST)
	// FRIEND 테이블의 status 'N' → 'Y' UPDATE
	@PostMapping("/acceptfriend/accept")
	@ResponseBody
	public Map<String, String> acceptFriend(@RequestBody Map<String, Integer> body, HttpSession session) {

		// Member loginUser = (Member) session.getAttribute("loginUser");

		// body에서 senderNo(요청 보낸 사람 memNo) 꺼내서 전달
		// 내 memNo를 receiverNo로 사용
		String result = fService.acceptFriend(body.get("senderNo"), getMemNo());

		Map<String, String> response = new HashMap<>();
		response.put("result", result);
		return response;
	}

	// 친구 거절 (Ajax POST)
	// FRIEND 테이블에서 해당 요청 DELETE
	@PostMapping("/acceptfriend/reject")
	@ResponseBody
	public Map<String, String> rejectFriend(@RequestBody Map<String, Integer> body, HttpSession session) {

		// Member loginUser = (Member) session.getAttribute("loginUser");

		// body에서 senderNo(요청 보낸 사람 memNo) 꺼내서 전달
		// 내 memNo를 receiverNo로 사용
		String result = fService.rejectFriend(body.get("senderNo"), getMemNo());

		Map<String, String> response = new HashMap<>();
		response.put("result", result);
		return response;
	}
}
