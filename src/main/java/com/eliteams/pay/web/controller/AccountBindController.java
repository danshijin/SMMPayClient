package com.eliteams.pay.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.eliteams.pay.web.model.Message;
import com.eliteams.pay.web.model.User;
import com.eliteams.pay.web.util.JSONUtil;
import com.eliteams.pay.web.util.Texting;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.DaBankDTO;
import com.smmpay.inter.dto.res.ResUserBindBank;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.BankService;
import com.smmpay.inter.smmpay.UserAccountService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 
 * @author duqiang 2015年11月5日 上午10:25:28
 */
@Controller
@RequestMapping(value = "/accountBind")
public class AccountBindController {
    private Logger             logger = Logger.getLogger(AccountBindController.class);

    @Autowired
    private UserAccountService userAccountService;
    @Autowired
    private AuthorService      authorService;
    @Autowired
    private BankService        bankService;

    /**
     * 显示账户银行卡情况页面
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/toBindCard")
    public ModelAndView toBindCard(HttpServletRequest request) {
        logger.info("去绑卡页面------------------");
        try {
            StringBuilder build = new StringBuilder();
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Map<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            if (null != user) {
                Date date = new Date();
                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("date", date.getTime() + "");//必带的时间
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("绑卡参数json=" + obj.toString());
                if (Authory.token == null)
                    RequestDataProxy.getAccessToken(authorService);
                Map<String, String> bindMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = userAccountService.getBank(bindMap);
                logger.info("status=" + dto.getStatus() + ",msg=" + dto.getMsg());
                ModelAndView model = new ModelAndView();
                List<ResUserBindBank> listBank =  null;
                if(dto.getData() != null){
	                 listBank = (List<ResUserBindBank>) dto.getData();
	                
	                for (Iterator<ResUserBindBank> iterator = listBank.iterator(); iterator.hasNext();) {
	                    ResUserBindBank resUserBindBank = (ResUserBindBank) iterator.next();
	                    if (null != resUserBindBank.getBindTime() && !"".equals(resUserBindBank.getBindTime())) {
	                        resUserBindBank.setBindTime(resUserBindBank.getBindTime().split(" ")[0]);
	                    }
	                }
                }
                if (dto.getStatus().equals("000000")) {
                    model.addObject("listBank", listBank);
                }
                model.addObject("type", "zh");
                model.setViewName("toBindCard");
                return model;
            } else {
                logger.error("用户还没登录，session为空,user=" + user);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 区绑定银行卡页面
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/toBindCardBank")
    public ModelAndView toBindCardBank(HttpServletRequest request) {
        logger.info("去绑卡银行页面------------------");
        try {
            ModelAndView model = new ModelAndView();

            //调用省级信息
            String s1 = "{\"data\":[{\"checkType\":\"1\",\"userName\":\"" + request.getParameter("accountName")
                    + "\"}]}";
            String s2 = "1" + request.getParameter("accountName");
            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

            ReturnDTO dto = bankService.getAllProvince(map);
            List<DaBankDTO> listBank = (List<DaBankDTO>) dto.getData();
            String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(listBank);
            logger.info("AProvince " + AProvince);
            model.addObject("AllProvince", AProvince);

            //调用账户所属银行
            dto = bankService.getAllBank(map);
            List<DaBankDTO> listBank1 = (List<DaBankDTO>) dto.getData();
            String bank = com.alibaba.fastjson.JSONObject.toJSONString(listBank1);
            logger.info("bank " + bank);
            model.addObject("AllBank", bank);
            model.addObject("type", "zh");
            model.setViewName("toBindCardBank");
            return model;
        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 开始绑卡
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/bindCardForm")
    @ResponseBody
    public String bindCardForm(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("开始绑卡------------------");
        try {
            String selProvince = request.getParameter("selProvince");//省
            String selCity = request.getParameter("selCity");//市
            String bankBlongs = request.getParameter("bankBlongs");//所属银行
            String bankName = request.getParameter("bankshortName");//开户名称
            String bankNo = request.getParameter("bankNo");//开户账号
            StringBuilder build = new StringBuilder();
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            Date date = new Date();
            if (null != user) {
                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("bankTypeId", bankBlongs);//所属银行
                build.append(bankBlongs);
                dataMap.put("bankId", bankName);//支行名称
                build.append(bankName);
                dataMap.put("provinceId", selProvince);//支行所在省
                build.append(selProvince);
                dataMap.put("cityId", selCity);//支行所在省
                build.append(selCity);
                dataMap.put("bankAccountNo", bankNo);//开户账号
                build.append(bankNo);
                dataMap.put("date", date.getTime() + "");//必带的时间
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("交易参数json=" + obj.toString());
                Map<String, String> cardmap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());

                ReturnDTO dto = userAccountService.bindUserBank(cardmap);
                logger.info("status " + dto.getStatus() + ",msg=" + dto.getMsg());
                String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(dto.getData());
                logger.info("AProvince " + AProvince);
                if (dto.getStatus().equals("000000")) {
                    rtnMap.put("info", "success");
                } else if (dto.getStatus().equals("000002") || dto.getStatus().equals("000003")) {//银行卡已被绑定
                    rtnMap.put("info", "exist");
                } else {
                    rtnMap.put("info", "faild");
                }
                return JSONUtil.map2json(rtnMap);
            } else {
                logger.error("用户还没登录，session为空,user=" + user);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 去验证卡
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/toCheckCard")
    public ModelAndView toCheckCard(HttpServletRequest request) {
        logger.info("区验证银行账户------------------");
        try {
            ModelAndView model = new ModelAndView();
            String bankName = request.getParameter("bankName");
            String bankAccountNo = request.getParameter("bankAccountNo");
            String bindTypeId = request.getParameter("bindTypeId");
            String bindId = request.getParameter("bindId");
            if (StringUtils.isNotBlank(bankName) && StringUtils.isNotBlank(bankAccountNo)
                    && StringUtils.isNotBlank(bindId) && StringUtils.isNotBlank(bindTypeId)) {
                bankName = java.net.URLDecoder.decode(bankName, "UTF-8");
                logger.info("bankname= " + bankName + "," + bankAccountNo);
                model.addObject("bankName", bankName);
                model.addObject("bindId", bindId);
                model.addObject("bindTypeId", bindTypeId);
                model.addObject("bankAccountNo", bankAccountNo);
                model.addObject("type", "zh");
                model.setViewName("toCheckCard");
                return model;
            } else {
                logger.error("toCheckCard区验证银行账户参数为空;bankName=" + bankName + ",bankAccountNo=" + bankAccountNo
                        + ",bindId=" + bindId + ",bindTypeId=" + bindTypeId);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 绑卡校验金额
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/checkBankMoney")
    @ResponseBody
    public String checkBankMoney(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("开始绑卡------------------");
        try {
            String bindId = request.getParameter("bindId");//卡id
            String money = request.getParameter("money");//输入金额
            StringBuilder build = new StringBuilder();
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            Date date = new Date();
            if (null != user && StringUtils.isNotBlank(bindId) && StringUtils.isNotBlank(money)) {
                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("bindId", bindId);
                build.append(bindId);
                dataMap.put("money", money);
                build.append(money);
                dataMap.put("date", date.getTime() + "");//必带的时间
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("校验金额json=" + obj.toString());
                Map<String, String> cardmap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = userAccountService.checkBankMoney(cardmap);
                logger.info("status " + dto.getStatus() + ",msg=" + dto.getMsg());
                String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(dto.getData());
                logger.info("userAccountService.checkBankMoney " + AProvince);

                if (dto.getStatus().equals("000000")) {
                    rtnMap.put("info", "success");
                } else if (dto.getStatus().equals("000003")) {//金额不一致
                    rtnMap.put("info", "differ");
                } else if (dto.getStatus().equals("000005")) {//验证几次超过5次
                    rtnMap.put("info", "countError");
                } else {
                    rtnMap.put("info", "faild");
                }
                return JSONUtil.map2json(rtnMap);
            } else {
                logger.error("开始绑卡checkBankMoney;没有登录session为空或者参数为空；bindId=" + bindId + ",money=" + money);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 解绑发送短信
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/sendMessage")
    public String sendMessage(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("发送短信------------------");
        try {
            String phone = request.getParameter("mobilePhone");
            if (StringUtils.isNotBlank(phone)) {
                Texting t = new Texting();
                Random r = new Random();
                Double d = r.nextDouble();
                String s1 = d + "";
                s1 = s1.substring(3, 3 + 6);
                logger.info("验证码=" + s1);
                String resultMsg = t.sendsmm(new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()), "你解绑银行卡的验证码是"
                        + s1 + "，请你在15分钟内使用,谢谢!", phone);
                String smsSendResult = Texting.checkResultCode(resultMsg);
                logger.info("发送验证码结果=" + smsSendResult);
                if (smsSendResult.equals("成功")) {
                    rtnMap.put("info", "success");
                }
                rtnMap.put("message", s1);
                rtnMap.put("messageTime", new Date());
                Message mess = new Message();
                mess.setMessage(s1);
                mess.setMessageTime(new Date());
                request.getSession().setAttribute("message", mess);//验证码
                return JSONUtil.map2json(rtnMap);
            } else {
                logger.error("sendMessage发送短信时参数mobilePhone为空=" + phone);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 校验验证码
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/checkMessage")
    @ResponseBody
    public String checkMessage(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("校验验证码------------------");
        try {
            SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            long nd = 1000 * 24 * 60 * 60;//一天的毫秒数
            long nh = 1000 * 60 * 60;//一小时的毫秒数
            long nm = 1000 * 60;//一分钟的毫秒数

            String message = request.getParameter("message");//卡id
            HttpSession session = request.getSession();
            Message mess = (Message) session.getAttribute("message");
            Date messageTime = mess.getMessageTime();
            long diff = sd.parse(sd.format(messageTime)).getTime() - sd.parse(sd.format(new Date())).getTime();
            long min = diff % nd % nh / nm;//计算差多少分钟
            if (min < 15) {
                if (mess.getMessage().equals(message)) {
                    rtnMap.put("info", "success");
                } else {
                    rtnMap.put("info", "faild");
                }
            } else {
                rtnMap.put("info", "overtime");
            }
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 解绑，关闭卡
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/updateUserBindBank")
    @ResponseBody
    public String updateUserBindBank(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("去解绑银行卡------------------");
        try {
            String bindId = request.getParameter("bindId");//卡id
            StringBuilder build = new StringBuilder();
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            Date date = new Date();
            if (null != user && StringUtils.isNotBlank(bindId)) {
                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("bindId", bindId);
                build.append(bindId);
                dataMap.put("date", date.getTime() + "");//必带的时间
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("解绑，关闭卡json=" + obj.toString());
                Map<String, String> cardmap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = userAccountService.updateUserBindBank(cardmap);
                logger.info("updateUserBindBank:status " + dto.getStatus() + ",msg=" + dto.getMsg());
                String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(dto.getData());
                logger.info("userAccountService.updateUserBindBank " + AProvince);
                if (dto.getStatus().equals("000000")) {
                    rtnMap.put("info", "success");
                } else if (dto.getStatus().equals("000002")) {
                    rtnMap.put("info", "only");
                } else {
                    rtnMap.put("info", "faild");
                }
                return JSONUtil.map2json(rtnMap);
            } else {
                logger.error("updateUserBindBank解绑关闭银行卡参数为空bindid=" + bindId + ",或者用户user为空" + user);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    public static void main(String[] args) {
        System.out.println("111");
        try {
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("222");
    }
}
