<%@page import="com.eliteams.pay.web.model.User"%>
<%@page import="com.eliteams.pay.web.util.UserCommon"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
User user=UserCommon.isLogin(request);
String email = "";
if(user != null){
	email = user.getUsername();
}

if(email.length()>10){
	email=	email.substring(0,10)+"...";
}
String type=(String)request.getAttribute("type");
String loginType=(String)request.getAttribute("loginType");
System.out.println("type-----------="+type+",loginType="+loginType);
%>

<style>
.sign-tt {top:100px; font-family:Microsoft Yahei;color:#fff; text-align:center;  right:130px; width:216px; overflow:hidden}
.sign-tt h5{font-size:46px; line-height:80px;}
.sign-tt h6{font-size:24px; line-height:30px; font-weight:lighter}
.sign-tt a{display:block; width:195px; height:36px; line-height:36px; background:#fff; border-radius:20px; color:#0095fc; font-size:16px; margin:20px auto 0px}
.sign-main{padding:20px 0px; background:#fff}
.sign-div{background:#fff}
.sign-ul{position:absolute; width:160px; border-right:4px #e4e4e4 solid; height:100%; float:left; padding-right:20px; top:0px; left:0px}
#sign-ul{position:absolute; top:80px; left:0px}
.sign-active{background:url(<%=path %>/pay/images/sign/sign-dot.png) no-repeat; width:20px; height:20px; position:absolute; top:8px; left:172px}
.sign-ul li{text-align:right; font-family:Microsoft Yahei; font-size:16px; line-height:36px; cursor:pointer}
.sign-ul li a{color:#333; display:block}
.sign-content{width:976px; float:right;}
.sign-pic li{border-bottom:1px #e4e4e4 dotted; padding:35px 0px 25px; font-family:Microsoft Yahei;}
.sign-pic li p{font-size:20px; color:#0095fc; line-height:40px}
.sign-pic li span{font-size:14px; color:#333; line-height:28px}
.pad-t75{padding-bottom:75px}
.sign-img{margin-top:15px}
.sign-pic li a{height:20px; display:block}
</style>
<script>
window.onscroll = function(){
     var oSul = document.getElementById('sign-ul');
	 var oDot = document.getElementById('sign-active');
	 var scrollTop = document.documentElement.scrollTop || document.body.scrollTop; 
	 var oDis = parseInt(scrollTop / document.documentElement.offsetHeight * 10);
	 var aSli = oSul.getElementsByTagName('a');
	 //document.title = oDis
	 startMove(oSul, scrollTop - 500) 
	 if(oDis == 8){
	     oDis = 7
	 }
     oDot.style.top = oSul.offsetHeight * (oDis/8) + 8 + 'px'
	 for(var i=0; i<aSli.length; i++){
		 for(var i=0; i<aSli.length; i++){
			 aSli[i].style.color = ''
		 }
		 aSli[oDis].style.color = '#0095fc'
	 }
}
var timer2 = null;
	 function startMove(obj, iTarget){
		 clearInterval(obj.timer2);
		 obj.timer2 = setInterval(function(){
		 	var speed2 = (iTarget - obj.offsetTop)/6;
			speed2 = speed2 >0 ? Math.ceil(speed2) : Math.floor(speed2);
			if(obj.offsetTop ==  iTarget){
				clearInterval(timer2)
			}
			else if(iTarget <150){
				obj.style.top = 80 + 'px'
			}
			else{
			    obj.style.top = obj.offsetTop + speed2 +'px'
			}
		 },30)
	 }
window.onload = function(){
    var oDot = document.getElementById('sign-active');
	var oSul = document.getElementById('sign-ul');
	var aSli = oSul.getElementsByTagName('a');
	for(var i=0; i<aSli.length; i++){
	    aSli[i].index = i;
		aSli[i].onclick = function(){
		    for(var i=0; i<aSli.length; i++){
			    aSli[i].style.color = ''
			}
			this.style.color = '#0095fc';
			oDot.style.top = aSli[1].offsetHeight * this.index + 8 +'px'
		}
	}
}	 
	
</script>


<div id="all">
    <a id="step1"></a>
    <div class="header">
        <div class="nav">
             <div class="web">
                 <ul class="block left">
                     <li><a href="<%=path %>/rest/trade/toTrade?type=jy">支付首页</a></li>
                     <li><a href="http://mall.smm.cn/" target="_blank">有色商城</a></li>
                     <li><a href="http://www.smm.cn/" target="_blank">有色网首页</a></li>
                 </ul>
                 <ul class="block right">
                     <li><a href="#">在线客服</a></li>
                     <li><a href="<%=path %>/rest/common/howtoSing">如何签约</a></li>
                     <li style="margin-right:0px"><a href="<%=path %>/rest/common/introduce">帮助中心</a></li>
                 </ul>
             </div>
        </div>
        <div class="logo">
            <div class="web hidden">
                <img src="<%=path %>/pay/images/sign/pay-logo.png" class="block left" />
                <a href="<%=path %>/rest/register/validateAccount" target="_blank" class="block right singup font14 white"><i class="fa fa-user white fa-lg"></i>立即签约</a>
            </div>
        </div>
        <div class="position hidden">
            <div id="scroll_jdt">
                <div class="web position">
                        <div class="login-box sign-tt">
                            <h5>企业签约</h5>
                            <h6>方便快捷的开通服务</h6>
                            <a href="<%=path %>/rest/register/validateAccount" target="_blank">立即签约</a>
                        </div> 
                    </div>
                <div class="ct_p_05">
                    <img src="<%=path %>/pay/images/sign/banner2.jpg" width="1920"/>
                    
                </div>
                
            </div>
        </div>
    </div>
    <div class="main sign-main">
    
        <div class="web position hidden">
            <div class="sign-ul" >
                <ul id="sign-ul">
                     <li class="position"><a href="#step1" style="color:#0095fc">注册流程图</a><p class="sign-active" id="sign-active"></p></li>
                     <li><a href="#step2">注册商城用户</a></li>
                     <li><a href="#step3">点击邮件中激活链接</a></li>
                     <li><a href="#step4">直接签约安全支付</a></li>
                     <li><a href="#step5">输入关联的商城用户名</a></li>
                     <li><a href="#step6">完善企业信息</a></li>
                     <li><a href="#step7">同意安全支付电子协议</a></li>
                     <li><a href="#step8">系统审核开通</a></li>
                </ul>
            </div>
            
            <div class="sign-content position"> 
                <ul class="sign-pic" id="sign-pic">
                    <li class="pad-t75"><img src="<%=path %>/pay/images/sign/sign-step.png" /></li>
                    <a id="step2"></a>
                    <li>
                        <p>注册商城用户（方式一）</p>
                        <span>商城用户注册时勾选开通安全支付，并填写您企业财务人员的邮箱</span>
                        <img src="<%=path %>/pay/images/sign/sign-img1.png" class="sign-img"/><a id="step3"></a>
                    </li>
                    <li>
                        <p>点击邮件中的激活链接（方式一）</p>
                        <span>企业财务收到邮件后，点击邮件中的激活链接</span>
                        <img src="<%=path %>/pay/images/sign/sign-img2.png" class="sign-img"/><a id="step4">
                    </li>
                    <li>
                        <p></a>直接签约安全支付（方式二）</p>
                        <span>点击页面中的“立即签约”按钮，进入签约页面</span>
                        <img src="<%=path %>/pay/images/sign/sign-img3.png" class="sign-img"/><a id="step5"></a>
                    </li>
                    <li>
                        <p>输入关联的商城用户名（方式二）</p>
                        <span>输入您企业的相关企业邮箱，和对应的商城业务人员账号</span>
                        <img src="<%=path %>/pay/images/sign/sign-img4.png" class="sign-img"/><a id="step6"></a>
                    </li>
                    <li>
                        <p>完善企业信息</p>
                        <span>录入您的企业信息和相关的证照影印件</span>
                        <img src="<%=path %>/pay/images/sign/sign-img5.png" class="sign-img"/><a id="step7"></a>
                    </li>
                    <li>
                        <p>同意安全支付用户协议</p>
                        <span>查阅安全支付用户电子协议</span>
                        <img src="<%=path %>/pay/images/sign/sign-img6.png" class="sign-img"/><a id="step8"></a>
                    </li>
                    <li>
                        <p>系统审核开通</p>
                        <span>通过有色网和中信银行审核后，开通支付账号并同时开通中信银行交易专用账户</span>
                        <img src="<%=path %>/pay/images/sign/sign-img7.png" class="sign-img"/>
                    </li>
                </ul>
            </div>
        </div>
        <div class="clear"></div>
    </div>
    <div class="footer font13 yahei">
        <div class="web">
            <div class="index-div">
                <span class="block left">
                    <a href="#" class="white">关于我们</a>
                    <a href="#" class="white">联系我们</a>
                    <a href="#" class="white">服务协议</a>
                    <a href="#" class="white">帮助中心</a>
                </span>
                <span class="block left gray">增值电信业务经营许可证：沪B2-20120059   沪ICP备09002236号-1</span>
            </div>
        </div>
    </div>
</div>

