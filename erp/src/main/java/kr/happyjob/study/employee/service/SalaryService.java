package kr.happyjob.study.employee.service;

import java.util.Map;

import kr.happyjob.study.employee.model.SalaryModel;

public interface SalaryService {
	
	/** 내역 한 건 조회 */
	SalaryModel salaryList(Map<String, Object> params) throws Exception;
		
	/** 내역 확인 */
	int salaryListCnt(Map<String, Object> params) throws Exception;
	
}
