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

import kr.happyjob.study.employee.model.SalaryClassModel;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.model.VctnInfoModel;
import kr.happyjob.study.employee.service.VctnInfoService;

@Controller
@RequestMapping("/employee/")
public class VctnInfoController {
	
	@Autowired
	VctnInfoService vctnInfoService;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	// 근태신청 연결
	@RequestMapping("vctnApply.do")
	public String vctnApply(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vctnApply");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		// 사용 가능 일수, 사용일수 등 불러오기
		VctnInfoModel vctnInfo = vctnInfoService.vctnInfo(loginID);
		
		Integer availDay = vctnInfo.getAvailDay();
		Integer useDate = vctnInfo.getUseDate();
		int remainDay = availDay - useDate;
		
		vctnInfo.setRemainDay(remainDay);
		
		model.addAttribute("loginId", loginID);
		model.addAttribute("vctnInfo", vctnInfo);

		return "employee/vctnApply";
	}
	
	// 근태신청 저장
	@RequestMapping("vctnSave.do")
	@ResponseBody
	public Map<String, String> vctnSave(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
		logger.info("+ Start " + className + ".vctnSave");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		// 남은 일수 가져오기
		VctnInfoModel remainChk = vctnInfoService.remainVctn(paramMap);
		
		int availDay = remainChk.getAvailDay();
		int useDate = Integer.parseInt((String)paramMap.get("useDate"));
		// 연차를 처음 사용하는 경우
		int first = remainChk.getSeq();
		int preRemainDay = 0;
		
		if(first == 0){
			preRemainDay = availDay;
		} else {
			preRemainDay = remainChk.getRemainDay();
		}
		
		if(preRemainDay > useDate){
			int remainDay = preRemainDay - useDate;
			paramMap.put("remainDay", remainDay);
			int result = vctnInfoService.saveVctn(paramMap);
			
			if (result > 0) {
				resultMap.put("result", "Success");
			} else {
				resultMap.put("result", "Fail");
			}
		} else {
			resultMap.put("result", "사용 가능한 일수를 초과하였습니다.");
		}
		
		return resultMap;
	}
	
	// 근태 중복 확인
	@RequestMapping("vctnChk.do")
	@ResponseBody
	public Map<String, String> vctnChk(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
		logger.info("+ Start " + className + ".vctnChk");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		VctnInfoModel result = vctnInfoService.chkVctn(paramMap);
		
		if (result == null) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	
	// 근태관리 목록
	@RequestMapping("vctnList.do")
	public String vctnList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vctnList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<VctnInfoModel> vctnList = vctnInfoService.vctnList(paramMap); 
		int vctnCnt = vctnInfoService.vctnListCnt(paramMap);
		
		model.addAttribute("vctnList", vctnList);
		model.addAttribute("vctnCnt", vctnCnt);

		return "employee/vctnList";
	}
	
	// 근태신청 상세조회
	@RequestMapping("vctnDetail.do")
	@ResponseBody
	public Map<String, Object> vctnDetail(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".vctnDetail");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		VctnInfoModel vctnDetail = vctnInfoService.vctnDetail(paramMap);
		
		resultMap.put("detailValue", vctnDetail);
		
