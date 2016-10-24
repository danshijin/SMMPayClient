<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<link type="text/css" rel="stylesheet" href="<%=path %>/pay/css/payment.css" />
<script>

var clientHeight=null;
var scrollHeight=null;
 window.onload=function(){
	  setTimeout(function() {
		  if (document.compatMode == "BackCompat") { 
			  clientHeight=document.body.clientHeight;
			  scrollHeight=document.body.scrollHeight;
			  if(clientHeight<scrollHeight){
					$('#rel').show();
					$('#abs').hide();
				}else{
					$('#abs').show();
					$('#rel').hide();
				} 
		  }else { 
			   	clientHeight=document.documentElement.clientHeight;
				scrollHeight=document.documentElement.scrollHeight; 
				if(clientHeight<scrollHeight){
					$('#rel').show();
					$('#abs').hide();
				}else{
					$('#abs').show();
					$('#rel').hide();
				} 
		  }

		  
		  
			 
      }, 100);  
}; 


</script>
  <div  id="rel" class="footer font13 yahei footer2" style="position:relative; bottom:0px;" >
        <div class="web">
            <div class="index-div">
                <span class="block left">
                    <a href="<%=path %>/rest/common/introduce" class="white">关于我们</a>
                    <a href="#" class="white">联系我们</a>
                    <a href="<%=path %>/rest/common/agreement" class="white">服务协议</a>
                    <a href="<%=path %>/rest/common/introduce" class="white">关于支付</a>
                </span>
                <span class="block left gray">增值电信业务经营许可证：沪B2-20120059   沪ICP备09002236号-1</span>
            </div>
        </div>
    </div>
     <div  id="abs" class="footer font13 yahei footer2" style="position:absolute; bottom:0px; ">
        <div class="web">
            <div class="index-div">
                <span class="block left">
                    <a href="<%=path %>/rest/common/introduce" class="white">关于我们</a>
                    <a href="#" class="white">联系我们</a>
                    <a href="<%=path %>/rest/common/agreement" class="white">服务协议</a>
                    <a href="<%=path %>/rest/common/introduce" class="white">关于支付</a>
                </span>
                <span class="block left gray">增值电信业务经营许可证：沪B2-20120059   沪ICP备09002236号-1</span>
            </div>
        </div>
    </div>