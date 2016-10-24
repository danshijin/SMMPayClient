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
#bd{
	width:400px !important;
}
</style>
<!------------------------------- 下拉菜单JS ----------------------------------->
  <script type="text/javascript">
	$(document).ready(function() {
		
		if("<%=email%>" != ""){
			$('#login').show();
			$("#user_login").html("<%=email%><i class='fa fa-caret-down'></i>");
			$('#qianyue').hide();
			$('#caidan').show();
			$('#logo').hide();
			$('#logo3').hide();
			$('#logo2').show();
		}else{
			$('#qianyue').show();
			$('#caidan').hide();
			$('#login').hide();
			if("<%=loginType%>" != "null"){
				if("<%=loginType%>" =='1'){
					$('#logo2').hide();
					$('#logo3').hide();
					$('#logo').show();
				}
			}else{
				$('#logo2').hide();
				$('#logo3').show();
				$('#logo').hide();
			}
			
		}
		if("<%=type%>" == 'jy'){
			$("#jy").addClass('block right dzd-a font14 white dzd-a-o');
			$("#dzd").addClass('block right dzd-a font14 white');
			$("#cj").addClass('block right dzd-a font14 white');
		}else if("<%=type%>" == 'dzd'){
			$("#dzd").addClass('block right dzd-a font14 white dzd-a-o');
			$("#jy").addClass('block right dzd-a font14 white');
			$("#cj").addClass('block right dzd-a font14 white');
		}else if("<%=type%>" == 'cj'){
			$("#cj").addClass('block right dzd-a font14 white dzd-a-o');
			$("#dzd").addClass('block right dzd-a font14 white');
			$("#jy").addClass('block right dzd-a font14 white');
		}
		var navLi=$(".user-box .user .user-id");
		navLi.mouseover(function () {
			$(this).find("a").addClass("current");
		})
		navLi.mouseleave(function(){
			$(this).find("a").removeClass("current");
		})
	
  function megaHoverOver(){
	  $(this).find(".sub").stop().fadeTo('fast', 1).show();
		  
	  //Calculate width of all ul's
	  (function($) { 
		  jQuery.fn.calcSubWidth = function() {
			  rowWidth = 0;
			  //Calculate row
			  $(this).find("ul").each(function() {					
				  rowWidth += $(this).width(); 
			  });	
		  };
	  })(jQuery); 
	  
	  if ( $(this).find(".row").length > 0 ) { //If row exists...
		  var biggestRow = 0;	
		  //Calculate each row
		  $(this).find(".row").each(function() {							   
			  $(this).calcSubWidth();
			  //Find biggest row
			  if(rowWidth > biggestRow) {
				  biggestRow = rowWidth;
			  }
		  });
		  //Set width
		  $(this).find(".sub").css({'width' :biggestRow});
		  $(this).find(".row:last").css({'margin':'0'});
		  
	  } else { //If row does not exist...
		  
		  $(this).calcSubWidth();
		  //Set Width
		  $(this).find(".sub").css({'width' : rowWidth});
		  
	  }
  }
  
  function megaHoverOut(){ 
	$(this).find(".sub").stop().fadeTo('fast', 0, function() {
		$(this).hide(); 
		
	});
	
  }


  var config = {    
	   sensitivity: 2, // number = sensitivity threshold (must be 1 or higher)    
	   interval: 20, // number = milliseconds for onMouseOver polling interval    
	   over: megaHoverOver, // function = onMouseOver callback (REQUIRED)    
	   timeout: 20, // number = milliseconds delay before onMouseOut    
	   out: megaHoverOut // function = onMouseOut callback (REQUIRED)    
  };

  $("ul#topnav li .sub").css({'opacity':'0'});
  $("ul#topnav li").hoverIntent(config);  
			
	});
					  
		function dzd(){//对账单显示
			<%-- location="<%=path %>/rest/trade/toTrade?type=dzd"; --%>
			location="<%=path %>/rest/user/checkbill";
		}
		function statement(){
			location="<%=path %>/rest/trade/statement";
		}
		function cj(){//出金
			//location="<%=path %>/rest/trade/toTrade?type=cj";
			location="<%=path %>/rest/pay/paypage";
		}
		function jy(){//交易
			location="<%=path %>/rest/trade/toTrade?type=jy";
		}
		function showCd(){//登录显示
			$('#bd').show();
		}
		function noShowCd(){
			$('#bd').hide();
		}
		function tuichu(){
			$('#qianyue').show();
			$('#caidan').hide();
			$('#login').hide();
			location="<%=path %>/rest/user/logout";
		}
		function megaHoverOut(){ 
			$(this).find(".sub").stop().fadeTo('fast', 0, function() {
				$(this).hide(); 
			});
		}
		function megaHoverOver(){
			$(this).find(".sub").stop().fadeTo('fast', 1).show();
			//Calculate width of all ul's
			(function($) { 
				jQuery.fn.calcSubWidth = function() {
					rowWidth = 0;
					//Calculate row
					$(this).find("ul").each(function() {					
						rowWidth += $(this).width(); 
					});	
				};
			})(jQuery); 
			if ( $(this).find(".row").length > 0 ) { //If row exists...
				var biggestRow = 0;	
			//Calculate each row
			$(this).find(".row").each(function() {							   
				$(this).calcSubWidth();
				//Find biggest row
				if(rowWidth > biggestRow) {
					biggestRow = rowWidth;
				}
			});
			//Set width
			$(this).find(".sub").css({'width' :biggestRow});
			$(this).find(".row:last").css({'margin':'0'});
			} else { //If row does not exist...
				$(this).calcSubWidth();
			//Set Width
			$(this).find(".sub").css({'width' : rowWidth});
			}
		}
		 //关闭弹出层
		  function CloseAlert(show_div,bg_div){
			  document.getElementById(show_div).style.display='none';
			  document.getElementById(bg_div).style.display='none';
		  };
		  function openAlert(a){
			  $("#fadeAlert").show();
		      $("#MyDivAlert").show();
		      
		      makeDivCenterInWindow("MyDivAlert");
				
		      $("#alt").html(a);
		  }
 </script>
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
                     <li style="margin-right:0px"><a href="<%=path %>/rest/common/introduce">关于支付</a></li>
                 </ul>
                 
               
               <div class="user-box right" id="login" >
                     <ul class="user font13 position" id="topnav">
                         <li class="user-id"><a href="#" class="block white" onmouseover="showCd()" onmouseout="noShowCd()" id="user_login"><i class=" fa fa-caret-down "></i></a>
                             <div class="user-btn sub" id="bd" style=" display: none" onmouseover="showCd()" onmouseout="noShowCd()">
                                 <a href="<%=path %>/rest/accountBind/toBindCard" class="user-a block left">绑定账户</a>
                                 <a href="<%=path %>/rest/user/chgpwd" class="user-a block left">修改密码</a>
                                 <a href="<%=path %>/rest/intoGold/into" class="user-a block left">如何入金</a>
                                 <a href="<%=path %>/rest/user/checkbill" class="user-a block left">电子回单</a>
                             </div>
                         </li>
                         <li><a href="<%=path %>/logout" >退出</a></li>
                         <li>｜</li>
                     </ul>
                 </div>
        	</div>
        </div>
	        <div class="logo"  id="logo" style="display: none">
	        		<div class="web hidden" id="qianyue">
		                <img src="<%=path %>/pay/images/pay-logo.png" class="block left" />
		                <a href="<%=path %>/rest/register/validateAccount" class="block right singup font14 white"><i class="fa fa-user white fa-lg"></i>立即签约</a>
		            </div>
	        </div>
	        <div class="logo2"  id="logo3" style="display: none">
	        		<div class="web hidden" id="qianyue">
		                <img src="<%=path %>/pay/images/pay-logo.png" class="block left" />
		                <a href="<%=path %>/rest/register/validateAccount" class="block right singup font14 white"><i class="fa fa-user white fa-lg"></i>立即签约</a>
		            </div>
	        </div>
	         <div class="logo2"  id="logo2" style="display: none">
	            <div class="web hidden" id="caidan">
	                <img src="<%=path %>/pay/images/pay-logo.png" class="block left" />
	                
	                <a href="#" class="block right dzd-a font14 white" id="statement" onclick="statement()"><i class="fa fa-bars gray4 fa-lg"></i>对账单</a>
	                <a href="#" class="block right dzd-a font14 white" id="cj" onclick="cj()"><i class="fa fa-dollar gray4 fa-lg"></i>出金</a>
	                <a href="#" class="block right dzd-a font14 white" id="jy" onclick="jy()"><i class="fa fa-exchange gray4 fa-lg"></i>交易</a>
	            </div>
	        </div>
        </div>
        
      <div class="black-bg" id="fadeAlert">
        <div class="altertt yahei black" id="MyDivAlert">
	         <p style="font-size:18px;line-height:24px;" align="center">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">
	         <span id="alt"  style="font-size:18px">操作失败，请重试!</span>
	         </span>
	         </p>
            <div class="clear"></div>
            <a href="###" class="close-btn" onclick="CloseAlert('MyDivAlert','fadeAlert')">确 定</a>
        </div>
    </div>

