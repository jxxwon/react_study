package kr.happyjob.study.accounting.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.accounting.dao.DisbDao;
import kr.happyjob.study.accounting.model.DisbInfoModel;
import kr.happyjob.study.accounting.model.DisbModel;
import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;

@Service
public class DisbServiceImpl implements DisbService {
	
	@Autowired
	private DisbDao disbDao;
	
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.virtualRootPath}")
	private String virtualRootPath;
	
	@Value("${fileUpload.disbPath}")
	private String disbPath;

	@Override
	public List<ComnGrpCodModel> accGrpCodeList() {
		return disbDao.accGrpCodeList();
	}

	@Override
	public List<ComnCodUtilModel> acctCodeList(Map<String, Object> paramMap) {
		return disbDao.acctCodeList(paramMap);
	}

	@Override
	public int saveDisb(Map<String, Object> paramMap, HttpServletRequest req) throws Exception {
		
		MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest) req;
		
		String itemFilePath = disbPath + File.separator;
		FileUtilCho fileUpload = new FileUtilCho(mhsr, rootPath, virtualRootPath, itemFilePath);
		
		Map<String, Object> fileInfo = fileUpload.uploadFiles();
		
		if (fileInfo.get("file_nm") == null) {
			paramMap.put("fileYn", "N");
			paramMap.put("fileInfo", null);
		} else {
			paramMap.put("fileYn", "Y");
			paramMap.put("fileInfo", fileInfo);
		}
		
		// 승인여부는 승인대기로 저장
		paramMap.put("apprYn", "W");
		// 금액에 콤마 제거
		paramMap.put("amount", ((String) paramMap.get("amount")).replaceAll(",", ""));
		
		return disbDao.saveDisb(paramMap);
	}

	@Override
	public List<DisbInfoModel> disbList(Map<String, Object> paramMap) {
		return disbDao.disbList(paramMap);
	}

	@Override
	public int disbListCnt(Map<String, Object> paramMap) {
		return disbDao.disbListCnt(paramMap);
	}

	@Override
	public DisbInfoModel disbDetail(Map<String, Object> paramMap) {
		return disbDao.disbDetail(paramMap);
	}

	@Override
	public int deleteDisb(Map<String, Object> paramMap, DisbInfoModel disb) {
		
		if (disb.getEviMaterial() != null) {
			File oldFile = new File(disb.getPhsycalPath());
			oldFile.delete();
		}
		
		return disbDao.deleteDisb(paramMap);
	}

	@Override
	public int updateDisb(Map<String, Object> paramMap) {
		return disbDao.updateDisb(paramMap);
	}

}
