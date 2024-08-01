package kr.happyjob.study.employee.model;

public class SalaryClassModel {
	private String posCode;
	private int year1;
	private int year2;
	private int year3;
	private int year4;
	private int year5;
	private int annualSalary;
	
	/* 직급 이름 */
	private String posName;
	
	public String getPosCode() {
		return posCode;
	}
	public void setPosCode(String posCode) {
		this.posCode = posCode;
	}
	public int getYear1() {
		return year1;
	}
	public void setYear1(int year1) {
		this.year1 = year1;
	}
	public int getYear2() {
		return year2;
	}
	public void setYear2(int year2) {
		this.year2 = year2;
	}
	public int getYear3() {
		return year3;
	}
	public void setYear3(int year3) {
		this.year3 = year3;
	}
	public int getYear4() {
		return year4;
	}
	public void setYear4(int year4) {
		this.year4 = year4;
	}
	public int getYear5() {
		return year5;
	}
	public void setYear5(int year5) {
		this.year5 = year5;
	}
	public int getAnnualSalary() {
		return annualSalary;
	}
	public void setAnnualSalary(int annualSalary) {
		this.annualSalary = annualSalary;
	}
	public String getPosName() {
		return posName;
	}
	public void setPosName(String posName) {
		this.posName = posName;
	}

}
