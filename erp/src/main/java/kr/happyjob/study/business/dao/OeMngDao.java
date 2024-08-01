package kr.happyjob.study.business.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.business.model.OeMngModel;

public interface OeMngDao {

	
		//견적서 전체조회
		public List<OeMngModel> oemList(Map<String, Object> paramMap) throws Exception;
		
		//견적서 전체 조회 카운트
		public int oemCnt(Map<String, Object> paramMap);

		
		/** 리스트 목록 단건 조회 => 견적서 상세조회 */
		public OeMngModel selectOemList(Map<String, Object> paramMap);

		
		//모달 안 리스트 조회
		public List<OeMngModel> oemListDetail (Map<String, Object> paramMap) throws Exception;
		
		//모달 안 리스트 조회 카운트
		public int oemDetailCnt(Map<String, Object> paramMap);
		
		
		// 계정금액 인서트 세번
		public int  insertAccSlip1(Map<String, Object> paramMap); // 단가
		public int  insertAccSlip2(Map<String, Object> paramMap); // 세금
		public int  insertAccSlip3(Map<String, Object> paramMap); // 공급가액
		
		/** 수주  안서트 */
		public int  insertOemList(Map<String, Object> paramMap);
		// 수주 제품 인서트 
		public int updateInsertOemList(Map<String, Object> paramMap);
		// scm order table 인서트  
		public int insertOrderOemList(Map<String, Object> paramMap);
		
		
		
		/** 단건수정 */
		public int updateOemList(Map<String, Object> paramMap);

		/** 단건 삭제 */
		public int deleteOemList(Map<String, Object> paramMap);
		
}
