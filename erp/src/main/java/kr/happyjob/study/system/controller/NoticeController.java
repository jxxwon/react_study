package kr.happyjob.study.system.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.system.model.NoticeModel;
import kr.happyjob.study.system.service.NoticeService;

@Controller
@RequestMapping("/system/")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	// 처음 로딩될 때 공지사항 연결
	@RequestMapping("notice.do")
	public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initNotice");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);

		return "system/notice";
	}

	@RequestMapping("noticeList.do")
	public String getNoticeList(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className + ".noticeList");
		logger.info("   - paramMap : " + paramMap);
		
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<NoticeModel> noticeList = noticeService.noticeList(paramMap);
		int noticeCnt = noticeService.noticeListCnt(paramMap);
		
		model.addAttribute("notice", noticeList);
		model.addAttribute("noticeCnt", noticeCnt);
		
		return "system/noticeList";
	}
	
	@RequestMapping("noticeListJson.do")
	@ResponseBody
	public Map<String, Object> noticeListJson(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.info("+ Start " + className + ".noticeList");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultmap = new HashMap<String, Object>();
		
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<NoticeModel> noticeList = noticeService.noticeList(paramMap);
		int noticeCnt = noticeService.noticeListCnt(paramMap);
		
		resultmap.put("noticeList", noticeList);
		resultmap.put("noticeCnt", noticeCnt);
		
		return resultmap;
	}
	
	@RequestMapping("noticeSave.do")
	@ResponseBody
	public Map<String, String> saveNotice(@RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".saveNotice");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = noticeService.saveNotice(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("noticeSaveFile.do")
	@ResponseBody
	public Map<String, String> noticeSaveFile(@RequestParam Map<String, Object> paramMap, HttpSession session,
			HttpServletRequest req) throws Exception {
		logger.info("+ Start " + className + ".noticeSaveFile");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = noticeService.noticeSaveFile(paramMap, req);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("noticeFileSaveJson.do")
	@ResponseBody
	public Map<String, Object> noticeFileSaveJson(@RequestPart(value="file", required=false) MultipartFile[] files, 
			@RequestPart(value="text", required=false)Map<String, Object> text) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		logger.info("+ Start " + className + ".noticeFileSaveJson");
		logger.info("   - text : " + text);
		logger.info("   - files : " + files);
		
		String resultMsg = "";

		int result = noticeService.noticeSaveFileJson(text, files);
		
		if (result > 0) {
			resultMsg = "Success";
		} else {
			resultMsg = "Fail";
		}
		
		resultMap.put("result", resultMsg);
		
		return resultMap;
	}
	
	@RequestMapping("noticeUpdate.do")
	@ResponseBody
	public Map<String, String> updateNotice(@RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".updateNotice");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = noticeService.updateNotice(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("noticeUpdateFile.do")
	@ResponseBody
	public Map<String, String> noticeUpdateFile(@RequestParam Map<String, Object> paramMap, HttpSession session,
			HttpServletRequest req) throws Exception {
		logger.info("+ Start " + className + ".noticeUpdateFile");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = noticeService.noticeUpdateFile(paramMap, req);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("noticeFileUpdateJson.do")
	@ResponseBody
	public Map<String, Object> noticeFileUpdateJson(@RequestPart(value="file", required=false) MultipartFile[] files, 
			@RequestPart(value="text", required=false)Map<String, Object> text) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		logger.info("+ Start " + className + ".noticeFileUpdateJson");
		logger.info("   - text : " + text);
		logger.info("   - files : " + files);
		
		String resultMsg = "";

		int result = noticeService.noticeUpdateFileJson(text, files);
		
		if (result > 0) {
			resultMsg = "Success";
		} else {
			resultMsg = "Fail";
		}
		
		resultMap.put("result", resultMsg);
		
		return resultMap;
	}
	
	
	@RequestMapping("/noticeDelete.do")
	@ResponseBody
	public Map<String, String> deleteNotice(@RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".deleteNotice");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = noticeService.deleteNotice(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("/noticeDetail.do")
	@ResponseBody
	public Map<String, Object> noticeDetail(@RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".noticeDetail");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		NoticeModel notice = noticeService.noticeDetail(paramMap);
		
		resultMap.put("detailValue", notice);
		
		return resultMap;
	}
	
	@RequestMapping("noticeDownload.do")
	public void dowloadNotice(@RequestParam Map<String, Object> paramMap, HttpServletResponse res) throws Exception {
		logger.info("+ Start " + className + ".dowloadNotice");
		logger.info("   - paramMap : " + paramMap);
		
		NoticeModel notice = noticeService.noticeDetail(paramMap);
		
		String filePath = notice.getPhsycal_path();
		byte bytes[] = FileUtils.readFileToByteArray(new File(filePath));
		
		res.setContentType("application/octet-stream");
		res.setContentLength(bytes.length);
		res.setHeader("Content-Disposition",
	            "attachment; fileName=\"" + URLEncoder.encode(notice.getFile_name(), "UTF-8") + "\";");
		res.setHeader("Content-Transfer-Encoding", "binary");
		res.getOutputStream().write(bytes);
		res.getOutputStream().flush();
		res.getOutputStream().close();
	}
}
