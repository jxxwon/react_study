package kr.happyjob.study.employee.model;

public class PromHistModel {
	
	private String loginId;
	private String deptCode;
	private String posCode;
	private String useYn;
	private String issuDate;
	
	/* 사원명 */
	private String name;
	/*부서명*/
	private String deptName;
	/*직급명*/
	private String posName;
	
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getPosCode() {
		return posCode;
	}
	public void setPosCode(String posCode) {
		this.posCode = posCode;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getIssuDate() {
		return issuDate;
	}
	public void setIssuDate(String issuDate) {
		this.issuDate = issuDate;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getPosName() {
		return posName;
	}
	public void setPosName(String posName) {
		this.posName = posName;
	}

}
