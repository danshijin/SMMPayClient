<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
String type=(String)request.getAttribute("buyOrSellerType");
String dateType=(String)request.getAttribute("dateType");
String statusType=(String)request.getAttribute("statusType");
String checkBankBool=(String)request.getAttribute("checkBankBool");
String orderNumber=(String)request.getAttribute("orderNumber");
String counterpart=(String)request.getAttribute("counterpart");
System.out.println("buyOrSeller-----------="+type+",checkBankBool="+checkBankBool+",dateType="+
dateType+",statusType="+statusType+",orderNumber="+orderNumber+",counterpart="+counterpart);
%>

<link type="text/css" rel="stylesheet" href="<%=path %>/pay/css/kkpager.css" />
<script src="<%=path %>/pay/js/kkpager.min.js"></script>

 <!----------------------------------JS模拟Select------------------------------------------->
                    <script>   
						 $(function() {
								//给买卖方初始化为全部
								$('#buyerOrSeller').attr("value","all");
								
								//根据过来的买卖方类型，显示不同的买卖方
								if("<%=type%>" == 'all'){
									$('#buyerOrSeller').attr("value","all");
									$("#allb").addClass('bs-list-b');
									$("#buyb").removeClass('bs-list-b');
									$("#sellerb").removeClass('bs-list-b');
								}else if("<%=type%>" =='buy'){
									$('#buyerOrSeller').attr("value","buy");
									$("#allb").removeClass('bs-list-b');
									$("#buyb").addClass('bs-list-b');
									$("#sellerb").removeClass('bs-list-b');
								}else if("<%=type%>" =='seller'){
									$('#buyerOrSeller').attr("value","seller");
									$("#allb").removeClass('bs-list-b');
									$("#buyb").removeClass('bs-list-b');
									$("#sellerb").addClass('bs-list-b');
								}
								if("<%=dateType%>" == 'day'){
									$('#timeFrame').html("当天");
								}else if("<%=dateType%>" =='threeMonth'){
									$('#timeFrame').html("最近三个月");
								}else if("<%=dateType%>" =='threeMonthAgo'){
									$('#timeFrame').html("三个月前交易");
								}

								if("<%=statusType%>" == 'paymentStatus'){
									$('#stateRange').html("待付款");
								}else if("<%=statusType%>" =='frozenStates'){
									$('#stateRange').html("已冻结");
								}else if("<%=statusType%>" =='finishedStatus'){
									$('#stateRange').html("已完成");
								}
								if("<%=checkBankBool%>" == 'success'){
									$("#checkBank").show();
								}else{
									$("#checkBank").hide();
								}
								if('<%=orderNumber%>'=='null'){
									$('#orderNumber').val('');//交易订单号
								}else{
									$('#orderNumber').val('<%=orderNumber%>');//交易订单号
								}
								
								if('<%=counterpart%>'=='null'){
									$('#counterpart').val('');//交易对方	
								}else{
									$('#counterpart').val('<%=counterpart%>');//交易对方
								}
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
								var moneyStatus= $("#moneyStatus").val();
								if(moneyStatus=='000001'){
									$('#totalMoney').html('--');
									 $('#userMoney').html('--');
									 $('#freezeMoney').html('--');
							 		openAlert("得到账户余额失败!");
								}
							});

							//分页
							function toPage(){
								
								function getParameter(name) {
									var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
									var r = window.location.search.substr(1).match(reg);
									if (r != null)
										return unescape(r[2]);
									return null;
								}
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
										var buyerOrSeller=$('#buyerOrSeller').val();//买卖方
										var timeFrame=$('#timeFrame').text();//时间
										timeFrame=timeFrame.replace(/\s+/g,"");
										var stateRange=$('#stateRange').text();//状态
										stateRange=stateRange.replace(/\s+/g,"");
										var orderNumber=$('#orderNumber').val();//交易订单号
										var counterpart=$('#counterpart').val();//交易对方
										if(stateRange=="所有状态"){
											stateRange="allStatus";
										}else if(stateRange=="待付款"){
											stateRange="paymentStatus";
										}else if(stateRange=="已冻结"){
											stateRange="frozenStates";
										}else if(stateRange=="已完成"){
											stateRange="finishedStatus";
										}
										if(timeFrame=="当天"){
											timeFrame="day";
										}else if(timeFrame=="最近一周"){
											timeFrame="week";
										}else if(timeFrame=="最近三个月"){
											timeFrame="threeMonth";
										}else if(timeFrame=="三个月前交易"){
											timeFrame="threeMonthAgo";
										}
										return this.hrefFormer + this.hrefLatter + "?pno=" + n+"&buyerOrSeller="+
										buyerOrSeller+"&timeFrame="+timeFrame+"&stateRange="+stateRange+
												"&orderNumber="+orderNumber+"&counterpart="+encodeURIComponent(encodeURIComponent(counterpart));
									}
								});
							}
						
						//买入还是卖出方
						function buyerOrSeller(type){
							location="<%=path %>/rest/trade/toTrade?buyerOrSeller="+type;
						}
						//时间范围
						function timeFrame(type){
							var buyerOrSeller=$('#buyerOrSeller').val();//买卖方
							var stateRange=$('#stateRange').text();//状态
							stateRange=stateRange.replace(/\s+/g,"");

							if(stateRange=="所有状态"){
								stateRange="allStatus";
							}else if(stateRange=="待付款"){
								stateRange="paymentStatus";
							}else if(stateRange=="已冻结"){
								stateRange="frozenStates";
							}else if(stateRange=="已完成"){
								stateRange="finishedStatus";
							}
							
							location="<%=path %>/rest/trade/toTrade?buyerOrSeller="+buyerOrSeller+
							"&timeFrame="+type+"&stateRange="+stateRange;
						}
						//状态范围
						function stateRange(type){
							var buyerOrSeller=$('#buyerOrSeller').val();//买卖方
							var timeFrame=$('#timeFrame').text();//时间
							timeFrame=timeFrame.replace(/\s+/g,"");
							var stateRange=$('#stateRange').text();//状态
							stateRange=stateRange.replace(/\s+/g,"");
							if(timeFrame=="当天"){
								timeFrame="day";
							}else if(timeFrame=="最近一周"){
								timeFrame="week";
							}else if(timeFrame=="最近三个月"){
								timeFrame="threeMonth";
							}else if(timeFrame=="三个月前交易"){
								timeFrame="threeMonthAgo";
							}
							location="<%=path %>/rest/trade/toTrade?buyerOrSeller="+buyerOrSeller+
							"&timeFrame="+timeFrame+"&stateRange="+type;
							
						}
						//查询
						function searchTrade(){
							var buyerOrSeller=$('#buyerOrSeller').val();//买卖方
							var timeFrame=$('#timeFrame').text();//时间
							timeFrame=timeFrame.replace(/\s+/g,"");
							var stateRange=$('#stateRange').text();//状态
							stateRange=stateRange.replace(/\s+/g,"");
							var orderNumber=$('#orderNumber').val();//交易订单号
							var counterpart=$('#counterpart').val();//交易对方
							if(timeFrame=="当天"){
								timeFrame="day";
							}else if(timeFrame=="最近一周"){
								timeFrame="week";
							}else if(timeFrame=="最近三个月"){
								timeFrame="threeMonth";
							}else if(timeFrame=="三个月前交易"){
								timeFrame="threeMonthAgo";
							}
							
							if(stateRange=="所有状态"){
								stateRange="allStatus";
							}else if(stateRange=="待付款"){
								stateRange="paymentStatus";
							}else if(stateRange=="已冻结"){
								stateRange="frozenStates";
							}else if(stateRange=="已完成"){
								stateRange="finishedStatus";
							}
							location="<%=path %>/rest/trade/toTrade?buyerOrSeller="+buyerOrSeller+
									"&timeFrame="+timeFrame+"&stateRange="+stateRange+
									"&orderNumber="+orderNumber+
									"&counterpart="+encodeURIComponent(encodeURIComponent(counterpart));
							
						}
						//查看
						function toLook(id){
							var buyerOrSeller = $("#buyerOrSeller").val();
							location="<%=path %>/rest/trade/toLook?paymentNo="+id+"&buyerOrSeller="+buyerOrSeller;
						}
						//刷新余额
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
										 $('#totalMoney').html('--');
										 $('#userMoney').html('--');
										 $('#freezeMoney').html('--');
								        openAlert("刷新金额失败!");
									 }
						        },  
						        error : function(data)//服务器响应失败处理函数  
						        {  
						         
						        }  
						    }); 
						}
						//金额格式化
						function moneySplit(money){
							 var moneyS=money.split(".");
							 var str="";
							 for(var i=moneyS[0].length;i>0;i--){
								 str=moneyS[0].substring(i-1,i)+str;
								 if(str.replace(/,/g,'').length%3==0){
									 str=","+str;
								 }
							 }
							 
							 if(moneyS.length>1){
								 str=str+"."+moneyS[1];
							 }else{
								 str=str+".000";		
							 }
							 
							 return str.substring(0,str.length-1);
						}

						//关闭
						function closePay(id){
 							ShowDiv('MyDiv1','fade1');
							$("#hiddenid").val(id);
							return;							}
					</script>
    <div class="main2">
        <div class="web position yahei black">
            <div class="payment"  style="">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">交易记录</b>
                    <span class="block left font14" id="checkBank" style="margin-left:158px;display: none">
                        <em class="fa fa-exclamation blue2 fa-lg">&nbsp;</em>
                       	 银行账户待验证&nbsp;
                        <a href="<%=path %>/rest/accountBind/toBindCard" class="blue2">立即验证></a>
                    </span>
                    <span class="block right font14">
                       	账户余额:￥<span id="totalMoney"><fmt:formatNumber value="${totalMoney}"  pattern="#,##0.00"/></span>&nbsp;&nbsp;
                                                                        可用余额：￥<span class="red2" id="userMoney"><fmt:formatNumber value="${userMoney}"  pattern="#,##0.00"/></span>元&nbsp;&nbsp;<a href="#" class="fa fa-refresh blue2 fa-lg" onclick="freshAccountMoney()">&nbsp;</a>
                        <span class="blcok" style="padding-top:10px"><a href="<%=path %>/rest/intoGold/into" class="block fj-a">入金</a></span>
                       	 冻结款项：￥<span class="orange" id="freezeMoney"><fmt:formatNumber value="${freezeMoney}"  pattern="#,##0.00"/></span>元
                    </span>
                </p>
                <table cellpadding="0" cellspacing="0" width="300px" class="bs-list font14 left">
                    <tr>
                         <td class="bs-list-b"   id="allb">
                        <a href="#" class="black" onclick="buyerOrSeller('all')" >全部</a>
                        </td>
                        <td  id="buyb">
                        <a href="#" class="black" onclick="buyerOrSeller('buy')" >买入</a>
                        </td>
                        <td  id="sellerb">
                        <a href="#" class="black" onclick="buyerOrSeller('seller')" >卖出</a>
                        </td>
                    </tr>
                </table>
                <div class="right block">
                    
                    <div class="block left" id="sel" style="padding-top:6px">
                        <dl>
                             <dt class="left"> 
                                 <h3 class="select-box select-box2 block left" id="timeFrame">最近一周</h3>
                                 <a href="javascript:;" class="block sel-a2" style="right:20px !important">
                                 <i class=" fa fa-caret-down black"></i>
                                 </a>
                                 <ul class="sel-ul" id="ddd" >
                                     <li><span onclick="timeFrame('day')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当天&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
                                     <li><span onclick="timeFrame('week')">&nbsp;&nbsp;&nbsp;最近一周&nbsp;&nbsp;</span></li>
                                     <li><span onclick="timeFrame('threeMonth')">&nbsp;&nbsp;&nbsp;最近三月&nbsp;&nbsp;</span></li>
                                     <li><span onclick="timeFrame('threeMonthAgo')">三个月前交易</span> </li>
                                 </ul>
                                 <span class="block left" style="width:1px; border-left:1px #3f3639 solid; height:16px; margin-left:20px"></span>
                             </dt>
                             <dt class="left" > 
                                 <h3 class="select-box select-box2" id="stateRange">所有状态</h3><a href="javascript:;" class="block sel-a2"><i class=" fa fa-caret-down black"></i></a>
                                 <ul class="sel-ul" style="left:0px !important" >
                                     <li><span onclick="stateRange('allStatus')">&nbsp;&nbsp;&nbsp;所有状态&nbsp;&nbsp;&nbsp;</span></li>
                                     <li><span onclick="stateRange('paymentStatus')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;待付款&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
                                     <li><span onclick="stateRange('frozenStates')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;已冻结&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
                                     <li><span onclick="stateRange('finishedStatus')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;已完成&nbsp;&nbsp;&nbsp;&nbsp;</span></li>
                                 </ul>
                             </dt>
                         </dl>
                     </div>    
                </div>
                <div class="clear"></div>
                <div class="search font14">
                    <form>
                        商城订单号<input type="text" class="search-box" id="orderNumber">
                        交易对方<input type="text" class="search-box" id="counterpart">
                        <a href="#" class="search-btn block" onclick="searchTrade()">搜索</a>
                    </form>
                </div>
                <table cellpadding="0" cellspacing="0" width="100%" class="bill-tab font14">
                    <tr>
                    	<th>交易编号</th>
                        <th>商城订单号</th>
                        <th>请求时间</th>
                        <th>产品名称</th>
                        <th>说明</th>
                        <th>交易对方</th>
                        <th>金额</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                   <c:if test="${totalRecords >= '0' }">
                    <c:forEach items="${tradList}" var="tradList">
                    <tr>
                      	<td>${tradList.paymentNo}</td>
                        <td>${tradList.mallOrderId}</td>
                        <td>${tradList.applyTime}</td>
                        <td>${tradList.productName}</td>
                        <td class="t-left">${tradList.productDetail}</td>
                        <td>${tradList.opposit}</td>
                        <td>
                        <c:if test="${tradList.sellOrBuy == '1' }">
                         <span class="red2">
                        -
                        <fmt:formatNumber value="${tradList.dealMoney}"  pattern="#,##0.00"/>
                       </span>
                        </c:if>
                        <c:if test="${tradList.sellOrBuy == '2' }">
                         <span class="green">
                        +
                        <fmt:formatNumber value="${tradList.dealMoney}"  pattern="#,##0.00"/>
                       </span>
                        </c:if>
                        </td>
                        <td>
                      	<c:if test="${tradList.paymentStatus == '0' }">
	                        <c:if test="${tradList.sellOrBuy == '1' }">
		                        <span class="red2">
	                   			    待付款
	                   			</span>
                        	</c:if>
                        <c:if test="${tradList.sellOrBuy == '2' }">
	                   		待付款
                        </c:if>
                         </c:if>
                        <c:if test="${tradList.paymentStatus == '1' }">
                         	<span style=" color:#0379B8;">
                      		已冻结
                      		</span>
                        </c:if>
                        
                        <c:if test="${tradList.paymentStatus == '2' }">
                      	已完成
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '3' }">
                      	已关闭
                        </c:if>
                        <c:if test="${tradList.paymentStatus == '4' }">
                      	冻结失败
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '5' }">
                      	解冻支付失败
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '6' }">
                      	待退款
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '7' }">
                      	已退款
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '8' }">
                      	退款失败
                        </c:if>
                         <c:if test="${tradList.paymentStatus == '9' }">
                      	冻结中
                        </c:if>
                        <c:if test="${tradList.paymentStatus == '10' }">
                      	付款中
                        </c:if>
                        <c:if test="${tradList.paymentStatus == '11' }">
                      	退款中
                        </c:if>
                        </td>
                        <td>
                        <c:choose>
	                        <c:when test="${tradList.paymentStatus == '0' }">
		                        <c:if test="${tradList.sellOrBuy == '1' }">
		                          <a href="#" onclick="closePay('${tradList.paymentId}')" class="black">关闭</a>｜
		                        </c:if>
	                        	<a href="#" class="black" onclick="toLook('${tradList.paymentNo}')">查看</a>
	                        </c:when>
	                    	<c:when test="${tradList.paymentStatus == '1' }">
	                        <a href="#" class="black" onclick="toLook('${tradList.paymentNo}')">查看</a>
	                        </c:when>
	                        <c:when test="${tradList.paymentStatus == '2' }">
	                        <a href="#" class="black" onclick="toLook('${tradList.paymentNo}')">查看</a>
	                        </c:when>
	                        <c:otherwise>
	                        <a href="#" class="black" onclick="toLook('${tradList.paymentNo}')">查看</a>
	                        </c:otherwise>
                        </c:choose>
                        </td>
                    </tr>
                    </c:forEach>
					</c:if>
					<c:if test="${totalRecords== '0'}">
					<tr>
					<td colspan="9" align="center">您最近没有交易记录！</td>
					</tr>
					</c:if>
                </table>
                    
                <div>
								<div style="width:80%;margin:0 auto;">
										<div id="kkpager"></div>
										<input type="hidden" value="${totalPage}" id="totalPage">
										<input type="hidden" value="${totalRecords}" id="totalRecords">
										<input type="hidden"  id="buyerOrSeller"  value="">
										<input type="hidden"  id="moneyStatus"  value="${moneyStatus}">
								</div>
				</div>
            </div>
            					
			</div>
        </div>
        
        <div class="black-bg" id="fade1">
	        <div class="alter yahei black" id="MyDiv1" >
	            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
	            <span class="block left">
	                <b style="font-size:24px">确认关闭！</b><br>
	                <input type="hidden" id="hiddenid">
	            </span>
	            <div class="clear"></div>
	            <a href="#" class="close-btn" style="width: 80px;float: left;margin-right: 10px;" onclick="CloseDivSure('MyDiv1','fade1')">确 定</a>
	            <a href="#" class="close-btn" style="width: 80px;float: left;" onclick="CloseDivClose('MyDiv1','fade1')">取 消</a>
	        </div>
	    </div>
	    
	    <script type="text/javascript">
		    function ShowDiv(show_div,bg_div){
		  		$("#"+bg_div).css("display", "block").width($(document).width()).height($(document).height());
		  		$("#"+show_div).css("display", "block");
		  		makeDivCenterInWindow(show_div);
		  	};
	    	//关闭弹出层
		  	function CloseDivSure(show_div,bg_div){
		  		document.getElementById(show_div).style.display='none';
		  		document.getElementById(bg_div).style.display='none';
		  		var id = $("#hiddenid").val();	
				$.ajax({  
			        url : "<%=path %>/rest/trade/closePay",   
			        dataType : 'json', 
			        data :{
			        	paymentId:id
					},
					success : function(data) {
						
						 if(data.info=='success'){
							 openAlert("关闭成功!");
							 location.reload();
						 }else{
					        openAlert("关闭失败!");
						 }
			        },  
			        error : function(data)//服务器响应失败处理函数  
			        {  
			        }  
			    }); 
			}
	    	
		  	function CloseDivClose(show_div,bg_div){
		  		document.getElementById(show_div).style.display='none';
		  		document.getElementById(bg_div).style.display='none';
			}
	    </script>

    
