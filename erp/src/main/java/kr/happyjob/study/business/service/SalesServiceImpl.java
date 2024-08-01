package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.SalesDao;
import kr.happyjob.study.business.model.SalesFindNameModel;
import kr.happyjob.study.business.model.SalesItemModel;
import kr.happyjob.study.business.model.SalesModel;

@Service
public class SalesServiceImpl implements SalesService {
	
	@Autowired
	private SalesDao salesDao;

	@Override
	public List<SalesModel> salePlanList(Map<String, Object> paramMap) throws Exception {
		return salesDao.salePlanList(paramMap);
	}

	@Override
	public int salePlanListCnt(Map<String, Object> paramMap) throws Exception {
		return salesDao.salePlanListCnt(paramMap);
	}

	@Override
	public List<SalesItemModel> searchList(Map<String, Object> paramMap) throws Exception {
		return salesDao.searchList(paramMap);
	}

	@Override
	public List<SalesItemModel> getMajorClasses(Map<String, Object> paramMap) throws Exception {
		return salesDao.getMajorClasses(paramMap);
	}

	@Override
	public List<SalesItemModel> getSubClasses(Map<String, Object> paramMap) throws Exception {
		return salesDao.getSubClasses(paramMap);
	}
	
	@Override
	public List<SalesItemModel> getItemNameClasses(Map<String, Object> paramMap) throws Exception {
		return salesDao.getItemNameClasses(paramMap);
	}
	
	@Override
	public SalesModel salePlanDetail(Map<String, Object> paramMap) throws Exception {
		return salesDao.salePlanDetail(paramMap);
	}

	@Override
	public int salePlanSave(Map<String, Object> paramMap) throws Exception {
		return salesDao.salePlanSave(paramMap);
	}

	@Override
	public int updateSalePlan(Map<String, Object> paramMap) throws Exception {
		return salesDao.updateSalePlan(paramMap);
	}

	@Override
	public int deleteSalePlan(Map<String, Object> paramMap) throws Exception {
		return salesDao.deleteSalePlan(paramMap);
	}

	@Override
	public List<SalesModel> custNameList(Map<String, Object> paramMap) throws Exception {
		return salesDao.custNameList(paramMap);
	}

	@Override
	public SalesFindNameModel searchName(Map<String, Object> paramMap) throws Exception {
		return salesDao.searchName(paramMap);
	}

	@Override
	public List<SalesModel> saleInfoList(Map<String, Object> paramMap) throws Exception {
		return salesDao.saleInfoList(paramMap);
	}

	@Override
	public int saleInfoListCnt(Map<String, Object> paramMap) throws Exception {
		return salesDao.saleInfoListCnt(paramMap);
	}

}
