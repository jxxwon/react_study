package kr.happyjob.study.employee.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.employee.model.VctnInfoModel;

public interface VctnInfoDao {

	VctnInfoModel vctnInfo(String loginID);

	int saveVctn(Map<String, Object> paramMap);

	List<VctnInfoModel> vctnList(Map<String, Object> paramMap);

	int vctnListCnt(Map<String, Object> paramMap);

	VctnInfoModel vctnDetail(Map<String, Object> paramMap);

	List<VctnInfoModel> vctnApproveList(Map<String, Object> paramMap);

	int vctnApproveListCnt(Map<String, Object> paramMap);

	VctnInfoModel vctnApproveDetail(Map<String, Object> paramMap);

	int approvalVctn(Map<String, Object> paramMap);

	int rejectVctn(Map<String, Object> paramMap);

	List<VctnInfoModel> vctnInfoCalendar(Map<String, Object> paramMap);

	List<VctnInfoModel> vctnCalendarApplyList(Map<String, Object> paramMap);

	int vctnCalendarApplyListCnt(Map<String, Object> paramMap);

	int updateVctn(Map<String, Object> paramMap);

	int deleteVctn(Map<String, Object> paramMap);

	VctnInfoModel chkVctn(Map<String, Object> paramMap);

	VctnInfoModel remainVctn(Map<String, Object> paramMap);

}
