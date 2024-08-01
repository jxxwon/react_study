package kr.happyjob.study.accounting.model;

public class UnpaidDetailModel {
	private int num;
	private String bookDate;
	private String unpaidState;
	private long amount;
	private String custName;
	private String custPerson;
	private String custPersonPh;
	private String bankName;
	private String custAccount;
	private String userName;
	private String expireState;
	private String expireDate;
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getBookDate() {
		return bookDate;
	}
	public void setBookDate(String bookDate) {
		this.bookDate = bookDate;
	}
	public String getUnpaidState() {
		return unpaidState;
	}
	public void setUnpaidState(String unpaidState) {
		this.unpaidState = unpaidState;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getCustPerson() {
		return custPerson;
	}
	public void setCustPerson(String custPerson) {
		this.custPerson = custPerson;
	}
	public String getCustPersonPh() {
		return custPersonPh;
	}
	public void setCustPersonPh(String custPersonPh) {
		this.custPersonPh = custPersonPh;
	}
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getCustAccount() {
		return custAccount;
	}
	public void setCustAccount(String custAccount) {
		this.custAccount = custAccount;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getExpireState() {
		return expireState;
	}
	public void setExpireState(String expireState) {
		this.expireState = expireState;
	}
	public String getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(String expireDate) {
		this.expireDate = expireDate;
	}
}
