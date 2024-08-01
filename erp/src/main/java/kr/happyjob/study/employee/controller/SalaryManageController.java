package kr.happyjob.study.employee.controller;

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

import kr.happyjob.study.employee.model.SalaryModel;
import kr.happyjob.study.employee.service.SalaryManageService;

@Controller
@RequestMapping("/employee/")
public class SalaryManageController {
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	private SalaryManageService salaryManageService;
		
	// 급여 관리 페이지
	@RequestMapping("empPayment.do")
	public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initSalary");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		logger.info("id:" + paramMap);

		return "employee/salaryManage";
	}		
	
	@RequestMapping("salaryManageList.do")
	public String getSalaryManageList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".salaryManageList");
		logger.info("   - paramMap : " + paramMap);
		
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<SalaryModel> salaryManageList = salaryManageService.salaryManageList(paramMap);
		int salaryManageListCnt = salaryManageService.salaryManageListCnt(paramMap);
		
		model.addAttribute("salaryManageList", salaryManageList);
		model.addAttribute("salaryManageListCnt", salaryManageListCnt);
		
		return "employee/salaryManageList";
	}
	
	@RequestMapping("salaryManageDetailList.do")
	public String getSalaryManageDetailList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".salaryManageDetailList");
		logger.info("   - paramMap : " + paramMap);
		
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		List<SalaryModel> salaryManageDetailList = salaryManageService.salaryManageDetailList(paramMap);
		int salaryManageDetailListCnt = salaryManageService.salaryManageDetailListCnt(paramMap);
		
		model.addAttribute("salaryManageDetailList", salaryManageDetailList);
		model.addAttribute("salaryManageDetailListCnt", salaryManageDetailListCnt);
		
		return "employee/salaryManageDetailList";
	}
	
	// 급여 승인
	@RequestMapping("salaryApprove.do")
	@ResponseBody
	public Map<String, String> salaryApprove(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".salaryApprove");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = salaryManageService.salaryApprove(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}

}
