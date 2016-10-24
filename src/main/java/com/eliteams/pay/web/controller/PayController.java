package com.eliteams.pay.web.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.eliteams.pay.web.model.User;
import com.eliteams.pay.web.util.JSONUtil;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.ResUserAccountDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.BankService;
import com.smmpay.inter.smmpay.UserAccountService;

import net.sf.json.JSONObject;

/**
 * @author xumengxi
 */
@Controller
@RequestMapping("/pay")
public class PayController {
    private Logger             logger = Logger.getLogger(PayController.class);

    @Resource
    private AuthorService      authorService;
    @Resource
    private UserAccountService userAccountService;
    @Resource
    private BankService        bankService;
    Date                       date   = new Date();

    @Value("#{ch['adminMail']}")
    private String             adminMail;

    @Value("#{ch['host']}")
    private String             ipHost;

    @Resource
    private JavaMailSender     mailSender;

    /**
     * 提现页面
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/paypage")
    public ModelAndView validateAccount(HttpServletRequest request, Model mode) {
        ModelAndView mav = new ModelAndView();

        if (Authory.token == null)
            RequestDataProxy.getAccessToken(authorService);

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            mav.setViewName("login");
            return mav;
        }
        //获取用户账户余额，总金额
        String s1 = "{\"data\":[{\"userId\":\"" + user.getId() + "\",\"userName\":\"" + user.getUsername()
                + "\",\"date\":\"" + date.getTime() + "\"}]}";
        String s2 = user.getId() + user.getUsername() + date.getTime();
        Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);
        ReturnDTO dto = userAccountService.getUserAccount(map);

        if (dto.getStatus().equals("000000")) {

            request.setAttribute("totalMoney", JSONObject.fromObject(dto.getData()).get("totalMoney"));
            request.setAttribute("userMoney", JSONObject.fromObject(dto.getData()).get("userMoney"));
        }

        request.setAttribute("moneyStatus", dto.getStatus());//成功还是失败状态

        /**
         * 获取已审核银行列表
         */
        String s3 = "{\"data\":[{\"userId\":\"" + user.getId() + "\",\"userName\":\"" + user.getUsername()
                + "\",\"bankStatus\":\"1\",\"date\":\"" + date.getTime() + "\"}]}";
        String s4 = user.getId() + user.getUsername() + "1" + date.getTime();

        map = RequestDataProxy.getRequestParam(s3, s4);
        //获取用户绑定银行列表
        dto = userAccountService.getBank(map);

        List<ResUserAccountDTO> bank = (List<ResUserAccountDTO>) dto.getData();

        request.setAttribute("type", "cj");
        request.setAttribute("banklist", bank);

        mav.setViewName("pay.paypage");
        return mav;
    }

    /**
     * 出金
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/deposits")
    @ResponseBody
    public String deposits(HttpServletRequest request, Model mode) {
        try {
            Map<String, Object> rtnMap = new HashMap<String, Object>();
            User user = (User) request.getSession().getAttribute("user");

            if (user == null) {
                rtnMap.put("info", "user loginout");
                return JSONUtil.map2json(rtnMap);
            }

            if (Authory.token == null)
                RequestDataProxy.getAccessToken(authorService);

            String drawMoney = request.getParameter("drawMoney");//取款金额
            String bankId = request.getParameter("bankId");//银行id

            /**
             * 调用出金接口
             */
            /**
             * userId; private String userName; private String cashType;1,立即返现
             * private String cashBankId; private String cashMoney;
             */

            String s1 = "{\"data\":[{\"userId\":\"" + user.getId() + "\",\"userName\":\"" + user.getUsername()
                    + "\",\"cashType\":\"1\",\"cashBankId\":\"" + bankId + "\",\"cashMoney\":\"" + drawMoney
                    + "\",\"date\":\"" + date.getTime() + "\"}]}";
            String s2 = user.getId() + user.getUsername() + "1" + bankId + drawMoney + date.getTime();

            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

            ReturnDTO dto = userAccountService.getCash(map);

            if (dto.getStatus().equals("000000")) {

               // String contentString = "尊敬的用户：<br/>有一笔新出金金额:￥" + drawMoney
               //        + "元，待审核，点击<a href='http://172.16.20.155/SMMPayCenter/login.do'>此处</a>立即操作。";

               // auditSuccessMail(contentString, adminMail, request, mailSender);
                rtnMap.put("info", "success");
            } else {
                rtnMap.put("info", dto.getMsg());
            }

            return JSONUtil.map2json(rtnMap);

        } catch (Exception e) {
            logger.info("出金申请异常" + e);
            e.printStackTrace();
            return null;
        }
    }

    public String auditSuccessMail(String contentString, String receiveMail, HttpServletRequest request,
                                   JavaMailSender mailSender) {
        try {
			Thread.sleep(10000);
            MimeMessage mailMessage = mailSender.createMimeMessage();
            //false 是mulitpart类型 、true html格式
            MimeMessageHelper messageHelper = new MimeMessageHelper(mailMessage, true, "utf-8");

            messageHelper.setFrom("上海有色网<no-replay@smm.cn>");
            messageHelper.setTo(receiveMail);

            messageHelper.setSubject("出金申请");
            // true 表示启动HTML格式的邮件
            messageHelper.setText(contentString, true);

            mailSender.send(mailMessage);
        } catch (Exception e) {
            logger.error("发送邮件：" + receiveMail + "失败", e);
            return "error";
        }
        logger.info("发送邮件：" + receiveMail + "成功");
        return "success";
    }
}
