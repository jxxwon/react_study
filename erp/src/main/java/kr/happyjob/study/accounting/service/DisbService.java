package kr.happyjob.study.accounting.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.accounting.model.DisbInfoModel;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;

public interface DisbService {

	List<ComnGrpCodModel> accGrpCodeList();

	List<ComnCodUtilModel> acctCodeList(Map<String, Object> paramMap);

	int saveDisb(Map<String, Object> paramMap, HttpServletRequest req) throws Exception;

	List<DisbInfoModel> disbList(Map<String, Object> paramMap);

	int disbListCnt(Map<String, Object> paramMap);

	DisbInfoModel disbDetail(Map<String, Object> paramMap);

	int deleteDisb(Map<String, Object> paramMap, DisbInfoModel disb);

	int updateDisb(Map<String, Object> paramMap);

}
