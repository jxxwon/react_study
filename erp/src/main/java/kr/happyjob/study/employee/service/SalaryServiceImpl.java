package kr.happyjob.study.employee.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.employee.dao.SalaryDao;
import kr.happyjob.study.employee.model.SalaryModel;

@Service
public class SalaryServiceImpl implements SalaryService {
	
	@Autowired
	private SalaryDao salarydao;

	@Override
	public SalaryModel salaryList(Map<String, Object> params) throws Exception {
		return salarydao.salaryList(params);
	}

	@Override
	public int salaryListCnt(Map<String, Object> params) throws Exception {
		return salarydao.salaryListCnt(params);
	}





}
