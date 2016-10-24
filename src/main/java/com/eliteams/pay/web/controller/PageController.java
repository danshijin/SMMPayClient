package com.eliteams.pay.web.controller;

import java.awt.image.BufferedImage;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.google.code.kaptcha.Constants;
import com.google.code.kaptcha.Producer;

/**
 * 视图控制器,返回jsp视图给前端
 * 
 * @since 2014年5月28日 下午4:00:49
 **/
@Controller
@RequestMapping("/page")
public class PageController {

    @Autowired
    private Producer captchaProducer = null;

    /**
     * 登录页
     */
    @RequestMapping("/login")
    public ModelAndView login() {
        ModelAndView model = new ModelAndView();
        model.addObject("loginType", "1");
        model.setViewName("login");
        return model;
    }

    @RequestMapping("/verifyCode")
    public void getKaptchaImage(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        response.setDateHeader("Expires", 0);

        // Set standard HTTP/1.1 no-cache headers.
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");

        // Set IE extended HTTP/1.1 no-cache headers (use addHeader).
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");

        // Set standard HTTP/1.0 no-cache header.
        response.setHeader("Pragma", "no-cache");

        // return a jpeg
        response.setContentType("image/jpeg");

        // create the text for the image
        String capText = captchaProducer.createText();

        // store the text in the session
        session.setAttribute(Constants.KAPTCHA_SESSION_KEY, capText);

        // create the image with the text
        BufferedImage bi = captchaProducer.createImage(capText);
        ServletOutputStream out = response.getOutputStream();

        // write the data out
        ImageIO.write(bi, "jpg", out);
        try {
            out.flush();
        } finally {
            out.close();
        }
    }

    /**
     * 注册
     */
    @RequestMapping("/register")
    public String register() {
        return "register";
    }

    /**
     * 注册
     */
    @RequestMapping("/register2")
    public String register2() {
        return "register2";
    }

    /**
     * 购物车
     */
    @RequestMapping("/shoppingCat")
    public String shoppingCat() {
        return "home/shoppingCat";
    }

    /**
     * 购物车成功
     */
    @RequestMapping("/shoppingSuccess")
    public String shoppingSuccess() {
        return "homeshoppingSuccess";
    }

    /**
     * 购物车成功
     */
    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    /**
     * 下单成功
     */
    @RequestMapping("/congratulations")
    public String congratulations() {
        return "home.congratulations";
    }

    /**
     * dashboard页
     */
    @RequestMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }

    /**
     * 404页
     */
    @RequestMapping("/404")
    public String error404() {
        return "404";
    }

    /**
     * 401页
     */
    @RequestMapping("/401")
    public String error401() {
        return "401";
    }

    /**
     * 500页
     */
    @RequestMapping("/500")
    public String error500() {
        return "500";
    }

}
