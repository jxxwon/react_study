package kr.happyjob.study.business.model;

public class SalesItemModel {
	
	private String manufac;			// 제조업체
	private String major_class;		// 대분류
	private String sub_class;		// 소분류
	private String item_name;		// 제품이름
	private String item_code;		// 제품 코드
	
	
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
	public String getItem_code() {
		return item_code;
	}
	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}
}
