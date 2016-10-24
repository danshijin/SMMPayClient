package com.eliteams.pay.web.model;

import java.util.Date;

/**
 * 类Message.java的实现描述：TODO 类实现描述
 * 
 * @author duqiang 2015年11月13日 上午11:04:29
 */
public class Message {
    private String message;

    private Date   messageTime;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getMessageTime() {
        return messageTime;
    }

    public void setMessageTime(Date messageTime) {
        this.messageTime = messageTime;
    }

}
