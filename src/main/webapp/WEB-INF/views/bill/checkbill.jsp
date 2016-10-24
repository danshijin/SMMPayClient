<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.smmpay.inter.dto.res.ResQueryTradingRecordDTO"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

String checkBankBool=(String)request.getAttribute("checkBankBool");
%>
<script src="<%=path %>/pay/js/page/login-soft.js" type="text/javascript"></script>
<script src="<%=path %>/pay/js/page/md5.js" type="text/javascript"></script>
<script src="<%=path %>/pay/js/user/chgpwd.js" type="text/javascript"></script>
<script src="<%=path %>/pay/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
<script src="<%=path %>/pay/js/kkpager.min.js"></script>
<link  href="<%=path %>/pay/css/kkpager.css" type="text/css" rel="stylesheet"/>

<script>BASE_URL = '<%=path %>'</script>

<div id="all">
    <div class="main2">
        <div class="web position yahei black">
            <div class="payment">
            
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">电子回单</b>
                    <span class="block left font14" id="checkBank" style="margin-left:158px;display: none">
                        <em class="fa fa-exclamation blue2 fa-lg">&nbsp;</em>
                       	 银行账户待验证&nbsp;
                        <a href="<%=path %>/rest/accountBind/toBindCard" class="blue2">立即验证></a>
                    </span>
                    
                    <span class="block right font14">
                        账户余额：￥<span id="totalMoney"><fmt:formatNumber value="${totalMoney}"  pattern="#,##0.00"/></span>&nbsp;&nbsp;
                        可用余额：￥<span class="red2" id="userMoney"><fmt:formatNumber value="${userMoney}"  pattern="#,##0.00"/></span>元&nbsp;&nbsp;<a href="#" class="fa fa-refresh blue2 fa-lg" onclick="freshAccountMoney()">&nbsp;</a>
                        <span class="blcok" style="padding-top:10px"><a href="<%=path %>/rest/intoGold/into" class="block fj-a">入金</a></span>
                       	冻结款项：￥<span class="orange" id="freezeMoney"><fmt:formatNumber value="${freezeMoney}"  pattern="#,##0.00"/></span>元
                    </span>
                </p>
     		
     		
                <div class="clear"></div>
                
	                <div class="search font14">
	                    <form>
	                        起始时间<input type="text" class="search-box" id="btime" onClick="WdatePicker()"> <!--  class="Wdate" -->
	                        截止时间<input type="text" class="search-box" id="etime" onClick="WdatePicker()">
	                        <a id="search" href="#" class="search-btn block">查询</a>
	                    </form>
	                </div>
                
                <div id="bill">
                <table style="cellpadding: 0; cellspacing: 0; width:100%;" class="bill-tab font14">
                    <tr>
                        <th>交易时间</th>
                        <th>交易编号</th>
                        <th>交易类型</th>
                        <th>摘要</th>
                        <th>交易对方</th>
                        <th>对方账号</th>
                        <th>金额</th>
                        <th>手续费</th>
                        <th>当时余额</th>
                        <th class="printhide" width="106px">打印校验码</th>
                    </tr>
                    
                    <c:forEach items="${tradeList}" var="trade">
	                    <tr>
	                        <%-- <td>${fn:substring(trade.tranTime,0,2)}:${fn:substring(trade.tranTime,2,4)}:${fn:substring(trade.tranTime,4,6)}</td> --%>
	                        <td>
	                        	<c:if test="${not empty trade.tranDate}">
	                        		${fn:substring(trade.tranDate,0,4)}-${fn:substring(trade.tranDate,4,6)}-${fn:substring(trade.tranDate,6,8)}
	                        		&nbsp;
	                        	</c:if>
		                        <c:if test="${not empty trade.tranTime}">
		                        	${fn:substring(trade.tranTime,0,2)}:${fn:substring(trade.tranTime,2,4)}:${fn:substring(trade.tranTime,4,6)}
		                        </c:if>
	                       </td>
	                        <td>${trade.tellerNo }</td>
	                        <td>
	                        	<c:choose>
		                        	<c:when test="${trade.tranType == 23 && trade.loanFlag == 'C' }">
		                        		入金
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 23 && trade.loanFlag == 'D' }">
		                        		出金
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 15 && trade.loanFlag == 'C' }">
		                        		转入
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 15 && trade.loanFlag == 'D' }">
		                        		转出
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 11 && trade.loanFlag == 'C' }">
		                        		转入
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 11 && trade.loanFlag == 'D' }">
		                        		转出
		                        	</c:when>
	                        	<c:otherwise>
	                        		 未知类型
	                        	</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <td>${trade.memo }</td>
	                        <td>${trade.accountNm }</td>
	                        <td>${trade.accountNo }</td>
	                        <td>
	                        	<c:choose>
		                        	<c:when test="${trade.tranType == 23 && trade.loanFlag == 'C' }">
		                        		+
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 23 && trade.loanFlag == 'D' }">
		                        		-
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 15 && trade.loanFlag == 'C' }">
		                        		+
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 15 && trade.loanFlag == 'D' }">
		                        		-
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 11 && trade.loanFlag == 'C' }">
		                        		+
		                        	</c:when>
		                        	<c:when test="${trade.tranType == 11 && trade.loanFlag == 'D' }">
		                        		-
		                        	</c:when>
	                        	</c:choose>
	                        	<fmt:formatNumber value="${trade.tranAmt }"  pattern="#,##0.00"/>
	                        </td>
	                        <td>-<fmt:formatNumber value="${trade.pdgAmt }"  pattern="#,##0.00"/></td>
	                        <td><fmt:formatNumber value="${trade.accBalAmt }"  pattern="#,##0.00"/></td>
	                        <td><a href="javascript:void(0)" onclick="showcode('${trade.verifyCode }',this);" class="print-btn block">打印</a>
	                    </tr>
                	</c:forEach>
                	
                </table>
                </div>
                	<p class="btn-m hidden bill-p"><a href="javascript:void(0);" onclick="readyprint();" class="block left back-btn back-btn2">打印</a><a href="<%=path %>/rest/trade/toTrade?type=jy" class="block left back-btn">返回</a>&nbsp;&nbsp;<a onclick="downloadpdf()" href="#" class="block black font13" style="line-height:36px"><img src="<%=path %>/pay/images/pdf.png" style="margin-top:-4px">&nbsp;下载</a></p>
                	<p class="font13 bill-txt"><b>打印校验码说明：</b><br>可使用打印校验码在中信银行公司网银首页上，以B/S方式，在线打印其附属的电子回单（带红章）。<br>点击进入中信银行首页 <a href="http://bank.ecitic.com" target="_blank" class="black">http://bank.ecitic.com</a><br><br></p>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
		toPage();
		
		if("<%=checkBankBool%>" == 'success'){
			$("#checkBank").show();
		}else{
			$("#checkBank").hide();
		}
		
		$("#search").bind("click", function() {
			if (!validate()) {
				return;
			}
			
			var btime = $("#btime").val();
			var etime = $("#etime").val();
			var pno = getParameter('pno');
			
			location = BASE_URL + "/rest/user/checkbill?pno="+pno+"&btime="+btime+"&etime="+etime;
		});
		
	});
	
	function validate(){
		var btime = $("#btime").val();
		var etime = $("#etime").val();
		
		var flag = false;
		if (btime) {
			flag = true;
		} else {
			flag = false;
			alert('请输开始时间');
			return;
		}
		if (etime) {
			flag = true;
		} else {
			flag = false;
			alert('请输入结束时间');
			return;
		}
		
		if(btime > etime){
			flag = false;
			alert('结束时间小于起始时间');
			return;
		}
		
		return flag;
	}
	
	//分页
	function getParameter(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null)
			return unescape(r[2]);
		return null;
	}
	
	function toPage(){
		var totalPage = $('#totalPage').val();
		var totalRecords = $('#totalRecords').val();
		var pageNo = getParameter('pno');
		if (!pageNo) {
			pageNo = 1;
		}
		//生成分页
		//有些参数是可选的，比如lang，若不传有默认值
		kkpager.generPageHtml({
			pno : pageNo,
			//总页码
			total : totalPage,
			//总数据条数
			totalRecords : totalRecords,
			getLink : function(n) {
				return this.hrefFormer + this.hrefLatter + "?pno=" + n;
			}
		});
	}
	
	function readyprint(){
		var print = document.getElementById("bill").innerHTML;
		printdiv(print);
	}
	
	function printdiv(printpage)
	{
		var headstr = "<html><head><title></title></head><body>";
		var footstr = "</body>";
		var oldstr = document.body.innerHTML;
		document.body.innerHTML = headstr+printpage+footstr;
		window.print(); 
		document.body.innerHTML = oldstr;
		return false;
	}
	
	function showcode(value,child){
		var parent = child.parentNode;
		$(parent).html("<a href='javascript:void(0);' target='_blank' onclick='zhongxing();'>"+value+"</a>");
	}
	
	function zhongxing(){
		window.open('http://bank.ecitic.com/');
	}
	
	
    function downloadtest(){
    	var url = "<%=path%>/rest/user/download";
    	$("#download").attr("href",url);
    }
    
    function downloadpdf(){
    	var pno = getParameter('pno');
    	location = BASE_URL + "/rest/user/downloadpdf?pno="+pno;
    }
    
    function freshAccountMoney(){
		$.ajax({  
	        url : "<%=path %>/rest/trade/freshAccountMoney",   
	        dataType : 'json', 
	        data :{
			},
			success : function(data) {
				
				 if(data.info=='success'){
					 openAlert("刷新余额成功!");
					 $('#totalMoney').html(moneySplit(data.totalMoney));
					 $('#userMoney').html(moneySplit(data.userMoney));
					 $('#freezeMoney').html(moneySplit(data.freezeMoney));
				 }else{
			        openAlert("刷新金额失败!");
				 }
	        },  
	        error : function(data)//服务器响应失败处理函数  
	        {  
	         
	        }  
	    }); 
	}
    
</script>
                   