package kr.happyjob.study.accounting.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.DisbInfoModel;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;

public interface DisbDao {

	List<ComnGrpCodModel> accGrpCodeList();

	List<ComnCodUtilModel> acctCodeList(Map<String, Object> paramMap);

	int saveDisb(Map<String, Object> paramMap);

	List<DisbInfoModel> disbList(Map<String, Object> paramMap);

	int disbListCnt(Map<String, Object> paramMap);

	DisbInfoModel disbDetail(Map<String, Object> paramMap);

	int deleteDisb(Map<String, Object> paramMap);

	int updateDisb(Map<String, Object> paramMap);

}
