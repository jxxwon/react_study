package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.EstMngDao;
import kr.happyjob.study.business.model.EstMngModel;

@Service
public class EstMngServiceImp implements EstMngService{
	
	@Autowired
	EstMngDao estMngDao;
	
	
	//리스트 목록 조회
	@Override
	public List<EstMngModel> estList(Map<String, Object> paramMap) throws Exception {
		
		List<EstMngModel> listEst = estMngDao.estList(paramMap);
		
		System.out.println("==================");
		System.out.println("listEst "+  listEst);
		System.out.println("listEst.size() "+listEst.size());
		System.out.println("==================");
		return listEst;
	}
	

	//리스트 목록 카운트  => 매퍼의 리스트 관계 확인
	@Override
	public int estCnt(Map<String, Object> paramMap) {
		
		int estCnt = estMngDao.estCnt(paramMap);
		
		return estCnt;
	}

	
	//단건조회
	@Override
	public List<EstMngModel> selectEstList(Map<String, Object> paramMap) {
		
		List<EstMngModel> estManage = estMngDao.selectEstList(paramMap);
		
		return estManage;
	}

	
	//단건 신규등록
	@Override
	public int insertEstList(Map<String, Object> paramMap) {
		int beta = estMngDao.insertEstList(paramMap);

		return beta;
	}

	//단건 업데이트
	@Override
	public int updateEstList(Map<String, Object> paramMap) {
		int beta = estMngDao.updateEstList(paramMap);
		return beta;
	}

	// 단건 삭제 
	@Override
	public int deleteEstList(Map<String, Object> paramMap) {
		int beta =  estMngDao.deleteEstList(paramMap);
		return beta;
	}

	
	
	// 모달 안 리스트 뿌리기
	@Override
	public List<EstMngModel> estListDetail(Map<String, Object> paramMap) throws Exception {
		List<EstMngModel> DetailList = estMngDao.estListDetail(paramMap);
		
		return DetailList;
	}
	
	// 모달 안 리스트 뿌리기 카운트 
	@Override
	public int estDetailCnt(Map<String, Object> paramMap) {
		int estDetailCnt = estMngDao.estDetailCnt(paramMap);
		return estDetailCnt;
	}


	
	// 견적서,견적 제품에  넘버 넣고 -> 이후 견적제품에 업데이트  
	@Override
	public int updateInsertEstList(Map<String, Object> paramMap) throws Exception {
		int updateInEstList =  estMngDao.updateInsertEstList(paramMap);
		return updateInEstList;
	}


	@Override
	public int insertApplyYn(Map<String, Object> paramMap) {
		int beta = estMngDao.insertApplyYn(paramMap);
		return beta;
	}


	
	
	

	
	
}
