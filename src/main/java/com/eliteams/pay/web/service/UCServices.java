package com.eliteams.pay.web.service;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;

import com.eliteams.pay.web.common.ResErrorCode;
import com.eliteams.pay.web.enumDef.LoginResult;
import com.eliteams.pay.web.model.User;
import com.eliteams.pay.web.tools.mail.UtilMail;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.ResQueryTradingRecordDTO;
import com.smmpay.inter.dto.res.ResUserAccountDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.UserAccountService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class UCServices {

	private static Logger logger = Logger.getLogger(UCServices.class.getName());

	/**
	 * 登录
	 * 
	 * @param request
	 * @param user
	 * @param authorService
	 * @param userAccountService
	 */
	public static ReturnDTO loginUser(HttpServletRequest request, User user, UserAccountService userAccountService,
			AuthorService authorService) {
		String loginIp = getIpAddr(request);
		Date date = new Date();
		if (Authory.token == null)
			RequestDataProxy.getAccessToken(authorService);
		String strData = "{\"data\":[{\"userName\":\"" + user.getUsername() + "\",\"password\":\"" + user.getPassword()
				+ "\",\"loginIp\":\"" + loginIp + "\",\"date\":\"" + date.getTime() + "\"}]}";
		Map<String, String> map = RequestDataProxy.getRequestParam(strData,
				user.getUsername() + user.getPassword() + loginIp + date.getTime());
		ReturnDTO dto = userAccountService.loginUser(map);
		return dto;
	}

	/**
	 * 修改密码
	 * 
	 * @param authorService
	 * @param userAccountService
	 * @param request
	 * 
	 * @param user
	 * @param authorService
	 * @param userAccountService
	 */
	public static ReturnDTO passwordChange(HttpServletRequest request, UserAccountService userAccountService,
			AuthorService authorService) {
		String userid = request.getParameter("userid");
		String username = request.getParameter("username");
		String oldpwd = request.getParameter("oldpwd");
		String newpwd = request.getParameter("newpwd");

		Date date = new Date();
		if (Authory.token == null)
			RequestDataProxy.getAccessToken(authorService);
		String strData = "{\"data\":[{\"userId\":\"" + userid + "\",\"userName\":\"" + username
				+ "\",\"oldPassword\":\"" + oldpwd + "\",\"newPassword\":\"" + newpwd + "\",\"date\":\""
				+ date.getTime() + "\"}]}";

		Map<String, String> map = RequestDataProxy.getRequestParam(strData,
				userid + username + oldpwd + newpwd + date.getTime());
		ReturnDTO dto = userAccountService.updateUserPassword(map);

		return dto;
	}

	/**
	 * 返回状态码转化
	 * 
	 * @param string
	 * @param request
	 * @param user
	 * @param dto
	 * @param loginResult
	 */
	public static LoginResult dtoConvertLoginResult(String requestType, ReturnDTO dto) {
		LoginResult loginResult = LoginResult.UNKNOWERROR;

		if (ResErrorCode.RETURN_SUCCESS_CODE.equals(dto.getStatus())) {
			loginResult = LoginResult.RETURN_SUCCESS_CODE;
			return loginResult;

		} else if (ResErrorCode.DECRYPTPARAM_ERROR_CODE.equals(dto.getStatus())) {
			loginResult = LoginResult.DECRYPTPARAM_ERROR_CODE;
			return loginResult;

		}

		if ("loginUser".equals(requestType)) {
			if (ResErrorCode.LOGIN_ERROR_AUDIT_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.NOT_APPROVED;

			} else if (ResErrorCode.LOGIN_ERROR_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.LOGIN_ERROR_CODE;

			} else if (ResErrorCode.LOGIN_ERROR_PAYCHANNEL_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.LOGIN_ERROR_PAYCHANNEL_CODE;

			} else if (ResErrorCode.LOGIN_ERROR_GET_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.LOGIN_ERROR_GET_CODE;
			}

		} else if ("updateUserPassword".equals(requestType)) {
			if (ResErrorCode.UPDATEPASSWORD_ERROR_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.CHANGE_PASSWORD_ERROR;

			}

		} else if ("getTradingRecord".equals(requestType)) {
			if (ResErrorCode.GETTRADINGRECORD_ERROR_CODE.equals(dto.getStatus())) {
				loginResult = LoginResult.GETTRADINGRECORD_ERROR_CODE;

			}
		}

		return loginResult;
	}

	/**
	 * 判断登录返回码
	 * 
	 * @param request
	 * @param user
	 * @param loginResult
	 * @param dto
	 * @param displayStyle
	 * @return
	 */
	public static LoginResult judgmentLoginResult(HttpServletRequest request, User user, LoginResult loginResult,
			ReturnDTO dto, String displayStyle) {

		String authenticationTimes = (String) request.getSession().getAttribute("authenticationTimes");
		authenticationTimes = StringUtils.isEmpty(authenticationTimes) ? "0" : authenticationTimes;

		if (LoginResult.EXE.getCode().equals(loginResult.getCode())) {
			request.getSession().setAttribute("authenticationTimes", authenticationTimes);

		} else if (LoginResult.LOGIN_ERROR_CODE.getCode().equals(loginResult.getCode())) {
			// timesAdd(request, authenticationTimes, user);

		} else if (LoginResult.VCODE_ERROR.getCode().equals(loginResult.getCode())) {
			// timesAdd(request, authenticationTimes, user);

		} else if (LoginResult.VCODE_NULL.getCode().equals(loginResult.getCode())) {
			// timesAdd(request, authenticationTimes, user);

		} else if (LoginResult.RETURN_SUCCESS_CODE.getCode().equals(loginResult.getCode())) {
			loginResult = success(request, user, loginResult, dto, displayStyle);

		}

		return loginResult;
	}

	/**
	 * 登录成功
	 * 
	 * @param request
	 * @param user
	 * @param loginResult
	 * @param dto
	 * @param displayStyle
	 * @return
	 */
	public static LoginResult success(HttpServletRequest request, User user, LoginResult loginResult, ReturnDTO dto,
			String displayStyle) {

		// 保存用户
		saveUserOfResUserAccountDTO(request.getSession(), dto, user);

		// 没有验证码才验证IP
		if ("none".equals(displayStyle)) {
			String ip = getIpAddr(request);

			if (dto.getData() instanceof ResUserAccountDTO) {
				ResUserAccountDTO temp = (ResUserAccountDTO) dto.getData();

				if (ip != null && !"".equals(ip)) {
					if (!StringUtils.isEmpty(temp.getLastLoginIp()) && !temp.getLastLoginIp().equals(ip)) {
						loginResult = LoginResult.VCODE_DIFFERENTIP;
						return loginResult;
					}
				}
			}
		}
		try {
			Subject subject = SecurityUtils.getSubject();
			UsernamePasswordToken token = new UsernamePasswordToken(user.getUsername(), user.getPassword());
			token.setRememberMe(true);
			// 身份验证
			subject.login(token);
		} catch (Exception e) {
			logger.error("验证登录错误", e);
		}

		return loginResult;
	}

	/**
	 * 返回IP地址
	 * 
	 * @param request
	 * @return
	 */
	public static String getIpAddr(HttpServletRequest request) {

		String ipAddress = request.getHeader("x-forwarded-for");

		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getHeader("Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = request.getRemoteAddr();

			if (ipAddress.equals("127.0.0.1")) {
				// 根据网卡取本机配置的IP
				InetAddress inet = null;
				try {
					inet = InetAddress.getLocalHost();

				} catch (UnknownHostException e) {
					e.printStackTrace();
				}

				ipAddress = inet.getHostAddress();
			}

		}
		// 对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
		if (ipAddress != null && ipAddress.length() > 15) {

			if (ipAddress.indexOf(",") > 0) {
				ipAddress = ipAddress.substring(0, ipAddress.indexOf(","));
			}
		}

		return ipAddress;

	}

	/**
	 * 认证失败次数增加
	 * 
	 * @param request
	 * @param times
	 * @param user
	 */
	public void timesAdd(HttpServletRequest request, String times, User user) {
		times = StringUtils.isEmpty(times) ? "0" : times;

		int count = Integer.parseInt(times);
		count += 1;

		if (count > 5) {
			logger.info("...............锁定账户4小时...............");

			logger.info("...............邮件通知用户账号异常...............");

			UtilMail se = new UtilMail(false);
			se.doSendHtmlEmail("账号异常", "<a href='http://mail.qq.com'>账户或密码输入错误超过5次，账户被锁定4个小时。</a></br>4个小时后请重新登录",
					user.getUsername());

		}

		request.getSession().setAttribute("authenticationTimes", String.valueOf(count));

	}

	/**
	 * 生成pdf文件
	 * 
	 * @param response
	 * @param tradeList
	 */
	public static void createPDF(HttpServletResponse response, List<ResQueryTradingRecordDTO> tradeList) {
		String _fileName = "reconciliationOfDocuments" + ".pdf";

		// iText 处理中文
		BaseFont _baseFont;
		try {
			_baseFont = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", false);
			// 1.创建 Document 对象
			Document _document = new Document(PageSize.A4);

			response.setContentType("application/pdf; charset=ISO-8859-1");
			response.setHeader("Content-Disposition",
					"inline; filename=" + new String(_fileName.getBytes(), "iso8859-1"));

			// 2.创建书写器，通过书写器将文档写入磁盘
			PdfWriter _pdfWriter = null;
			try {
				_pdfWriter = PdfWriter.getInstance(_document, response.getOutputStream());

			} catch (Exception e) {
				logger.info("单据生成失败，请检查服务器目录权限配置是否正确");
				e.printStackTrace();
				return;

			}
			if (_pdfWriter == null) {
				logger.info("单据生成失败，请检查服务器目录权限配置是否正确");
				return;

			}
			// 3.打开文档
			_document.open();

			PdfPTable _tabGoods = new PdfPTable(10);
			float[] columnWidth = new float[10];
			columnWidth[0] = 100;
			columnWidth[1] = 50;
			columnWidth[2] = 50;
			columnWidth[3] = 50;
			columnWidth[4] = 50;
			columnWidth[5] = 100;
			columnWidth[6] = 50;
			columnWidth[7] = 50;
			columnWidth[8] = 50;
			columnWidth[9] = 50;
			_tabGoods.setTotalWidth(600);// 设置表格的总宽度
			_tabGoods.setTotalWidth(columnWidth);// 设置表格的各列宽度
			_tabGoods.setLockedWidth(true);
			// 添加标题行
			_tabGoods.setHeaderRows(1);
			_tabGoods.addCell(new Paragraph("交易时间", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("交易编号", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("交易类型", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("摘要", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("交易对方", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("对方账号", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("金额", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("手续费", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("当时余额", new Font(_baseFont)));
			_tabGoods.addCell(new Paragraph("打印校验码", new Font(_baseFont)));
			Object[] _outTrades = tradeList.toArray();
			DecimalFormat df = new DecimalFormat("#,##0.00");

			// 将商品销售详细信息加入表格
			for (int i = 0; i < _outTrades.length; i++) {
				if ((_outTrades[i] != null) && (_outTrades[i] instanceof ResQueryTradingRecordDTO)) {
					ResQueryTradingRecordDTO temp = (ResQueryTradingRecordDTO) _outTrades[i];
					String dateTime = null;
					if (temp.getTranDate() != null) {
						dateTime = temp.getTranDate().substring(0, 4) + "-" + temp.getTranDate().substring(4, 6) + "-"
								+ temp.getTranDate().substring(6, 8) + " ";
					}
					if (temp.getTranTime() != null) {
						if (dateTime != null) {
							dateTime += temp.getTranTime().substring(0, 2) + ":" + temp.getTranTime().substring(2, 4)
									+ ":" + temp.getTranTime().substring(4, 6);
						} else {
							dateTime = temp.getTranTime().substring(0, 2) + ":" + temp.getTranTime().substring(2, 4)
									+ ":" + temp.getTranTime().substring(4, 6);
						}

					}
					_tabGoods.addCell(dateTime);
					_tabGoods.addCell(new Paragraph(String.valueOf(temp.getTellerNo()), new Font(_baseFont)));

					if ("23".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("入金", new Font(_baseFont)));
					} else if ("23".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("出金", new Font(_baseFont)));
					} else if ("15".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("转入", new Font(_baseFont)));
					} else if ("15".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("转出", new Font(_baseFont)));
					} else if ("11".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("转入", new Font(_baseFont)));
					} else if ("11".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(new Paragraph("转出", new Font(_baseFont)));
					} else {
						_tabGoods.addCell(new Paragraph("未知类型", new Font(_baseFont)));
					}

					_tabGoods.addCell(new Paragraph(temp.getMemo(), new Font(_baseFont)));
					_tabGoods.addCell(new Paragraph(temp.getAccountNm(), new Font(_baseFont)));
					_tabGoods.addCell(new Paragraph(temp.getAccountNo(), new Font(_baseFont)));

					if ("23".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("+" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else if ("23".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("-" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else if ("15".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("+" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else if ("15".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("-" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else if ("11".equals(temp.getTranType()) && "C".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("+" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else if ("11".equals(temp.getTranType()) && "D".equals(temp.getLoanFlag())) {
						_tabGoods.addCell(
								new Paragraph("-" + String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					} else {
						_tabGoods.addCell(
								new Paragraph(String.valueOf(df.format(temp.getTranAmt())), new Font(_baseFont)));
					}
					_tabGoods.addCell(
							new Paragraph("-" + String.valueOf(df.format(temp.getPdgAmt())), new Font(_baseFont)));
					_tabGoods.addCell(
							new Paragraph(String.valueOf(df.format(temp.getAccBalAmt())), new Font(_baseFont)));
					_tabGoods.addCell(new Paragraph(temp.getVerifyCode(), new Font(_baseFont)));
				}
			}

			// 5.向文档中添加内容，将表格加入文档中
			_document.add(_tabGoods);

			// 6.关闭文档
			_document.close();

		} catch (DocumentException | IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	/**
	 * 分页条件
	 * 
	 * @param request
	 * @param session
	 * @param authorService
	 * @param requestMap
	 * @param build
	 * @param build
	 * @return
	 */
	public static Map<String, String> pagingCondition(HttpServletRequest request, HttpSession session,
			AuthorService authorService) {
		String startDate = request.getParameter("btime");
		String endDate = request.getParameter("etime");

		Map<String, String> requestMap = new LinkedHashMap<>();
		StringBuilder build = new StringBuilder();

		User user = (User) session.getAttribute("user");
		if (null != user) {
			requestMap.put("userId", user.getId() + "");
			build.append(user.getId() + "");
			requestMap.put("userName", user.getUsername());
			build.append(user.getUsername());
		}

		Integer pno = null;
		if (null != request.getParameter("pno") && !"null".equalsIgnoreCase(request.getParameter("pno"))) {
			pno = Integer.parseInt(request.getParameter("pno"));
		}
		if (pno == null)
			pno = 1;

		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		if (startDate == null || "null".equalsIgnoreCase(startDate)) {
			startDate = sdf.format(date);
		}
		if (endDate == null || "null".equalsIgnoreCase(endDate)) {
			endDate = sdf.format(date);
		}

		requestMap.put("startDate", startDate);
		build.append(startDate);
		requestMap.put("endDate", endDate);
		build.append(endDate);

		requestMap.put("page", pno + "");// 第几页
		build.append(pno + "");
		requestMap.put("pageSize", "" + Integer.MAX_VALUE);// 每页显示的条数
		build.append(Integer.MAX_VALUE);
		requestMap.put("date", date.getTime() + "");// 必带的时间
		build.append(date.getTime() + "");

		Map<String, Object> map = new HashMap<String, Object>();// 外面数据map
		JSONArray arr = JSONArray.fromObject(requestMap);
		map.put("data", arr);
		JSONObject obj = JSONObject.fromObject(map);

		logger.info("请求数据 requsMap ：" + obj.toString());
		logger.info("请求数据 buildMap ：" + build.toString());

		if (Authory.token == null)
			RequestDataProxy.getAccessToken(authorService);
		Map<String, String> requestParamMap = RequestDataProxy.getRequestParam(obj.toString(), build.toString());
		return requestParamMap;
	}

	/**
	 * 得到账户余额
	 * 
	 * @param request
	 * @param userAccountService
	 * @param authorService
	 * @return
	 */
	public static ReturnDTO getUserAccount(HttpServletRequest request, UserAccountService userAccountService,
			AuthorService authorService) {
		StringBuilder build = new StringBuilder();
		// 获取登录用户信息
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		Map<String, Object> dataMap = new LinkedHashMap<String, Object>();// 里面的数据map
		Map<String, Object> map = new HashMap<String, Object>();// 外面数据map
		if (null != user) {
			Date date = new Date();
			dataMap.put("userId", user.getId() + "");
			build.append(user.getId() + "");
			dataMap.put("userName", user.getUsername());
			build.append(user.getUsername());
			dataMap.put("date", date.getTime() + "");// 必带的时间
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
	 * @param authorService
	 * @param userAccountService
	 * @return
	 */
	public static ReturnDTO checkBank(HttpServletRequest request, UserAccountService userAccountService,
			AuthorService authorService) {
		StringBuilder build = new StringBuilder();
		// 获取登录用户信息
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		Map<String, Object> dataMap = new LinkedHashMap<String, Object>();// 里面的数据map
		Map<String, Object> map = new HashMap<String, Object>();// 外面数据map
		if (null != user) {
			Date date = new Date();
			dataMap.put("userId", user.getId() + "");
			build.append(user.getId() + "");
			dataMap.put("userName", user.getUsername());
			build.append(user.getUsername());
			dataMap.put("date", date.getTime() + "");// 必带的时间
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

	/**
	 * 在session中保存用户
	 * 
	 * @param session
	 * @param dto
	 * @param user2
	 */
	public static void saveUserOfResUserAccountDTO(HttpSession session, ReturnDTO dto, User user) {
		if (dto.getData() instanceof ResUserAccountDTO) {
			ResUserAccountDTO temp = (ResUserAccountDTO) dto.getData();

			user.setId(Long.valueOf(temp.getUserId()));
			user.setUsername(temp.getUserName());
			user.setCellphone(temp.getMobilePhone());
			user.setAccountName(temp.getCompanyName());
			user.setAccountNo(temp.getAccountNo());

		}
		session.setAttribute("user", user);

	}

}
