package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.employee.model.SalaryModel;

public interface SalaryManageService {
	
	// 급여 전체 리스트
	List<SalaryModel> salaryManageList(Map<String, Object> paramMap) throws Exception;
	
	// 급여 전체 리스트 개수
	int salaryManageListCnt(Map<String, Object> paramMap) throws Exception;
	
	// 급여 상세 리스트
	List<SalaryModel> salaryManageDetailList(Map<String, Object> paramMap) throws Exception;
	
	// 급여 상세 리스트 개수
	int salaryManageDetailListCnt(Map<String, Object> paramMap) throws Exception;
	
	// 급여 승인
	int salaryApprove(Map<String, Object> paramMap) throws Exception;
}
