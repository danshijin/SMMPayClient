package com.eliteams.pay.web.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/capth")
public class StartCapthcaController {

    @RequestMapping(value = "/startCapth", method = RequestMethod.POST)
    protected void startCapth(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {

        // Conifg the parameter of the geetest object
        GeetestLib gtSdk = new GeetestLib();
        gtSdk.setCaptchaId(GeetestConfig.getCaptcha_id());
        gtSdk.setPrivateKey(GeetestConfig.getPrivate_key());

        gtSdk.setGtSession(request);

        String resStr = "{}";

        if (gtSdk.preProcess() == 1) {//连接服务器成功
            // gt server is in use
            resStr = gtSdk.getSuccessPreProcessRes();
            gtSdk.setGtServerStatusSession(request, 1);

        } else {
            // gt server is down
            resStr = gtSdk.getFailPreProcessRes();
            gtSdk.setGtServerStatusSession(request, 0);
        }

        PrintWriter out = response.getWriter();
        out.println(resStr);
    }
}
