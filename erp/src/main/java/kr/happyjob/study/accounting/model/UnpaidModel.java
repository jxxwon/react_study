package kr.happyjob.study.accounting.model;

public class UnpaidModel {

	private String type;
	private int num;
	private String custName;
	private String userName;
	private String bookDate;
	private long amount;
	private String unpaidState;
	private String expireState;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getBookDate() {
		return bookDate;
	}
	public void setBookDate(String bookDate) {
		this.bookDate = bookDate;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public String getUnpaidState() {
		return unpaidState;
	}
	public void setUnpaidState(String unpaidState) {
		this.unpaidState = unpaidState;
	}
	public String getExpireState() {
		return expireState;
	}
	public void setExpireState(String expireState) {
		this.expireState = expireState;
	}
}
