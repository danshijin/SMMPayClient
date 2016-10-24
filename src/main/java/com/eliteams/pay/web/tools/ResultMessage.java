package com.eliteams.pay.web.tools;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * 提示信息
 * 
 * @author zhangnan
 */
public class ResultMessage implements Serializable {

    /**
	 * 
	 */
    private static final long   serialVersionUID = -7339461273795844294L;

    public static final String  SUCCESS          = "success";

    public static final String  ERROR            = "error";

    private String              code;

    private String              message;

    private Map<String, Object> attributes;

    public ResultMessage(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public ResultMessage(Map<String, Object> attributes, String code, String message) {
        this.code = code;
        this.message = message;
        this.attributes = attributes;
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

    public boolean isSuccess() {
        return SUCCESS.equalsIgnoreCase(code);
    }

    @Override
    public String toString() {
        return "ResultMessage [code=" + code + ", message=" + message + "]";
    }

    public Map<String, Object> getAttributes() {
        return attributes;
    }

    public void setAttributes(Map<String, Object> attributes) {
        this.attributes = attributes;
    }

    public void addObject(String key, Object value) {
        if (attributes == null) {
            attributes = new HashMap<String, Object>();
        }
        attributes.put(key, value);
    }

    /**
     * 调用当前方法把状态改为异常
     * 
     * @param msg
     */
    public void raise(String msg) {
        code = ERROR;
        message = msg;
    }

    public void raise(ResultHandle handle) {
        if (handle.isFail()) {
            raise(handle.getMsg());
        }
    }

    public static ResultMessage createResultMessage() {
        ResultMessage msg = new ResultMessage(SUCCESS, "操作成功");
        return msg;
    }
}
