<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

        
        
    </div>
    <div class="main2">
        <div class="web position yahei black" >
            <div class="payment" >
                <p class="index-tt pay-tt"><i></i>找回密码<span class="right gray font14" style="padding-top:10px">客服电话： 021-12345678</span></p>
                <ul class="step step2 block font14">
                    <li class="step-li-b"><a href="#" class="white">填写账户名</a></li>
                    <li class="step-li-w"><a href="#" class="white">查收验证邮件</a></li>
                    <li class="step-li-w"><a href="#" class="black">重置密码</a></li>
                    <li class="step-li-b"><a href="#" class="black">完成</a></li>
                </ul>
                <div class="regist-box font16" style="border-bottom:none; padding:78px 0px 49px 0px">
                    <div class="yahei black" style="margin:0px auto; width:100%; text-align:center">
                        <span class="block fa fa-check-circle fa-2x green" style="vertical-align:middle">&nbsp;&nbsp;</span>
                        <span class="block" style="font-size:18px">
                            验证邮件已发送至${userName} 请登陆您的邮件查收验证邮件
                        </span>
                        <div class="clear"></div>
                        <a href="/rest/trade/toTrade?type=jy" class="close-btn">返回首页</a>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
>

