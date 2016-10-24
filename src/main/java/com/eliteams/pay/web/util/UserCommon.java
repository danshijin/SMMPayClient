package com.eliteams.pay.web.util;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.SavedRequest;

import com.eliteams.pay.web.model.User;

public class UserCommon {

    public static User isLogin(HttpServletRequest request) {
        Subject subject = SecurityUtils.getSubject();

        if (subject.isAuthenticated()) {
            User user = (User) request.getSession().getAttribute("user");
            return user;
        }

        return null;
    }

    public static void setUrl(HttpServletRequest request) {
        Subject subject = SecurityUtils.getSubject();
        Session session = subject.getSession(false);
        SavedRequest sr = new SavedRequest(request);
        session.setAttribute("shiroSavedRequest", sr);
    }
}
