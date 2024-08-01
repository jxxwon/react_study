package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.OeMngDao;
import kr.happyjob.study.business.model.OeMngModel;

@Service
public class OeMngServiceImp implements OeMngService{
	
	@Autowired
	OeMngDao oeMngDao;
	
	
	
	//리스트 목록 조회
	@Override
	public List<OeMngModel> oemList(Map<String, Object> paramMap) throws Exception {
		
		List<OeMngModel> listOem = oeMngDao.oemList(paramMap);
		
		System.out.println("==================");
		System.out.println("listOem "+  listOem);
		System.out.println("listOem.size() "+listOem.size());
		System.out.println("==================");
		
		return listOem;
	}
	

	//리스트 목록 카운트  => 매퍼의 리스트 관계 확인
	@Override
	public int oemCnt(Map<String, Object> paramMap) {
		
		int estCnt = oeMngDao.oemCnt(paramMap);
		
		return estCnt;
	}

	
	//단건조회
	@Override
	public OeMngModel selectOemList(Map<String, Object> paramMap) {
		
		OeMngModel oemManage = oeMngDao.selectOemList(paramMap);
		
		return oemManage;
	}

	
	//단건 신규등록
	@Override
	public int insertOemList(Map<String, Object> paramMap) {
		int beta = oeMngDao.insertOemList(paramMap);

		return beta;
	}

	//단건 업데이트
	@Override
	public int updateOemList(Map<String, Object> paramMap) {
		int beta = oeMngDao.updateOemList(paramMap);
		return beta;
	}

	// 단건 삭제 
	@Override
	public int deleteOemList(Map<String, Object> paramMap) {
		int beta =  oeMngDao.deleteOemList(paramMap);
		return beta;
	}

	
	
	// 모달 안 리스트 뿌리기
	@Override
	public List<OeMngModel> oemListDetail(Map<String, Object> paramMap) throws Exception {
		
		List<OeMngModel> DetailList = oeMngDao.oemListDetail(paramMap);

		return DetailList;
	}
	
	// 모달 안 리스트 뿌리기 카운트 
	@Override
	public int oemDetailCnt(Map<String, Object> paramMap) {
		int oemDetailCnt = oeMngDao.oemDetailCnt(paramMap);
		return oemDetailCnt;
	}

	// 계정금액 인서트 3번  
	@Override
	public int insertAccSlip1(Map<String, Object> paramMap) {
		int inseAcc1 = oeMngDao.insertAccSlip1(paramMap);
		return inseAcc1;
	}


	@Override
	public int insertAccSlip2(Map<String, Object> paramMap) {
		int inseAcc2 = oeMngDao.insertAccSlip2(paramMap);
		return inseAcc2;
	}


	@Override
	public int insertAccSlip3(Map<String, Object> paramMap) {
		int inseAcc3 = oeMngDao.insertAccSlip3(paramMap);
		return inseAcc3;
	}

	
	//수주서 인서트
	@Override
	public int updateInsertOemList(Map<String, Object> paramMap) throws Exception {
		int updateInOemList =  oeMngDao.updateInsertOemList(paramMap);
		return updateInOemList;
	}


	
	// order table에 인서트
	@Override
	public int insertOrderOemList(Map<String, Object> paramMap) {
		int insertOrderOemList = oeMngDao.insertOrderOemList(paramMap);
		return insertOrderOemList;
	}


}
