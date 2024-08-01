package kr.happyjob.study.accounting.model;

public class UnpaidDetailItemModel {
	
	private String itemName;
	private long provideValue;
	private long itemPrice;
	private long itemSurtax;
	private int qut;
	
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public long getProvideValue() {
		return provideValue;
	}
	public void setProvideValue(long provideValue) {
		this.provideValue = provideValue;
	}
	public long getItemPrice() {
		return itemPrice;
	}
	public void setItemPrice(long itemPrice) {
		this.itemPrice = itemPrice;
	}
	public long getItemSurtax() {
		return itemSurtax;
	}
	public void setItemSurtax(long itemSurtax) {
		this.itemSurtax = itemSurtax;
	}
	public int getQut() {
		return qut;
	}
	public void setQut(int qut) {
		this.qut = qut;
	}
}
