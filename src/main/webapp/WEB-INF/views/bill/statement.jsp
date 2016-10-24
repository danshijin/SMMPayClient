<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.smmpay.inter.dto.res.ResQueryTradingRecordDTO"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

String checkBankBool=(String)request.getAttribute("checkBankBool");
java.text.DecimalFormat df =new java.text.DecimalFormat("0.##");
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
                    <b class="block left">对账单</b>
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
	               <form id="frm1" style="float:right; ">
                        <input type="hidden" name="timeDistrictType" id="timeDistrictType"/>
               			<input type="hidden" name="tranType" id="tranType"/>
                    </form>
	                
	                <div class="right block">
                    
	                    <div class="block left" id="sel" style="padding-top:6px">
	                        <dl>
	                             <dt class="left"> 
	                                 <h3 class="select-box select-box2 block left" id="timeFrame">最近一周</h3>
	                                 <a href="javascript:;" class="block sel-a2" style="right:20px !important">
	                                 <i class=" fa fa-caret-down black"></i>
	                                 </a>
	                                 <ul class="sel-ul" id="ddd" >
	                                     <li><span onclick="timeFrame('0')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当天&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="timeFrame('1')">&nbsp;&nbsp;&nbsp;最近一周&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="timeFrame('2')">&nbsp;&nbsp;&nbsp;最近三月&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="timeFrame('3')">三个月前交易</span> </li>
	                                 </ul>
	                                 <span class="block left" style="width:1px; border-left:1px #3f3639 solid; height:16px; margin-left:20px"></span>
	                             </dt>
	                             <dt class="left" > 
	                                 <h3 class="select-box select-box2" id="stateRange">所有交易</h3><a href="javascript:;" class="block sel-a2"><i class=" fa fa-caret-down black"></i></a>
	                                 <ul class="sel-ul" style="left:0px !important" >
	                                 	 <li><span onclick="stateRange('0')">&nbsp;&nbsp;&nbsp;&nbsp;所有交易&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="stateRange('1')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入金&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="stateRange('2')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出金&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="stateRange('3')">&nbsp;&nbsp;&nbsp;&nbsp;解冻支付&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="stateRange('4')">&nbsp;&nbsp;&nbsp;&nbsp;资金解冻&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
	                                     <li><span onclick="stateRange('5')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手续费&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
	                                 </ul>
	                             </dt>
	                         </dl>
	                     </div>    
	                </div>
                <div id="bill">
                <table style="cellpadding: 0; cellspacing: 0; width:100%;" class="bill-tab font14">
                    <tr>
                        <th>交易时间</th>
                        <th>对方账户名称</th>
                        <th>账号及开户行</th>
                        <th>借</th>
                        <th>贷</th>
                        <th>账户余额</th>
                        <th>摘要</th>
                    </tr>
                    <c:forEach items="${tradeList}" var="trade">
	                    <tr>
	                       <td>
	                        	${trade.trDate.substring(0, 10)}
	                        	<br />
	                        	${trade.trDate.substring(11)}
	                       </td>
	                       <td>
	                        	${trade.oppositCompanyName}
	                       </td>
	                       <td>
	                        	${trade.oppositBankName}
	                        	<br />
	                        	${trade.oppositBankAccount}
	                       </td>
	                        <td><fmt:formatNumber value="${trade.borrow}" pattern="0.00" /></td>
	                        <td><fmt:formatNumber value="${trade.loan}" pattern="0.00" /></td>
	                        <td><fmt:formatNumber value="${trade.userMoney}" pattern="0.00" /></td>
	                        <td>${trade.note}</td>
	                	</tr>
                	</c:forEach>
                	
                </table>
                </div>
                 <div style="width: 80%; margin: 0 auto;">
						<div id="kkpager"></div>
						<input type="hidden" value="${totalPage}" id="totalPage">
						<input type="hidden" value="${totalRecords}" id="totalRecords">
				</div>
                	<p class="btn-m hidden bill-p">
                		<a href="javascript:void(0)" onclick="exportExcel()" class="block left back-btn">导出EXCEL</a>&nbsp;&nbsp;
                		<a href="javascript:void(0);" onclick="readyprint();" class="block left back-btn back-btn2">打印</a>
                	</p>
                	<p class="font13 bill-txt"><b>电子回单说明：</b><br>可使用电子防伪码在在中信银行公司网银首页上，以B/S方式，在线打印其附属账户的电子回单（带红章）。
                	<br>•点击进入中信银行首页 <a href="http://bank.ecitic.com" target="_blank" class="black">http://bank.ecitic.com</a>
                	<br>•选择 “公司网银登录”- "电子回单服务"
                	<br>•在弹出窗口中选择 “附属帐户电子回单” 并输入电子回单防伪码</p>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
	$(function() {
		
		$("#statement").addClass("dzd-a-o");
		
		if("${timeDistrictType}" == '0'){
			$('#timeFrame').html("当天");
		} else if("${timeDistrictType}" =='1'){
			$('#timeFrame').html("最近一周");
		} else if("${timeDistrictType}" =='2'){
			$('#timeFrame').html("最近三月");
		} else if("${timeDistrictType}" =='3'){
			$('#timeFrame').html("三个月前交易");
		}

		if("${tranType}" == '0'){
			$('#stateRange').html("所有交易");
		} else if("${tranType}" =='1'){
			$('#stateRange').html("入金");
		} else if("${tranType}" =='2'){
			$('#stateRange').html("出金");
		} else if("${tranType}" =='3'){
			$('#stateRange').html("解冻支付");
		} else if("${tranType}" =='4'){
			$('#stateRange').html("资金解冻");
		} else if("${tranType}" =='5'){
			$('#stateRange').html("手续费");
		}
		
		var timeDistrictType = "${timeDistrictType}" || 1;
		var tranType = "${tranType}" || 0;
		$("#timeDistrictType").val(timeDistrictType);
		$("#tranType").val(tranType);
		
		toPage();
		
		var oflink = document.getElementById('sel');
		 var aDt = oflink.getElementsByTagName('dt');
		 var aUl = oflink.getElementsByTagName('ul');
		 var aH3= oflink.getElementsByTagName('h3');
		 for(var i=0;i<aDt.length;i++){
			 aDt[i].index = i;
			 aDt[i].onclick = function(ev){
				 var ev = ev || window.event;
				 var This = this;
				 for(var i=0;i<aUl.length;i++){
					 aUl[i].style.display = 'none';
				 }
				 aUl[this.index].style.display = 'block';
				 document.onclick = function(){
					 aUl[This.index].style.display = 'none';
				 };
				 ev.cancelBubble = true;
	
			 };
		 }
		 for(var i=0;i<aUl.length;i++){
	
			 aUl[i].index = i;
	
			 (function(ul){
	
				 var iLi = ul.getElementsByTagName('li');
	
				 for(var i=0;i<iLi.length;i++){
					 iLi[i].onmouseover = function(){
						 this.className = 'hover';
					 };
					 iLi[i].onmouseout = function(){
						 this.className = '';
					 };
					 iLi[i].onclick = function(ev){
						 var ev = ev || window.event;
						 aH3[this.parentNode.index].innerHTML = this.innerHTML;
						 ev.cancelBubble = true;
						 this.parentNode.style.display = 'none';
					 };
				 }
	
			 })(aUl[i]);
		 }
	});
	
	//时间范围
	function timeFrame(type){
		$("#timeDistrictType").val(type);
		$("#frm1").attr("action", "<%=path %>/rest/trade/statement");
		$("#frm1").submit();
	}
	//状态范围
	function stateRange(type){
		$("#tranType").val(type);
		$("#frm1").attr("action", "<%=path %>/rest/trade/statement");
		$("#frm1").submit();
	}
	
	function exportExcel(){
		if("${tradeList.size()}" == 0){
			alert("没有数据！");
			return;
		}
		
		$("#frm1").attr("action", "<%=path %>/rest/trade/statementExport");
		$("#frm1").submit();
	}
	
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
				return this.hrefFormer + this.hrefLatter + "?pno=" + n + "&timeDistrictType="+$("#timeDistrictType").val() +"&tranType=" + $("#tranType").val();
			}
		});
	}
	
	function readyprint(){
		if("${tradeList.size()}" == 0){
			alert("没有数据！");
			return;
		}
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
                   