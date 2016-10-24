<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<script type="text/javascript">
var AccountNoPass=false;
function validateAccountName(){
	 var accountName = $('#accountName').val();
	 if(accountName==""){
		 AccountNoPass=false
		 return ;
	 }
	var re3 = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
	 if(!re3.test(accountName)){
		AccountNoPass=false;
	  	 $("#validateSpan1").show();
	     $("#imgError").show();	
	     $("#imgSuccess").hide();
	     //$("#validateSymbo1").attr('class','fa fa-times-circle red');//不通过，红色标志
	     $("#validateSpan1").attr('class','red font12');
	     $("#validateSpan1").text("请输入正确的邮箱格式");
	       return;
	 }else{
		 $("#validateSpan1").hide();
	     $("#imgError").hide();
	     $("#imgSuccess").hide();
		 $.ajax({
				url : "<%=path %>/rest/user/checkMail",
				type : "post",
				dataType : "json",
				data :{
					"userEmail":accountName
				},
				success : function(data) {
					if(data.info=='faild'){
						$("#validateSpan1").show();
				     	$("#imgError").show();	
				     	$("#imgSuccess").hide();
				     	//$("#validateSymbo1").attr('class','fa fa-times-circle red');//不通过，红色标志
				     	return;
					}else{
						$("#validateSpan1").hide();
						 $("#imgSuccess").show();
						 $("#imgError").hide();
			  		     //$("#validateSymbo1").attr('class','fa fa-check-circle green');//通过，绿色标志
						 AccountNoPass=true;
					}
				}
			}); 
	 }  	  
}



</script>


<%-- 	<!------------------------- 滑动JS 请修改效果 ----------------------------->
 <script type="text/javascript">
 	$(function() {
			var iPhone = document.getElementById("iphone");
			var oLock = document.getElementById("lock");
			var oBtn = oLock.getElementsByTagName("span")[0];
			var disX = 0;
			var maxL = oLock.clientWidth + 10;
			var oBg = document.createElement("img");
			oBg.src = "<%=path %>/pay/images/passed.png";//预加载下第二张背景，其它没什么大用。
			
			
			oBtn.onmousedown = function (e){
				var e = e || window.event;
				disX = e.clientX - this.offsetLeft;
				document.onmousemove = function (e){
					var e = e || window.event;
					var l = e.clientX - disX;
					l < 0 && (l = 0);
					l > maxL && (l = maxL);
					oBtn.style.left = l + "px";
					oBtn.offsetLeft == maxL && (iPhone.style.background = "url("+ oBg.src +")", oLock.style.display = "none");
					return false;
				};
				
				document.onmouseup = function (){
					document.onmousemove = null;
					document.onmouseup = null;
					oBtn.releaseCapture && oBtn.releaseCapture();
					oBtn.offsetLeft > maxL / 2 ?
					startMove(maxL, function (){
						iPhone.style.background = "url("+ oBg.src +")";
						oLock.style.display = "none"
					}) :
					startMove(0)
				};
				this.setCapture && this.setCapture();
				return false
			};
			
			function startMove (iTarget, onEnd){
				clearInterval(oBtn.timer);
				oBtn.timer = setInterval(function (){
					doMove(iTarget, onEnd)
				}, 10)
			}
			
			function doMove (iTarget, onEnd){
				var iSpeed = (iTarget - oBtn.offsetLeft) / 5;
				iSpeed = iSpeed > 0 ? Math.ceil(iSpeed) : Math.floor(iSpeed);
				iTarget == oBtn.offsetLeft ? (clearInterval(oBtn.timer), onEnd && onEnd()) : oBtn.style.left = iSpeed + oBtn.offsetLeft + "px";
				$("#imgError3").css('display','none');
				$("#validateSpan3").css('display','none');
				$("#imgSuccess3").show();
				
			}
 	});
</script> --%>

<script type="text/javascript">
	$(document).ready(function(){
        $("#QapTcha").QapTcha({disabledSubmit:true},'<%=basePath%>');
    });
</script>

