package com.kh.cam.member.model.validator;

import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.kh.cam.member.model.vo.Member;

public class MemberValidator implements Validator {

	// 이메일 정규식 패턴
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    // 전화번호 정규식 패턴 (010-1234-5678 형식)
    private static final String PHONE_REGEX = "^\\d{2,3}-\\d{3,4}-\\d{4}$";
	
	@Override
	public boolean supports(Class<?> clazz) {
		return Member.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Member member = (Member) target;

        // 1. 필수 입력값 검증 (ValidationUtils 사용 - null 또는 공백 체크)
        // rejectIfEmptyOrWhitespace(에러객체, 필드명, 에러코드, 기본메시지)
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "memId", "required", "아이디는 필수 항목입니다.");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "memPw", "required", "비밀번호는 필수 항목입니다.");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "memName", "required", "이름은 필수 항목입니다.");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "phone", "required", "이메일은 필수 항목입니다.");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "required", "이메일은 필수 항목입니다.");

        // 2. 아이디 길이 제한 및 유효 글자 검증
        if (member.getMemId() != null && (member.getMemId().length() < 4 || member.getMemId().length() > 12)) {
            errors.rejectValue("memId", "length", "아이디는 4~12자 사이여야 합니다.");
        }
        if(!member.getMemId().matches("^[a-zA-Z0-9_]+$")) {
			errors.rejectValue("userId", "pattern", "아이디는 영문, 숫자, _만 사용할 수 있습니다.");
		}

        // 3. 비밀번호 복잡성 검증 (예: 8자 이상)
        if (member.getMemPw() != null && member.getMemPw().length() < 8) {
            errors.rejectValue("memPw", "short", "비밀번호는 최소 8자 이상이어야 합니다.");
        }

        // 4. 이메일 형식 검증 (정규식 활용)
        if (member.getEmail() != null && !member.getEmail().isEmpty()) {
            if (!Pattern.matches(EMAIL_REGEX, member.getEmail())) {
                errors.rejectValue("email", "invalid", "올바른 이메일 형식이 아닙니다.");
            }
        }

        // 5. 전화번호 형식 검증
        if (member.getPhone() != null && !member.getPhone().isEmpty()) {
            if (!Pattern.matches(PHONE_REGEX, member.getPhone())) {
                errors.rejectValue("phone", "invalid", "전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)");
            }
        }

        // 6. 부서 번호 검증 (0보다 커야 함)
        if (member.getDeptNo() <= 0) {
            errors.rejectValue("deptNo", "invalid", "유효한 부서 번호를 선택해주세요.");
        }
	}

}
