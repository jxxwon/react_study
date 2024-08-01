package kr.happyjob.study.sales.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.sales.dao.RevenueDao;
import kr.happyjob.study.sales.model.RevenueDailyModel;
import kr.happyjob.study.sales.model.RevenueModel;
import kr.happyjob.study.sales.model.TopRevenueModel;

@Service
public class RevenueServiceImpl implements RevenueService {

	@Autowired
	private RevenueDao dao;

	@Override
	public List<RevenueDailyModel> searchDaily(Map<String, Object> params) {
		return dao.searchDaily(params);
	}

	@Override
	public int searchDailyTotalCount(Map<String, Object> params) {
		return dao.searchDailyTotalCount(params);
	}

	@Override
	public List<RevenueModel> searchRevenue(Map<String, Object> params) {
		return dao.searchRevenue(params);
	}

	@Override
	public List<TopRevenueModel> searchTopItem(Map<String, Object> params) {
		return dao.searchTopItem(params);
	}

	@Override
	public List<TopRevenueModel> searchTopCust(Map<String, Object> params) {
		return dao.searchTopCust(params);
	}
}
