package com.eliteams.pay.web.tools.mail;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import freemarker.template.Template;

public class UtilMail {
    /**
     * Message对象将存储我们实际发送的电子邮件信息，
     * Message对象被作为一个MimeMessage对象来创建并且需要知道应当选择哪一个JavaMail session。
     */
    private MimeMessage          message;

    /**
     * Session类代表JavaMail中的一个邮件会话。
     * 每一个基于JavaMail的应用程序至少有一个Session（可以有任意多的Session）。
     * JavaMail需要Properties来创建一个session对象。 寻找"mail.smtp.host" 属性值就是发送邮件的主机
     * 寻找"mail.smtp.auth" 身份验证，目前免费邮件服务器都需要这一项
     */
    private Session              session;

    /***
     * 邮件是既可以被发送也可以被受到。JavaMail使用了两个不同的类来完成这两个功能：Transport 和 Store。 Transport
     * 是用来发送信息的，而Store用来收信。对于这的教程我们只需要用到Transport对象。
     */
    private Transport            transport;

    private String               mailHost        = "";
    private String               sender_username = "";
    private String               sender_password = "";

    private Properties           properties      = new Properties();
    @Resource
    private FreeMarkerConfigurer freemarkerConfig;

    /*
     * 初始化方法
     */
    public UtilMail(boolean debug) {
        String path = "src/main/resources/MailServer.properties";

        try {
            InputStream in = new FileInputStream(path);
            properties.load(in);
            this.mailHost = properties.getProperty("mail.smtp.host");
            this.sender_username = properties.getProperty("mail.sender.username");
            this.sender_password = properties.getProperty("mail.sender.password");
        } catch (IOException e) {
            e.printStackTrace();
        }

        session = Session.getInstance(properties);
        session.setDebug(debug);//开启后有调试信息
        message = new MimeMessage(session);
    }

    /**
     * 发送邮件
     * 
     * @param subject 邮件主题
     * @param sendHtmlUrl 邮件内容路径
     * @param receiveUser 收件人地址
     */
    public void doSendHtmlUrlEmail(String subject, String sendHtmlUrl, String receiveUser, Map<String, String> map) {
        try {

            String imgPath = System.getProperty("SMMPayClient") + "/pay/images/mail/";
            Template tpl = freemarkerConfig.getConfiguration().getTemplate(sendHtmlUrl);
            String sendHtml = FreeMarkerTemplateUtils.processTemplateIntoString(tpl, map);

            // 发件人
            //InternetAddress from = new InternetAddress(sender_username);
            // 下面这个是设置发送人的Nick name
            InternetAddress from = new InternetAddress(MimeUtility.encodeWord("上海有色网"));
            message.setFrom(from);

            // 收件人
            InternetAddress to = new InternetAddress(receiveUser);
            message.setRecipient(Message.RecipientType.TO, to);//还可以有CC、BCC

            // 邮件主题
            message.setSubject(subject);
            /*
             * 32. * 创建一个子类型为 “related” 的 MIME 消息组合对象， 33. * 其实 MimeMultipart
             * 类还有另外两种子类型，请自行 34. * 查阅并比较其中的适用场景 35.
             */

            MimeMultipart multipart = new MimeMultipart("related");
            MimeBodyPart htmlBodyPart = new MimeBodyPart();
            htmlBodyPart.setContent(sendHtml, "text/html;charset=UTF-8");
            multipart.addBodyPart(htmlBodyPart);

            /*
             * 创建一个表示图片文件的 MimeBodyPart 对象， 并加入 到上面所创建的 MimeMultiPart 对象中， 使用
             * JAF 框架中的 FileDataSource 类获取图片文件源， 它能够自动获知文件的 MIME 格式并设置好消息头
             */
            MimeBodyPart jpgBodyPart = new MimeBodyPart();
            FileDataSource fds = new FileDataSource(imgPath + "u18.png");
            jpgBodyPart.setDataHandler(new DataHandler(fds));
            jpgBodyPart.setContentID("IMG0");
            FileDataSource fds1 = new FileDataSource(imgPath + "u20.png");
            jpgBodyPart.setDataHandler(new DataHandler(fds1));
            jpgBodyPart.setContentID("IMG1");
            FileDataSource fds2 = new FileDataSource(imgPath + "u22.png");
            jpgBodyPart.setDataHandler(new DataHandler(fds2));
            jpgBodyPart.setContentID("IMG2");

            multipart.addBodyPart(jpgBodyPart);

            //String content = sendHtml.toString();
            // 邮件内容,也可以使纯文本"text/plain"
            message.setContent(multipart);
            // 保存邮件
            message.saveChanges();
            transport = session.getTransport("smtps");
            // smtp验证，就是你用来发邮件的邮箱用户名密码
            transport.connect(mailHost, sender_username, sender_password);
            // 发送
            transport.sendMessage(message, message.getAllRecipients());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (transport != null) {
                try {
                    transport.close();
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 发送邮件
     * 
     * @param subject 邮件主题
     * @param sendHtmlUrl 邮件内容路径
     * @param receiveUser 收件人地址
     */
    public void doSendHtmlEmail(String subject, String sendHtml, String receiveUser) {
        try {
            // 发件人
            //InternetAddress from = new InternetAddress(sender_username);
            // 下面这个是设置发送人的Nick name
            InternetAddress from = new InternetAddress(MimeUtility.encodeWord("上海有色网") + "<no-replay@smm.cn>");
            message.setFrom(from);

            // 收件人
            InternetAddress to = new InternetAddress(receiveUser);
            message.setRecipient(Message.RecipientType.TO, to);//还可以有CC、BCC

            // 邮件主题
            message.setSubject(subject);

            String content = sendHtml.toString();
            // 邮件内容,也可以使纯文本"text/plain"
            message.setContent(content, "text/html;charset=UTF-8");

            // 保存邮件
            message.saveChanges();

            transport = session.getTransport("smtp");
            // smtp验证，就是你用来发邮件的邮箱用户名密码
            transport.connect(mailHost, sender_username, sender_password);

            // 发送
            transport.sendMessage(message, message.getAllRecipients());
            //System.out.println("send success!");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (transport != null) {
                try {
                    transport.close();
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void main(String[] args) {
        UtilMail se = new UtilMail(false);
        Map<String, String> map = new HashMap<String, String>();
        map.put("connect", "http://haolloyin.blog.51cto.com");
        se.doSendHtmlUrlEmail("标题", "mail/auditSuccess.html", "2631130211@qq.com", map);
    }

}
