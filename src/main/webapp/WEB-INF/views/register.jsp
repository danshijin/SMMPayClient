<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
					+ request.getServerName() + ":" + request.getServerPort()
					+ path + "/";
%>
<script type="text/javascript">
var NamePass = false;
var AccountNoPass = false;
function validateAccountName(isAsync) {
	var accountName = $('#accountName').val();
	if (accountName == "") {
		$("#validateSpan1").show();
		$("#imgError1").show();
		$("#imgSuccess1").hide();
		NamePass = false;
		return;
	}
	var re3 = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
	if (!re3.test(accountName)) {
		$("#imgError1").show();
		$("#imgSuccess1").hide();
		$("#validateSpan1").show();
		$("#validateSpan1").attr('class', 'red font12');
		$("#validateSpan1").text("请输入正确的邮箱格式");
		NamePass = false;
		return;
	} else {
		$.ajax({
			type : "POST",
			url : "<%=path%>/rest/register/validateName",
			data : {
				"accountName" : accountName
			},
			async: isAsync,
			dataType : "json",
			success : function(data) {
				if (data.info == 'success') {
					NamePass = true;
					$("#validateSpan1").text("");
					$("#validateSpan1").hide();
					$("#imgError1").hide();
					$("#imgSuccess1").show();
				} else {
					NamePass = false;

					$("#imgError1").show();
					$("#imgSuccess1").hide();

					$("#validateSpan1").show();
					$("#validateSpan1").attr('class', 'red font12');
					$("#validateSpan1").text("此用户已经存在");
				}
			},
			error : function(data) {
				NamePass = false;
				openAlert("请求失败!");
			}
		});
	}
}

function validateAccountNo(isAsync) {
	var accountNo = $('#accountNo').val();
	if (accountNo == "") {
		$("#validateSpan2").show();
		$("#imgError2").show();
		$("#imgSuccess2").hide();
		AccountNoPass = false;
		return;
	} else {
		$.ajax({
			type : "POST",
			url : "<%=path%>/rest/register/validateNo",
			data : {
				"accountNo" : accountNo
			},
			dataType : "json",
			async: isAsync,
			success : function(data) {
				if (data.userinfo != "0") {
					AccountNoPass = false;
					$("#imgError2").show();
					$("#imgSuccess2").hide();
					$("#validateSpan2").show();
					$("#validateSpan2").attr('class', 'red font12');
					$("#validateSpan2").text("此账户在商城中不存在");
				} else {
					if (data.info != 'success') {
						AccountNoPass = false;

						$("#imgError2").show();
						$("#imgSuccess2").hide();

						$("#validateSpan2").show();
						$("#validateSpan2").attr('class', 'red font12');
						$("#validateSpan2").text("此商城会员在本系统中已经存在");
					} else {// 两次校验都通过
						AccountNoPass = true;
						$("#validateSpan2").text("");
						$("#validateSpan2").hide();

						$("#imgError2").hide();
						$("#imgSuccess2").show();
					}
				}
			},
			error : function(e) {
				openAlert("商城验证请求失败!");
				AccountNoPass = false;
			}
		});
	}
}
</script>


