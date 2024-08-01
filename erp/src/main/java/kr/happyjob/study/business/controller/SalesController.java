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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.business.model.SalesFindNameModel;
import kr.happyjob.study.business.model.SalesItemModel;
import kr.happyjob.study.business.model.SalesModel;
import kr.happyjob.study.business.service.SalesService;
import kr.happyjob.study.system.model.NoticeModel;

@Controller
@RequestMapping("/business/")
public class SalesController {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	@Autowired
	private SalesService salesService;

	// 영업 계획 페이지
	@RequestMapping("empSalePlan.do")
	public String salePlanInit(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initSalePlan");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");		
		paramMap.put("loginID", loginID);

		logger.info("id:" + paramMap);
		
		// 제조업체 리스트
		List<SalesItemModel> searchList = salesService.searchList(paramMap);
		
		// 거래처 이름 리스트
		List<SalesModel> custNameList = salesService.custNameList(paramMap);
		
		SalesFindNameModel searchName = salesService.searchName(paramMap);
		
		model.addAttribute("loginID", loginID);
		model.addAttribute("searchName", searchName);
		model.addAttribute("searchList", searchList);
		model.addAttribute("custNameList", custNameList);
		logger.info("searchList:" + searchList);
		logger.info("custNameList:" + custNameList);

		return "business/salePlan";
	}

	// 영업 계획 리스트
	@RequestMapping("salePlanList.do")
	public String getSalePlanList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".salePlanList");
		logger.info("   - paramMap : " + paramMap);

		int cpage = Integer.valueOf((String) paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String) paramMap.get("pageSize"));

		int startSeq = (cpage - 1) * pageSize;

		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);

		List<SalesModel> salePlanList = salesService.salePlanList(paramMap);
		int salePlanListCnt = salesService.salePlanListCnt(paramMap);

		model.addAttribute("salePlanList", salePlanList);
		model.addAttribute("salePlanListCnt", salePlanListCnt);

		return "business/salePlanList";
	}
		
	// 대분류
	@RequestMapping("getMajorClasses.do")
	@ResponseBody
	public List<SalesItemModel> getMajorClasses(@RequestParam Map<String, Object> paramMap) throws Exception {
	    return salesService.getMajorClasses(paramMap);
	}
	
	// 소분류
	@RequestMapping("getSubClasses.do")
	@ResponseBody
	public List<SalesItemModel> getSubClasses(@RequestParam Map<String, Object> paramMap) throws Exception {
	    return salesService.getSubClasses(paramMap);
	}
	
	// 제품이름
	@RequestMapping("getItemNameClasses.do")
	@ResponseBody
	public List<SalesItemModel> getItemNameClasses(@RequestParam Map<String, Object> paramMap) throws Exception {
	    return salesService.getItemNameClasses(paramMap);
	}
		
	// 영업계획서 상세 조회
	@RequestMapping("salePlanDetail.do")
	@ResponseBody
	public Map<String, Object> salePlanDetail(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".salePlanDetail");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
				
		SalesModel salePlanDetail = salesService.salePlanDetail(paramMap);
		
		resultMap.put("salePlanDetail", salePlanDetail);
		
		return resultMap;
	}
	
	// 영업계획서 등록
	@RequestMapping("salePlanSave.do")
	@ResponseBody
	public Map<String, String> salePlanSave(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".saveSalePlan");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginID = (String)session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		int result = salesService.salePlanSave(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 영업계획서 수정
	@RequestMapping("salePlanUpdate.do")
	@ResponseBody
	public Map<String, String> updateSalePlan(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".updateSalePlan");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		String loginID = (String)session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		int result = salesService.updateSalePlan(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 영업계획서 삭제
	@RequestMapping("salePlanDelete.do")
	@ResponseBody
	public Map<String, String> deleteSalePlan(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".deleteSalePlan");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = salesService.deleteSalePlan(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 영업 실적 조회 페이지
	@RequestMapping("bmSalePlan.do")
	public String saleInfoInit(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initSaleInfo");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");		
		paramMap.put("loginID", loginID);
		
		// 제조업체 이름 리스트
		List<SalesItemModel> searchList = salesService.searchList(paramMap);

		logger.info("id:" + paramMap);
		
		model.addAttribute("loginID", loginID);
		model.addAttribute("searchList", searchList);

		return "business/saleInfo";
	}
	
	// 영업 실적 조회 리스트
	@RequestMapping("saleInfoList.do")
	public String getSaleInfoList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".saleInfoList");
		logger.info("   - paramMap : " + paramMap);

		int cpage = Integer.valueOf((String) paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String) paramMap.get("pageSize"));

		int startSeq = (cpage - 1) * pageSize;

		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);

		List<SalesModel> saleInfoList = salesService.saleInfoList(paramMap);
		int saleInfoListCnt = salesService.saleInfoListCnt(paramMap);

		model.addAttribute("saleInfoList", saleInfoList);
		model.addAttribute("saleInfoListCnt", saleInfoListCnt);

		return "business/saleInfoList";
	}
}
