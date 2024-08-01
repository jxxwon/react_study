package kr.happyjob.study.sales.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.sales.model.RevenueDailyModel;
import kr.happyjob.study.sales.model.RevenueModel;
import kr.happyjob.study.sales.model.TopRevenueModel;

public interface RevenueDao {

	List<RevenueDailyModel> searchDaily(Map<String, Object> params);

	int searchDailyTotalCount(Map<String, Object> params);

	List<RevenueModel> searchRevenue(Map<String, Object> params);

	List<TopRevenueModel> searchTopItem(Map<String, Object> params);

	List<TopRevenueModel> searchTopCust(Map<String, Object> params);
}
