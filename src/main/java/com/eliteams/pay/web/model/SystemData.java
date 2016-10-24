package com.eliteams.pay.web.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 系统数据查询
 * 
 * @author hanfeihu
 */
public class SystemData implements Serializable {

	private static final long serialVersionUID = 7238103894030507046L;

	private String trDate; // 日期
	private String note; // 交易备注
	private String companyName; // 企业名称
	private String oppositCompanyName; // 对方企业名称
	private BigDecimal borrow; // 借
	private BigDecimal loan; // 贷
	private BigDecimal freezeMoney; // 交易后余额
	private BigDecimal userMoney; // 交易后余额
	private BigDecimal totalMoney; // 总余额
	private String trType; // 类型
	private String companyMail; // 企业邮箱
	private String oppositBankName; //对方银行账户名
	private String oppositBankAccount; //对方银行账户号
	private Integer oppositUserPayChannelId; //对方支付渠道id
	private BigDecimal trCharge;  //手续费
	public String getTrDate() {
		return trDate;
	}
	public void setTrDate(String trDate) {
		this.trDate = trDate;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getOppositCompanyName() {
		return oppositCompanyName;
	}
	public void setOppositCompanyName(String oppositCompanyName) {
		this.oppositCompanyName = oppositCompanyName;
	}
	public BigDecimal getBorrow() {
		return borrow;
	}
	public void setBorrow(BigDecimal borrow) {
		this.borrow = borrow;
	}
	public BigDecimal getLoan() {
		return loan;
	}
	public void setLoan(BigDecimal loan) {
		this.loan = loan;
	}
	public BigDecimal getFreezeMoney() {
		return freezeMoney;
	}
	public void setFreezeMoney(BigDecimal freezeMoney) {
		this.freezeMoney = freezeMoney;
	}
	public BigDecimal getUserMoney() {
		return userMoney;
	}
	public void setUserMoney(BigDecimal userMoney) {
		this.userMoney = userMoney;
	}
	public BigDecimal getTotalMoney() {
		return totalMoney;
	}
	public void setTotalMoney(BigDecimal totalMoney) {
		this.totalMoney = totalMoney;
	}
	public String getTrType() {
		return trType;
	}
	public void setTrType(String trType) {
		this.trType = trType;
	}
	public String getCompanyMail() {
		return companyMail;
	}
	public void setCompanyMail(String companyMail) {
		this.companyMail = companyMail;
	}
	public String getOppositBankName() {
		return oppositBankName;
	}
	public void setOppositBankName(String oppositBankName) {
		this.oppositBankName = oppositBankName;
	}
	public String getOppositBankAccount() {
		return oppositBankAccount;
	}
	public void setOppositBankAccount(String oppositBankAccount) {
		this.oppositBankAccount = oppositBankAccount;
	}
	public Integer getOppositUserPayChannelId() {
		return oppositUserPayChannelId;
	}
	public void setOppositUserPayChannelId(Integer oppositUserPayChannelId) {
		this.oppositUserPayChannelId = oppositUserPayChannelId;
	}
	public BigDecimal getTrCharge() {
		return trCharge;
	}
	public void setTrCharge(BigDecimal trCharge) {
		this.trCharge = trCharge;
	}

}
