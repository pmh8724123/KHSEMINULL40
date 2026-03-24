package com.kh.cam.member.controller;

import java.text.SimpleDateFormat;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.validator.MemberValidator;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
@Slf4j
public class MemberController {

	private final BCryptPasswordEncoder pwEncoder;
	private final MemberService mService;
	
	// 회원가입 페이지 이동
	@GetMapping("/register")
	public String enroll(@ModelAttribute Member member, Model model) {
		model.addAttribute("uniList", mService.selectUniList());
		return "member/register";
	}
	
	@GetMapping("deptList")
	@ResponseBody
	public List<Department> deptList(@RequestParam int uniNo) {
		return mService.selectDeptList(uniNo);
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.addValidators(new MemberValidator());
		
//		SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
//		dateFormat.setLenient(false);
	}
	
	@PostMapping("/register")
	public String register(@Validated @ModelAttribute Member member, BindingResult bindingResult, Model model,  RedirectAttributes ra) {
		// 유효성 검사 실패
		if(bindingResult.hasErrors()) {
			log.info("error : {}", bindingResult.getFieldError());
			return "member/register";
		}
		
		// 유효성 검사 성공시 비밀번호 암오화하여 회원가입
		member.setMemPw(pwEncoder.encode(member.getMemPw()));
		mService.insertMember(member);
		log.debug("Member : {}", member);
		
		// 유효성 검사 성공시 비밀번호 암호화하여 회원가입
		String encryptedPassword = pwEncoder.encode(member.getMemPw());
		member.setMemPw(encryptedPassword);
		
		return "redirect:/";
	}
	
}
