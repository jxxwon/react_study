package kr.happyjob.study.employee.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.dao.SalaryManageDao;
import kr.happyjob.study.employee.model.SalaryModel;

@Service
public class SalaryManageServiceImpl implements SalaryManageService {
	
	@Autowired
	private SalaryManageDao salaryManageDao;

	@Override
	public List<SalaryModel> salaryManageList(Map<String, Object> paramMap) throws Exception {
		return salaryManageDao.salaryManageList(paramMap);
	}

	@Override
	public int salaryManageListCnt(Map<String, Object> paramMap) throws Exception {
		return salaryManageDao.salaryManageListCnt(paramMap);
	}

	@Override
	public List<SalaryModel> salaryManageDetailList(Map<String, Object> paramMap) throws Exception {
		return salaryManageDao.salaryManageDetailList(paramMap);
	}

	@Override
	public int salaryManageDetailListCnt(Map<String, Object> paramMap) throws Exception {
		return salaryManageDao.salaryManageDetailListCnt(paramMap);
	}

	@Override
	public int salaryApprove(Map<String, Object> paramMap) throws Exception {
		return salaryManageDao.salaryApprove(paramMap);
	}
	
}
