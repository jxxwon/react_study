package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.employee.model.PromHistModel;
import kr.happyjob.study.employee.model.SalaryClassModel;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.model.VctnInfoModel;

public interface UserInfoDao {

	List<UserInfoModel> empMgtList(Map<String, Object> paramMap);

	int empMgtListCnt(Map<String, Object> paramMap);

	List<SalaryClassModel> empSalaryList();

	int empSalaryListCnt();

	int empSave(Map<String, Object> paramMap);

	int empRetire(Map<String, Object> paramMap);

	UserInfoModel empDetail(Map<String, Object> paramMap);

	int empSalarySave(Map<String, Object> paramMap);

	int empUpdate(Map<String, Object> paramMap);

	int empSalaryUpdate(Map<String, Object> paramMap);

	UserInfoModel empUserIdChk(String loginId);

	int promHistSave(Map<String, Object> paramMap);

	List<PromHistModel> empGradeList(Map<String, Object> paramMap);

	int empGradeListCnt();

	List<PromHistModel> empGradeDetailList(Map<String, Object> paramMap);

	int empGradeDetailListCnt(Map<String, Object> paramMap);

	void insertPromHist(Map<String, Object> paramMap);

	int updatePromHist(Map<String, Object> paramMap);

}
