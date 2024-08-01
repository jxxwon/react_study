package kr.happyjob.study.business.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.business.dao.BizPartnerDao;
import kr.happyjob.study.business.model.BizPartnerModel;

@Service
public class BizPartnerServiceImpl implements BizPartnerService {
	
	@Autowired
	private BizPartnerDao bizPartnerDao;

	@Override
	public List<BizPartnerModel> bizPartnerList(Map<String, Object> paramMap) {
		return bizPartnerDao.bizPartnerList(paramMap);
	}

	@Override
	public int bizPartnerListCnt(Map<String, Object> paramMap) {
		return bizPartnerDao.bizPartnerListCnt(paramMap);
	}

	@Override
	public int saveBizPartner(Map<String, Object> paramMap) {
		
		// 1. 회사전화
		StringBuilder custPhBuilder = new StringBuilder();
		custPhBuilder.append((String) paramMap.get("custPhPre"))
					 .append("-")
					 .append((String) paramMap.get("custPhMid"))
					 .append("-")
					 .append((String) paramMap.get("custPhSuf"));
		paramMap.put("custPh", custPhBuilder.toString());
		
		// 2. 휴대전화
		String custPersonPh1 = (String) paramMap.get("custPersonPhPre");
		String custPersonPh2 = (String) paramMap.get("custPersonPhMid");
		String custPersonPh3 = (String) paramMap.get("custPersonPhSuf");
		System.out.println(custPersonPh2);
		if (!custPersonPh1.isEmpty() && !custPersonPh2.isEmpty() && !custPersonPh3.isEmpty()) {
			StringBuilder custPersonPhBuilder = new StringBuilder();
			custPersonPhBuilder.append(custPersonPh1)
						 	   .append("-")
						 	   .append(custPersonPh2)
						 	   .append("-")
						 	   .append(custPersonPh3);		
			paramMap.put("custPersonPh", custPersonPhBuilder.toString());
		};
		
		return bizPartnerDao.saveBizPartner(paramMap);
	}

	@Override
	public BizPartnerModel bizPartnerDetail(Map<String, Object> paramMap) {
		return bizPartnerDao.bizPartnerDetail(paramMap);
	}

	@Override
	public int updateBizPartner(Map<String, Object> paramMap) {

		// 1. 회사전화
		StringBuilder custPhBuilder = new StringBuilder();
		custPhBuilder.append((String) paramMap.get("custPhPre"))
					 .append("-")
					 .append((String) paramMap.get("custPhMid"))
					 .append("-")
					 .append((String) paramMap.get("custPhSuf"));
		paramMap.put("custPh", custPhBuilder.toString());
		
		// 2. 휴대전화
		String custPersonPh1 = (String) paramMap.get("custPersonPhPre");
		String custPersonPh2 = (String) paramMap.get("custPersonPhMid");
		String custPersonPh3 = (String) paramMap.get("custPersonPhSuf");
		
		if (!custPersonPh1.isEmpty() && !custPersonPh2.isEmpty() && !custPersonPh3.isEmpty()) {
			StringBuilder custPersonPhBuilder = new StringBuilder();
			custPersonPhBuilder.append(custPersonPh1)
						 	   .append("-")
						 	   .append(custPersonPh2)
						 	   .append("-")
						 	   .append(custPersonPh3);		
			paramMap.put("custPersonPh", custPersonPhBuilder.toString());
		};

		return bizPartnerDao.updateBizPartner(paramMap);
	}

	@Override
	public int deleteBizPartner(Map<String, Object> paramMap) {
		return bizPartnerDao.deleteBizPartner(paramMap);
	}

}
