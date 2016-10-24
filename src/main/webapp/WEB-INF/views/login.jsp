<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!--[if lt IE 9]>

   <style type="text/css">

   .login-box div {
       background:transparent;
       filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#b2000000,endColorstr=#b2000000);
       zoom: 1;
    }

    </style>

<![endif]-->

<script src="<%=path %>/pay/js/page/login-soft.js" type="text/javascript"></script>
<script src="<%=path %>/pay/js/page/md5.js" type="text/javascript"></script>

<script>BASE_URL = '<%=path %>'</script>

        <div class="banner position hidden">
            <div class="web position">
                <div class="login-box">
                <div class="font16"><a href="#" class="white">企业用户登录</a></div>
                <div class="login-txt" style="height: 300px;">
                    <form>
                    	<a id="errormessage" class="block errormessage" style="visibility: hidden;"><font color="#fef1b6">AAA</font></a>
                    	<div class="clear"></div>
                        <label><span class="fa fa-user fa-lg white"></span></label><input type="text" name="username" id="username" class="login-in" value="请输入注册时填写的邮箱" /><br />
                        <div class="clear"></div>
                        <label><span class="fa fa-lock fa-lg white"></span></label><input type="password" name="password" id="password" class="login-in" /><br />
                        <div class="clear"></div>
                        
                        <a id="identifyingcode" style="display:none;border: 0px;margin: 0px;">
	                        <label><span class="fa fa-ellipsis-v fa-lg white"></span></label><input type="text" name="vCode" id="vCode" class="login-in login-in2" value="验证码" />
    	                    <img class="yzm block left" alt="点击刷新验证码" id="verifyCode" src="<%=path %>/rest/page/verifyCode" onclick="Login.verifyCode();">
        	                <div class="clear"></div>
                        </a>
                        
                        <a href="#" class="block login-btn font14" id="tLogin" onclick="Login.doLogin();">登 录</a>
                        
                        <p class="login-a"><a href="<%=path %>/rest/register/validateAccount" class="block right white font12" >立即签约</a><a href="<%=path %>/rest/user/forgetpwd" class="block right white font12">忘记密码&nbsp;&nbsp;</a></p>
                        <div class="clear"></div>
                        <!-- <a href="#" class="block error font13"><span class="fa fa-times-circle fa-lg orange">&nbsp;&nbsp;</span>请输入注册时填写的邮箱</a> -->
                        <span>&nbsp;&nbsp;</span></a>
                    </form>
                </div>
            </div>
            </div>
            <div class="position web">
                    <div class="text_u95">实时清算 资金保障</div>
            		<img class="img_157" src="<%=path %>/pay/images/u157.png">
            		<div class="text_u97">中信银行资金保障，实时划款，实时到帐</div>
            		<div class="text_u98"><a>了解详情 ></a></div>
                </div>
            <div id="scroll_jdt">
                
            	<div id="ONE" style="display: none;">
	            	<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner1.jpg" width="1920"/></a></div>
	                <div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner2.jpg" width="1920"/></a></div>
            		<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner3.jpg" width="1920"/></a></div> 
            	</div>
            	<div id="TWO" style="display: none;">
	                <div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner2.jpg" width="1920"/></a></div>
            		<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner3.jpg" width="1920"/></a></div> 
	            	<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner1.jpg" width="1920"/></a></div>
            	</div>
            	<div id="THREE" style="display: none;">
            		<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner3.jpg" width="1920"/></a></div> 
	            	<div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner1.jpg" width="1920"/></a></div>
	                <div class="ct_p_05"><a href="#"><img src="<%=path %>/pay/images/banner2.jpg" width="1920"/></a></div>
            	</div>
                	
            </div>
            <div class="position web">
                <div class="scrDotList_wrap">
                    <span class="scrDotList" id="slide_dot">
                        <span></span>
                    </span>
                </div>
            </div>
            <script type="text/javascript">
	        	$(document).ready(function() {
	        		var myArray = new Array(3);  
		            myArray[0] = "ONE";  
		            myArray[1] = "TWO";  
		            myArray[2] = "THREE"; 
	            	var num = myArray[parseInt(Math.random()*1000)%myArray.length];
	            	$("#"+num).show();
	        	});
            
				(function(){
					var focusScroll_01 = new ScrollPic();
					focusScroll_01.scrollContId   = "scroll_jdt"; //内容容器ID
					focusScroll_01.dotListId = "slide_dot";
					focusScroll_01.dotClassName = "";
					focusScroll_01.dotOnClassName = "on";
					focusScroll_01.listType       = "";//列表类型(number:数字，其它为空)
					focusScroll_01.listEvent      = "onmouseover"; //切换事件
					focusScroll_01.frameWidth     = 1920;//显示框宽度
					focusScroll_01.pageWidth      = 1920; //翻页宽度
					focusScroll_01.upright        = false; //垂直滚动
					focusScroll_01.speed          = 10; //移动速度(单位毫秒，越小越快)
					focusScroll_01.space          = 60; //每次移动像素(单位px，越大越快)
					focusScroll_01.autoPlay       = true; //自动播放
					focusScroll_01.autoPlayTime   = 5; //自动播放间隔时间(秒)
					focusScroll_01.circularly     = true;
					focusScroll_01.initialize(); //初始化
					/* document.getElementById('scroll_left').onmousedown = function(){
						focusScroll_01.pre();
						return false;
					}
					document.getElementById('scroll_right').onmousedown = function(){
						focusScroll_01.next();
						return false;
					} */
				})()
			</script>
             
        </div>
    
    <div class="main">
        <div class="web">
            <div class="index-div yahei black">
                <h1 class="index-tt"><i></i>为什么选择有色网支付系统？</h1>
                <ul class="index-ul block hidden">
                    <li><i class="block index-icon left"></i><p class="block left pt12"><span class="index-tt block pb16">大额支付</span><br /><span class="font14">面向金属行业的B2B大额支付服务<br />实现资金流与商流、物流的同步</span></p></li>
                    <li><i class="block index-icon index-icon2 left"></i><p class="block left pt12"><span class="index-tt block pb16">实时到账</span><br /><span class="font14">通过人民银行大额支付通道<br />实时提款，实时到账</span></p></li>
                    <li style="margin-right:0px"><i class="block index-icon index-icon3 left"></i><p class="block left pt12"><span class="index-tt block pb16">安全保障</span><br /><span class="font14">中信银行提供资金监管<br />资金储存企业独立账户，专款专用</span></p></li>
                </ul>
                <h1 class="index-tt"><i></i>合作伙伴</h1>
                <div class="ccb hidden">
                    <img src="<%=path %>/pay/images/ccblogo.png" class="block left" />
                    <span class="font13 block left">注册成功SMM支付系统的用户，同时设立您企业在中信银行的交易专用账户。用户仅需通过企业网银将项款存储于该账户，即可轻松交易。<br />企业资金划转均通过人行大额支付通道，实时到账。</span>
                </div>
            </div>
        </div>
    </div>
   
   
   
     <div class="black-bg" id="fade">
        <div class="alter yahei black" id="MyDiv" >
            <span class="block left fa fa-check-circle fa-2x green">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">感谢您注册有色大额支付系统！</b><br>
                <span style="font-size:18px">稍后有色网审核人员审核通过后，即进行登录进行交易！</span> 
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv','fade')">确 定</a>
        </div>
    </div>
    
 <script type="text/javascript">
$(function(){
	if("${msg }"=="success"){
	  //弹出隐藏层
	  document.getElementById("MyDiv").style.display='block';
	  document.getElementById("fade").style.display='block' ;
	  var bgdiv = document.getElementById("fade");
	  bgdiv.style.width = document.body.scrollWidth;
	  // bgdiv.style.height = $(document).height();
	  $("#fade").height($(document).height());
	}
});
	  //关闭弹出层
	  function CloseDiv(show_div,bg_div)
	  {
	  document.getElementById(show_div).style.display='none';
	  document.getElementById(bg_div).style.display='none';
	  };
	  </script>


