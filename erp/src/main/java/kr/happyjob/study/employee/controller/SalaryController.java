package kr.happyjob.study.employee.controller;

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

import kr.happyjob.study.business.model.SalesFindNameModel;
import kr.happyjob.study.business.service.SalesService;
import kr.happyjob.study.employee.model.SalaryModel;
import kr.happyjob.study.employee.service.SalaryService;

@Controller
@RequestMapping("/employee/")
public class SalaryController {
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	private SalaryService salaryService;
	
	@Autowired
	private SalesService salesService;
	
	// 급여 조회 페이지
	@RequestMapping("empPayHist.do")
	public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initSalary");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		logger.info("id:" + paramMap);

		return "employee/salary";
	}
	
	// 급여 항목 리스트
	@RequestMapping("salaryList.do")
	@ResponseBody
	public SalaryModel getSalaryList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".deductList");
		logger.info("   - paramMap : " + paramMap);
		
		//Map<String, String> resultMap = new HashMap<>();
		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
	
		SalaryModel salaryList = salaryService.salaryList(paramMap);
		logger.info("리스트 존재 여부: " + salaryList);
		
		// 이름 불러오기
		SalesFindNameModel searchName = salesService.searchName(paramMap);
		String name = searchName.getName();
				
		// 리스트가 존재하지 않을 경우 (초기화)
		if (salaryList == null) {
			salaryList = new SalaryModel(loginID, name);
		}
		
		return salaryList;
	}
	
}
