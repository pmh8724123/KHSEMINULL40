package com.kh.cam.member.model.service;

import java.util.Collections;
import java.util.List;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.dao.MemberDao;
import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService, UserDetailsService {

	private final MemberDao mDao;
	
	@Override
	public int insertMember(Member member) {
		return mDao.insertMember(member);
	}

	@Override
	public List<University> selectUniList() {
		return mDao.selectUniList();
	}

	@Override
	public List<Department> selectDeptList(int uniNo) {
		return mDao.selectDeptList(uniNo);
	}

	@Override
	public Member loginMember(Member m) {
		return mDao.loginMember(m);
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Member member = mDao.loadUserByUsername(username);
		
		if(member == null) {
			throw new UsernameNotFoundException(username);
		}
		
		return new org.springframework.security.core.userdetails.User(
	            member.getMemId(),
	            member.getMemPw(),
	            Collections.singletonList(new SimpleGrantedAuthority("USER"))
	    );
	}

}
