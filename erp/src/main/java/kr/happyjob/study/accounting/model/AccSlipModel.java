package kr.happyjob.study.accounting.model;
import java.util.Date;

public class AccSlipModel {

	
	// 회계 전표 정보 테이블
	// 결의번호
	private int reso_num;
	// 사번
	private String loginID;
	/* 계정대분류코드 */
	private String acct_code;
	/* 전표번호 */
	private String acct_num;
	// 현장 원가
	private int onsite_cost;
	
	
	
	// 지출결의서 정보 테이블
	/* 승인여부 */
	private String appr_yn;
	/* 승인일자 */
	private String apply_date;
	// 승인자
	private String applyer;
	/* 수주일자 */
	private Date book_date;
	// 결의 금액
	private int amount;
	
	
	// 거래처 정보테이블
	/* 거래처명 */
	private String cust_name;
	/* 메모 */
	private String cust_memo;
	/* 거래처 코드 */
	private String cust_id;
	/* 담당자 */
	private String cust_person;
	
	
	

	public int getReso_num() {
		return reso_num;
	}

	public void setReso_num(int reso_num) {
		this.reso_num = reso_num;
	}

	public int getOnsite_cost() {
		return onsite_cost;
	}

	public void setOnsite_cost(int onsite_cost) {
		this.onsite_cost = onsite_cost;
	}

	public String getLoginID() {
		return loginID;
	}

	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}

	public String getAcct_code() {
		return acct_code;
	}

	public void setAcct_code(String acct_code) {
		this.acct_code = acct_code;
	}

	public String getAcct_num() {
		return acct_num;
	}

	public void setAcct_num(String acct_num) {
		this.acct_num = acct_num;
	}

	public String getAppr_yn() {
		return appr_yn;
	}

	public void setAppr_yn(String appr_yn) {
		this.appr_yn = appr_yn;
	}

	public String getApply_date() {
		return apply_date;
	}

	public void setApply_date(String apply_date) {
		this.apply_date = apply_date;
	}

	public String getApplyer() {
		return applyer;
	}

	public void setApplyer(String applyer) {
		this.applyer = applyer;
	}

	public Date getBook_date() {
		return book_date;
	}

	public void setBook_date(Date book_date) {
		this.book_date = book_date;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public String getCust_name() {
		return cust_name;
	}

	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}

	public String getCust_memo() {
		return cust_memo;
	}

	public void setCust_memo(String cust_memo) {
		this.cust_memo = cust_memo;
	}

	public String getCust_id() {
		return cust_id;
	}

	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}

	public String getCust_person() {
		return cust_person;
	}

	public void setCust_person(String cust_person) {
		this.cust_person = cust_person;
	}
	
	
	
	
	

}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	