<script type="text/javascript" src="<%=path %>/pay/QapTcha/js/jquery.js"></script>
<script type="text/javascript" src="<%=path %>/pay/QapTcha/js/jquery-ui.js"></script>
<script type="text/javascript" src="<%=path %>/pay/QapTcha/js/jquery.ui.touch.js"></script>
<script type="text/javascript" src="<%=path %>/pay/QapTcha/js/QapTcha.jquery.js"></script>
<script type="text/javascript" src="<%=path %>/pay/QapTcha/js/jquery.hoverIntent.minified.js"></script>
<link type="text/css" rel="stylesheet" href="<%=path %>/pay/QapTcha/css/QapTcha.jquery.css" />
        
    <div class="main2">
        <div class="web position yahei black">
            <div class="payment">
                <p class="index-tt pay-tt"><i></i>欢迎签约SMM支付系统服务</p>
                <ul class="step block font14">
                    <li class="step-li-b"><a href="#" class="white">填写账户名</a></li>
                    <li class="step-li-w"><a href="#" class="black">查收验证邮件</a></li>
                    <li class="step-li-w"><a href="#" class="black">填写邮件中的验证码</a></li>
                    <li class="step-li-b"><a href="#" class="black">重置密码</a></li>
                </ul>
                <div class="regist-box font16">
                    <form>
                        <label>账户名</label><input type="text" onblur="validateAccountName()"  id="accountName" class="inform">
                       <img id="imgError" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
                       <img id="imgSuccess" src="<%=path %>/pay/images/succ.jpg" style="display: none"/>
                       <span id="validateSpan1" style="display:none" class="red font12">无此邮箱账户</span><br>
                       <%-- <br><label></label><div href="#" class="block slider-box gray2" id="iphone"><div id="lock"><span href="#" class="block slider"><i class="fa fa-angle-double-right fa-2x"></i></span>请拖动滑块验证</div></div>
						<div href="#" class="block slider-box2 gray2" id="iphone">
							<img id="imgError3" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
							<span id="validateSpan3" style="display: none" class="red font12">请拖动滑块验证</span>
							<img id="imgSuccess3" src="<%=path %>/pay/images/succ.jpg" style="display: none"/>
						</div> --%>
						
						<label></label><div href="#" class="block gray2">
							<div class="QapTcha" id="QapTcha" style="width:auto"></div>
						</div>
	
				<div style="padding-left:180px">
								<div id="div_geetest_lib"></div>	
								<div id="div_id_embed" ></div>
								<script type="text/javascript">
								function geetest_ajax_results() {
									var accountName = $('#accountName').val();
									 if( !AccountNoPass){
										 $("#validateSpan1").show();
									     $("#validateSymbo1").show();
									     $("#validateSymbo1").attr('class','fa fa-times-circle red');//不通过，红色标志
									     $("#validateSpan1").attr('class','red font12');
									     $("#validateSpan1").text("请输入正确的账户");
								 		return;
									}
									 
									var url = document.getElementById("bgSlider").style.backgroundImage;
									if(url.indexOf("backgroundyz1.png") <= 0){
										return;
									}
									 
								    /* if($("#imgSuccess3").css('display') == 'none'){
								 		$("#imgError3").show();
								 		$("#validateSpan3").show();
								 		return ;
								 	} */
								    
								 	location="<%=path %>/rest/user/sendMail?userName="+accountName;
									 
									<%-- else{
										$.ajax({
											url : "<%=path %>/rest/verify/verifyServlet",
											type : "post",
											dataType : "json",
											data : gt_captcha_obj.getValidate(),
											success : function(sdk_result) {
												if(sdk_result.info!="success"){
											        openAlert("尚未通过滑动验证!");
													return;
												}else{
													location="<%=path %>/rest/user/sendMail?userName="+accountName;
												}
											}
										});
									} --%>
								
										
								
									
								}
								
								<%-- function verifyServlet(){}
									var gtFailbackFrontInitial = function(result) {
										var s = document.createElement('script');
										s.id = 'gt_lib';
										s.src = 'http://static.geetest.com/static/js/geetest.0.0.0.js';
										s.charset = 'UTF-8';
										s.type = 'text/javascript';
										document.getElementsByTagName('head')[0].appendChild(s);
										var 
									loaded = false;
										s.onload = s.onreadystatechange = function() {
											if (!loaded
													&& (!this.readyState
															|| this.readyState === 'loaded' || this.readyState === 'complete')) {
												loadGeetest(result);
												loaded = true;
											}
										};
									}
				
									var loadGeetest = function(config) {
										window.gt_captcha_obj = new window.Geetest({
											gt : config.gt,
											challenge : config.challenge,
											product : 'embed',
											offline : !config.success
										});
				
										gt_captcha_obj.appendTo("#div_id_embed");
				
										gt_captcha_obj.onSuccess(function() {
											//geetest_ajax_results()
										});
									}
				
									s = document.createElement('script');
									s.src = 'http://api.geetest.com/get.php?callback=gtcallback';
									$("#div_geetest_lib").append(s);
									
									var gtcallback =( function() {
										var status = 0, result, apiFail;
										return function(r) {
											status += 1;
											if (r) {
												result = r;
												setTimeout(function() {
													if (!window.Geetest) {
														apiFail = true;
														gtFailbackFrontInitial(result)
													}
												}, 1000)
											}
											else if(apiFail) {
												return
											}
											if (status == 2) {
												loadGeetest(result);//加载验证码
											}
										};
									})();
									
									$.ajax({
												url : "<%=path %>/rest/capth/startCapth",//发起验证码请求，返回一个验证码
												type : "post",
												dataType : 'JSON',
												success : function(result) {
													gtcallback(result);
												}
											}) --%>
								</script>
				</div>
						 <div class="clear"></div>	
                        <label class="left"></label>
                        <div class="clear" style="margin-top:6px"></div>
                        <label class="left"></label>
                        <a href="#" class="block left next-btn font16" onclick="geetest_ajax_results()">下一步</a>
                    </form>
                </div>
              
            </div>
        </div>
    </div>
   


