package com.kh.cam.member.controller;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.validator.MemberValidator;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.service.AttendanceService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
@Slf4j
public class MemberController {

	private final BCryptPasswordEncoder pwEncoder;
	private final MemberService mService;
	private final AttendanceService attService;
	private final MemberValidator mValidator;

	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@GetMapping("/login")
	public String login(Model model, RedirectAttributes ra) {
		ra.addFlashAttribute("errMsg", "아이디 또는 비밀번호가 옳지 않습니다. 다시 입력해주세요.");

		return "redirect:/";
	}

	// 회원가입 페이지 이동
	@GetMapping("/register")
	public String enroll(Model model) {
		if (!model.containsAttribute("member")) {
			model.addAttribute("member", new Member());
		}

		model.addAttribute("uniList", mService.selectUniList());
		return "member/register";
	}

	@GetMapping("/deptList")
	@ResponseBody
	public List<Department> deptList(@RequestParam int uniNo) {
		return mService.selectDeptList(uniNo);
	}

	@InitBinder("member")
	public void initBinder(WebDataBinder binder) {
		binder.addValidators(mValidator);
	}

	@PostMapping("/register")
	public String register(@Validated @ModelAttribute Member member, BindingResult bindingResult, Model model, RedirectAttributes ra) {
		System.out.println(member);
		
		// 유효성 검사 실패
		if (bindingResult.hasErrors()) {
			ra.addFlashAttribute("member", member);
			ra.addFlashAttribute("org.springframework.validation.BindingResult.member", bindingResult);
			model.addAttribute("uniList", mService.selectUniList());
			
			return "redirect:/member/register";
		}
		
		System.out.println("유효성 검사 성공");
		
		try {
			mService.register(member);
		}
		catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("member", member);
			ra.addFlashAttribute("errMsg", "다시 시도해 주세요.");
			
			return "redirect:/member/register";
		}

		return "redirect:/";
	}

	@GetMapping("/waiting")
	public String waiting() {
		return "common/waiting";
	}

	@GetMapping("/findIdPw")
	public String findIdPw() {
		return "member/findIdPw";
	}

	@PostMapping("/findIdPw")
	public String findMember(@ModelAttribute Member m, @RequestParam String type, Model model) {
		String result;
		System.out.println(m.getMemName() + " / " + m.getPhone());
		switch (type) {
		case "id":
			result = mService.selectMemId(m);
			System.out.println(result);
			model.addAttribute("idResult", mService.selectMemId(m));
			break;
		case "pw":
			result = "";
			break;
		}

		return "member/findIdPw";
	}

	@PostMapping("/findId")
	public String selectMemId(@ModelAttribute Member member) {

		try {
			mService.selectMemId(member);
		} catch (Exception e) {

		}

		return "redirect:/member/findId";
	}

	@PostMapping("/sendSms")
	@ResponseBody
	public String sendSms(@RequestBody Map<String, String> map, HttpSession session) {
		String phone = map.get("phone");

		try {
			mService.sendSms(phone);
		} catch (Exception e) {
			return "error";
		}

		return "ok";
	}

}
