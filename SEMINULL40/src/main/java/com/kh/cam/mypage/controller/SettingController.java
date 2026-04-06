package com.kh.cam.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

	
	// 현재 비밀번호 확인만 진행
	@PostMapping(value = "/verifyPw", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> verifyPassword(@RequestParam("curPw") String inputPw) {
		Map<String, Object> result = new HashMap<>();

		// SecurityContext에서 로그인 유저 추출
		CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		String dbPw = userDetails.getMember().getMemPw();

		log.info("받은 비밀번호: {}", inputPw);

		if (pwEncoder.matches(inputPw, dbPw)) {
			result.put("result", "ok");
		} else {
			result.put("result", "fail");
		}
		return result;
	}
	
	
	
	

	@GetMapping(value = "/deptList", produces = "application/json; charset=utf-8")
	@ResponseBody
	public List<Map<String, Object>> getDeptList() {
		// 1. 현재 로그인 유저 정보 추출
		CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication()
				.getPrincipal();
		int myDeptNo = userDetails.getMember().getDeptNo();

		// 2. 동일 대학 학과 리스트 조회 (Service -> Mapper 호출)
		return mService.selectDeptListBySetting(myDeptNo);
	}

	
	
	
	
	// curPw : 현재 비번
	// newPw : 새로운 비번
	@PostMapping(value = "/update", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> updateMember(Member inputMember, @RequestParam("curPw") String curPw,
			@RequestParam("newPw") String newPw) {
		Map<String, Object> result = new HashMap<>();
		
		String phoneRegex = "^\\d{2,3}-\\d{3,4}-\\d{4}$";
	    String studentNoRegex = "^[0-9]+$";
	    String pwRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&]).{8,}$";

		try {

			Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			CustomUserDetails userDetails = (CustomUserDetails) principal;
			Member loginUser = userDetails.getMember();
			
		
			// 현재 비밀번호 검증 (BCrypt matches 사용)
			if (!pwEncoder.matches(curPw, loginUser.getMemPw())) {
				result.put("result", "fail");
				result.put("message", "현재 비밀번호가 일치하지 않습니다.");
				return result;
			}
			
			// 비밀번호 검사
			if (newPw != null && !newPw.trim().isEmpty()) {
		        if (!newPw.matches(pwRegex)) {
		            result.put("result", "fail");
		            result.put("message", "새 비밀번호는 영문, 숫자, 특수문자 포함 8자 이상이어야 합니다.");
		            return result;
		        }
		        inputMember.setMemPw(pwEncoder.encode(newPw));
		    } else {
		        inputMember.setMemPw(loginUser.getMemPw());
		    }
			
			

			// 변경할 데이터 세팅 (입력값이 없으면 기존값 유지)
			// MyBatis에서 동적 쿼리(<if>)를 쓰더라도, VO에 기존 ID를 넣어줘야 WHERE절이 작동합니다.
			inputMember.setMemNo(loginUser.getMemNo());

			if (newPw != null && !newPw.trim().isEmpty()) {
				inputMember.setMemPw(pwEncoder.encode(newPw)); // 새 비번 암호화 후 세팅
			} else {
				inputMember.setMemPw(loginUser.getMemPw()); // 비번 변경 안 함 (기존 암호 유지)
			}

			// 4. DB 업데이트 실행
			int updateResult = mService.updateMember(inputMember);

			if (updateResult > 0) {
				// 5. 중요: 세션(SecurityContext) 내 정보 갱신
				// DB만 바꾸면 화면 상의 'loginUser'는 로그아웃 전까지 옛날 정보를 들고 있습니다.
				Member updatedUser = mService.selectMemById(loginUser.getMemId());
				userDetails.setMember(updatedUser); // CustomUserDetails 내부의 VO 교체

				result.put("result", "ok");
			}

		} catch (org.springframework.dao.DataIntegrityViolationException e) {
			// UNIQUE 제약조건 위반 시 발생하는 예외
			log.error("중복 데이터 발생: {}", e.getMessage());
			result.put("result", "fail");

			// 에러 메시지 내용에 따라 분기 (DB 엔진에 따라 메시지가 다를 수 있음)
			String errorMsg = e.getMessage();
			if (errorMsg.contains("MEM_ID")) {
				result.put("message", "이미 사용 중인 아이디입니다.");
			} else if (errorMsg.contains("PHONE")) {
				result.put("message", "이미 등록된 전화번호입니다.");
			} else {
				result.put("message", "중복된 정보가 존재하여 수정할 수 없습니다.");
			}
		} catch (Exception e) {
			log.error("수정 중 일반 오류: {}", e.getMessage());
			result.put("result", "fail");
			result.put("message", "시스템 오류가 발생했습니다.");
		}

		return result;
	}

	
	

	
	@RequestMapping("/withdraw")
	public String withdraw() {
		return "/member/withdraw";
	}
	
	
	@PostMapping(value = "/withdraw/confirm", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> withdrawConfirm(@RequestParam("curPw") String curPw,
	                                           @RequestParam("reason") String reason,
	                                           HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    
	    // 1. 로그인 유저 정보 가져오기
	    CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    Member loginUser = userDetails.getMember();

	    // 2. 비밀번호 검증
	    if (!pwEncoder.matches(curPw, loginUser.getMemPw())) {
	        result.put("result", "fail");
	        result.put("message", "비밀번호가 일치하지 않습니다.");
	        return result;
	    }

	    // 3. 회원 데이터 삭제 실행 (Service 호출)
	    // 연쇄 삭제 로직은 Service와 Mapper에서 처리
	    int deleteResult = mService.deleteMember(loginUser.getMemNo());

	    if (deleteResult > 0) {
	        // 4. 탈퇴 성공 시 로그아웃 처리 및 세션 만료
	        SecurityContextHolder.clearContext(); // 시큐리티 인증 정보 삭제
	        if (session != null) {
	            session.invalidate(); // 세션 무효화
	        }
	        result.put("result", "ok");
	    } else {
	        result.put("result", "fail");
	        result.put("message", "탈퇴 처리 중 오류가 발생했습니다.");
	    }

	    return result;
	}

}
