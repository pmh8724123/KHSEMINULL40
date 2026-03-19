package com.kh.cam.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.cam.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@RequiredArgsConstructor
@Slf4j
public class MemberDaoImpl implements MemberDao {

	private final SqlSessionTemplate session;
	
	@Override
	public int insertMember(Member member) {
		log.info(member.toString());
		return session.insert("member.insertMember", member);
	}

}
