package kr.happyjob.study.sales.model;

public class RevenueDailyModel {
	private String bookDate;
	private String custId;
	private String custName;
	private long amount;
	private long payAmount;
	private String unpaidState;
	
	public String getBookDate() {
		return bookDate;
	}
	public void setBookDate(String bookDate) {
		this.bookDate = bookDate;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public long getPayAmount() {
		return payAmount;
	}
	public void setPayAmount(long payAmount) {
		this.payAmount = payAmount;
	}
	public String getUnpaidState() {
		return unpaidState;
	}
	public void setUnpaidState(String unpaidState) {
		this.unpaidState = unpaidState;
	}
}
