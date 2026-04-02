package com.kh.cam.member.model.vo;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class CustomUserDetails implements UserDetails{

	private static final long serialVersionUID = 1L;
	private final Member member;
	
	public CustomUserDetails(Member member) {
		this.member = member;
	}
	
	public Member getMember() {
		return member;
	}
	
	public int getUserno() {
		return member.getMemNo();
	}
	
	@Override
	public String getUsername() {
		return member.getMemId();
	}
	
	@Override
	public String getPassword() {
		return member.getMemPw();
	}
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return member.getAuthorities().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuthority())).collect(Collectors.toList());
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}

	public void setMember(Member updatedUser) {
		// TODO Auto-generated method stub
		
	}

}
