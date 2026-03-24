package com.kh.cam.member.model.validator;

import java.util.regex.Pattern;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.kh.cam.member.model.vo.Member;

@Component
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
		
		// 유효성 검사 로직
		if(member.getMemId() != null) {
			if(!(member.getMemId().length()>=4 && member.getMemId().length()<=20)) {
				errors.rejectValue("memId", "length", "아이디를 4~20자로 작성해주세요.");
			}
			if(!member.getMemId().matches("^[a-zA-Z0-9_]+$")) {
				errors.rejectValue("memId", "pattern", "아이디는 영문, 숫자, _만 사용할 수 있습니다.");
			}
		}
		
		
	}

}
