package com.kh.cam.notice.model.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.cam.board.model.vo.Attachment;
import com.kh.cam.notice.model.dao.NoticeDao;
import com.kh.cam.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {
	
	private final NoticeDao nDao;
	
	@Override
	public List<Notice> selectNoticeList(Integer uniNo) {
		return nDao.selectNoticeList(uniNo);
	}

	@Override
	@Transactional
	public int insertNotice(Notice notice, List<Attachment> list) {
		int result = nDao.insertNotice(notice);
		
//		if(result > 0 && !list.isEmpty()) {
//            for(Attachment at : list) {
//                if(nDao.insertFiles(at) < 0) {
//                	result = -1;
//                	break;
//                }
//            }
//        }
        return result;
	}

	@Override
	public Notice selectNotice(int noticeNo) {
		return nDao.selectNotice(noticeNo);
	}

	@Override
	public int updateNotice(Notice notice) {
		return nDao.updateNotice(notice);
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return nDao.deleteNotice(noticeNo);
	}
	
}
