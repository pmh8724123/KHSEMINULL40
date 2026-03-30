package com.kh.cam.member.model.service;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.dao.MemberDao;
import com.kh.cam.member.model.vo.CustomUserDetails;
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

	@Override
	public List<University> selectUniList() {
		return mDao.selectUniList();
	}

	@Override
	public List<Department> selectDeptList(int uniNo) {
		return mDao.selectDeptList(uniNo);
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Member member = mDao.loadUserByUsername(username);
		
		if(member == null) {
			throw new UsernameNotFoundException("존재하지 않는 사용자 : " + username);
		}
		System.out.println(member);
		return new CustomUserDetails(member);
	}

	@Override
	public String selectMemId(Member m) {
		return mDao.selectMemId(m);
	}

	@Override
	public Member selectMemById(String memId) {
		return mDao.loadUserByUsername(memId);
	}

}
