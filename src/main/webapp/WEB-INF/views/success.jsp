<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>    <script type="text/javascript">
$(function(){
	  //弹出隐藏层
	  document.getElementById("MyDiv").style.display='block';
	  document.getElementById("fade").style.display='block' ;
	  var bgdiv = document.getElementById("fade");
	  bgdiv.style.width = document.body.scrollWidth;
	  // bgdiv.style.height = $(document).height();
	  $("#fade").height($(document).height());
});
	  //关闭弹出层
	  function CloseDiv(show_div,bg_div)
	  {
	  document.getElementById(show_div).style.display='none';
	  document.getElementById(bg_div).style.display='none';
	  };
	  </script>
        
    <div class="main2">
        <div class="web position yahei black">
            <div class="payment">
                <p class="index-tt pay-tt"><i></i>欢迎签约SMM支付系统服务</p>
             <ul class="step block font14 step3">
				<li class="step-li-b"><a href="#" class="white">创建账户</a></li>
				<li class="step-li-w"><a href="#" class="white">填写账户信息</a></li>
				<li class="step-li-w"><a href="#" class="white">有色网审核信息</a></li>
				<li class="step-li-b"><a href="#" class="black">正式使用</a></li>
			</ul>
			<!-- 
			    <div id="u131" style="width:200px height:300px;vertical-align:middle;text-align: center">
          <p style="font-size:24px;line-height:normal;">
          <span style="font-family:'Arial Negreta', 'Arial';
          font-weight:700;font-size:24px;line-height:normal;">感谢您注册有色大额支付系统！
          </span></p><p style="font-size:18px;line-height:24px;">
          <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">稍候有色网审核人员审核通过后， 即进行登陆进行交易！</span>
          </p>
        </div>
			 -->
			  
        
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
              
            </div>
        </div>
    </div>
   