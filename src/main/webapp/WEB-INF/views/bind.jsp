<%@page import="com.eliteams.pay.web.model.Message"%>
<%@page import="com.eliteams.pay.web.model.User"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
User user = (User) request.getSession().getAttribute("user");

String mobilePhone="";
if(null!=user){
    mobilePhone=user.getCellphone();
}

System.out.println("mobilePhone="+mobilePhone);
%>
    <div class="main2">
        <div class="web yahei black position">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">绑定账户管理</b>
                     <b class="block left">修改密码</b>
                </p>
                <ul class="bind-li font13 hidden">
                <c:forEach items="${ listBank}" var="listBank">
                    <c:if test="${listBank.auditStatus == '0' }">
	                	<c:if test="${listBank.isPayment == '1' }">
		                    <li>
		                        		 <table style="height: 65px">
		                        	 <tr>
		                        	 <td rowspan="3"><img src="<%=path %>/pay/images/bankImages/${listBank.bindTypeId}.jpg" width="16"> </td>
		                        	  <td>${listBank.bindBank}</td>
		                        	 </tr>
		                        	  <tr>
		                        	  <td>${listBank.bankName}</td>
		                        	 </tr>
		                        	 <tr>
		                        	  <td>${listBank.bankAccountNo}</td>
		                        	 </tr>
		                        	 </table>
		                        	   
		                      		 <p class="bank-gray gray"><span class="block left"><i class="fa fa-money gray">&nbsp;&nbsp;</i>未验证</span>
		                      		 <a href="javascript:updateUserBank('${listBank.bindId}')" class="block blue2 right">关闭</a>
		                      		 <a href="#" onclick="checkCard('${listBank.bankName}','${listBank.bankAccountNo}','${listBank.bindId}','${listBank.bindTypeId}')" class="block blue2 right">验证｜</a>
		                      		 </p>
		                    </li>
		                 </c:if>
		                 <c:if test="${listBank.isPayment == '0' }">
		                    <li>
		                        	 
		                        	 <table style="height: 65px">
		                        	 <tr>
		                        	 <td rowspan="3"><img src="<%=path %>/pay/images/bankImages/${listBank.bindTypeId}.jpg" width="16"> </td>
		                        	  <td>${listBank.bindBank}</td>
		                        	 </tr>
		                        	  <tr>
		                        	  <td>${listBank.bankName}</td>
		                        	 </tr>
		                        	 <tr>
		                        	  <td>${listBank.bankAccountNo}</td>
		                        	 </tr>
		                        	 </table>
		                        	
		                      		 <p class="bank-gray gray">
		                      		 <a href="#" onclick="updateUserBank('${listBank.bindId}')" class="block blue2 right">关闭</a>
		                      		 </p>
		                    </li>
		                 </c:if>
                    </c:if>
                   <c:if test="${listBank.auditStatus == '1' }">
                        	    <li>
                        	 	 <table style="height: 65px">
		                        	 <tr>
		                        	 <td rowspan="3"><img src="<%=path %>/pay/images/bankImages/${listBank.bindTypeId}.jpg" width="16"> </td>
		                        	  <td>${listBank.bindBank}</td>
		                        	 </tr>
		                        	  <tr>
		                        	  <td>${listBank.bankName}</td>
		                        	 </tr>
		                        	 <tr>
		                        	  <td>${listBank.bankAccountNo}</td>
		                        	 </tr>
		                        	 </table>
                      		  <p class="bank-gray gray">
                      		  <span class="block left">
                      		  <i class="fa fa-clock-o gray">&nbsp;&nbsp;</i>最近使用： 
                      		  ${listBank.bindTime}
                      		  </span>
                      		  <a href="#" class="block red right"  id="Button1" onclick="ShowDiv('MyDiv','fade','${listBank.bindId}')">解绑</a>
                      		  </p>
                        	  </li>
                   </c:if>
                </c:forEach>

                    <li>
                        <p class="add-bank"><a href="<%=path %>/rest/accountBind/toBindCardBank" class="blue2"><i class="fa gray fa-plus fa-2x"></i><br>添加绑定账户</a></p> 
                    </li>
                </ul>
                <p class="font13 bill-txt" style="margin:50px 0px 80px"><b>绑定说明：</b><br>添加绑定账户后，系统将会将您账户汇入一笔款项。<br>收到该金额后，在验证账户页面输入与汇入款项一致的金额数字，系统核对无误后，则绑定成功。<br>需绑定的账户开户名需和注册账户企业名称一致。</p>
            </div>
        </div>
    </div>
    
    <!----------------------------- 弹窗 ----------------------------------->
    <script type="text/javascript">
    var wait=60;
    var bId="";
    
	 	 //弹出隐藏层
	  function ShowDiv(show_div,bg_div,bindId){
		  bId=bindId;
		  document.getElementById(show_div).style.display='block';
		  document.getElementById(bg_div).style.display='block' ;
		  var bgdiv = document.getElementById(bg_div);
		  bgdiv.style.width = document.body.scrollWidth;
		  $("#"+bg_div).height($(document).height());
		  time(show_div,bg_div);
		  $.ajax({  
		        url : '<%=path %>/rest/accountBind/sendMessage',   
		        dataType : 'json', 
		        data :{
					"mobilePhone":"<%=mobilePhone%>"
				},
				success : function(data) {
					/*  if(data.info=='success'){
						 
						yzm=data.message;
					 }else{
						 alert("解绑失败");
					 } */
		        },  
		        error : function(data)//服务器响应失败处理函数  
		        {  
		         
		        }  
		    }); 
		  
	  };
	  //关闭弹出层
	  function CloseDiv(show_div,bg_div) {
		  document.getElementById(show_div).style.display='none';
		  document.getElementById(bg_div).style.display='none';
	  };
	  
	  function ShowSuccessDiv(show_div,bg_div){
		  document.getElementById(show_div).style.display='block';
		  document.getElementById(bg_div).style.display='block' ;
		  var bgdiv = document.getElementById(bg_div);
		  bgdiv.style.width = document.body.scrollWidth;
		  $("#"+bg_div).height($(document).height());
	  }
	  function time(show_div,bg_div) {
	          if (wait == 0) {
	        	  //.back-btn{width:175px; height:33px; border:1px gray solid; border-radius:2px; line-height:33px; text-align:center; color:#cceeff; margin:40px 0px;}
					//.back-btn2{background:#cceeff; color:#fff !important;}
				  $("#yzm").removeClass('block back-btnb back-btnb2 yam-btn');
				  $("#yzm").addClass('block back-btn back-btn2 yam-btn');
	              $('#yzm').removeAttr("disabled");            
	              $('#yzm').val("重新发送");
	              wait = 60;
	          } else { // www.jbxue.com
	        	  //$("#yzm").removeClass('block back-btn back-btn2 yam-btn');
	        	  $("#yzm").addClass('block back-btnb back-btnb2 yam-btn');
	        	  $('#yzm').attr("disabled", true);
	              $('#yzm').val("" + wait + "秒后可重新发送");
	              wait--;
	              setTimeout(function() {
	            	  time(show_div,bg_div);    
	              }, 1000);  
	          }
	      }
	  function checkCard(bankName,bankAccountNo,bindId,bindTypeId){
		  location="<%=path%>/rest/accountBind/toCheckCard?bankName="+encodeURIComponent(encodeURIComponent(bankName))+
				  "&bankAccountNo="+bankAccountNo+"&bindId="+bindId+"&bindTypeId="+bindTypeId;
	  }
	  //解绑
	  function checkMessage(){
		  var message=$('#message').val();
			  $.ajax({  
			        url : '<%=path%>/rest/accountBind/checkMessage',   
			        dataType : 'json', 
			        data :{
						"message":message
					},
			        success : function(data) {
						 if(data.info=='success'){
							 $('#messageError').hide();
							 //updateUserBank();
							 confirmCard();
						 }else if(data.info=='overtime'){
							 $('#messageError').hide();
							 $('#overtime').show();
						 }else{
							  $('#messageError').show();
						 }
			        },  
			        error : function(data)//服务器响应失败处理函数  
			        {  
			        	openAlert("请求失败!");
			        }  
			    });    
	  }
	  
	  //关闭银行卡
	  function updateUserBank(bid){
		  bId=bid;
		  $("#qr").show();
	      $("#qra").show();
	      $("#qralt").html("你确认关闭该卡！");
	  }
	  //确认解绑
	  function confirmCard(){
		  CloseDiv('MyDiv','fade');
		  $("#qr").hide();
	      $("#qra").hide();
		   $.ajax({  
		        url : '<%=path%>/rest/accountBind/updateUserBindBank',   
		        dataType : 'json', 
		        data :{
					"bindId":bId,
				},
		        success : function(data) {
		        	
					 if(data.info=='success'){
						 CloseDiv('MyDiv','fade');
						 ShowSuccessDiv('MyDivBind','fadeBind');
						 setTimeout(function() {
							 CloseDiv('MyDivBind','fadeBind');
							 location="<%=path %>/rest/accountBind/toBindCard";
			              }, 2000);  
						 
					 }else{
					     openAlert("解绑失败!");
					 }
		        },  
		        error : function(data)//服务器响应失败处理函数  
		        {  
			        openAlert("请求失败!");
		        }  
		    }); 
	  }
	  
	  //确认关闭
	  function confirmCloseCard(){
		  CloseDiv('MyDiv','fade');
		  $("#qr").hide();
	      $("#qra").hide();
		   $.ajax({  
		        url : '<%=path%>/rest/accountBind/updateUserBindBank',   
		        dataType : 'json', 
		        data :{
					"bindId":bId,
				},
		        success : function(data) {
		        	
					 if(data.info=='success'){
						 CloseDiv('MyDiv','fade');
						 location="<%=path %>/rest/accountBind/toBindCard";
					 }else if(data.info=='only'){
					     openAlert("该银行卡卡为唯一绑定卡，不能解绑或者关闭!");
					 }else{
						 openAlert("关闭失败!");
					 }
		        },  
		        error : function(data)//服务器响应失败处理函数  
		        {  
			        openAlert("请求失败!");
		        }  
		    }); 
	  }
	  </script>
    <div class="black-bg" id="fade">
        <div class="alter yahei black" id="MyDiv" >
            <span class="block left fa fa-info-circle fa-2x blue">&nbsp;&nbsp;</span>
            <span class="block left yzm-box">
                <b style="font-size:24px">解绑账号验证码已发送到您注册的手机！ </b><br><br>
                <span class="font16 gray">请填写您收到的验证码 <input type="text" id="message" class="inform" style="width:150px">
                  <input type="button" id="yzm" onclick="time('MyDiv','fade')" class="block back-btnb back-btnb2 yam-btn" value="" />
                   <p style="padding:10px 0px 0px 165px;display: none" class="font14" id="messageError"><img id="imgError" src="<%=path %>/pay/images/err.jpg" /> 验证码错误</p>
                   <p style="padding:10px 0px 0px 165px;display: none" class="font14" id="voertime"><img id="imgError" src="<%=path %>/pay/images/err.jpg" /> 验证码超时</p>
                </span>
            </span>
            <div class="clear"></div>
            <div class="a-margin">
                <a href="#" class="close-btn left" onclick="checkMessage()">确定</a><a href="#" class="close-btn left close-btn2" onclick="CloseDiv('MyDiv','fade')">返回</a>
            </div>
        </div>
    </div>
    

      
      <div class="black-bg" id="fadeBind">
        <div class="alter yahei black" id="MyDivBind" >
  			
            <div align="center" style="width: 150px">
            <h3>解绑成功</h3>
                <p style="background: url('<%=path %>/pay/images/u131.png') no-repeat; width:130px;"><span> <img src="<%=path %>/pay/images/bd.png">帐户解绑成功</span></p>
            </div>
        </div>
    </div> 
    
     <div class="black-bg" id="qr">
        <div class="altertt yahei black" id="qra">
	         <p style="font-size:18px;line-height:24px;" align="center">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">
	         <span id="qralt"  style="font-size:18px">操作失败，请重试!</span>
	         </span>
	         </p>
            <div class="clear"></div>
           <div >
           <span> <button style="background: #0095fc;color: #fff;width: 80px;height: 20px"  onclick="confirmCloseCard()">确 定</button> 
            <button style="background: #0095fc;color: #fff;width: 80px;height: 20px"  onclick="CloseAlert('qr','qra')">取消</button>
            </span>
            </div>
        </div>   
    </div>