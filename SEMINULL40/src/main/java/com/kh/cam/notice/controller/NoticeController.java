package com.kh.cam.notice.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.notice.model.service.NoticeService;
import com.kh.cam.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
@Slf4j
public class NoticeController {

	private final NoticeService nService;
	
	@GetMapping("/list")
	public String noticeList(Model model) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		Member member = user.getMember();
		
		List<Notice> noticeList = nService.selectNoticeList(member.getUniNo());
		
		model.addAttribute("noticeList", noticeList);
		
		return "notice/notice";
	}
	
	@GetMapping("/write")
	public String noticeWrite() {
		return "notice/writeNotice";
	}
	
	@PostMapping("/insertNotice")
	public String insertNotice(@ModelAttribute Notice notice, MultipartFile[] upfiles, HttpSession session, RedirectAttributes ra) {
		CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		try {
			// 공지사항 대학 설정
			notice.setUniNo(user.getMember().getUniNo());
			
			// 파일 리스트 생성
			List<Attachment> list = new ArrayList<>();
			if(upfiles != null) {
				String savePath = session.getServletContext().getRealPath("/resources/upload_files/");
				makeDirectory(savePath); // 폴더 생성 공통 메서드 호출
				
				for(MultipartFile f : upfiles) {
					if(!f.getOriginalFilename().equals("")) {
						String changeName = saveFile(f, savePath); 
						Attachment at = new Attachment();
						at.setOriginName(f.getOriginalFilename());
						at.setChangeName(changeName);
						at.setTargetType("NOTICE");
						list.add(at);
					}
				}
			}
			
			nService.insertNotice(notice, list);
			
			ra.addFlashAttribute("");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/notice/list";
	}
	
	@GetMapping("/detail")
	public String selectNotice(@RequestParam int noticeNo, Model model) {
		
		try {
			Notice notice = nService.selectNotice(noticeNo);
			List<Attachment> list = nService.selectAttList(noticeNo);
			
			System.out.println(noticeNo);
			System.out.println(list);
			
			model.addAttribute("notice", notice);
			model.addAttribute("list", list);
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return "notice/noticeDetail";
	}
	
	@GetMapping("/modify")
	public String noticeModiry(@RequestParam int noticeNo, Model model) {
		model.addAttribute("notice", nService.selectNotice(noticeNo));
		
		return "notice/writeNotice";
	}
	
	@PostMapping("/updateNotice")
	public String updateNotice(@ModelAttribute Notice notice, RedirectAttributes ra) {
		int result = nService.updateNotice(notice);
		
		return "redirect:/notice/detail?noticeNo=" + notice.getNoticeNo();
	}
	
	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<Void> deleteNotice(@RequestParam int noticeNo) {
	    try {
	    	nService.deleteNotice(noticeNo);
	        return ResponseEntity.ok().build();
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
	
	private void makeDirectory(String path) {
	    File dir = new File(path);
	    if(!dir.exists()) dir.mkdirs();
	}

	private String saveFile(MultipartFile upfile, String savePath) {
	    String originName = upfile.getOriginalFilename();
	    String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	    int ranNum = (int)(Math.random() * 90000 + 10000);
	    String ext = originName.substring(originName.lastIndexOf("."));
	    
	    String changeName = currentTime + ranNum + ext;
	    try {
	        upfile.transferTo(new File(savePath + changeName));
	    } catch (IOException e) {
	        log.error("파일 저장 오류: {}", e.getMessage());
	    }
	    return changeName;
	}
	
}
