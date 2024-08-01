package kr.happyjob.study.accounting.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.accounting.model.AccSlipModel;

public interface AccSlipDao {
	
		public List<Map<String, Object>> accSlipList(Map<String, Object> paramMap);
		
		public int accSlipCnt(Map<String, Object> paramMap); 
	
		public List<Map<String, Object>> accSlipModal(Map<String, Object> paramMap);
		
		public void accSlipInsert(Map<String, Object> paramMap);
}