package kr.happyjob.study.employee.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.employee.dao.UserInfoDao;
import kr.happyjob.study.employee.model.PromHistModel;
import kr.happyjob.study.employee.model.SalaryClassModel;
import kr.happyjob.study.employee.model.UserInfoModel;
import kr.happyjob.study.employee.model.VctnInfoModel;
import kr.happyjob.study.system.model.NoticeModel;

@Service
public class UserInfoServiceImpl implements UserInfoService{

	@Autowired
	UserInfoDao userInfoDao;
	
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.virtualRootPath}")
	private String virtualRootPath;
	
	@Value("${fileUpload.userPhotoPath}")
	private String userPhotoPath;
	
	@Override
	public List<UserInfoModel> empMgtList(Map<String, Object> paramMap) throws Exception {
		return userInfoDao.empMgtList(paramMap);
	}

	@Override
	public int empMgtListCnt(Map<String, Object> paramMap) throws Exception {
		return userInfoDao.empMgtListCnt(paramMap);
	}

	@Override
	public List<SalaryClassModel> empSalaryList() {
		return userInfoDao.empSalaryList();
	}

	@Override
	public int empSalaryListCnt() {
		return userInfoDao.empSalaryListCnt();
	}

	@Override
	public int empSave(Map<String, Object> paramMap, HttpServletRequest req) throws Exception{
		MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest)req;
		
		String itemFilePath = userPhotoPath + File.separator;
		FileUtilCho fileUpload = new FileUtilCho(mhsr, rootPath, virtualRootPath, itemFilePath);
		
		Map<String, Object> fileInfo = fileUpload.uploadFiles();
		
		if (fileInfo.get("file_nm") == null) {
			paramMap.put("fileYn", "N");
			paramMap.put("fileInfo", null);
		} else {
			paramMap.put("fileYn", "Y");
			paramMap.put("fileInfo", fileInfo);
		}
		return userInfoDao.empSave(paramMap);
	}

	@Override
	public int empRetire(Map<String, Object> paramMap) {
		return userInfoDao.empRetire(paramMap);
	}

	@Override
	public UserInfoModel empDetail(Map<String, Object> paramMap) {
		return userInfoDao.empDetail(paramMap);
	}

	@Override
	public int empSalarySave(Map<String, Object> paramMap) {
		return userInfoDao.empSalarySave(paramMap);
	}
	
	@Transactional
    public void saveEmployeeAndSalary(Map<String, Object> paramMap, HttpServletRequest req) throws Exception {
        // 직원 정보 저장
        empSave(paramMap, req);
        // 급여 정보 저장
        empSalarySave(paramMap);
		// 승진이력 생성
		promHistSave(paramMap);
    }

	@Override
	public int empUpdate(Map<String, Object> paramMap, HttpServletRequest req) throws Exception {
		UserInfoModel originFile = userInfoDao.empDetail(paramMap);
		
		if (originFile.getFileName() != null) {
			File oldFile = new File(originFile.getPhsycalPath());
			oldFile.delete();
		}
		
		MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest)req;
		
		String itemFilePath = userPhotoPath + File.separator;
		FileUtilCho fileUpload = new FileUtilCho(mhsr, rootPath, virtualRootPath, itemFilePath);
		
		Map<String, Object> fileInfo = fileUpload.uploadFiles();
		
		if (fileInfo.get("file_nm") == null) {
			paramMap.put("fileYn", "N");
			paramMap.put("fileInfo", null);
		} else {
			paramMap.put("fileYn", "Y");
			paramMap.put("fileInfo", fileInfo);
		}
		
		return userInfoDao.empUpdate(paramMap);
	}

	@Override
	public int empSalaryUpdate(Map<String, Object> paramMap) {
		return userInfoDao.empSalaryUpdate(paramMap);
	}

	
	@Transactional
	public void updateEmployeeAndSalary(Map<String, Object> paramMap, HttpServletRequest req){
		// 직원 정보 저장
		try {
			empUpdate(paramMap, req);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 급여 정보 저장
		empSalaryUpdate(paramMap);
	}

	@Override
	public UserInfoModel empUserIdChk(String loginId) {
		return userInfoDao.empUserIdChk(loginId);
	}

	// 승진이력 생성
	@Override
	public int promHistSave(Map<String, Object> paramMap) {
		return userInfoDao.promHistSave(paramMap);
	}

	@Override
	public List<PromHistModel> empGradeList(Map<String, Object> paramMap) {
		return userInfoDao.empGradeList(paramMap);
	}

	@Override
	public int empGradeListCnt() {
		return userInfoDao.empGradeListCnt();
	}

	@Override
	public List<PromHistModel> empGradeDetailList(Map<String, Object> paramMap) {
		return userInfoDao.empGradeDetailList(paramMap);
	}

	@Override
	public int empGradeDetailListCnt(Map<String, Object> paramMap) {
		return userInfoDao.empGradeDetailListCnt(paramMap);
	}

	@Override
	public void insertPromHist(Map<String, Object> paramMap) {
		// 기존 이력 최종여부 'n'으로 변경
		int result = updatePromHist(paramMap);
		if(result > 0){
			userInfoDao.insertPromHist(paramMap);
		}
	}
	
	public int updatePromHist(Map<String, Object> paramMap){
		return userInfoDao.updatePromHist(paramMap);
	}

}
