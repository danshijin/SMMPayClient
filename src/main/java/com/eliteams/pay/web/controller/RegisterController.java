package com.eliteams.pay.web.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.eliteams.pay.web.util.ImageTypeCheck;
import com.eliteams.pay.web.util.JSONUtil;
import com.eliteams.pay.web.util.URLRequest;
import com.smmpay.common.author.Authory;
import com.smmpay.common.request.RequestDataProxy;
import com.smmpay.inter.AuthorService;
import com.smmpay.inter.dto.req.UserAccountDTO;
import com.smmpay.inter.dto.res.DaBankDTO;
import com.smmpay.inter.dto.res.DaProvinceCityDTO;
import com.smmpay.inter.dto.res.ReturnDTO;
import com.smmpay.inter.smmpay.BankService;
import com.smmpay.inter.smmpay.UserAccountService;

/**
 * @author xumengxi
 */
@Controller
@RequestMapping("/register")
public class RegisterController {
    private Logger             logger = Logger.getLogger(RegisterController.class);
    @Resource
    private UserAccountService userAccountService;
    @Resource
    private AuthorService      authorService;
    @Resource
    private BankService        bankService;

    @Value("#{ch['validateUser.URL']}")
    private String             validateUser;

    @Value("#{message['photopath']}")
    private String             photopath;

    @Value("#{message['uploadpath']}")
    private String             uploadpath;

    Date                       date   = new Date();
    @Value("#{ch['realdownloadpath']}")
    private String             realdownloadpath;

    /**
     * 注册第一个页面
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/validateAccount")
    public ModelAndView validateAccount(HttpServletRequest request, Model mode) {
        ModelAndView mav = new ModelAndView();
        request.setAttribute("userNo", request.getParameter("userNo"));
        mav.setViewName("register.validateAccount");
        return mav;
    }

    /**
     * 注册第二个页面
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/registerUser")
    public ModelAndView RegisterUser(HttpServletRequest request, Model mode) {
        String accountNo = request.getParameter("accountNo");
        String accountName = request.getParameter("accountName");

        if (accountNo != null && !"".equals(accountNo) && accountName != null && !"".equals(accountName)) {//将上一个页面的参数放到session里
            request.getSession().setAttribute("accountNo", accountNo);
            request.getSession().setAttribute("accountName", accountName);
        }

        if (Authory.token == null)
            RequestDataProxy.getAccessToken(authorService);

        /**
         * 调用省级信息
         */
        String s1 = "{\"data\":[{\"parentId\":\"111\"}]}";
        String s2 = "111";
        Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

        ReturnDTO dto = bankService.getAllProvince(map);
        List<DaProvinceCityDTO> listAProvince = (List<DaProvinceCityDTO>) dto.getData();
        String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(listAProvince);
        request.setAttribute("AllProvince", AProvince);

        /**
         * 调用账户所属银行
         */

