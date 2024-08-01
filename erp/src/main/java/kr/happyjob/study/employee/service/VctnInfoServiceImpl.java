package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.dao.VctnInfoDao;
import kr.happyjob.study.employee.model.VctnInfoModel;

@Service
public class VctnInfoServiceImpl implements VctnInfoService{

	@Autowired
	VctnInfoDao vctnInfoDao;
	
	@Override
	public VctnInfoModel vctnInfo(String loginID) {
		return vctnInfoDao.vctnInfo(loginID);
	}

	@Override
	public int saveVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.saveVctn(paramMap);
	}

	@Override
	public List<VctnInfoModel> vctnList(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnList(paramMap);
	}

	@Override
	public int vctnListCnt(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnListCnt(paramMap);
	}

	@Override
	public VctnInfoModel vctnDetail(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnDetail(paramMap);
	}

	@Override
	public List<VctnInfoModel> vctnApproveList(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnApproveList(paramMap);
	}

	@Override
	public int vctnApproveListCnt(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnApproveListCnt(paramMap);
	}

	@Override
	public VctnInfoModel vctnApproveDetail(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnApproveDetail(paramMap);
	}

	@Override
	public int approvalVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.approvalVctn(paramMap);
	}

	@Override
	public int rejectVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.rejectVctn(paramMap);
	}

	@Override
	public List<VctnInfoModel> vctnInfoCalendar(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnInfoCalendar(paramMap);
	}

	@Override
	public List<VctnInfoModel> vctnCalendarApplyList(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnCalendarApplyList(paramMap);
	}

	@Override
	public int vctnCalendarApplyListCnt(Map<String, Object> paramMap) {
		return vctnInfoDao.vctnCalendarApplyListCnt(paramMap);
	}

	@Override
	public int updateVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.updateVctn(paramMap);
	}

	@Override
	public int deleteVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.deleteVctn(paramMap);
	}

	@Override
	public VctnInfoModel chkVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.chkVctn(paramMap);
	}

	@Override
	public VctnInfoModel remainVctn(Map<String, Object> paramMap) {
		return vctnInfoDao.remainVctn(paramMap);
	}


}
