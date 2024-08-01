package kr.happyjob.study.business.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.business.model.BizPartnerModel;
import kr.happyjob.study.business.service.BizPartnerService;

@Controller
@RequestMapping("/business/")
public class BizPartnerController {
	
	@Autowired
	private BizPartnerService bizPartnerService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	// 거래처 관리 초기 화면
	@RequestMapping("bizPartner.do")
	public String initBizPartner(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".initBizPartner");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);

		return "business/bizPartner";
	}
	
	@RequestMapping("bizPartnerList.do")
	public String getBizPartnerList(Model model, @RequestParam Map<String, Object> paramMap) throws Exception {
		logger.info("+ Start " + className + ".getBizPartnerList");
		logger.info("   - paramMap : " + paramMap);
		
		int currentPage = Integer.valueOf((String)paramMap.get("currentPage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (currentPage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<BizPartnerModel> bizPartnerList = bizPartnerService.bizPartnerList(paramMap);
		int bizPartnaerCnt = bizPartnerService.bizPartnerListCnt(paramMap);
		
		model.addAttribute("bizPartnerList", bizPartnerList);
		model.addAttribute("bizPartnaerCnt", bizPartnaerCnt);
		
		return "business/bizPartnerList";
	}
	
	@RequestMapping("saveBizPartner.do")
	@ResponseBody
	public Map<String, String> saveBizPartner(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".saveBizPartner");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = bizPartnerService.saveBizPartner(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("bizPartnerDetail.do")
	@ResponseBody
	public BizPartnerModel bizPartnerDetail(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".bizPartnerDetail");
		logger.info("   - paramMap : " + paramMap);
		
		return bizPartnerService.bizPartnerDetail(paramMap);
	}
	
	@RequestMapping("updateBizPartner.do")
	@ResponseBody
	public Map<String, String> updateBizPartner(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".updateBizPartner");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		int result = bizPartnerService.updateBizPartner(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	@RequestMapping("deleteBizPartner.do")
	@ResponseBody
	public Map<String, String> deleteBizPartner(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".deleteBizPartner");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = bizPartnerService.deleteBizPartner(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}

}
