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

import kr.happyjob.study.employee.model.PromHistModel;
import kr.happyjob.study.employee.model.SalaryClassModel;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.model.VctnInfoModel;
import kr.happyjob.study.employee.service.UserInfoService;
import kr.happyjob.study.system.model.NoticeModel;

@Controller
@RequestMapping("/employee/")
public class UserInfoController {
	
	@Autowired
	UserInfoService userInfoService;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	// 인사관리 연결
	@RequestMapping("empMgt.do")
	public String init(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".initEmpMgt");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);

		return "employee/empMgt";
	}

	// 인사관리 목록
	@RequestMapping("empMgtList.do")
	public String empMgtList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empMgtList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<UserInfoModel> empMgtList = userInfoService.empMgtList(paramMap); 
		int empMgtCnt = userInfoService.empMgtListCnt(paramMap);
		
		model.addAttribute("empMgtList", empMgtList);
		model.addAttribute("empMgtCnt", empMgtCnt);

		return "employee/empMgtList";
	}
	
	// 호봉 목록
	@RequestMapping("empSalaryList.do")
	public String empSalaryList(Model model, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empSalaryList");
		
		// 목록 불러오기
		List<SalaryClassModel> empSalaryList = userInfoService.empSalaryList();
		int empSalaryCnt = userInfoService.empSalaryListCnt();
		
		model.addAttribute("empSalaryList", empSalaryList);
		model.addAttribute("empSalaryCnt", empSalaryCnt);
		
		return "employee/empSalaryList";
	}
	
	// 사원등록
	@RequestMapping("empSave.do")
	@ResponseBody
	public Map<String, String> empSave(@RequestParam Map<String, Object> paramMap, HttpSession session,
			HttpServletRequest req) throws Exception {
		logger.info("+ Start " + className + ".empSave");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		try {
            // 트랜잭션 관리 메소드 호출
            userInfoService.saveEmployeeAndSalary(paramMap, req);
            resultMap.put("result", "Success");
        } catch (Exception e) {
            logger.error("Error during empSave transaction", e);
            resultMap.put("result", "Fail");
        }
        
        return resultMap;
	}
	
	// 퇴사처리
	@RequestMapping("empRetire.do")
	@ResponseBody
	public Map<String, String> empRetire(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".empRetire");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = userInfoService.empRetire(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 상세조회
	@RequestMapping("empDetail.do")
	@ResponseBody
	public Map<String, Object> empDetail(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".empDetail");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		UserInfoModel empDetail = userInfoService.empDetail(paramMap);
		
		resultMap.put("detailValue", empDetail);
		
		return resultMap;
	}
	
	// 사원 수정
	@RequestMapping("empUpdate.do")
	@ResponseBody
	public Map<String, Object> empUpdate(@RequestParam Map<String, Object> paramMap, HttpSession session,
			HttpServletRequest req) throws Exception {
		logger.info("+ Start " + className + ".empUpdate");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		// 직급, 부서가 변경되면 승진 이력 생성
		// 기존  정보 불러오기
		UserInfoModel pre = userInfoService.empDetail(paramMap);
		// 부서변경 확인
		String preDeptCode = pre.getDeptCode();
		String chDeptCode = (String) paramMap.get("deptCode");
		// 직급변경 확인
		String prePosCode = pre.getPosCode();
		String chPosCode = (String) paramMap.get("posCode");

		try {
            // 트랜잭션 관리 메소드 호출
            userInfoService.updateEmployeeAndSalary(paramMap, req);
            if(preDeptCode.equals(chDeptCode) == false || prePosCode.equals(chPosCode) == false){
            	userInfoService.insertPromHist(paramMap);
            }
            resultMap.put("result", "Success");
        } catch (Exception e) {
            logger.error("Error during empSave transaction", e);
            resultMap.put("result", "Fail");
        }
		
        return resultMap;
	}
	
	// 사번 중복체크
	@RequestMapping("empUserIdChk.do")
	@ResponseBody
	public Map<String, Object> empUserIdChk(@RequestParam Map<String, Object> paramMap, Model model, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empUserIdChk");
		logger.info("   - paramMap : " + paramMap);
		
		String result = "";
		
		String loginId = (String) paramMap.get("loginId");
		
		UserInfoModel userIdChk = userInfoService.empUserIdChk(loginId);
		if(userIdChk != null){
			result = "false";
		} else {
			result = "Success";
		}
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("result", result);
	    
	    return resultMap;
	}
	
	// 승진내역관리 연결
	@RequestMapping("empGrade.do")
	public String empGrade(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".EmpGrade");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);

		return "employee/empGrade";
	}
	
	// 승진내역관리 목록
	@RequestMapping("empGradeList.do")
	public String empGradeList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empGradeList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<PromHistModel> empGradeList = userInfoService.empGradeList(paramMap); 
		int empGradeCnt = userInfoService.empGradeListCnt();
		
		model.addAttribute("empGradeList", empGradeList);
		model.addAttribute("empGradeCnt", empGradeCnt);

		return "employee/empGradeList";
	}
	
	// 승진내역 상세목록
	@RequestMapping("empGradeDetailList.do")
	public String empGradeDetailList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".empGradeDetailList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<PromHistModel> empGradeDetailList = userInfoService.empGradeDetailList(paramMap); 
		int empGradeDetailCnt = userInfoService.empGradeDetailListCnt(paramMap);
		
		model.addAttribute("empGradeDetailList", empGradeDetailList);
		model.addAttribute("empGradeDetailCnt", empGradeDetailCnt);
		
		return "employee/empGradeDetailList";
	}
	
}
