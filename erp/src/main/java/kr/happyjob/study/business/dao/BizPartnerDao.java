package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.BizPartnerModel;

public interface BizPartnerDao {

	List<BizPartnerModel> bizPartnerList(Map<String, Object> paramMap);

	int bizPartnerListCnt(Map<String, Object> paramMap);

	int saveBizPartner(Map<String, Object> paramMap);

	BizPartnerModel bizPartnerDetail(Map<String, Object> paramMap);

	int updateBizPartner(Map<String, Object> paramMap);

	int deleteBizPartner(Map<String, Object> paramMap);

}
