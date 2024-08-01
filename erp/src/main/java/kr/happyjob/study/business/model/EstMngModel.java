package kr.happyjob.study.business.model;

import java.util.Date;

public class EstMngModel {
	
	private int estm_num; // 일련번호
	private String estm_date; // 일자
	private Date expire_date; // 유효기간
	private Date book_date; // 수주일자
	
	// 거래처 테이블
	private String cust_id; // 거래처ID
	private String cust_name; // 거래처 이름
	private String cust_person; // 담당자
	private String cust_person_ph; // 담당자 번호
	private String cust_addr; // 주소
	private String cust_detail_addr; // 상세 주소
	private String biz_num; // 사업자번호
	
	
	// 제품정보테이블
	private String item_code; // 품목코드
	private String item_name; // 품목명
	private int item_price; // 단가
	private int item_surtax; // 부가세
	private int provide_value; // 공급가액
	private Date apply_date; // 승인일자
	private String apply_yn; // 승인여부
	
	// 견적상세테이블
	private int qut; // 수량 
	
	
	public int getEstm_num() {
		return estm_num;
	}
	public void setEstm_num(int estm_num) {
		this.estm_num = estm_num;
	}
	public String getEstm_date() {
		return estm_date;
	}
	public void setEstm_date(String estm_date) {
		this.estm_date = estm_date;
	}
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public String getCust_name() {
		return cust_name;
	}
	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}
	public String getCust_person() {
		return cust_person;
	}
	public void setCust_person(String cust_person) {
		this.cust_person = cust_person;
	}
	public String getCust_addr() {
		return cust_addr;
	}
	public void setCust_addr(String cust_addr) {
		this.cust_addr = cust_addr;
	}
	public String getCust_detail_addr() {
		return cust_detail_addr;
	}
	public void setCust_detail_addr(String cust_detail_addr) {
		this.cust_detail_addr = cust_detail_addr;
	}
	public String getItem_code() {
		return item_code;
	}
	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public int getItem_price() {
		return item_price;
	}
	public void setItem_price(int item_price) {
		this.item_price = item_price;
	}
	public int getItem_surtax() {
		return item_surtax;
	}
	public void setItem_surtax(int item_surtax) {
		this.item_surtax = item_surtax;
	}
	public int getProvide_value() {
		return provide_value;
	}
	public void setProvide_value(int provide_value) {
		this.provide_value = provide_value;
	}
	
	
	public int getQut() {
		return qut;
	}
	public void setQut(int qut) {
		this.qut = qut;
	}
	public String getBiz_num() {
		return biz_num;
	}
	public void setBiz_num(String biz_num) {
		this.biz_num = biz_num;
	}
	
	public String getCust_person_ph() {
		return cust_person_ph;
	}
	public void setCust_person_ph(String cust_person_ph) {
		this.cust_person_ph = cust_person_ph;
	}
	public Date getBook_date() {
		return book_date;
	}
	public void setBook_date(Date book_date) {
		this.book_date = book_date;
	}
	public Date getApply_date() {
		return apply_date;
	}
	public void setApply_date(Date apply_date) {
		this.apply_date = apply_date;
	}
	public Date getExpire_date() {
		return expire_date;
	}
	public void setExpire_date(Date expire_date) {
		this.expire_date = expire_date;
	}
	public String getApply_yn() {
		return apply_yn;
	}
	public void setApply_yn(String apply_yn) {
		this.apply_yn = apply_yn;
	}
	
	
	

}
