package com.eliteams.pay.web.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.eliteams.pay.web.model.SystemData;
import com.eliteams.pay.web.model.User;
import com.eliteams.pay.web.service.UCServices;
import com.eliteams.pay.web.util.DateUtil;
import com.eliteams.pay.web.util.ExcelExportConf;
import com.eliteams.pay.web.util.ExportUtil;
import com.eliteams.pay.web.util.JSONUtil;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.ResPayDetail;
import com.smmpay.inter.dto.res.ResTradingRecordDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.TradingRecordService;
import com.smmpay.inter.smmpay.UserAccountService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 
 * @author duqiang 2015年11月5日 上午10:25:28
 */
@Controller
@RequestMapping(value = "/trade")
public class tradeController {
    private Logger               logger = Logger.getLogger(tradeController.class);

    @Autowired
    private UserAccountService   userAccountService;

    @Autowired
    private AuthorService        authorService;
    @Autowired
    private TradingRecordService tradingRecordService;

    @RequestMapping(value = "/toTrade")
    public ModelAndView toTrade(HttpServletRequest request) {
        logger.info("交易开始------------------");
        String buyOrSellerType = "all";
        String dateType = "week";
        String statusType = "allStatus";
        Integer pno = null;
        try {
            if (null != request.getParameter("pno")) {
                pno = Integer.parseInt(request.getParameter("pno"));
            }
            if (pno == null)
                pno = 1;
            String buyerOrSeller = request.getParameter("buyerOrSeller");//买卖方
            String timeFrame = request.getParameter("timeFrame");//时间
            String stateRange = request.getParameter("stateRange");//状态
            String orderNumber = request.getParameter("orderNumber");//交易订单号
            String counterpart = request.getParameter("counterpart");//交易对方
            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            StringBuilder build = new StringBuilder();
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (null != user) {

                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                if (null != buyerOrSeller && !"".equals(buyerOrSeller)) {
                    buyOrSellerType = buyerOrSeller;
                    String isBuy = "";//是否卖出
                    if (buyerOrSeller.equals("all")) {
                        isBuy = "0";
                    } else if (buyerOrSeller.equals("buy")) {
                        isBuy = "1";
                    } else if (buyerOrSeller.equals("seller")) {
                        isBuy = "2";
                    }
                    dataMap.put("isBuy", isBuy);
                    build.append(isBuy);
                } else {
                    dataMap.put("isBuy", "0");
                    build.append("0");
                }
                Date date = new Date();
                String startDate = "";//开始日期
                String endDate = "";//结束日期
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (null != timeFrame && !"".equals(timeFrame)) {
                    dateType = timeFrame;
                    if (timeFrame.equals("day")) {
                        startDate = sdf.format(date);
                        endDate = sdf.format(date);
                    } else if (timeFrame.equals("week")) {//一周
                        startDate = DateUtil.dateAddAndSubtract("-7", "yyyy-MM-dd", sdf.format(date));
                        endDate = sdf.format(date);
                    } else if (timeFrame.equals("threeMonth")) {//三个月
                        startDate = DateUtil.monthAddAndSubtract("-3", "yyyy-MM-dd", sdf.format(date));
                        endDate = sdf.format(date);
                    } else if (timeFrame.equals("threeMonthAgo")) {//三个月之前
                       // startDate = DateUtil.monthAddAndSubtract("3", "yyyy-MM-dd", sdf.format(date));
                        endDate = DateUtil.monthAddAndSubtract("-3", "yyyy-MM-dd", sdf.format(date));
                    }
                } else {//一周
                    startDate = DateUtil.dateAddAndSubtract("-7", "yyyy-MM-dd", sdf.format(date));
                    endDate = sdf.format(date);
                }
                dataMap.put("startDate", startDate);
                build.append(startDate);
                dataMap.put("endDate", endDate);
                build.append(endDate);
                if (null != stateRange && !"".equals(stateRange)) {
                    String paymentStatus = "";//支付状态
                    statusType = stateRange;
                    if (stateRange.equals("paymentStatus")) {
                        paymentStatus = "0";
                    } else if (stateRange.equals("frozenStates")) {
                        paymentStatus = "1";
                    } else if (stateRange.equals("finishedStatus")) {
                        paymentStatus = "2";
                    } else if (stateRange.equals("allStatus")) {//所有状态
                        paymentStatus = "4";
                    }
                    dataMap.put("paymentStatus", paymentStatus);
                    build.append(paymentStatus);
                } else {
                    dataMap.put("paymentStatus", "4");
                    build.append("4");
                }
                if (null != orderNumber && !"".equals(orderNumber)) {//订单号
                    dataMap.put("mallOrderId", orderNumber);
                    build.append(orderNumber);
                }
                if (null != counterpart && !"".equals(counterpart)) {//交易对方公司名
                    counterpart = java.net.URLDecoder.decode(counterpart, "UTF-8");
                    dataMap.put("opposite", counterpart);
                    build.append(counterpart);
                }
                dataMap.put("page", pno + "");//第几页
                build.append(pno + "");
                dataMap.put("pageSize", "10");//每页显示的条数
                build.append("10");
                dataMap.put("date", date.getTime() + "");//必带的时间
                build.append(date.getTime() + "");
                logger.info("buyerOrSeller=" + buyerOrSeller + ",timeFrame=" + timeFrame + ",stateRange=" + stateRange
                        + ",orderNumber=" + orderNumber + ",counterpart=" + counterpart);
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("交易参数json=" + obj.toString());
                logger.info("交易参数build=" + build.toString());
                ModelAndView model = new ModelAndView();
                //得到账户余额
                ReturnDTO userDto = getUserAccount(request);
                model.addObject("moneyStatus", userDto.getStatus());//账户余额
                Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                //得到账户交易记录
                ReturnDTO dto = tradingRecordService.getPaymentRecord(userMap);
                logger.info("得到账户的支付记录status=" + dto.getStatus() + ",msg=" + dto.getMsg());
                Map<String, Object> record = (Map<String, Object>) dto.getData();
                logger.info("count=" + record.get("count") + ",list=" + record.get("list"));
                List<ResTradingRecordDTO> tracList = (List<ResTradingRecordDTO>) record.get("list");
                logger.info("tracList=" + tracList.toString());
                String records = com.alibaba.fastjson.JSONObject.toJSONString(tracList);
                logger.info("records=" + records);
                if (dto.getStatus().equals("000000") && dto.isSuccess() == true) {//代表成功 
                    model.addObject("tradList", tracList);//账户余额
                }

                if (userDto.getStatus().equals("000000")) {
                    model.addObject("totalMoney", JSONObject.fromObject(userDto.getData()).get("totalMoney"));//账户余额
                    model.addObject("userMoney", JSONObject.fromObject(userDto.getData()).get("userMoney"));//可用余额
                    model.addObject("freezeMoney", JSONObject.fromObject(userDto.getData()).get("freezeMoney"));//冻结金额
                }
                if (null != request.getParameter("type")) {
                    model.addObject("type", request.getParameter("type"));
                } else {
                    model.addObject("type", "jy");
                }
                Integer totalPage = Integer.parseInt(record.get("count") + "") / 10;
                if (Integer.parseInt(record.get("count") + "") % 10 > 0) {
                    totalPage++;
                }
                //待验证银行账户
                ReturnDTO checkBankDto = checkBank(request);
                if (checkBankDto.getStatus().equals("000000")) {
                    model.addObject("checkBankBool", "success");
                } else {
                    model.addObject("checkBankBool", "faild");
                }

                model.addObject("buyOrSellerType", buyOrSellerType);//买卖类型
                model.addObject("dateType", dateType);//时间类型
                model.addObject("statusType", statusType);//状态类型
                model.addObject("orderNumber", orderNumber);//交易订单号
                model.addObject("counterpart", counterpart);//交易对方
                model.addObject("totalRecords", record.get("count"));// 总条数
                model.addObject("totalPage", totalPage);// 总页数
                model.setViewName("toTrade");
                return model;
            } else {
                logger.error("登录的user为空");
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    @RequestMapping(value = "/freshAccountMoney")
    @ResponseBody
    public String freshAccountMoney(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("开始刷新账户余额------------------");
        try {
            ReturnDTO userDto = getUserAccount(request);
            if (userDto.getStatus().equals("000000")) {
                rtnMap.put("totalMoney", JSONObject.fromObject(userDto.getData()).get("totalMoney") + "");//账户余额
                rtnMap.put("userMoney", JSONObject.fromObject(userDto.getData()).get("userMoney") + "");//可用余额
                rtnMap.put("freezeMoney", JSONObject.fromObject(userDto.getData()).get("freezeMoney") + "");//冻结金额
                rtnMap.put("info", "success");
            } else {
                logger.error("刷新账户金额失败,status=" + userDto.getStatus() + ",msg=" + userDto.getMsg());
                rtnMap.put("info", "faild");
            }
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /**
     * 得到账户余额
     * 
     * @param request
     * @return
     */
    public ReturnDTO getUserAccount(HttpServletRequest request) {
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
            logger.info("交易参数json=" + obj.toString());
            if (Authory.token == null)
                RequestDataProxy.getAccessToken(authorService);
            Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
            ReturnDTO dto = userAccountService.getUserAccount(userMap);
            logger.info("得到账户余额信息status=" + dto.getStatus() + ",msg=" + dto.getMsg());
            return dto;
        } else {
            logger.error("用户还没登录session为空");
        }
        return null;

    }

    /**
     * 验证银行账户
     * 
     * @param request
     * @return
     */
    public ReturnDTO checkBank(HttpServletRequest request) {
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
            logger.info("验证银行json=" + obj.toString());
            Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
            ReturnDTO dto = userAccountService.checkBank(userMap);
            logger.info("验证银行status=" + dto.getStatus() + ",msg=" + dto.getMsg());
            return dto;
        } else {
            logger.error("用户还没登录，session为空");
        }
        return null;
    }

    @RequestMapping(value = "/toLook")
    public ModelAndView toLook(HttpServletRequest request) {
        logger.info("交易查看------------------");
        try {
            //获取登录用户信息
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String paymentNo = request.getParameter("paymentNo");
            
            //更新
            String buyerOrSeller = request.getParameter("buyerOrSeller");
            request.setAttribute("buyerOrSeller", buyerOrSeller);
            
            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            StringBuilder build = new StringBuilder();
            if (null != user && StringUtils.isNotBlank(paymentNo)) {
                dataMap.put("userId", user.getId() + "");
                
                //更新
                request.setAttribute("userId", user.getId());
                
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("paymentNo", paymentNo);
                build.append(paymentNo);
                Date date = new Date();
                dataMap.put("date", date.getTime() + "");
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("交易查看json=" + obj.toString());
                Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = tradingRecordService.getPaymentDetail(userMap);
                logger.info("tradingRecordService.getPaymentDetail>>>>>>>>>>>>>=" + dto.getStatus() + ","
                        + dto.getMsg());
                ResPayDetail resPayDetail = (ResPayDetail) dto.getData();
                ModelAndView model = new ModelAndView();
                if (dto.getStatus().equals("000000")) {
                    model.addObject("resPayDetail", resPayDetail);
                }
                model.setViewName("toTradeLook");
                return model;
            } else {
                logger.error("用户还没登录，session为空,user=" + user + ",或者paymentNo为空=" + paymentNo);
            }

        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    @RequestMapping(value = "/closePay")
    @ResponseBody
    public String closePay(HttpServletRequest request) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("开始关闭交易------------------");
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String paymentId = request.getParameter("paymentId");
            LinkedHashMap<String, Object> dataMap = new LinkedHashMap<String, Object>();//里面的数据map
            Map<String, Object> map = new HashMap<String, Object>();//外面数据map
            StringBuilder build = new StringBuilder();
            if (null != user && StringUtils.isNotBlank(paymentId)) {
                dataMap.put("userId", user.getId() + "");
                build.append(user.getId() + "");
                dataMap.put("userName", user.getUsername());
                build.append(user.getUsername());
                dataMap.put("paymentId", paymentId);
                build.append(paymentId);
                Date date = new Date();
                dataMap.put("date", date.getTime() + "");
                build.append(date.getTime() + "");
                JSONArray arr = JSONArray.fromObject(dataMap);
                map.put("data", arr);
                JSONObject obj = JSONObject.fromObject(map);
                logger.info("关闭交易json=" + obj.toString());
                Map<String, String> userMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
                ReturnDTO dto = tradingRecordService.closePayment(userMap);
                logger.info("tradingRecordService.closePayment>>>>>>>>>>>>>=" + dto.getStatus() + "," + dto.getMsg());

                if (dto.getStatus().equals("000000")) {
                    rtnMap.put("info", "success");
                } else {
                    rtnMap.put("info", "faild");
                }
            } else {
                logger.error("closePay params is null.user=" + user + ",paymentId=" + paymentId);
            }
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            logger.error("系统错误", e);
        }
        return null;
    }

    /** 对账单
     * @param session
     * @param request
     * @param pno
     * @param pageSize
     * @param timeDistrictType
     * @param tranType
     * @return
     */
    @RequestMapping(value="statement")
    public String statement(HttpSession session, HttpServletRequest request, Integer pno, Integer pageSize, Integer timeDistrictType, Integer tranType){
    	// 设置默认值
    	pno = pno == null ? 1 : pno; //页数默认是1
    	pageSize = pageSize == null ? 20 : pageSize; //每页显示条数默认20条
    	timeDistrictType = timeDistrictType == null ? 1 : timeDistrictType; // 默认为一周内
    	tranType = tranType == null ? 0 : tranType; // 默认交易类型为所有
    	
		Map<String, String> requestParamMap = getRequestParamMapForStatement(session, pno, pageSize, timeDistrictType, tranType); //封装请求参数
		
    	ReturnDTO tradingDto = tradingRecordService.getRecordForClient(requestParamMap); // 接口返回对账单数据
    	int count = 0;
    	@SuppressWarnings("unchecked")
		Map<String,Object> dataMap = (Map<String, Object>) tradingDto.getData();
    	
    	if(dataMap == null){ // 返回值数据为空
    		request.setAttribute("tradeList", new ArrayList<>());
    	} else {
    		count = (int) dataMap.get("count");
    		request.setAttribute("tradeList", com.alibaba.fastjson.JSONObject.parseArray((String) dataMap.get("jsonList"), SystemData.class));
    	}
    	request.setAttribute("totalRecords", count);
    	request.setAttribute("totalPage", (count / pageSize) + (count % pageSize > 0 ? 1 : 0));// 总页数
    	
    	ReturnDTO userDto = UCServices.getUserAccount(request, userAccountService, authorService);
        if (userDto.getStatus().equals("000000")) {
            request.setAttribute("totalMoney", JSONObject.fromObject(userDto.getData()).get("totalMoney"));// 账户余额
            request.setAttribute("userMoney", JSONObject.fromObject(userDto.getData()).get("userMoney"));// 可用余额
            request.setAttribute("freezeMoney", JSONObject.fromObject(userDto.getData()).get("freezeMoney"));// 冻结金额
        }
        request.setAttribute("timeDistrictType", timeDistrictType);
        request.setAttribute("tranType", tranType);
        
    	return "bill.statement";
    }
    
    /** 对账单导出为excel
	 * @param request
	 * @param response
	 * @param session
	 * @param timeDistrictType
	 * @throws Exception
	 */
	@RequestMapping("statementExport")
	public void poolExportDel(HttpServletRequest request, HttpServletResponse response, HttpSession session, Integer timeDistrictType)
			throws Exception {
		statement(session, request, 1, Integer.MAX_VALUE, timeDistrictType, 0);
		@SuppressWarnings("unchecked")
		List<SystemData> list = (List<SystemData>) request.getAttribute("tradeList");
		dataFormatBeforeExport(list);
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		try {
			ExportUtil<SystemData> excel = new ExportUtil<SystemData>();
			String fileName = "对账单";
			String[] header = new String[] { "交易时间", "对方账户名称", "账号及开户行", "借", "贷", "账户余额", "摘要" };
			String[] headerNames = new String[] { "trDate", "oppositCompanyName", "oppositBankName", "borrow",
					"loan", "userMoney", "note"};
			String[] comments = new String[] { null, null, null, null, null, null, null, null, null, null, null };
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			ExcelExportConf.columnHeight = ExcelExportConf.columnHeight + ExcelExportConf.columnHeight;
			excel.export("sheet1", header, headerNames, comments, list, os, "");
			byte[] content = os.toByteArray();
			InputStream is = new ByteArrayInputStream(content);
			// 设置response参数，可以打开下载页面
			response.reset();
			response.setContentType("application/vnd.ms-excel;charset=utf-8");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + new String((fileName + ".xls").getBytes("GBK"), "iso-8859-1"));
			ServletOutputStream out = response.getOutputStream();

			bis = new BufferedInputStream(is);
			bos = new BufferedOutputStream(out);
			byte[] buff = new byte[2048];
			int bytesRead;
			// Simple read/write loop.
			while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
				bos.write(buff, 0, bytesRead);
			}
		} catch (Exception e) {
			logger.error("导出excel时发生错误：", e);
		} finally {
			// 将导出excel中的默认单元格行高改为默认值
			ExcelExportConf.columnHeight = ExcelExportConf.columnHeight / 2;
			if (bis != null)
				bis.close();
			if (bos != null)
				bos.close();
		}
	}
    
    /** 封装接口请求参数
     * @param session
     * @param pno
     * @param pageSize
     * @param timeDistrictType
     * @param tranType
     * @return
     */
    private Map<String, String> getRequestParamMapForStatement(HttpSession session, int pno, int pageSize, int timeDistrictType, int tranType){
    	Map<String, String> dateParamMap = transferTimeDistrictType(timeDistrictType);
    	String startDate = dateParamMap.get("startDate");
    	String endDate = dateParamMap.get("endDate");
    	
    	User user = (User) session.getAttribute("user");
    	Map<String, Object> map = new LinkedHashMap<String, Object>();
    	StringBuilder build = new StringBuilder();
    	map.put("userId", String.valueOf(user.getId()));
    	build.append(user.getId());
    	map.put("userName", user.getUsername());
    	build.append(user.getUsername());
    	map.put("startDate", startDate);
    	build.append(startDate);
    	map.put("endDate", endDate);
    	build.append(endDate);
    	map.put("page", String.valueOf(pno));
    	build.append(pno);
    	map.put("pageSize", String.valueOf(pageSize));
    	build.append(String.valueOf(pageSize));
    	map.put("tranType", String.valueOf(tranType));
    	build.append(tranType);
        Map<String, Object> mapParam = new LinkedHashMap<String, Object>();// 外面数据map
		JSONArray arr = JSONArray.fromObject(map);
		mapParam.put("data", arr);
		JSONObject obj = JSONObject.fromObject(mapParam);
		logger.info("请求数据 requsMap ：" + obj.toString());
		logger.info("请求数据 buildMap ：" + build.toString());
	   if (Authory.token == null)
			RequestDataProxy.getAccessToken(authorService);
		return RequestDataProxy.getRequestParam(obj.toString(), build.toString());
    }
	
	/** 导出excel前将数据进行格式化
	 * @param list
	 * @return
	 */
	private List<SystemData> dataFormatBeforeExport(List<SystemData> list){
		for(SystemData data : list){
			data.setTrDate(data.getTrDate().substring(0, 10) + "\n" + data.getTrDate().substring(11)); // 日期格式化
			String halfL = data.getOppositBankName();
			String halfR = data.getOppositBankAccount();
			halfL = halfL == null ? "" : halfL;
			halfR = halfR == null ? "" : halfR;
			data.setOppositBankName(halfL + "\n" + halfR); // 对方银行账户名及账户号
		}
		return list;
	}
	
    
    /** 转换交易时间
     * @param type
     * @return
     */
    private Map<String, String> transferTimeDistrictType(Integer type){
    	type = type == null ? 1 : type; // 默认是最近一周
    	Map<String, String> rltMap = new HashMap<>();
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	SimpleDateFormat sdfBrief = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
    	Date now = new Date();
    	switch(type){
    		case 0: // 当天
    			rltMap.put("startDate", sdfBrief.format(now));
    			rltMap.put("endDate", sdf.format(now));
    			break;
    		case 1: // 最近一周
    			rltMap.put("startDate", DateUtil.dateAddAndSubtract("-7", "yyyy-MM-dd", sdf.format(now)));
    			rltMap.put("endDate", sdf.format(now));
    			break;
    		case 2: // 最近三月
    			rltMap.put("startDate", DateUtil.monthAddAndSubtract("-3", "yyyy-MM-dd", sdf.format(now)));
    			rltMap.put("endDate", sdf.format(now));
    			break;
    		case 3: // 三个月前交易
    			rltMap.put("startDate", "2015-01-01 00:00:00");
    			rltMap.put("endDate", DateUtil.monthAddAndSubtract("-3", "yyyy-MM-dd", sdf.format(now)));
    			break;
    		default: // 最近一周
    			rltMap.put("startDate", DateUtil.dateAddAndSubtract("-7", "yyyy-MM-dd", sdf.format(now)));
    			rltMap.put("endDate", sdf.format(now));
    			break;
    	}
    	return rltMap;
    }

    public UserAccountService getUserAccountService() {
        return userAccountService;
    }

    public void setUserAccountService(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

}
