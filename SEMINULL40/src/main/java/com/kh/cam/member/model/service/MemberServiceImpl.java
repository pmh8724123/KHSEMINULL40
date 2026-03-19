package com.kh.cam.member.model.service;

import org.springframework.stereotype.Service;

import com.kh.cam.member.model.dao.MemberDao;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

	private final MemberDao mDao;
	
	@Override
	public int insertMember(Member member) {
		return mDao.insertMember(member);
	}

}
