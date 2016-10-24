<%@page import="com.eliteams.pay.web.model.User"%>
<%@page import="com.eliteams.pay.web.util.UserCommon"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>


    <div class="main2">
        <style>
    
        </style>
        <div class="web position yahei black" >
            <div class="payment intro hidden" >
                <div class="left intro-dot"><img src="<%=path %>/pay/images/step-dot.png"/></div>
                <div class="left intro-txt">
                    <p class="intro-tt">安全支付业务介绍</p>
                    <div class="intro-content">
                        <em class="block left"><img src="<%=path %>/pay/images/intro-icon.png" /><br />安全支付</em>
                        <p class="left">有色网安全支付系统是一套基于中信银行结算系统，符合金属商品交易的大额支付体系。平<br/>台开通专属您的银行交易账户。<br/>通过平台在线支付，可为您提升资金与货品安全，提高商品交易效率，减少交易成本。</p>
                    </div>
                    <p class="intro-tt">产品特点</p>
                    <ul class="index-ul block hidden">
                        <li><i class="block index-icon left"></i><p class="block left pt12"><span class="index-tt block pb16">大额支付</span><br><span class="font14">面向金属行业的B2B大额支付服务<br>实现资金流与商流、物流的同步</span></p></li>
                        <li><i class="block index-icon index-icon2 left"></i><p class="block left pt12"><span class="index-tt block pb16">实时到账</span><br><span class="font14">通过人民银行大额支付通道<br>实时提款，实时到账</span></p></li>
                        <li style="margin-right:0px"><i class="block index-icon index-icon3 left"></i><p class="block left pt12"><span class="index-tt block pb16">安全保障</span><br><span class="font14">中信银行提供资金监管<br>资金储存企业独立账户，专款专用</span></p></li>
                    </ul>
                    <p class="intro-tt">支付流程</p>
                    <img src="<%=path %>/pay/images/intro-img.png" width="1080" class="mar-tb"/>
                    <p class="intro-tt">合作伙伴</p>
                    <img src="<%=path %>/pay/images/ccblogo.png" width="160" />
                </div>
            </div>
        </div>
    </div>

