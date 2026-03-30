package com.kh.cam.assessment.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.cam.assessment.model.service.AssessmentService;
import com.kh.cam.assessment.model.vo.Assessment;

@Controller
@RequestMapping("/rating")
public class AssessmentController {

	@Autowired
	public AssessmentService assessmentService;
	
	
	@GetMapping("")
	public String assessmentList(){
		return "board/assessment";
	}
	
	@GetMapping("/write")
	public String assessmentWriteForm(@RequestParam("lectureNo") int lectureNo, Model model) {
	    Assessment lecture = assessmentService.getLectureInfo(lectureNo);
	    model.addAttribute("lecture", lecture);
	    return "board/assessmentWrite";
	}
	
	
	
}
