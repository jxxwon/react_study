package kr.happyjob.study.employee.model;

public class VctnInfoModel {
	
	private int seq;
	private String loginId;
	private String vctnCode;
	private int useDate;
	private int remainDay;
	private String vctnReason;
	private String vctnStrDate;
	private String vctnEndDate;
	private String emgContact;
	private String applyer;
	private String applyYn;
	private String applyDate;
	private String rejectNote;
	private String regDate;
	
	/*사용 가능 일수*/
	private int availDay;
	/*근무부서*/
	private String deptCode;
	/*부서명*/
	private String deptName;
	/*성명*/
	private String name;
	/*연차종류명*/
	private String vctnName;
	
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getVctnCode() {
		return vctnCode;
	}
	public void setVctnCode(String vctnCode) {
		this.vctnCode = vctnCode;
	}
	public int getUseDate() {
		return useDate;
	}
	public void setUseDate(int useDate) {
		this.useDate = useDate;
	}
	public int getRemainDay() {
		return remainDay;
	}
	public void setRemainDay(int remainDay) {
		this.remainDay = remainDay;
	}
	public String getVctnReason() {
		return vctnReason;
	}
	public void setVctnReason(String vctnReason) {
		this.vctnReason = vctnReason;
	}
	public String getVctnStrDate() {
		return vctnStrDate;
	}
	public void setVctnStrDate(String vctnStrDate) {
		this.vctnStrDate = vctnStrDate;
	}
	public String getVctnEndDate() {
		return vctnEndDate;
	}
	public void setVctnEndDate(String vctnEndDate) {
		this.vctnEndDate = vctnEndDate;
	}
	public String getEmgContact() {
		return emgContact;
	}
	public void setEmgContact(String emgContact) {
		this.emgContact = emgContact;
	}
	public String getApplyer() {
		return applyer;
	}
	public void setApplyer(String applyer) {
		this.applyer = applyer;
	}
	public String getApplyYn() {
		return applyYn;
	}
	public void setApplyYn(String applyYn) {
		this.applyYn = applyYn;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getRejectNote() {
		return rejectNote;
	}
	public void setRejectNote(String rejectNote) {
		this.rejectNote = rejectNote;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public int getAvailDay() {
		return availDay;
	}
	public void setAvailDay(int availDay) {
		this.availDay = availDay;
	}
	
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getVctnName() {
		return vctnName;
	}
	public void setVctnName(String vctnName) {
		this.vctnName = vctnName;
	}
	

}
