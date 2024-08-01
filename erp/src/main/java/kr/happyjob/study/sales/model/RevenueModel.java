package kr.happyjob.study.sales.model;

public class RevenueModel {

	private String bookDate;
	private long amount;
    private long payAmount;
	private long unpaidAmount;
	
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
	public long getPayAmount() {
		return payAmount;
	}
	public void setPayAmount(long payAmount) {
		this.payAmount = payAmount;
	}
	public long getUnpaidAmount() {
		return unpaidAmount;
	}
	public void setUnpaidAmount(long unpaidAmount) {
		this.unpaidAmount = unpaidAmount;
	}
}
