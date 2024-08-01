package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.SalesFindNameModel;
import kr.happyjob.study.business.model.SalesItemModel;
import kr.happyjob.study.business.model.SalesModel;

public interface SalesDao {
	
	// 영업계획 전체 리스트
	List<SalesModel> salePlanList(Map<String, Object> paramMap) throws Exception;
	
	// 영업계획 전체 리스트 개수
	int salePlanListCnt(Map<String, Object> paramMap) throws Exception;
	
	// 검색 리스트  제조업체
	List<SalesItemModel> searchList(Map<String, Object> paramMap) throws Exception;
	
	// 검색 리스트 대분류
	List<SalesItemModel> getMajorClasses(Map<String, Object> paramMap) throws Exception;
	
	// 검색 리스트 소분류
	List<SalesItemModel> getSubClasses(Map<String, Object> paramMap) throws Exception;
	
	// 검색 리스트 제품이름
	List<SalesItemModel> getItemNameClasses(Map<String, Object> paramMap) throws Exception;
	
	// 모달창 거래처이름
	List<SalesModel> custNameList(Map<String, Object> paramMap) throws Exception;
	
	// 영업계획서 상세 조회
	SalesModel salePlanDetail(Map<String, Object> paramMap) throws Exception;
	
	// 영업계획서 저장
	int salePlanSave(Map<String, Object> paramMap) throws Exception;
	
	// 영업계획서 수정
	int updateSalePlan(Map<String, Object> paramMap) throws Exception;

	// 영업계획서 삭제
	int deleteSalePlan(Map<String, Object> paramMap) throws Exception;
	
	// 유저이름
	SalesFindNameModel searchName(Map<String, Object> paramMap) throws Exception;
	
	
	// 영업실적조회 전체 리스트
	List<SalesModel> saleInfoList(Map<String, Object> paramMap) throws Exception;
	
	// 영업실적조회 전체 리스트 개수
	int saleInfoListCnt(Map<String, Object> paramMap) throws Exception;
		
}
