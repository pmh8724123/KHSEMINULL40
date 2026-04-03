package com.kh.cam.information.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/information")
public class InformationController {
	@GetMapping("/tos")
    public String tos() {
        return "information/tos";
    }

    @GetMapping("/privacyPolicy")
    public String privacyPolicy() {
        return "information/privacyPolicy";
    }
    
    @GetMapping("/informationNotice")
    public String notice() {
    	return "information/informationNotice";
    }
    
    @GetMapping("/qna")
    public String qna() {
    	return "information/qna";
    }
}
