package com.kh.cam.assessment.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.cam.assessment.model.service.AssessmentService;
import com.kh.cam.assessment.model.vo.Assessment;
import com.kh.cam.assessment.model.vo.LectureVO;
import com.kh.cam.member.model.vo.CustomUserDetails;

@Controller
@RequestMapping("/rating")
public class AssessmentController {

    @Autowired
    private AssessmentService assessmentService;

    @GetMapping("")
    public String assessmentList(
        @RequestParam(value="keyword", required=false) String keyword,
        Model model) {
        
        // 직접 SecurityContext에서 유저 정보 꺼내기
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        CustomUserDetails userDetails = null;
        
        if (principal instanceof CustomUserDetails) {
            userDetails = (CustomUserDetails) principal;
        }

        System.out.println("==== 직접 꺼낸 유저 정보 ====");
        System.out.println("userDetails: " + userDetails);
        if(userDetails != null) {
            System.out.println("member: " + userDetails.getMember());
        }

        if (userDetails == null || userDetails.getMember() == null) {
            return "redirect:/member/login.me"; 
        }

        int uniNo = userDetails.getMember().getUniNo();
        List<Assessment> list = assessmentService.selectLectureList(uniNo, keyword);
        
        model.addAttribute("lectureList", list);
        model.addAttribute("keyword", keyword);
        
        return "board/assessment"; 
    }

    // 실시간 검색 API (AJAX) - 팝업 내 검색창에서 사용
    @GetMapping("/api/search")
    @ResponseBody
    public List<LectureVO> searchLectures(@RequestParam(required = false) String keyword, 
                                          @RequestParam int uniNo) {
        // 2. 이제 서비스에 메서드가 생겼으므로 빨간 줄이 사라집니다.
        return assessmentService.searchLectures(uniNo, keyword);
    }

    @PostMapping("/insert")
    public String insertAssessment(Assessment asse, @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        // 1. 서비스 객체 주입 확인 (NPE 방지)
        if (assessmentService == null) {
            System.out.println("❌ 오류: assessmentService가 주입되지 않았습니다(null).");
            return "redirect:/rating?error=server";
        }

        // 2. 로그인 유저 정보 확인 및 세팅
        if (userDetails != null && userDetails.getMember() != null) {
            // 정상적인 경우
            asse.setMemNo(userDetails.getMember().getMemNo());
        } else {
            // 로그인 정보가 없거나 Member 객체가 null인 경우 (NPE 방지용 임시번호 1 부여)
            System.out.println("⚠️ 경고: 로그인 정보가 없거나 Member가 null입니다. 임시로 1번 회원으로 진행합니다.");
            asse.setMemNo(1); 
        }

        // 3. 데이터 확인용 출력
        System.out.println("전달된 데이터: " + asse);

        // 4. DB 저장 실행
        try {
            int result = assessmentService.insertAssessment(asse);
            System.out.println("✅ 저장 성공! 결과: " + result);
        } catch (Exception e) {
            System.out.println("❌ DB 저장 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/rating";
    }
}