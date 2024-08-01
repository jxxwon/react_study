package kr.happyjob.study.accounting.model;

import java.util.Date;

public class DisbModel {
	
	private int resoNum;			// 결의번호
	private String applyId;			// 신청자 아이디
	private String custId;			// 거래처 아이디
	private String acctCode;		// 계정과목코드
	private Date applyDate;			// 신청일
	private Date useDate;			// 사용일
	private String disbContent;		// 내용
	private int amount;				// 결의금액
	private String apprYn;			// 승인여부
	private Date apprDate;			// 승인일
	private String eviMaterial;		// 증빙자료(첨부파일)
	private String phsycalPath;		// 물리경로
	private String logicalPath;		// 논리경로
	private int fileSize;			// 파일크기
	private String fileExt;			// 파일확장자
	
	public int getResoNum() {
		return resoNum;
	}
	public void setResoNum(int resoNum) {
		this.resoNum = resoNum;
	}
	public String getApplyId() {
		return applyId;
	}
	public void setApplyId(String applyId) {
		this.applyId = applyId;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getAcctCode() {
		return acctCode;
	}
	public void setAcctCode(String acctCode) {
		this.acctCode = acctCode;
	}
	public Date getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}
	public Date getUseDate() {
		return useDate;
	}
	public void setUseDate(Date useDate) {
		this.useDate = useDate;
	}
	public String getDisbContent() {
		return disbContent;
	}
	public void setDisbContent(String disbContent) {
		this.disbContent = disbContent;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getApprYn() {
		return apprYn;
	}
	public void setApprYn(String apprYn) {
		this.apprYn = apprYn;
	}
	public Date getApprDate() {
		return apprDate;
	}
	public void setApprDate(Date apprDate) {
		this.apprDate = apprDate;
	}
	public String getEviMaterial() {
		return eviMaterial;
	}
	public void setEviMaterial(String eviMaterial) {
		this.eviMaterial = eviMaterial;
	}
	public String getPhsycalPath() {
		return phsycalPath;
	}
	public void setPhsycalPath(String phsycalPath) {
		this.phsycalPath = phsycalPath;
	}
	public String getLogicalPath() {
		return logicalPath;
	}
	public void setLogicalPath(String logicalPath) {
		this.logicalPath = logicalPath;
	}
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileExt() {
		return fileExt;
	}
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
}
