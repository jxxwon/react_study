package kr.happyjob.study.accounting.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class DisbInfoModel {
	
	private int resoNum;		// 결의번호
	private String applyId;		// 신청자 아이디
	private String applyName;	// 신청자 이름
	private String applyDept;	// 신청자 부서
	private String custId;		// 거래처 아이디
	private String custName;	// 거래처명
	private String groupCode;	// 계정대분류코드
	private String grCodeNm;	// 계정대분류명
	private String acctCode;	// 계정과목코드
	private String acctCodeNm;	// 계정과목코드명
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date applyDate;		// 신청일	
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date useDate;		// 사용일
	private String disbContent;	// 내용
	private int amount;			// 결의금액
	private String apprYn;		// 승인여부
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date apprDate;		// 승인일
	private String eviMaterial;	// 증빙자료(첨부파일)
	private String phsycalPath;	// 물리경로
	private String logicalPath;	// 논리경로
	private int fileSize;		// 파일크기
	private String fileExt;		// 파일확장자
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
	public String getApplyName() {
		return applyName;
	}
	public void setApplyName(String applyName) {
		this.applyName = applyName;
	}
	public String getApplyDept() {
		return applyDept;
	}
	public void setApplyDept(String applyDept) {
		this.applyDept = applyDept;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getGroupCode() {
		return groupCode;
	}
	public void setGroupCode(String groupCode) {
		this.groupCode = groupCode;
	}
	public String getGrCodeNm() {
		return grCodeNm;
	}
	public void setGrCodeNm(String grCodeNm) {
		this.grCodeNm = grCodeNm;
	}
	public String getAcctCode() {
		return acctCode;
	}
	public void setAcctCode(String acctCode) {
		this.acctCode = acctCode;
	}
	public String getAcctCodeNm() {
		return acctCodeNm;
	}
	public void setAcctCodeNm(String acctCodeNm) {
		this.acctCodeNm = acctCodeNm;
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
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	
}
