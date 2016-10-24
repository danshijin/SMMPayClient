package com.eliteams.pay.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.eliteams.pay.web.tools.ResultMessage;
import com.eliteams.pay.web.tools.mail.UtilMail;

/**
 * 公共视图控制器
 * 
 * @since 2014年4月15日 下午4:16:34
 **/
@Controller
@RequestMapping("/common")
public class CommonController {
    /**
     * 首页
     * 
     * @param request
     * @return
     */
    @RequestMapping("index")
    public String index(HttpServletRequest request) {
        return "index";
    }

    @RequestMapping("agreement")
    public String agreement(HttpServletRequest request) {
        request.setAttribute("type", "a");
        return "agreement";
    }

    @RequestMapping("introduce")
    public String introduce(HttpServletRequest request) {
        request.setAttribute("type", "a");
        return "introduce";
    }

    /**
     * 发送邮件
     */
    @RequestMapping("tomail")
    @ResponseBody
    public ResultMessage toMail(HttpServletRequest req) {
        UtilMail se = new UtilMail(false);
        se.doSendHtmlEmail(req.getParameter("mailTitle"), req.getParameter("mailContent"), "dq19900926@163.com");
        return new ResultMessage("success", "发送邮件成功！");
    }
    
    @RequestMapping("/howtoSing")
    public String howtoSing(HttpServletRequest request) {
        return "howtoSing";
    }
}
