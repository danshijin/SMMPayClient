package com.eliteams.pay.web.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.eliteams.pay.web.util.JSONUtil;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.res.DaBankDTO;
import com.smmpay.inter.dto.res.DaProvinceCityDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.BankService;

@Controller
@RequestMapping(value = "/intoGold")
public class IntoGoldController {

	private Logger logger = Logger.getLogger(RegisterController.class);

	@Resource
	private AuthorService authorService;

	@Resource
	private BankService bankService;

	@RequestMapping("/into")
	public String into(HttpServletRequest request, Model mode) {
		return "into";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/addbind")
	public String addbind(HttpServletRequest request, Model mode) {
		String accountName = request.getParameter("accountName");
		accountName = StringUtils.isEmpty(accountName)?"RainingLean":accountName;
		
		/**
		 * 调用省级信息
		 */
		String s1 = "{\"data\":[{\"checkType\":\"1\",\"userName\":\"" + accountName + "\"}]}";
		String s2 = "1" + accountName;
		Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

		ReturnDTO dto = bankService.getAllProvince(map);
		List<DaBankDTO> listBank = (List<DaBankDTO>) dto.getData();
		String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(listBank);
		request.setAttribute("AllProvince", AProvince);
		
		/**
         * 调用账户所属银行
         */
        dto = bankService.getAllBank(map);
        List<DaBankDTO> listBank1 = (List<DaBankDTO>) dto.getData();
        String bank = com.alibaba.fastjson.JSONObject.toJSONString(listBank1);
        request.setAttribute("AllBank", bank);
        
		return "addbind";
	}

	@RequestMapping("/bind")
	public String bind(HttpServletRequest request, Model mode) {
		return "bind";
	}

	@RequestMapping("/validate")
	public String validate(HttpServletRequest request, Model mode) {
		return "validate";
	}

	/**
	 * 获取市
	 * 
	 * @param request
	 * @param mode
	 */
	@RequestMapping("/getCity")
	@ResponseBody
	public String getCity(HttpServletRequest request, Model mode) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		logger.info("获取市>>参数:provinec=" + request.getParameter("provinec"));
		try {
			Date date = new Date();

			if (Authory.token == null)
				RequestDataProxy.getAccessToken(authorService);

			String s1 = "{\"data\":[{\"parentId\":\"" + request.getParameter("provinec") + "\",\"date\":\""
					+ date.getTime() + "\"}]}";
			String s2 = request.getParameter("provinec") + date.getTime();
			Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);
			ReturnDTO dto = bankService.getCitys(map);

			@SuppressWarnings("unchecked")
			List<DaProvinceCityDTO> listBank = (List<DaProvinceCityDTO>) dto.getData();

			String city = com.alibaba.fastjson.JSONObject.toJSONString(listBank);

			System.out.println("city" + city);
			rtnMap.put("info", city);

			return JSONUtil.map2json(rtnMap);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("获取city失败", e);
			return null;
		}
	}
}
