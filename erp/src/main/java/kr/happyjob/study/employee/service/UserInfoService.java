package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.employee.model.PromHistModel;
import kr.happyjob.study.employee.model.SalaryClassModel;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.model.VctnInfoModel;

public interface UserInfoService {

	List<UserInfoModel> empMgtList(Map<String, Object> paramMap) throws Exception;

	int empMgtListCnt(Map<String, Object> paramMap) throws Exception;

	List<SalaryClassModel> empSalaryList();

	int empSalaryListCnt();

	int empSave(Map<String, Object> paramMap, HttpServletRequest req) throws Exception;

	int empRetire(Map<String, Object> paramMap);

	UserInfoModel empDetail(Map<String, Object> paramMap);

	int empSalarySave(Map<String, Object> paramMap);
	
	void saveEmployeeAndSalary(Map<String, Object> paramMap, HttpServletRequest req) throws Exception;

	int empUpdate(Map<String, Object> paramMap, HttpServletRequest req) throws Exception;
	
	int empSalaryUpdate(Map<String, Object> paramMap);
	
	void updateEmployeeAndSalary(Map<String, Object> paramMap, HttpServletRequest req);

	UserInfoModel empUserIdChk(String loginId);
	
	int promHistSave(Map<String, Object> paramMap);

	List<PromHistModel> empGradeList(Map<String, Object> paramMap);

	int empGradeListCnt();

	List<PromHistModel> empGradeDetailList(Map<String, Object> paramMap);

	int empGradeDetailListCnt(Map<String, Object> paramMap);

	void insertPromHist(Map<String, Object> paramMap);

}
