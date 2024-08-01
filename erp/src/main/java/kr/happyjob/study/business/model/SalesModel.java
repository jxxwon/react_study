package kr.happyjob.study.business.model;

import java.util.Date;

public class SalesModel {
	
	private int plan_num;		// 계획번호 (PK)
	private String loginID;		// 사번
	private String cust_id;		// 거래처ID
	private String item_code;	// 품목코드
	private Date target_date;	// 목표날짜
	private int goal_qut;		// 목표수량
	private int perform_qut;	// 실적수량
	private String plan_note;	// 비고
	
	private String cust_name;	// 거래처이름
	private String manufac;		// 제조업체
	private String major_class; // 대분류
	private String sub_class;	// 소분류
	private String item_name;	// 품목명
	private String name;		// 사원명
	
	
	public int getPlan_num() {
		return plan_num;
	}
	public void setPlan_num(int plan_num) {
		this.plan_num = plan_num;
	}
	public String getLoginID() {
		return loginID;
	}
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public String getItem_code() {
		return item_code;
	}
	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}
	public Date getTarget_date() {
		return target_date;
	}
	public void setTarget_date(Date target_date) {
		this.target_date = target_date;
	}
	public int getGoal_qut() {
		return goal_qut;
	}
	public void setGoal_qut(int goal_qut) {
		this.goal_qut = goal_qut;
	}
	public int getPerform_qut() {
		return perform_qut;
	}
	public void setPerform_qut(int perform_qut) {
		this.perform_qut = perform_qut;
	}
	public String getPlan_note() {
		return plan_note;
	}
	public void setPlan_note(String plan_note) {
		this.plan_note = plan_note;
	}
	public String getCust_name() {
		return cust_name;
	}
	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}
	public String getManufac() {
		return manufac;
	}
	public void setManufac(String manufac) {
		this.manufac = manufac;
	}
	public String getMajor_class() {
		return major_class;
	}
	public void setMajor_class(String major_class) {
		this.major_class = major_class;
	}
	public String getSub_class() {
		return sub_class;
	}
	public void setSub_class(String sub_class) {
		this.sub_class = sub_class;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

}
