package kr.happyjob.study.accounting.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.accounting.dao.UnpaidDao;
import kr.happyjob.study.accounting.model.UnpaidDetailItemModel;
import kr.happyjob.study.accounting.model.UnpaidDetailModel;
import kr.happyjob.study.accounting.model.UnpaidModel;

@Service
public class UnpaidServiceImpl implements UnpaidService {

	@Autowired
	private UnpaidDao dao;

	@Override
	public List<UnpaidModel> search(Map<String, Object> params) {
		return dao.search(params);
	}

	@Override
	public int searchTotalCount(Map<String, Object> params) {
		return dao.searchTotalCount(params);
	}

	@Override
	public UnpaidDetailModel searchEstmDetail(Map<String, Object> params) {
		return dao.searchEstmDetail(params);
	}

	@Override
	public List<UnpaidDetailItemModel> searchEstmDetailItems(Map<String, Object> params) {
		return dao.searchEstmDetailItems(params);
	}

	@Override
	public UnpaidDetailModel searchObtainDetail(Map<String, Object> params) {
		return dao.searchObtainDetail(params);
	}

	@Override
	public List<UnpaidDetailItemModel> searchObtainDetailItems(Map<String, Object> params) {
		return dao.searchObtainDetailItems(params);
	}

	@Override
	public int depositUnpaid(Map<String, Object> params) {
		return dao.depositUnpaid(params);
	}
}
