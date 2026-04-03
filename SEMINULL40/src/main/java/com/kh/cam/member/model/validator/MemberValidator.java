package com.kh.cam.member.model.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.kh.cam.member.model.service.MemberService;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MemberValidator implements Validator {

	// 정규식 패턴 정의
	private static final String ID_REGEX = "^[a-zA-Z0-9_]+$";
	private static final String PW_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&]).{8,}$";
	private static final String STUDENNO_REGEX = "^[0-9]+$";
	private static final String PHONE_REGEX = "^\\d{2,3}-\\d{3,4}-\\d{4}$";

	private final MemberService mService;

	@Override
	public boolean supports(Class<?> clazz) {
		return Member.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Member member = (Member) target;

		validateMemId(member, errors);
		validateMemPw(member, errors);

		// 이름 유효성 검사
		if (member.getMemName() == null || member.getMemName().trim().isEmpty()) {
			errors.rejectValue("memName", "required", "이름을 입력하세요.");
		}

		validateUniNo(member, errors);

		// 학번 유효성 검사
		if (member.getStudentNo() == null || member.getStudentNo().equals("0")
				|| member.getStudentNo().trim().isEmpty()) {
			errors.rejectValue("studentNo", "required", "학번를 입력하세요.");
		}
		if (!member.getStudentNo().matches("^[0-9]+$")) {
			errors.rejectValue("studentNo", "pattern", "학번은 숫자만 입력할 수 있습니다.");
		}

		// 전화번호 유효성 검사
		if (member.getPhone() == null) {
			errors.rejectValue("phone", "required", "전화번호를 입력하세요.");
		}
		if (!member.getPhone().matches(PHONE_REGEX)) {
			errors.rejectValue("phone", "pattern", "전화번호를 010-0000-0000 형식으로 입력하세요.");
		}

	}


	private void validateMemId(Member member, Errors errors) {
		// 아이디 유효성 검사
		if (member.getMemId() == null || member.getMemId().trim().isEmpty()) {
			errors.rejectValue("memId", "required", "아이디를 입력해주세요.");
			return;
		}
		if (mService.selectMemById(member.getMemId()) != null) {
			errors.rejectValue("memId", "duplicate", "이미 사용중인 아이디입니다.");
			return;
		}
		if (member.getMemId().length() < 4 || member.getMemId().length() > 20) {
			errors.rejectValue("memId", "length", "아이디를 4~20자로 작성해주세요.");
			return;
		}
		if (!member.getMemId().matches(ID_REGEX)) {
			errors.rejectValue("memId", "pattern", "아이디는 영문, 숫자, _만 사용할 수 있습니다.");
			return;
		}
	}

	private void validateMemPw(Member member, Errors errors) {
		// 비밀번호 유효성 검사
		if (member.getMemPw() == null || member.getMemPw().trim().isEmpty()) {
			errors.rejectValue("memPw", "required", "비밀번호를 입력해주세요");
			return;
		}
		if (member.getMemPw().length() < 8) {
			errors.rejectValue("memPw", "length", "비밀번호를 최소 8글자 이상으로 작성하세요.");
			return;
		}
		if (!member.getMemPw().matches(PW_REGEX)) {
			errors.rejectValue("memPw", "pattern", "비밀번호에 특수문자가 포함되어야 합니다.");
			return;
		}
	}
	
	private void validateUniNo(Member member, Errors errors) {
		// 학교,학과 유효성 검사
		if (member.getUniNo() == null || member.getUniNo() == 0) {
			errors.rejectValue("uniNo", "required", "학교를 선택하세요.");
			return;
		}
		if (member.getDeptNo() == null || member.getDeptNo() == 0) {
			errors.rejectValue("deptNo", "required", "학과를 선택하세요.");
			return;
		}
	}


}