<script type="text/javascript">
	$(function(){
        $("#QapTcha").QapTcha({disabledSubmit:true},'<%=basePath%>');
        $("#nextfoot").click(function() {
        	validateAccountName(false);
        	if (!NamePass) {
        		$("#validateSymbo1").show();
        		$("#validateSpan1").show();
        		$("#accountName").focus();
        		return;
        	}

        	validateAccountNo(false);
        	if (!AccountNoPass) {
        		$("#validateSymbo2").show();
        		$("#validateSpan2").show();
        		$("#accountNo").focus();
        		return;
        	}
        	var url = document.getElementById("bgSlider").style.backgroundImage;
        	if (url.indexOf("backgroundyz1.png") <= 0) {
        		return;
        	}
        	window.location.href = "<%=path%>/rest/register/registerUser?accountNo="
        			+ $('#accountNo').val()
        			+ "&accountName="
        			+ $('#accountName').val();
        });
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
				<div class="index-tt pay-tt">
				<i></i>欢迎签约SMM支付系统服务
				<div  style="float:right;font-size:13px;font-family: 'Arial Normal', 'Arial'">
				客服电话：400-885 6671
			</div>
			</div>
			<ul class="step block font14">
				<li class="step-li-b"><a href="javascript:void(0)" class="white">创建账户</a></li>
				<li class="step-li-w"><a href="javascript:void(0)" class="black">填写账户信息</a></li>
				<li class="step-li-w"><a href="javascript:void(0)" class="black">有色网审核信息</a></li>
				<li class="step-li-b"><a href="javascript:void(0)" class="black">正式使用</a></li>
			</ul>
			<div class="regist-box font16">
				<form>
					<label>账户名</label><input type="text" onblur="validateAccountName(true)"
						id="accountName" class="inform">
						<img id="imgError1" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
						<img id="imgSuccess1" src="<%=path %>/pay/images/succ.jpg" style="display: none"/>
						<span
						id="validateSpan1" style="display: none" class="red font12">请输入邮箱</span><br>
					<label>请输入需绑定的商城账号</label><input type="text"
						onblur="validateAccountNo(true)" id="accountNo" value="${userNo }" class="inform">
						<img id="imgError2" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
						<img id="imgSuccess2" src="<%=path %>/pay/images/succ.jpg" style="display: none"/><span id="validateSpan2"
						style="display: none" class="red font12">请输入账号</span><br>
						<%-- <label></label><div href="#" class="block slider-box gray2" id="iphone"><div id="lock"><span href="#" class="block slider"><i class="fa fa-angle-double-right fa-2x"></i></span>请拖动滑块验证</div></div>
						
						<div href="#" class="block slider-box2 gray2" id="iphone">
							<img id="imgError3" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
							<span id="validateSpan3" style="display: none" class="red font12">请拖动滑块验证</span>
							<img id="imgSuccess3" src="<%=path %>/pay/images/succ.jpg" style="display: none"/>
						</div> --%>
						
						<label></label><div href="#" class="block gray2">
							<div class="QapTcha" id="QapTcha" style="width:auto"></div>
						</div>
						
						
						<label></label><div class="QapTcha" id="QapTcha" style="width:auto"></div>
					
					<div class="clear"></div>
					<label class="left"></label>
					
					<!-- 
					<div class="block left pb16" style="padding-top: 15px">
						<div class="checkbox left">
							<input type="checkbox" id="checkboxOneInput" style=" visibility:visible">
						</div>
						<span class="block left font14">我同意支付服务协议</span>
					</div>
					-->

					
					<div class="clear" style="margin-top: 6px"></div>
					<label class="left"></label> <a href="#"
						class="block left next-btn font16" id="nextfoot">下一步</a>
					<div class="clear"></div>
				</form>
			</div>
			<div class="regist-txt font13">
				<p>
					<b class="black">注册前需要准备：</b><span class="gray2">影印件必须为彩色原件的扫描或数码照</span>
				</p>
				<p class="blue hidden">
					<span class="block dot"></span>企业法人营业执照影印件
				</p>
				<p class="blue hidden">
					<span class="block dot"></span>组织机构代码证影印件
				</p>
				<p class="blue hidden">
					<span class="block dot"></span>对公银行账户
				</p>
				<p class="blue hidden">
					<span class="block dot"></span>税务登记证影印件
				</p>
				<p class="blue hidden">
					<span class="block dot"></span>
		
					管理员授权委托书（加盖公章、经办人签字）<a style="text-decoration:underline;" href="<%=path%>/rest/register/downloadLocal" >模版下载</a>
					
					<!-- <a
						href="#">管理员授权委托书（加盖公章、经办人签字）模版下载</a> -->
				</p>
			</div>
		</div>
	</div>
</div>
