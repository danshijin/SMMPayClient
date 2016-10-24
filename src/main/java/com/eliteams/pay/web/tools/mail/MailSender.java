package com.eliteams.pay.web.tools.mail;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import freemarker.template.Template;

public class MailSender {
    private Logger logger = Logger.getLogger(MailSender.class.getName());

    /**
     * @param connect 连接地址
     * @param subject标题
     * @param receiveMail 收件地址
     * @return
     */

    public String auditSuccessMail(String userName, String accountName, String account, String receiveMail,
                                   HttpServletRequest request, FreeMarkerConfigurer freemarkerConfig,
                                   JavaMailSender mailSender) {
        // TODO Auto-generated method stub
        String imgPath = null;
        String os = System.getProperties().getProperty("os.name");
        if (os.startsWith("win") || os.startsWith("Win")) {
            imgPath = request.getSession().getServletContext().getRealPath("\\") + "pay\\images\\mail\\";
        } else {

            imgPath = request.getSession().getServletContext().getRealPath("/") + "pay/images/mail/";
        }
        logger.info("图片路径》》" + imgPath);

        try {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userName", userName);
            map.put("account", account);
            map.put("registeredMail", receiveMail);
            map.put("accountName", accountName);
            Template tpl = freemarkerConfig.getConfiguration().getTemplate("mail/payment-mail.html");
            String htmlText = FreeMarkerTemplateUtils.processTemplateIntoString(tpl, map);

            MimeMessage mailMessage = mailSender.createMimeMessage();
            //false 是mulitpart类型 、true html格式
            MimeMessageHelper messageHelper = new MimeMessageHelper(mailMessage, true, "utf-8");

            messageHelper.setFrom("上海有色网<no-replay@smm.cn>");
            messageHelper.setTo(receiveMail);

            messageHelper.setSubject("密码重置");
            // true 表示启动HTML格式的邮件
            messageHelper.setText(htmlText, true);

            FileSystemResource img = new FileSystemResource(new File(imgPath + "index-icon_1.png"));

            messageHelper.addInline("IMG0", img);//跟cid一致

            FileSystemResource img1 = new FileSystemResource(new File(imgPath + "index-icon_2.png"));

            messageHelper.addInline("IMG1", img1);//跟cid一致

            FileSystemResource img2 = new FileSystemResource(new File(imgPath + "index-icon_3.png"));

            messageHelper.addInline("IMG2", img2);//跟cid一致

            mailSender.send(mailMessage);
        } catch (Exception e) {
            logger.error("发送邮件：" + receiveMail + "失败", e);
            return "error";
        }
        logger.error("发送邮件：" + receiveMail + "成功");
        return "success";
    }

}
