package kr.happyjob.study.accounting.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.UnpaidDetailItemModel;
import kr.happyjob.study.accounting.model.UnpaidDetailModel;
import kr.happyjob.study.accounting.model.UnpaidModel;

public interface UnpaidService {

	List<UnpaidModel> search(Map<String, Object> params);

	int searchTotalCount(Map<String, Object> params);

	UnpaidDetailModel searchEstmDetail(Map<String, Object> params);

	List<UnpaidDetailItemModel> searchEstmDetailItems(Map<String, Object> params);

	UnpaidDetailModel searchObtainDetail(Map<String, Object> params);

	List<UnpaidDetailItemModel> searchObtainDetailItems(Map<String, Object> params);

	int depositUnpaid(Map<String, Object> params);
}
