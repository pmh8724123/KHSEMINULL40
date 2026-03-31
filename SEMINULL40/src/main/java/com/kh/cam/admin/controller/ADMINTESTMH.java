package com.kh.cam.admin.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class ADMINTESTMH {
	public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encPw = encoder.encode("1234");
        System.out.println(encPw);
    }
}
