package com.kh.cam.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.common.model.vo.Department;
import com.kh.cam.common.model.vo.University;
import com.kh.cam.member.model.dao.MemberDao;
import com.kh.cam.member.model.vo.CustomUserDetails;
import com.kh.cam.member.model.vo.Member;
import com.kh.cam.mypage.model.dao.AttendanceDao;
import com.solapi.sdk.SolapiClient;
import com.solapi.sdk.message.model.Message;
import com.solapi.sdk.message.service.DefaultMessageService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
	
	private final MemberDao mDao;
	private final BCryptPasswordEncoder pwEncoder;
	
	private String authCode;

	private DefaultMessageService messageService = SolapiClient.INSTANCE.createInstance("NCSYQVICYB1UINCP", "H5JJT49K5ACXORMEIVPSBCHZLYDTCFOC");
	
	@Override
	public int insertMember(Member member) {
		
		
		return mDao.insertMember(member);
	}

	@Override
	@Transactional
	public void register(Member member) {
		
		
		member.setMemPw(pwEncoder.encode(member.getMemPw()));
		
		mDao.insertMember(member);
		mDao.insertAtt(member.getMemNo());
		
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

		if (member == null) {
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

	@Override
	public int updateMember(Member inputMember) {
		return mDao.updateMember(inputMember);
	}

	@Override
	public List<Map<String, Object>> selectDeptListBySetting(int myDeptNo) {
		return mDao.selectDeptListBySetting(myDeptNo);
	}

	@Override
	public int deleteMember(int memNo) {
		return mDao.deleteMember(memNo);
	}	
	
	public void sendSms(String phone) {
		authCode = String.valueOf((int)(Math.random() * 900000) + 100000);
		
		Message message = new Message();
		message.setFrom("010-8584-5793");
		message.setTo(phone);
		message.setText("인증번호 : " + authCode);
		
		System.out.println(authCode);
		
//		try {
//			messageService.send(message);
//		}
//		catch (SolapiMessageNotReceivedException exception) {
//			System.out.println(exception.getFailedMessageList());
//			System.out.println(exception.getMessage());
//		}
//		catch (Exception exception) {
//			System.out.println(exception.getMessage());
//		}
	}

}