        dto = bankService.getAllBank(map);
        List<DaBankDTO> listBank = (List<DaBankDTO>) dto.getData();
        String bank = com.alibaba.fastjson.JSONObject.toJSONString(listBank);
        request.setAttribute("AllBank", bank);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("register.registerUser");
        return mav;
    }

    /**
     * 获取市
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/getCity")
    @ResponseBody
    public String getCity(HttpServletRequest request, Model mode) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("获取市>>参数:provinec=" + request.getParameter("provinec"));
        try {
            if (Authory.token == null)
                RequestDataProxy.getAccessToken(authorService);

            String s1 = "{\"data\":[{\"parentId\":\"" + request.getParameter("provinec") + "\",\"date\":\""
                    + date.getTime() + "\"}]}";
            String s2 = request.getParameter("provinec") + date.getTime();
            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);
            ReturnDTO dto = bankService.getCitys(map);
            List<DaProvinceCityDTO> listcity = (List<DaProvinceCityDTO>) dto.getData();
            String city = com.alibaba.fastjson.JSONObject.toJSONString(listcity);

            System.out.println("city" + city);
            rtnMap.put("info", city);
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("获取city失败", e);
            return null;
        }
    }

    /**
     * 获取开户行
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping(value = "/getDepositBank", method = RequestMethod.POST)
    @ResponseBody
    public String getDepositBank(HttpServletRequest request, Model mode) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("开户行关键字>>参数=" + request.getParameter("bankName"));
        try {
            String bankBlongs = request.getParameter("bankBlongs");//输入的关键字
            String selCity = request.getParameter("selCity");
            String bankName = request.getParameter("bankName");

            String s1 = "{\"data\":[{\"cityId\":\"" + selCity + "\",\"bankKind\":\"" + bankBlongs
                    + "\",\"shortName\":\"" + bankName + "\",\"date\":\"" + date.getTime() + "\"}]}";
            String s2 = selCity + bankBlongs + bankName + date.getTime();

            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);
            ReturnDTO dto = bankService.getBankByCityLike(map);

            List<DaBankDTO> listBank = (List<DaBankDTO>) dto.getData();

            /*
             * listBank = new ArrayList<>(); DaBankDTO e1 = new DaBankDTO();
             * DaBankDTO e2 = new DaBankDTO(); DaBankDTO e3 = new DaBankDTO();
             * DaBankDTO e4 = new DaBankDTO(); DaBankDTO e5 = new DaBankDTO();
             * e1.setId(1); e2.setId(2); e3.setId(3); e4.setId(4); e5.setId(5);
             * e1.setEngName("天气不咋地"); e2.setEngName("今天天气号码");
             * e3.setEngName("你的手机号码是多少"); e4.setEngName("还没有买没有手机");
             * e5.setEngName("那买了什么东西"); listBank.add(e1); listBank.add(e2);
             * listBank.add(e3); listBank.add(e4); listBank.add(e5);
             */

            String banknames = com.alibaba.fastjson.JSONObject.toJSONString(listBank);
            logger.info("开户行=" + banknames);
            System.out.println(s1);
            rtnMap.put("info", banknames);
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("获取开户行失败", e);
            return null;
        }

    }

    /**
     * 校验账户
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/validateName")
    @ResponseBody
    public String validateName(HttpServletRequest request, Model mode) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("校验账户>>参数:name=" + request.getParameter("accountName"));

        if (Authory.token == null)
            RequestDataProxy.getAccessToken(authorService);

        String s1 = "{\"data\":[{\"checkType\":\"1\",\"userName\":\"" + request.getParameter("accountName") + "\"}]}";
        String s2 = "1" + request.getParameter("accountName");
        Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

        ReturnDTO dto = userAccountService.checkUser(map);

        System.out.println(dto.getMsg());
        System.out.println(dto.getStatus());

        rtnMap.put("info", dto.getStatus().equals("000000") ? "success" : "Failure");

        try {
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("校验账户失败", e);
            return null;
        }
    }

    /**
     * 校验商城账号
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/validateNo")
    @ResponseBody
    public String validateNo(HttpServletRequest request, Model mode) {
        Map<String, Object> rtnMap = new HashMap<String, Object>();
        logger.info("校验账号>>参数:No=" + request.getParameter("accountNo"));
        try {
            if (Authory.token == null)
                RequestDataProxy.getAccessToken(authorService);

            String s1 = "{\"data\":[{\"checkType\":\"2\",\"mallUserName\":\"" + request.getParameter("accountNo")
                    + "\"}]}";
            String s2 = "2" + request.getParameter("accountNo");
            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);

            ReturnDTO dto = userAccountService.checkUser(map);

            Map<String, String> usermap = new HashMap<String, String>();
            //校验账号是否在商城存在
            usermap.put("username", request.getParameter("accountNo"));
            String rtnAddUser = URLRequest.post(validateUser, usermap);
            JSONObject obj = JSONObject.fromObject(rtnAddUser);

            rtnMap.put("userinfo", obj.get("errno"));
            //            rtnMap.put("userinfo", "0");
            rtnMap.put("info", dto.getStatus().equals("000000") ? "success" : "Failure");
            logger.info("是否存在=" + obj.get("errno"));
            return JSONUtil.map2json(rtnMap);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("校验商城账号失败", e);
            return null;
        }
    }

    /**
     * 校验code
     * 
     * @param request
     * @param mode
     * @return
     */
    @RequestMapping("/validatecode")
    public ModelAndView validatecode(HttpServletRequest request, Model mode) {
        ModelAndView mav = new ModelAndView();
        logger.info("code>>参数:code=" + request.getParameter("code"));
        try {
            if (Authory.token == null)
                RequestDataProxy.getAccessToken(authorService);

            if (request.getParameter("code") == null || "".equals(request.getParameter("code"))) {
                mav.setViewName("register.validateAccount");
                return mav;
            }

            //根据coding查询账户名称和账号
            String usernameString = "";
            String usernoString = "";

            String s1 = "{\"data\":[{\"code\":\"" + request.getParameter("code") + "\"}]}";
            String s2 = request.getParameter("code");
            Map<String, String> map = RequestDataProxy.getRequestParam(s1, s2);
            ReturnDTO dto = userAccountService.getUserByCode(map);

            if (!dto.getStatus().equals("000000")) {
                mav.setViewName("register.validateAccount");
                return mav;
            }

            //查询名称和账号是否存在
            JSONObject obj = JSONObject.fromObject(dto.getData());

            usernameString = (String) obj.get("userName");
            usernoString = (String) obj.get("mallUserName");

            s1 = "{\"data\":[{\"checkType\":\"1\",\"userName\":\"" + usernameString + "\"}]}";
            s2 = "1" + usernameString;
            map = RequestDataProxy.getRequestParam(s1, s2);
            dto = userAccountService.checkUser(map);

            if (!dto.getStatus().equals("000000")) {
                mav.setViewName("register.validateAccount");
                return mav;
            }

            s1 = "{\"data\":[{\"checkType\":\"2\",\"mallUserName\":\"" + usernoString + "\"}]}";
            s2 = "2" + usernoString;
            map = RequestDataProxy.getRequestParam(s1, s2);
            dto = userAccountService.checkUser(map);
            if (!dto.getStatus().equals("000000")) {
                mav.setViewName("register.validateAccount");
                return mav;
            }

            request.setAttribute("accountName", usernameString);
            request.setAttribute("accountNo", usernoString);

            /**
             * 调用省级信息
             */
            s1 = "{\"data\":[{\"parentId\":\"111\"}]}";
            s2 = "111";
            map = RequestDataProxy.getRequestParam(s1, s2);
            dto = bankService.getAllProvince(map);
            List<DaBankDTO> listAProvince = (List<DaBankDTO>) dto.getData();
            String AProvince = com.alibaba.fastjson.JSONObject.toJSONString(listAProvince);
            System.out.println("AProvince " + AProvince);
            request.setAttribute("AllProvince", AProvince);

            /**
             * 调用账户所属银行
             */

            dto = bankService.getAllBank(map);
            List<DaBankDTO> listBank = (List<DaBankDTO>) dto.getData();
            String bank = com.alibaba.fastjson.JSONObject.toJSONString(listBank);
            System.out.println("bank " + bank);
            request.setAttribute("AllBank", bank);

            mav.setViewName("register.registerUser");
            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            logger.error("校验code方法失败", e);
            return null;
        }
    }

    //上传
    @RequestMapping("/uploadmethod")
    @ResponseBody
    public String uploadmethod(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map<String, Object> rtnMap = new HashMap<String, Object>();

//        String urlString = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
//                + request.getContextPath() + "/pay/papersPhoto/";

        String newRealFileName = null;
        String ftype=request.getParameter("ftype");
        try {
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            CommonsMultipartFile file = null;
           // String filetype = "businessLicense";//营业执照
            if(ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==1){
            	 file = (CommonsMultipartFile) multipartRequest.getFile("fileField1");
            }
            if (ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==2) {
                file = (CommonsMultipartFile) multipartRequest.getFile("fileField2");
               /// filetype = "idCard";//身份证影件
            }
            if (ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==3) {
                file = (CommonsMultipartFile) multipartRequest.getFile("fileField3");
               // filetype = "taxRegistration";//税务登记影件
            }
            if (ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==4) {
                file = (CommonsMultipartFile) multipartRequest.getFile("fileField4");
               /// filetype = "proxy";//委托书
            }
            if (ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==5) {
                file = (CommonsMultipartFile) multipartRequest.getFile("fileField5");
               /// filetype = "file53";//银行基本开户证明
            }
            if (ftype!=null&&!ftype.equals("")&&Integer.valueOf(ftype)==6) {
                file = (CommonsMultipartFile) multipartRequest.getFile("fileField6");
               // filetype = "file6";//税务登记影件四证合一
            }
            if(file==null){
                rtnMap.put("info", "请选择上传文件");
                return JSONUtil.map2json(rtnMap);
            }
            // 获得文件名： 
            String realFileName = file.getOriginalFilename();
            if(realFileName==null||"".equals(realFileName)){
                rtnMap.put("info", "请选择上传文件");
                return JSONUtil.map2json(rtnMap);
            }
            
            
            
            
            String suffixFlag = realFileName.substring(realFileName.indexOf("."));
            suffixFlag = suffixFlag.toLowerCase();

            newRealFileName = new Date().getTime() + "." + FilenameUtils.getExtension(realFileName);
            /**
             * 第一层拦截：直接获取文件名字判断是否是图片文件
             */
            if (!suffixFlag.contains("jpg") && !suffixFlag.contains("bmp") && !suffixFlag.contains("jpeg")
                    && !suffixFlag.contains("gif") && !suffixFlag.contains("tiff") && !suffixFlag.contains("psd")
                    && !suffixFlag.contains("tga") && !suffixFlag.contains("png") && !suffixFlag.contains("eps")) {
                rtnMap.put("info", "请确认上传的文件是图片格式");
                return JSONUtil.map2json(rtnMap);
            }
            
            /**
             * 第二层拦截:用文件头判断图片格式
             */
            
             byte[] bt = new byte[4];
        	 bt=Arrays.copyOf(file.getBytes(), 4);
        	 String str = ImageTypeCheck.getPicType(bt);
             if(str!=null){
            	 if(str.contains("noimg")){
            		 rtnMap.put("info", "只支持以下图片格式:jpg、jpeg、png、gif、bmp");
                     return JSONUtil.map2json(rtnMap);
            	 }
             }else{
            	 rtnMap.put("info", "请确认上传的文件是图片格式");
                 return JSONUtil.map2json(rtnMap);
             }
             
            
             /**
              *第三层拦截:获取图片宽高。 如果连宽高属性都没有，那肯定不是图片
              */
            /*Image img= ImageIO.read( file.getInputStream());
             img.getWidth(null);*/

            // 获取路径 
            //            String ctxPath = request.getSession().getServletContext().getRealPath("//") + "//pay//papersPhoto//" + "//";

            //下载路径
            //            String ctxPath = request.getScheme() + "://" + request.getLocalAddr() + ":" + request.getLocalPort()
            //                    + photopath;
            String ctxPath = realdownloadpath + photopath;
            logger.info("下载文件的路径》》" + ctxPath);
            // 创建文件 
            File dirPath = new File(uploadpath);
            if (!dirPath.exists()) {
                dirPath.mkdir();
            }
            File uploadFile = new File(uploadpath + newRealFileName);
            FileCopyUtils.copy(file.getBytes(), uploadFile);
            rtnMap.put("info", "上传成功");
            rtnMap.put("fileurl", ctxPath + newRealFileName);
            rtnMap.put("FileName", newRealFileName);
            //    }
        } catch (Exception e) {
        	e.printStackTrace();
            logger.error("图片上传出错 ", e);
            rtnMap.put("info", "图片上传出错");
        }
        return JSONUtil.map2json(rtnMap);
    }
    @RequestMapping(value = "/registerForm")
    @ResponseBody
    public String registerForm(@ModelAttribute UserAccountDTO userAccountDTO, HttpServletRequest request) {
    	Map<String, Object> rtnMap = new HashMap<String, Object>();
        String selProvince = request.getParameter("selProvince");//省
        String selCity = request.getParameter("selCity");//市
        String bankBlongs = request.getParameter("bankBlongs");//所属银行
        String bankid = request.getParameter("bankshortName");//开户id
        String accountName = request.getParameter("accountName");//账户名
        String accountNo = request.getParameter("accountNo");//商城账户

        String fileField1Text = request.getParameter("fileField1Text");
        String fileField2Text = request.getParameter("fileField2Text");
        String fileField3Text = request.getParameter("fileField3Text");
        String fileField4Text = request.getParameter("fileField4Text");
        String bankOpenUrl = request.getParameter("fileField5Text");  // 银行基本开户证明
        String threeCertificatesUrl = request.getParameter("fileField6Text"); // 多证合一营业执照影印件
        String isCommon = request.getParameter("isCommon"); // 多证合一营业执照影印件
        String registerip = getIpAddr(request);

        if (Authory.token == null)
            RequestDataProxy.getAccessToken(authorService);
        Date date = new Date();
        String s="";
        String signString="";
        s = "{\"data\":[{\"userName\":\"" + accountName 
    		+ "\",\"password\":\"" + userAccountDTO.getPassword()
            + "\",\"mallUserName\":\"" + accountNo 
            + "\",\"certificateNo\":\"" + userAccountDTO.getCertificateNo() 
            + "\",\"companyName\":\"" + userAccountDTO.getCompanyName() 
            + "\",\"companyAddr\":\"" + userAccountDTO.getCompanyAddr() 
            + "\",\"contactName\":\"" + userAccountDTO.getContactName()
            + "\",\"phone\":\"" + userAccountDTO.getPhone() 
            + "\",\"mobilePhone\":\"" + userAccountDTO.getMobilePhone() 
            + "\",\"postCode\":\"" + userAccountDTO.getPostCode() 
            + "\",\"bankTypeId\":\"" + bankBlongs 
            + "\",\"provinceId\":\"" + selProvince 
            + "\",\"cityId\":\"" + selCity
	        + "\",\"bankAccountNo\":\"" + userAccountDTO.getBankAccountNo()
	        + "\",\"registerIp\":\"" + registerip
	        + "\",\"isCommon\":\"" + isCommon
	        + "\",\"date\":\"" + date.getTime();
        
        signString = accountName 
 			+ userAccountDTO.getPassword() 
 			+ accountNo + userAccountDTO.getCertificateNo()
	        + userAccountDTO.getCompanyName() 
	        + userAccountDTO.getCompanyAddr()
	        + userAccountDTO.getContactName() 
	        + userAccountDTO.getPhone() 
	        + userAccountDTO.getMobilePhone()
	        + userAccountDTO.getPostCode() 
	        + bankBlongs 
	        + selProvince 
	        + selCity 
	        + userAccountDTO.getBankAccountNo() 
	        + registerip
	        + isCommon
	        + date.getTime();
        if(StringUtils.isNotBlank(bankid)){
      		s += "\",\"bankId\":\"" + bankid;
            signString += bankid;
        }
        
        if(StringUtils.isNotBlank(isCommon) && isCommon.equalsIgnoreCase("false")){
        	s += "\",\"certificateUrl\":\"" + fileField1Text 
		        + "\",\"idCardUrl\":\"" + fileField2Text 
		        + "\",\"registerCertificateUrl\":\"" + fileField3Text 
		        + "\",\"bankOpenUrl\":\"" + bankOpenUrl
		        + "\",\"authorizeUrl\":\"" + fileField4Text;
        	signString += fileField1Text
        			+ fileField2Text
        			+ fileField3Text
        			+ bankOpenUrl
        			+ fileField4Text;
        } else {
        	s += "\",\"threeCertificatesUrl\":\"" + threeCertificatesUrl
        		+ "\",\"bankOpenUrl\":\"" + bankOpenUrl
        		+ "\",\"authorizeUrl\":\"" + fileField4Text;
        	signString += threeCertificatesUrl
        			+ bankOpenUrl
        			+ fileField4Text;
        }
        s += "\"}]}";   // 结束符
        Map<String, String> map = RequestDataProxy.getRequestParam(s, signString);
        ReturnDTO dto = userAccountService.registerUser(map);

        
        logger.info("注册信息：" + signString);
        logger.info("注册状态：" + dto.getMsg());
        logger.info("注册状态代码：" + dto.getStatus());

        rtnMap.put("status", dto.getStatus().equals("000000") ? "ok" : "faild");
        
        rtnMap.put("msg", dto.getMsg());
		String result = "";
        try {
        	result = JSONUtil.map2json(rtnMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
    }
    
    @RequestMapping(value = "/success")
    public ModelAndView success(HttpServletRequest request, Model mode) {
        ModelAndView mav = new ModelAndView();
        request.setAttribute("msg", "success");
        mav.setViewName("register.registerUser");
        return mav;
    }

    /**
     * 获取客户端ip
     * 
     * @param request
     * @return
     */
    public String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /**
     * 下载远程文件并保存到本地
     * 
     * @param remoteFilePath 远程文件路径
     * @param localFilePath 本地文件路径
     */
    @RequestMapping(value = "/downloadLocal")
    public void downloadLocal(HttpServletResponse response, HttpServletRequest request) throws Exception {
        logger.info("开始下载文件》》》》");
        //        String filePath = request.getSession().getServletContext().getRealPath("//") + "//pay//word/企业操作员授权委托书.docx";
        //        String filePath = request.getScheme() + "://" + request.getLocalAddr() + ":" + request.getLocalPort()
        //                + uploadpath + "企业操作员授权委托书.docx";

        String filePath = null;
        try {
            String os = System.getProperties().getProperty("os.name");
            logger.info("os.startsWith=" + os);
            if (os.startsWith("win") || os.startsWith("Win")) {
                filePath = request.getSession().getServletContext().getRealPath("") + "\\pay\\word\\企业操作员授权委托书.docx";
            } else {

                filePath = request.getSession().getServletContext().getRealPath("") + "/pay/word/企业操作员授权委托书.docx";
            }
            logger.info("下载文件的路径》》》》" + filePath);
            // 下载本地文件
            String fileName = "企业操作员授权委托书.docx".toString(); // 文件的默认保存名
            // 读到流中
            InputStream inStream = new FileInputStream(filePath);// 文件的存放路径
            // 设置输出的格式
            response.reset();
            response.setContentType("bin");
            response.setHeader("Content-Disposition",
                    "attachment; filename=" + java.net.URLEncoder.encode(fileName, "UTF-8"));

            // 循环取出流中的数据
            byte[] b = new byte[100];
            int len;
            while ((len = inStream.read(b)) > 0)
                response.getOutputStream().write(b, 0, len);
            inStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
