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
    public String insertAssessment(Assessment asse) { // @AuthenticationPrincipal 일단 제거하고 직접 꺼내봅시다.
        
        // 1. 직접 SecurityContext에서 유저 정보 꺼내기 (가장 확실한 방법)
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        CustomUserDetails userDetails = null;
        
        if (principal instanceof CustomUserDetails) {
            userDetails = (CustomUserDetails) principal;
        }

        // 2. 로그인 유저 체크
        if (userDetails != null && userDetails.getMember() != null) {
            // 로그인한 진짜 유저의 번호를 세팅합니다.
            asse.setMemNo(userDetails.getMember().getMemNo());
            System.out.println("✅ 실제 유저 번호 세팅: " + asse.getMemNo());
        } else {
            // 로그인 정보가 없으면 저장을 막고 로그인 페이지로 보냅니다.
            System.out.println("❌ 저장 실패: 로그인 정보가 없습니다.");
            return "redirect:/member/login.me"; 
        }

        // 3. DB 저장 실행
        try {
            int result = assessmentService.insertAssessment(asse);
            System.out.println("✅ 저장 성공! 결과: " + result);
        } catch (Exception e) {
            System.out.println("❌ DB 저장 중 에러 발생: " + e.getMessage());
            // 에러가 나면 알림 처리를 위해 에러 파라미터를 들고 갑니다.
            return "redirect:/rating?error=duplicate";
        }
        
        return "redirect:/rating";
    }
}