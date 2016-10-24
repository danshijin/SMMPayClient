package com.eliteams.pay.web.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.eliteams.pay.web.util.JSONUtil;

@Controller
@RequestMapping(value = "/verify")
public class VerifyController {

    @RequestMapping(value = "/verifyServlet", method = RequestMethod.POST)
    @ResponseBody
    public String verifyServlet(HttpServletRequest request) throws ServletException, IOException {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        GeetestLib geetest = GeetestLib.getGtSession(request);
        int gt_server_status_code = GeetestLib.getGtServerStatusSession(request);

        String gtResult = "fail";

        if (gt_server_status_code == 1) {
            gtResult = geetest.enhencedValidateRequest(request);
        } else {
            System.out.println("failback:use your own server captcha validate");
            gtResult = "fail";
            gtResult = geetest.failbackValidateRequest(request);
        }

        rtnMap.put("info", gtResult);
        return JSONUtil.map2json(rtnMap);
    }
}
