package kr.happyjob.study.accounting.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.annotation.ResponseStatusExceptionResolver;

import kr.happyjob.study.accounting.model.DisbInfoModel;
import kr.happyjob.study.accounting.model.DisbModel;
import kr.happyjob.study.accounting.service.DisbService;
import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.business.service.BizPartnerService;
import kr.happyjob.study.employee.dao.UserInfoDao;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.service.UserInfoService;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;
import kr.happyjob.study.system.model.NoticeModel;

@Controller
@RequestMapping("/accounting/")
public class DisbController {
	
	@Autowired
	private BizPartnerService bizPartnerService;
	
	@Autowired
	private DisbService disbService;
	
	@Autowired
	private UserInfoService userInfoService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	// 지출결의서 조회 및 신청 초기 화면
	@RequestMapping("disbApply.do")
	public String initdisbApply(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".initdisbApply");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginId", loginID);
		
		List<BizPartnerModel> bizPartnerList = bizPartnerService.bizPartnerList(paramMap);
		List<ComnGrpCodModel> accGrpCodList = disbService.accGrpCodeList();
		UserInfoModel userInfo = userInfoService.empDetail(paramMap);
		
		model.addAttribute("bizPartnerList", bizPartnerList);
		model.addAttribute("accGrpCodList", accGrpCodList);
		model.addAttribute("userInfo", userInfo);
		
		return "accounting/disbApply";
	}
	
	// 지출결의서 승인 초기 화면
	@RequestMapping("disbursement.do")
	public String disbApproval(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("+ Start " + className + ".disbApproval");
		logger.info("   - paramMap : " + paramMap);

		List<ComnGrpCodModel> accGrpCodList = disbService.accGrpCodeList();		
		model.addAttribute("accGrpCodList", accGrpCodList);
		
		return "accounting/disbApproval";
	}
	
	// 본인 지출결의서 목록 조회
	@RequestMapping("disbList.do")
	public String disbList(Model model, @RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".disbList");
		logger.info("   - paramMap : " + paramMap);
		
		String loginId = (String) session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int cpage = Integer.valueOf((String)paramMap.get("currentPage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<DisbInfoModel> disbList = disbService.disbList(paramMap);
		int disbCnt = disbService.disbListCnt(paramMap);
		
		model.addAttribute("disbList", disbList);
		model.addAttribute("disbCnt", disbCnt);
		
		return "accounting/disbList";
	}

	// 전체 지출결의서 목록 조회
	@RequestMapping("disbApprList.do")
	public String disbApprList(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className + ".disbApprList");
		logger.info("   - paramMap : " + paramMap);
		
		int cpage = Integer.valueOf((String)paramMap.get("currentPage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<DisbInfoModel> disbList = disbService.disbList(paramMap);
		int disbCnt = disbService.disbListCnt(paramMap);
		
		model.addAttribute("disbList", disbList);
		model.addAttribute("disbCnt", disbCnt);
		
		return "accounting/disbList";
	}
	
	// 계정과목 리스트 조회
	@RequestMapping("acctCodeList.do")
	@ResponseBody
	public List<ComnCodUtilModel> acctCodeList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.info("+ Start " + className + ".acctCodeList");
		logger.info("   - paramMap : " + paramMap);
		
		return disbService.acctCodeList(paramMap);
	}
	
	// 지출결의서 저장
	@RequestMapping("saveDisb.do")
	@ResponseBody
	public Map<String, String> saveDisb(@RequestParam Map<String, Object> paramMap, HttpSession session, HttpServletRequest req) throws Exception {
		logger.info("+ Start " + className + ".saveDisb");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);

		int result = disbService.saveDisb(paramMap, req);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 지출결의서 상세 조회
	@RequestMapping("disbDetail.do")
	@ResponseBody
	public DisbInfoModel disbDetail(@RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className + ".disbDetail");
		logger.info("   - paramMap : " + paramMap);
		
		return disbService.disbDetail(paramMap);
	}
	
	// 지출결의서 삭제
	@RequestMapping("deleteDisb.do")
	@ResponseBody
	public Map<String, String> deleteDisb(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".disbDelete");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		String loginId = (String)session.getAttribute("loginId");
		
		// 1. 지출결의서 조회
		DisbInfoModel disb = disbService.disbDetail(paramMap);
		
		// 2. 삭제하려는 사용자와 지출결의서 작성자가 일치한지, 이미 승인이 된 지출결의서인지 확인
		if(!disb.getApplyId().equals(loginId) || "Y".equals(disb.getApprYn())) {
			resultMap.put("result", "Fail");
			return resultMap;
		}
		
		int result = disbService.deleteDisb(paramMap, disb);	
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("updateDisb.do")
	@ResponseBody
	public Map<String, String> updateDisb(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".updateDisb");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();

		int result = disbService.updateDisb(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 지출결의서 다운로드
	@RequestMapping("disbDownload.do")
	public void disbDownload(@RequestParam Map<String, Object> paramMap, HttpServletResponse res) throws Exception {
		logger.info("+ Start " + className + ".disbDownload");
		logger.info("   - paramMap : " + paramMap);
		
		DisbInfoModel disb = disbService.disbDetail(paramMap);
		
		String filePath = disb.getPhsycalPath();
		byte bytes[] = FileUtils.readFileToByteArray(new File(filePath));
		
		res.setContentType("application/octet-stream");
		res.setContentLength(bytes.length);
		res.setHeader("Content-Disposition",
	            "attachment; fileName=\"" + URLEncoder.encode(disb.getEviMaterial(), "UTF-8") + "\";");
		res.setHeader("Content-Transfer-Encoding", "binary");
		res.getOutputStream().write(bytes);
		res.getOutputStream().flush();
		res.getOutputStream().close();
	}
	
}
