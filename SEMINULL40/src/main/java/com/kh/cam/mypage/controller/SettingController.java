package com.kh.cam.mypage.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping("/setting")
@RequiredArgsConstructor
@Slf4j
public class SettingController {
	
	private final BCryptPasswordEncoder pwEncoder;
	private final MemberService mService;
	
	// [1단계] 현재 비밀번호 확인만 진행
    @PostMapping(value = "/verifyPw", produces = "application/json; charset=utf-8")
    public Map<String, Object> verifyPassword(Map<String, String> data) {
        Map<String, Object> result = new HashMap<>();
        
        // SecurityContext에서 로그인 유저 추출
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String dbPw = userDetails.getMember().getMemPw();
        String inputPw = data.get("curPw");

        if (pwEncoder.matches(inputPw, dbPw)) {
            result.put("result", "ok");
        } else {
            result.put("result", "fail");
        }
        return result;
    }
	
	
	// curPw : 현재 비번
	// newPw : 새로운 비번
	@PostMapping(value = "/update", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> updateMember(Member inputMember, 
	                                        @RequestParam("curPw") String curPw,
	                                        @RequestParam("newPw") String newPw) {
	    Map<String, Object> result = new HashMap<>();

	    // 1. 현재 로그인된 사용자 정보 가져오기
	    Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    CustomUserDetails userDetails = (CustomUserDetails) principal;
	    Member loginUser = userDetails.getMember(); // CustomUserDetails 내에 저장된 VO 추출

	    // 2. 현재 비밀번호 검증 (BCrypt matches 사용)
	    if (!pwEncoder.matches(curPw, loginUser.getMemPw())) {
	        result.put("result", "fail");
	        result.put("message", "현재 비밀번호가 일치하지 않습니다.");
	        return result;
	    }

	    // 3. 변경할 데이터 세팅 (입력값이 없으면 기존값 유지)
	    // MyBatis에서 동적 쿼리(<if>)를 쓰더라도, VO에 기존 ID를 넣어줘야 WHERE절이 작동합니다.
	    inputMember.setMemId(loginUser.getMemId()); 

	    if (newPw != null && !newPw.trim().isEmpty()) {
	        inputMember.setMemPw(pwEncoder.encode(newPw)); // 새 비번 암호화 후 세팅
	    } else {
	        inputMember.setMemPw(loginUser.getMemPw()); // 비번 변경 안 함 (기존 암호 유지)
	    }

	    // 4. DB 업데이트 실행
	    int updateResult = mService.updateMember(inputMember);

	    if (updateResult > 0) {
	        // 5.  중요: 세션(SecurityContext) 내 정보 갱신 
	        // DB만 바꾸면 화면 상의 'loginUser'는 로그아웃 전까지 옛날 정보를 들고 있습니다.
	        Member updatedUser = mService.selectMemById(loginUser.getMemId());
	        userDetails.setMember(updatedUser); // CustomUserDetails 내부의 VO 교체
	        
	        result.put("result", "ok");
	    } else {
	        result.put("result", "fail");
	        result.put("message", "수정 중 오류가 발생했습니다.");
	    }

	    return result;
	}
	
//	@PostMapping("/update")
//	public String updateMember1(@ModelAttribute Member member) {
//		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//		
//		member.setMemPw(pwEncoder.encode(member.getMemPw()));
//		
//		int result = mService.updateMember(member);
//		
//	    if(inputMember.getMemPw() != null) {
//	    	inputMember.setMemPw(pwEncoder.encode(inputMember.getMemPw()));
//	    }
//	    
//	    mService.updateMember(inputMember);
//		
//		if(result > 0) {
//			return "redirect:/mypage?category=setting";
//		}
//		else {
//			// 에러페이지 반환
//		}
//		
//	}
}
