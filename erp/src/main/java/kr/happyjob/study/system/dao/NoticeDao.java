package kr.happyjob.study.system.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.system.model.NoticeModel;

public interface NoticeDao {
	
	List<NoticeModel> noticeList(Map<String, Object> params) throws Exception;
	
	int noticeListCnt(Map<String, Object> params) throws Exception;
	
	int saveNotice(Map<String, Object> params) throws Exception;
	
	int noticeSaveFile(Map<String, Object> params) throws Exception;
	
	int updateNotice(Map<String, Object> params) throws Exception;
	
	int noticeUpdateFile(Map<String, Object> params) throws Exception;
	
	int deleteNotice(Map<String, Object> params) throws Exception;
	
	NoticeModel noticeDetail(Map<String, Object> params) throws Exception;
	
	int noticeSaveFileJson(Map<String, Object> paramMap);

	int noticeUploadFileJson(Map<String, Object> paramMap);
}
