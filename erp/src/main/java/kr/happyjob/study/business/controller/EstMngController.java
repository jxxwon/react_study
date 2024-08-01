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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.business.model.EstMngModel;
import kr.happyjob.study.business.service.EstMngService;


@Controller
@RequestMapping("/business/")
public class EstMngController {

	@Autowired
	private EstMngService estService; 
	
		// 프로퍼티 값 
		@Value("${cop.copnm}")
		private String erp_copnm; // 회사이름
		
		@Value("${cop.copnum}")
		private String erp_copnum; //사업자등록번호
		
		@Value("${cop.addr}")
		private String erp_addr; // 주소
		
		@Value("${cop.emp}")
		private String erp_emp; // 담당자
		
		@Value("${cop.tel}")
		private String erp_tel;	 // 회사 번호
	
		// Set logger
		private final Logger logger = LogManager.getLogger(this.getClass());
		// Get class name for logger
		private final String className = this.getClass().toString();
		
	// 화면 띄우기
	@RequestMapping("estMng.do")
	public String estMangement(){
		return "business/estMng";
		
	}
	
	
	/* model에 List 넣기  == 조회*/
    @RequestMapping("estMngList.do")
    public String estManagementList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
    			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + "estMngList ");

		
		int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호 넘어온것
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈 넘어온것
		int pageIndex = (currentPage-1)*pageSize;								// 페이지 시작 row 번호 넘어온것
		String client_search =(String) paramMap.get("client_search");  // 거래처 검색 셀렉트박스 넘어온것
		String from_date =(String) paramMap.get("from_date"); // 날짜 시작 데이터 검색  넘어온것
		String to_date =(String) paramMap.get("to_date"); // 날짜 끝 데이터 검색  넘어온것
		
		
		paramMap.put("pageIndex", pageIndex); // db로
		paramMap.put("pageSize", pageSize); // db로
		

		
		// 1 . 목록 리스트 조회 
		List<EstMngModel> estList = estService.estList(paramMap); // -> 콜백단으로 보내지는 데이터
		model.addAttribute("estList", estList);

		
		
		// 2 . 목록 리스트  카운트 조회
		int estCnt = estService.estCnt(paramMap);


		model.addAttribute("estCnt", estCnt);
		model.addAttribute("from_date", from_date);
		model.addAttribute("to_date", to_date);

		
		logger.info("   - paramMap ? ? ? ? ? ? : " + paramMap);
		
		return "/business/EstMngCallBack"; 
	}
	
    
    
    // 단건 조회 
  	@RequestMapping("estMngSelect.do")
  	@ResponseBody
  	public Map<String, Object> selectEstList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
  			HttpServletResponse response, HttpSession session) throws Exception{
  	
  		 		logger.info("+ 자바단 컨트롤러 Start " + className + " .estMngSelect");
  		
  		String result = "SUCCESS";
  		String resultMsg = "조회 되었습니다.";

  		//단건 조회  
  		//단건조회에 맞는 모달 안 리스트 뽑을 때 estm_num 여깄음
  		List<EstMngModel> estpart = estService.selectEstList(paramMap); 
  		logger.info("+ End " + estpart + "estpart");
  		
  		Map<String, Object> resultMap = new HashMap<String, Object>();
  		resultMap.put("result",result); // 컨트롤러 탔으니 성공했다는 메세지 뷰로 보낸다 
  		resultMap.put("estpart",estpart); // 단건조회 목록
  		resultMap.put("resultMsg",resultMsg); // 한국어로 메세지 
  		
  		// 우리 회사 프로퍼티 박은거 보내기 
  		resultMap.put("erp_copnm",erp_copnm); // 회사이름 
  		resultMap.put("erp_copnum",erp_copnum); // 사업자번호
  		resultMap.put("erp_addr",erp_addr); // 회사 주소 
  		resultMap.put("erp_emp",erp_emp); // 담당자 이름 
  		resultMap.put("erp_tel",erp_tel); // 담당자 전화번호 
  		String applyer = (String) session.getAttribute("loginId");
  		paramMap.put("applyer", applyer);
 		logger.info("+ End " + estpart + "estpart");
 		
 		resultMap.put("estm_num", paramMap.get("estm_num"));
 	 
 	 	logger.info("+ End " + className + "estMngSelect"); // log4j  순서도 중요 
 	 	logger.info(paramMap.get("estm_num"));
 	 	logger.info(resultMap.get("estm_num"));
 	 	logger.info(resultMap);
 		 
  		return resultMap ;
  		
  	}    
  	
  	/* 모달에 foreach문 돌리기 : 단건 조회 항목에 대한 주문 건 리스트  */
    @RequestMapping("estDetaillist.do")
    public String EstDetaillist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
    			HttpServletResponse response, HttpSession session) throws Exception {

		
		logger.info("+ 자바단 컨트롤러 Start " + className + " .EstDetaillist");


		// 1 . 목록 리스트 조회 
		List<EstMngModel> estDetailList = estService.estListDetail(paramMap); // -> 콜백단으로 보내지는 데이터
		model.addAttribute("estDetailList", estDetailList);
		
		model.addAttribute("userType", session.getAttribute("userType"));
		
		// 2 . 목록 리스트  카운트 조회
		int estDetailCnt =estService.estDetailCnt(paramMap);
		model.addAttribute("estDetailCnt",estDetailCnt);
		model.addAttribute("estm_num",paramMap.get("estm_num"));
		
		
		logger.info("   자바단 컨트롤러  - paramMap : " + paramMap);
		
		return "/business/EstDetailMngModal"; 
	}
    
    
    // 신규 견적서 등록 및 수정 
  	@RequestMapping("estMngSave.do")
 	@ResponseBody
 	public Map<String, Object> saveEstManage(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
 			HttpServletResponse response, HttpSession session) throws Exception {
 		
 		logger.info("+ Start " + className + ".estMngSave");

 		logger.info("   - paramMap : " + paramMap);
 		
 		
 		String action = (String)paramMap.get("action");
 		
 		String result = "SUCCESS";
 		String resultMsg = "저장 되었습니다.";

 		String estm_num = request.getParameter("estm_num");
 		
 		String client_search1 = request.getParameter("client_search1");
 		
 		String item_name = request.getParameter("item_name");
 		
 		String qut = request.getParameter("qut");
 		
 		

 		String loginID = (String) session.getAttribute("loginId");
 		paramMap.put("loginID", loginID);


 		
 		if ("I".equals(action)) {
 			
 			// 신규 등록 일때
 			// estimate 테이블 인서트
 			estService.insertEstList(paramMap);
 			
 			// estm_detail 테이블 인서트
 			estService.updateInsertEstList(paramMap);
 			
 		} else if("U".equals(action)) {
 			//  단건 조회시 
 			estService.estListDetail(paramMap);
 			
 			
 		} else {
 			result = "FALSE";
 			resultMsg = "알수 없는 요청 입니다.";
 		}
 		
 		
 		// resultMap => 뷰로 간다 
 		Map<String, Object> resultMap = new HashMap<String, Object>();
 		resultMap.put("result", result);
 		resultMap.put("resultMsg", resultMsg);
 		resultMap.put("estm_num", estm_num);
 		
 		logger.info("수정 저장 End " + className + ".신규등록 및 수정 ");
 		logger.info("   - paramMap : " + paramMap);
 		
 		System.out.println("저장 컨트롤러 ");
 		
 		return resultMap;
 	}
 	

 	
  	// 삭제 
  	@RequestMapping("estMngListDelete.do")
 	@ResponseBody
 	public Map<String, Object> deleteEstManage(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
 			HttpServletResponse response, HttpSession session) throws Exception {
  		
  		logger.info("+ Start " + className + ".estMngListDelete");
 		logger.info("   - paramMap : " + paramMap);

 		String result = "SUCCESS";
 		String resultMsg = "삭제 되었습니다.";
  		
 		String estm_num = request.getParameter("estm_num");

 		 // estm_num 바로 받아서 삭제 : view단의  param : estm_num -> mapper
 	 	estService.deleteEstList(paramMap);
 		

 		 Map<String, Object> resultMap = new HashMap<String, Object>();
 		resultMap.put("result", result); // 잘왔다고 확인 보내주기
 		resultMap.put("resultMsg", resultMsg);
 		
 		
 		logger.info("+ End " + className + ".estMngListDelete");
 		
  		return resultMap;

  	}
    
 	// 견적서 승인 or 반려 
   	@RequestMapping("estApplyYesNo.do")
  	@ResponseBody
  	public Map<String, Object> estApplyYesNo(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
  			HttpServletResponse response, HttpSession session) throws Exception {
  		
  		logger.info("+ Start " + className + ".estApplyYesNo");
  		logger.info("   - paramMap : " + paramMap);
  		
  		
  		String result = "SUCCESS";
  		String resultMsg = "저장 되었습니다.";
  		
  		String estm_num = request.getParameter("estm_num");

  		String loginID = (String) session.getAttribute("loginId");
  		paramMap.put("applyer", loginID);
  		
  		// 신규 등록 일때
  		// estm_info 테이블 인서트
  		estService.insertApplyYn(paramMap);

  			
  		// resultMap => 뷰로 간다 
  		Map<String, Object> resultMap = new HashMap<String, Object>();
  		resultMap.put("result", result);
  		resultMap.put("resultMsg", resultMsg);
  		
  		
  		return resultMap;
  	}
  	
    
	
	
	
	
}
