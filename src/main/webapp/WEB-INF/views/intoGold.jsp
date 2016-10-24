<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.eliteams.pay.web.model.User"%>
<%@page import="com.eliteams.pay.web.util.UserCommon"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+ path + "/";
	
	User user=UserCommon.isLogin(request);
	
	String accountName = "";
	String accountNo = "";
	
	if(user != null){
		accountName = user.getAccountName();
		accountNo = user.getAccountNo();
	}

	
%>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
	<div class="main2">
		<div class="web yahei black position">
			<div class="payment">
				<p class="index-tt pay-tt2 hidden">
					<b class="block left">企业入金</b>
				</p>
				<p class="font18 into-txt" style="margin: 50px 0px 80px">
					<b>账户信息：</b>
					<br> <img src="<%=path %>/pay/images/zx-logo.jpg" width="180"><Br>
					开户银行：中信银行上海自贸区分行<br>
					账户名称：<%=accountName %><br>
					银行账号：<%=accountNo %><br><br>
					<b>入金说明：</b><br>
					有色网同中信银行合作推出的支付系统，提供线上电子平台交易资金监管，托收等服务。资金划转通过中国人民银行大额支付通道实时到账。<br>
					注册成功有色网支付系统后，中信银行开通您企业独立账户。<br>
					您可通过您的企业网银直接划款至以上银行账号完成入金（充值）操作。
				</p>
			</div>
		</div>
	</div>
	
	<!----------------------------- 弹窗 ----------------------------------->
	<script type="text/javascript">
		//弹出隐藏层
		function ShowDiv(show_div, bg_div) {
			document.getElementById(show_div).style.display = 'block';
			document.getElementById(bg_div).style.display = 'block';
			var bgdiv = document.getElementById(bg_div);
			bgdiv.style.width = document.body.scrollWidth;
			// bgdiv.style.height = $(document).height();
			$("#" + bg_div).height($(document).height());
		};
		//关闭弹出层
		function CloseDiv(show_div, bg_div) {
			document.getElementById(show_div).style.display = 'none';
			document.getElementById(bg_div).style.display = 'none';
		};
	</script>
	<div class="black-bg" id="fade">
		<div class="alter yahei black" id="MyDiv">
			<span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
			<span class="block left"> <b style="font-size: 24px">对不起，您当前输入错误次数过多，请明天再试！
			</b><br>
			<br>

			</span>
			<div class="clear"></div>
			<a href="#" class="close-btn" onclick="CloseDiv('MyDiv','fade')">确
				定</a>
		</div>
	</div>




