/*
 * package com.kh.cam.mypage.controller;
 * 
 * import java.util.List;
 * 
 * import javax.servlet.http.HttpSession;
 * 
 * import org.springframework.beans.factory.annotation.Autowired; import
 * org.springframework.stereotype.Controller; import
 * org.springframework.ui.Model; import
 * org.springframework.web.bind.annotation.GetMapping;
 * 
 * import com.kh.cam.member.model.vo.Member; import
 * com.kh.cam.mypage.model.service.FriendsService; import
 * com.kh.cam.mypage.model.vo.Friends;
 * 
 * @Controller public class FriendsController {
 * 
 * @Autowired private FriendsService friendsService;
 * 
 * // 친구 목록이 있는 메인 페이지 컨트롤러 (기존 컨트롤러에 추가)
 * 
 * @GetMapping("/friend") // 기존 URL에 맞게 수정 public String main(HttpSession
 * session, Model model) {
 * 
 * Member loginUser = (Member) session.getAttribute("loginUser"); if (loginUser
 * == null) return "redirect:/login";
 * 
 * List<Friends> friendList =
 * friendsService.getFriendList(loginUser.getMemNo());
 * model.addAttribute("friendList", friendList);
 * 
 * return "mypage"; // 뷰 이름 }
 * 
 * // 친구 추가 페이지
 * 
 * @GetMapping("/addfriend") public String addFriend() { return
 * "friend/addFriend"; }
 * 
 * // 친구 수락 페이지
 * 
 * @GetMapping("/acceptfriend") public String acceptFriend(HttpSession session,
 * Model model) {
 * 
 * Member loginUser = (Member) session.getAttribute("loginUser"); if (loginUser
 * == null) return "redirect:/login";
 * 
 * List<Friends> pendingList =
 * friendsService.getPendingList(loginUser.getMemNo());
 * model.addAttribute("pendingList", pendingList);
 * 
 * return "friend/acceptFriend"; } }
 */