<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page isELIgnored="false"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
  <script>
  function rtnTrade(){
	  location="<%=path %>/rest/trade/toTrade?type=jy";
  }
  </script>
   
    <div class="main2">
        <div class="web position yahei black">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">支付货款</b>
                </p>
                <div class="order-box font13 hidden">
                    <p class="border-b hidden" style="line-height:40px; ">
                        <span class="block left" style="width:210px">订单编号：<b>${resPayDetail.mallOrderId}</b></span>
                        <span class="block left">状态：<span class="orange">
                        <c:if test='${resPayDetail.paymentStatus == "0" }'>
                      	待付款
                        </c:if>
                        <c:if test='${resPayDetail.paymentStatus=="1"}'>
                      	已冻结
                        </c:if>
                        <c:if test='${resPayDetail.paymentStatus=="2"}'>
                      	已完成
                        </c:if>
                         <c:if test='${resPayDetail.paymentStatus=="3"}'>
                      	已关闭 
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '4' }">
                      	冻结失败
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '5' }">
                      	解冻支付失败
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '6' }">
                      	待退款
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '7' }">
                      	已退款
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '8' }">
                      	退款失败
                        </c:if>
                         <c:if test="${resPayDetail.paymentStatus == '9' }">
                      	冻结中
                        </c:if>
                        <c:if test="${resPayDetail.paymentStatus == '10' }">
                      	付款中
                        </c:if>
                        <c:if test="${resPayDetail.paymentStatus == '11' }">
                      	退款中
                        </c:if>
                        </span></span>
                        <span class="block right">付款申请时间：${resPayDetail.createTime}</span>
                    </p>
                    <div style="padding:0px 30px 40px">
                        <div class="border-b hidden" style="padding:20px 0px">
                            <ul class="block left">
                                <li>对方企业：${resPayDetail.oppositCompanyName}</li>
                                <li>对方账号：${resPayDetail.oppositPayChannelAccount}</li>
                                <li>商品名称：${resPayDetail.productName}</li>
                                <li>商品详情：${resPayDetail.productDetail}</li>
                                <li>商品数量：${resPayDetail.productNum}吨</li>
                                <li>交易金额：￥<fmt:formatNumber value="${resPayDetail.dealMoney}"  pattern="#,##0.00"/>元</li>
                                <li>采购时间：${resPayDetail.createTime}</li>
                                <li>收交方式：${resPayDetail.settlementType}</li>
                                <li>交易类型：${resPayDetail.dealType}</li>
                                <li>发票说明：${resPayDetail.invoice}</li>
                                <li>交易编号：<b>${resPayDetail.paymentNo}</b></li>
                            </ul>
                            
                            <div class="right" >
                               <c:if test='${resPayDetail.paymentStatus == "0" }'>
	                      		   <p class="pay-step"></p>
                                <!---------------- 另两个状态 class="pay-step pay-step2" class="pay-step pay-step3----------------->
                                <ul class="pay-step-li font13">
		                      		<li>待付款<br><span class="gray">${resPayDetail.createTime}</span></li>
                                    <li>已冻结<br><span class="gray"></span></li>
                                    <li style="margin-right:0px">已完成<br><span class="gray"  style="white-space:nowrap;"></span></li>
                                </ul>
	                        	</c:if>
	                        	
	                        	<c:if test='${resPayDetail.paymentStatus=="1" || resPayDetail.paymentStatus=="10"}'>
	                      		   <p class="pay-step pay-step2"></p>
                                <!---------------- 另两个状态 class="pay-step pay-step2" class="pay-step pay-step3----------------->
                                <ul class="pay-step-li font13">
		                      		<li>待付款<br><span class="gray">${resPayDetail.createTime}</span></li>
                                    <li>已冻结<br><span class="gray">${resPayDetail.freezeTime}</span></li>
                                    <li style="margin-right:0px">已完成<br><span class="gray"  style="white-space:nowrap;"></span></li>
                                </ul>
	                        	</c:if>
	                        	
                        		<c:if test='${resPayDetail.paymentStatus=="2"}'>
                      			   <p class="pay-step pay-step3"></p>
                                <!---------------- 另两个状态 class="pay-step pay-step2" class="pay-step pay-step3----------------->
                                <ul class="pay-step-li font13">
		                      		<li>待付款<br><span class="gray">${resPayDetail.createTime}</span></li>
                                    <li>已冻结<br><span class="gray">${resPayDetail.freezeTime}</span></li>
                                    <li style="margin-right:0px">已完成<br><span class="gray"  style="white-space:nowrap;">${resPayDetail.doneTime}</span></li>
                                </ul>
                        		</c:if>
                             
                            </div>
                             <div  style="float: right; clear: both;">
                              
                             	￥<span class="red2" style="font-size: 30px;"><fmt:formatNumber value="${resPayDetail.dealMoney}"  pattern="#,##0.00"/></span>元
                           
                           </div>
                        </div>
                       
                        <div>
                            <p>付款方式：${resPayDetail.paymentType}</p>
                            <p>付款时间：${resPayDetail.createTime}</p>
                            <c:if test='${resPayDetail.payType == "0"}'>
	                            <c:if test='${resPayDetail.paymentCode !=null and resPayDetail.paymentCode !="" and resPayDetail.buyerUserId == userId}'>
	                            	<p>唯一支付码：${resPayDetail.paymentCode}</p>
	                            </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>
                <a href="javascript:history.go(-1)" class="block right back-btn" onclick="history.go(-1)">返回</a>
                <div class="clear"></div>
            </div>
        </div>
    </div>