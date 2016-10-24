package com.eliteams.pay.web.enumDef;

public enum LoginResult {
	
	//全局状态码
	RETURN_SUCCESS_CODE("RETURN_SUCCESS_CODE", "处理成功"),
	DECRYPTPARAM_ERROR_CODE("DECRYPTPARAM_ERROR_CODE","解密失败"),
	UNKNOWERROR("UNKNOWERROR", "未知错误"),
	EXE("EXE", "程序应用错误"),
	
	//登录状态码
	NOT_APPROVED("NOT_APPROVED","用户未通过审核"),
	LOGIN_ERROR_GET_CODE("LOGIN_ERROR_GET_CODE","获取用户失败"),
	LOGIN_ERROR_CODE("LOGIN_ERROR_CODE", "用户名或密码错误"),
	LOGIN_ERROR_PAYCHANNEL_CODE("LOGIN_ERROR_PAYCHANNEL_CODE","用户关联账户未生成"),
	VCODE_DIFFERENTIP("VCODE_DIFFERENTIP","与上次登录IP不同"),
	VCODE_ERROR("VCODE_ERROR","验证码错误"),
	VCODE_NULL("VCODE_NULL", "验证不能为空"),
	
	//修改密码状态码
	CHANGE_PASSWORD_ERROR("CHANGE_PASSWORD_ERROR","修改密码错误"),
	
	//对账状态码
	GETTRADINGRECORD_ERROR_CODE("GETTRADINGRECORD_ERROR_CODE","获取通道账户信息失败");
	
	private String code;
	private String message;

	private LoginResult(String code, String message) {
		this.code = code;
		this.message = message;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