		return resultMap;
	}
	
	// 근태신청 수정
		@RequestMapping("vctnUpdate.do")
		@ResponseBody
		public Map<String, String> vctnUpdate(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
			logger.info("+ Start " + className + ".vctnUpdate");
			logger.info("   - paramMap : " + paramMap);
			
			Map<String, String> resultMap = new HashMap<>();
			
			// 남은 일수 가져오기
			VctnInfoModel remainChk = vctnInfoService.remainVctn(paramMap);
			
			int availDay = remainChk.getAvailDay();
			int useDate = Integer.parseInt((String)paramMap.get("useDate"));
			
			if(useDate < availDay){
				int result = vctnInfoService.updateVctn(paramMap);
				
				if (result > 0) {
					resultMap.put("result", "Success");
				} else {
					resultMap.put("result", "Fail");
				}
			} else {
				resultMap.put("result", "사용 가능한 일수를 초과하였습니다.");
			}
			
			
			return resultMap;
		}
		
	// 근태신청 삭제
	@RequestMapping("vctnDelete.do")
	@ResponseBody
	public Map<String, String> vctnDelete(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
		logger.info("+ Start " + className + ".vctnDelete");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = vctnInfoService.deleteVctn(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 근태관리 연결
	@RequestMapping("vctnApprove.do")
	public String vctnApprove(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vctnApprove");
		logger.info("   - paramMap : " + paramMap);

		String loginID = (String) session.getAttribute("loginId");
		paramMap.put("loginID", loginID);
		
		return "employee/vctnApprove";
	}
	
	// 근태관리 결재 관련 목록
	@RequestMapping("vctnApproveList.do")
	public String vctnApproveList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vctnApproveList");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<VctnInfoModel> vctnApproveList = vctnInfoService.vctnApproveList(paramMap); 
		int vctnApproveCnt = vctnInfoService.vctnApproveListCnt(paramMap);
		
		model.addAttribute("vctnApproveList", vctnApproveList);
		model.addAttribute("vctnApproveCnt", vctnApproveCnt);

		return "employee/vctnApproveList";
	}
	
	// 근태 승인 상세조회
	@RequestMapping("vctnApproveDetail.do")
	@ResponseBody
	public Map<String, Object> vctnApproveDetail(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".vctnApproveDetail");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		VctnInfoModel vctnDetail = vctnInfoService.vctnApproveDetail(paramMap);
		
		resultMap.put("detailValue", vctnDetail);
		
		return resultMap;
	}
	
	// 근태 승인
	@RequestMapping("vctnApproval.do")
	@ResponseBody
	public Map<String, String> vctnApprove(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
		logger.info("+ Start " + className + ".vctnApproval");
		logger.info("   - paramMap : " + paramMap);

		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = vctnInfoService.approvalVctn(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 근태 반려
	@RequestMapping("vctnReject.do")
	@ResponseBody
	public Map<String, String> vctnReject(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception{
		logger.info("+ Start " + className + ".vctnReject");
		logger.info("   - paramMap : " + paramMap);
		
		String loginId = (String)session.getAttribute("loginId");
		paramMap.put("loginId", loginId);
		
		Map<String, String> resultMap = new HashMap<>();
		
		int result = vctnInfoService.rejectVctn(paramMap);
		
		if (result > 0) {
			resultMap.put("result", "Success");
		} else {
			resultMap.put("result", "Fail");
		}
		
		return resultMap;
	}
	
	// 근태현황조회 연결
	@RequestMapping("vctnCalendar.do")
	public String vctnCalendar(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".vctnCalendar");
		logger.info("   - paramMap : " + paramMap);
		
		return "employee/vctnCalendar";
	}
	
	// 근태 현황조회 승인, 미승인, 반려 건수 조회
	@RequestMapping("vctnCalendarList.do")
	@ResponseBody
	public Map<String, Object> vctnCalendarList(@RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		logger.info("+ Start " + className + ".vctnCalendarListCnt");
		logger.info("   - paramMap : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		// 건수 불러오기
		String searchStrDate = (String)paramMap.get("formattedMonth") + "-01";
		String searchEndDate = (String)paramMap.get("formattedMonth") + "-31";
		
		paramMap.put("searchStrDate", searchStrDate);
		paramMap.put("searchEndDate", searchEndDate);
		
		List<VctnInfoModel> vctnCalendar = vctnInfoService.vctnInfoCalendar(paramMap);
		
		resultMap.put("detailValue", vctnCalendar);
		
		return resultMap;
	}
	
	// 근태현황조회 상세조회
	@RequestMapping("vctnCalendarDetail.do")
	public String vctnCalendarDetail(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vctnCalendarDetail");
		logger.info("   - paramMap : " + paramMap);
		
		// 페이징
		int cpage = Integer.valueOf((String)paramMap.get("cpage"));
		int pageSize = Integer.valueOf((String)paramMap.get("pageSize"));
		
		int startSeq = (cpage - 1) * pageSize;
		
		paramMap.put("startSeq", startSeq);
		paramMap.put("pageSize", pageSize);
		
		// 목록 불러오기
		List<VctnInfoModel> vctnApproveList = vctnInfoService.vctnApproveList(paramMap); 
		int vctnApproveCnt = vctnInfoService.vctnApproveListCnt(paramMap);
		
		model.addAttribute("vctnApproveList", vctnApproveList);
		model.addAttribute("vctnApproveCnt", vctnApproveCnt);

		return "employee/vctnApproveList";
	}
	
	// 근태현황조회 일자별 조회
	@RequestMapping("vctnCalendarApplyList.do")
	public String vctnCalendarApplyList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".vctnCalendarApplyList");
		
		// 목록 불러오기
		
		List<VctnInfoModel> vctnCalendarApplyList = vctnInfoService.vctnCalendarApplyList(paramMap);
		
		model.addAttribute("vctnCalendarApplyList", vctnCalendarApplyList);
		
		return "employee/vctnCalendarList";
	}
	
}
