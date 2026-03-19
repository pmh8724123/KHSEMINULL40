package com.kh.cam.mainpage.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainpageController {
	
	@RequestMapping("/mainpage")
	public String mainPage() {
		return "mainpage";
	}

}
