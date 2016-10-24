package com.eliteams.pay.web.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.eliteams.pay.web.enumDef.LoginResult;
import com.eliteams.pay.web.model.User;
import com.eliteams.pay.web.service.UCServices;
import com.eliteams.pay.web.tools.mail.MailSender;
import com.eliteams.pay.web.util.JSONUtil;
import com.eliteams.pay.web.util.StringUtil;
import com.google.code.kaptcha.Constants;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.ResQueryTradingRecordDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.TradingRecordService;
import com.smmpay.inter.smmpay.UserAccountService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping(value = "/user")
public class UserController {

    private Logger               logger     = Logger.getLogger(UserController.class.getName());

    @Autowired
    private UserAccountService   userAccountService;

    @Autowired
    private AuthorService        authorService;

    @Autowired
    private TradingRecordService tradingRecordService;

    @Value("#{configProperties['user.username.null']}")
    private String               userPageSize;
    @Resource
    private JavaMailSender       mailSender;
    @Resource
    private FreeMarkerConfigurer freemarkerConfig;
    @Value("#{ch['host']}")
    private String               ipHost;

    @RequestMapping(value = "/userLogin", produces = "text/plain; charset=utf-8")
    public String userLogin(HttpServletRequest request, HttpServletResponse response, User user, String vCode,
                            Model mode) {

        LoginResult loginResult = null;
        ReturnDTO dto = null;

        String displayStyle = request.getParameter("displayStyle");

        if ("none".equals(displayStyle)) {
            dto = UCServices.loginUser(request, user, userAccountService, authorService);
            loginResult = UCServices.dtoConvertLoginResult("loginUser", dto);
        }
        if ("inline".equals(displayStyle)) {
            if (StringUtils.isNotBlank(vCode)) {
                String code = (String) request.getSession().getAttribute(Constants.KAPTCHA_SESSION_KEY);

                if (code.equals(vCode)) {
                    dto = UCServices.loginUser(request, user, userAccountService, authorService);
                    loginResult = UCServices.dtoConvertLoginResult("loginUser", dto);

                } else {
                    loginResult = LoginResult.VCODE_ERROR;

                }
            } else {
                loginResult = LoginResult.VCODE_NULL;

            }

        }

        loginResult = UCServices.judgmentLoginResult(request, user, loginResult, dto, displayStyle);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("code", loginResult.getCode());
        resultMap.put("msg", loginResult.getMessage());

        String jsonStr = JSONUtil.doConvertObject2Json(resultMap);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        PrintWriter writer;
        try {
            writer = response.getWriter();
            writer.write(jsonStr);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 修改密码
     * 
     * @param session
     */
    @RequestMapping(value = "/chgpwd", method = RequestMethod.GET)
    public String resetPwd(HttpSession session) {
        return "edit";
    }

    /**
     * 修改密码
     * 
     * @param request
     * @param response
     * @param session
     * @return
     */
    @RequestMapping(value = "/passwordChange", produces = "text/plain; charset=utf-8")
    public String passwordChange(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        ReturnDTO dto = UCServices.passwordChange(request, userAccountService, authorService);
        LoginResult loginResult = UCServices.dtoConvertLoginResult("updateUserPassword", dto);

        if (loginResult.getCode().equals(LoginResult.RETURN_SUCCESS_CODE)) {
            User user = new User();
            user.setPassword(request.getParameter("newpwd"));

            UCServices.saveUserOfResUserAccountDTO(session, dto, user);

        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("code", loginResult.getCode());
        resultMap.put("msg", loginResult.getMessage());

        String jsonStr = JSONUtil.doConvertObject2Json(resultMap);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html");
        PrintWriter writer;
        try {
            writer = response.getWriter();
            writer.write(jsonStr);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 对账单
     * 
     * @param session
     */
    @RequestMapping(value = "/checkbill", method = RequestMethod.GET)
    public String checkBill(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        Map<String, String> requestParamMap = UCServices.pagingCondition(request, session, authorService);
        ReturnDTO dto = tradingRecordService.getTradingRecord(requestParamMap);
        logger.info("对账单status=" + dto.getStatus() + ",msg=" + dto.getMsg());

        LoginResult loginResult = UCServices.dtoConvertLoginResult("getTradingRecord", dto);
        if (loginResult != LoginResult.RETURN_SUCCESS_CODE) {
            request.setAttribute("retCode", loginResult.getCode());
            request.setAttribute("retMsg", loginResult.getMessage());
            return "error";
        }

        Map<String, Object> record = (Map<String, Object>) dto.getData();
        List<ResQueryTradingRecordDTO> tradeList = (List<ResQueryTradingRecordDTO>) record.get("list");

        ReturnDTO userDto = UCServices.getUserAccount(request, userAccountService, authorService);
        ReturnDTO checkBankDto = UCServices.checkBank(request, userAccountService, authorService);

        if (userDto == null || checkBankDto == null) {
            request.setAttribute("retCode", "");
            request.setAttribute("retMsg", userDto == null ? "得到账户余额失败" : "验证银行账户失败");
            return "error";
        }

        if (checkBankDto.getStatus().equals("000000")) {
            request.setAttribute("checkBankBool", "success");
        } else {
            request.setAttribute("checkBankBool", "faild");
        }

        if (userDto.getStatus().equals("000000")) {
            request.setAttribute("totalMoney", JSONObject.fromObject(userDto.getData()).get("totalMoney"));// 账户余额
            request.setAttribute("userMoney", JSONObject.fromObject(userDto.getData()).get("userMoney"));// 可用余额
            request.setAttribute("freezeMoney", JSONObject.fromObject(userDto.getData()).get("freezeMoney"));// 冻结金额
        }

        request.setAttribute("tradeList", tradeList);
        request.setAttribute("type", "dzd");

        return "bill.checkbill";
    }

    /**
     * 下载pdf文件
     * 
     * @param session
     * @throws Exception
     */
    @RequestMapping(value = "/downloadpdf", method = RequestMethod.GET)
    public String downloadpdf(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws Exception {
        Map<String, String> requestParamMap = UCServices.pagingCondition(request, session, authorService);
        ReturnDTO dto = tradingRecordService.getTradingRecord(requestParamMap);

        LoginResult loginResult = UCServices.dtoConvertLoginResult("getTradingRecord", dto);
        if (loginResult != LoginResult.RETURN_SUCCESS_CODE) {
            request.setAttribute("retCode", loginResult.getCode());
            request.setAttribute("retMsg", loginResult.getMessage());
            return "error";
        }

        Map<String, Object> record = (Map<String, Object>) dto.getData();
        List<ResQueryTradingRecordDTO> tradeList = (List<ResQueryTradingRecordDTO>) record.get("list");
        
        if (tradeList == null || tradeList.size() <= 0) {
            request.setAttribute("retCode", "");
            request.setAttribute("retMsg", "数据为空");
            return "error";

        }

        UCServices.createPDF(response, tradeList);

        return null;
    }

    /**
     * 登录成功
     */
    @RequestMapping("/loginSucc")
    public String loginSucc(HttpServletRequest request, Model mode) {
        return "redirect:/rest/trade/toTrade";
    }

    /**
     * 用户登出
     * 
     * @param session
     * @return
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        if (session.getAttribute("user") != null) {
            logger.info(session.getAttribute("user") + "已退出");
            session.removeAttribute("user");
            // 登出操作
            Subject subject = SecurityUtils.getSubject();
            subject.logout();
        }
        return "login";
    }

    /**
     * 基于角色 标识的权限控制案例
     */
    @RequestMapping(value = "/test")
    // @RequiresRoles(value = RoleSign.ADMIN)
    public String test() {
        System.out.println(userPageSize);
        return "test.login";
    }

    /**
     * 基于角色 标识的权限控制案例
     */
    @RequestMapping(value = "/admin")
    @ResponseBody
    // @RequiresRoles(value = RoleSign.ADMIN)
    public String admin() {
        return "拥有admin角色,能访问";
    }

    /**
     * 基于权限标识的权限控制案例
     */
    @RequestMapping(value = "/create")
    @ResponseBody
    // @RequiresPermissions(value = PermissionSign.USER_CREATE)
    public String create() {
        return "拥有user:create权限,能访问";
    }

    @RequestMapping(value = "/forgetpwd")
    public ModelAndView forgetpwd(HttpServletRequest request, Model mode) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("forgetpwd");
        return mav;
    }

    /**
     * 忘记密码
     * 
     * @param session
     * @return
     */
    @RequestMapping(value = "/checkMail")
    @ResponseBody
    public String checkMail(HttpServletRequest request) {
        try {
            Map<String, Object> rtnMap = new HashMap<String, Object>();
            String userEmail = request.getParameter("userEmail");
            if (StringUtils.isNotBlank(userEmail)) {
                StringBuilder build = new StringBuilder();
                LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();// 里面的数据map
                Map<String, Object> map = new HashMap<String, Object>();// 外面数据map
                dataMap.put("checkType", "1");
                build.append("1");
                dataMap.put("userName", userEmail);
                build.append(userEmail);
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("忘记密码json=" + obj.toString() + ",build=" + build.toString());
                if (Authory.token == null)
                    RequestDataProxy.getAccessToken(authorService);
                Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = userAccountService.checkUser(userMap);
                logger.info("检验账户邮箱是否存在status=" + dto.getStatus() + ",msg=" + dto.getMsg());
                if (dto.getStatus().equals("000001")) {
                    rtnMap.put("info", "success");
                } else {
                    rtnMap.put("info", "faild");
                }
                return JSONUtil.map2json(rtnMap);
            } else {
                logger.error("checkMail检验邮箱账户参数为空userEmail=" + userEmail);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    @RequestMapping(value = "/sendMail")
    public ModelAndView sendMail(HttpServletRequest request) {
        try {
            String userName = request.getParameter("userName");
            if (StringUtils.isNotBlank(userName)) {
                String emailBase64 = StringUtil.encodeStr(userName);// base64加密
                logger.info("重置密码发送邮件的ip地址=" + ipHost);
                String senderBool = new MailSender().auditSuccessMail("都强", "<a href='" + ipHost
                        + "/rest/user/toResetPassword?userEmail=" + emailBase64 + "'>" + ipHost
                        + "/rest/user/toResetPassword?userEmail=" + emailBase64 + "</a>", "2222", userName, request,
                        freemarkerConfig, mailSender);
                logger.info("邮件发送=" + senderBool);
                if (senderBool.equals("success")) {
                    ModelAndView model = new ModelAndView();
                    model.addObject("userName", userName);
                    model.setViewName("toCheckMail");
                    return model;
                } else {
                    logger.error("发送邮件失败senderBool=" + senderBool);
                }

            } else {
                logger.error("sendMail发送邮箱的参数为空,userEmail=" + userName);
            }

        } catch (Exception e) {
            logger.error("发送邮件失败", e);
        }
        return null;
    }

    @RequestMapping(value = "/toResetPassword")
    public ModelAndView toResetPassword(HttpServletRequest request) {
        try {
            String userEmail = request.getParameter("userEmail");
            if (StringUtils.isNotBlank(userEmail)) {
                ModelAndView model = new ModelAndView();
                model.addObject("userEmail", userEmail);
                model.setViewName("toResetPassword");
                return model;
            } else {
                logger.error("toResetPassword跳转到重置密码页面时参数为空,userEmail=" + userEmail);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    @RequestMapping(value = "/resetPassword")
    public ModelAndView resetPassword(HttpServletRequest request) {
        try {
            String pwd = request.getParameter("password");
            String userEmail = request.getParameter("userEmail");
            if (StringUtils.isNotBlank(userEmail) && StringUtils.isNotBlank(pwd)) {
                userEmail = StringUtil.decodeStr(userEmail);// base64加密
                StringBuilder build = new StringBuilder();
                Map<String, Object> dataMap = new LinkedHashMap<String, Object>();// 里面的数据map
                Map<String, Object> map = new HashMap<String, Object>();// 外面数据map
                dataMap.put("userName", userEmail);
                build.append(userEmail);
                dataMap.put("password", pwd);
                build.append(pwd);
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("交易参数json=" + obj.toString());
                if (Authory.token == null)
                    RequestDataProxy.getAccessToken(authorService);
                Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = userAccountService.setUserPassword(userMap);
                logger.info("得到账户余额信息status=" + dto.getStatus() + ",msg=" + dto.getMsg());
                if (dto.getStatus().equals("000000")) {
                    ModelAndView model = new ModelAndView();
                    // model.addObject("userName", email);
                    model.setViewName("resetPassword");
                    return model;
                } else {
                    logger.error("resetPassword重置密码错误,status=" + dto.getStatus() + ",msg=" + dto.getMsg());
                }

            } else {
                logger.error("resetPassword重置密码时参数为空,userEmail=" + userEmail + ",pwd=" + pwd);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }
    
   /**
     * 加载图片
     * 
     * @param session
     */
    @RequestMapping(value = "/loadImage", method = RequestMethod.GET)
    public String loadImage(HttpServletRequest request,@RequestParam String imageUrl,@RequestParam String width,@RequestParam String height) {
    	System.out.println("loadImage"+imageUrl);
    	request.setAttribute("loadImage", imageUrl);
    	request.setAttribute("width", width);
    	request.setAttribute("height", height);
        return "loadImage";
    }
}
