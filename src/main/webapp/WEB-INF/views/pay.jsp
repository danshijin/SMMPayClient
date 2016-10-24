<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript">
<!--

//-->
$(function() {
	
	var figure=0;//手续费

var moneyStatus= "${moneyStatus}";
if(moneyStatus=='000001'){
	 $('#totalMoney').html('--');
	 $('#userMoney').html('--');
	openAlert("得到账户余额失败!");
}
});

  
/**  
 * 去除千分位  
 *@param{Object}num  
 */  
function delcommafy(num){  
   num = num.replace(/[ ]/g, "");//去除空格  
   num=num.replace(/,/gi,'');  
   return num;  
}  


function calculateCashMoney(){
	var userMoneyfigure=0;
	//根据可用金额计算最大可出金金额
	var userMoney=$("#userMoney").html();//可用金额
	userMoney=delcommafy(userMoney);
	if(userMoney<=10000){
		userMoneyfigure=5.50;
	}else if(userMoney<=100000 && userMoney>10000){
		userMoneyfigure=10.50;
	}else if(userMoney<=500000 && userMoney>100000){
		userMoneyfigure=15.50;
	}else if(userMoney<=1000000 && userMoney>500000){
		userMoneyfigure=20.50;
	}else{
		userMoneyfigure=200.50;
	}
	var cashMoney=userMoney-userMoneyfigure;//可体现金额等于可用余额减去手续费
	$("#cashMoney").html(cashMoney.toFixed(2));
}


function calculate(){
	figure=0;
	var  drawMoney=$("#drawMoney").val();//输入的金额
	
	if(drawMoney==null || drawMoney==""){
		//openAlert("请输入金额");
		$("#poundage").text("");
		return;
	}
	  var exp = /^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;   
	  if(!exp.test(drawMoney)){
		  openAlert("格式不正确(保留两位小数，最大金额为99999999.99)");
		  $("#poundage").text("");
		  $("#drawMoney").val("");
		  return ;
	}else{
		
		 if($("#bindTypeId").val()!="" && $("#bindTypeId").val()!="108"){
				 if(drawMoney<=10000){
						figure=5.50;
						$("#poundage").text("手续费："+figure+"元");
					}else if(drawMoney<=100000 && drawMoney>10000){
						figure=10.50;
						$("#poundage").text("手续费："+figure+"元");
					}else if(drawMoney<=500000 && drawMoney>100000){
						figure=15.50;
						$("#poundage").text("手续费："+figure+"元");
					}else if(drawMoney<=1000000 && drawMoney>500000){
						figure=20.50;
						$("#poundage").text("手续费："+figure+"元");
					}else{
						figure=200.50;
						$("#poundage").text("手续费："+figure+"元");
					}
		 }else{
			 $("#poundage").text("手续费：0元");
		 }
		
	}
}


function freshAccountMoney(){
	$.ajax({  
        url : "<%=path %>/rest/trade/freshAccountMoney",   
        dataType : 'json', 
        data :{
		},
		success : function(data) {
			 if(data.info=='success'){
				 
				 
				 if(data.info=='success'){
					 openAlert("刷新余额成功!");
					 $('#totalMoney').html(moneySplit(data.totalMoney));
					 $('#userMoney').html(moneySplit(data.userMoney));
					 
					 if($("#bindTypeId").val()!="" && $("#bindTypeId").val()!="108"){//刷新余额后，判断是否是中信银行卡。
						 calculateCashMoney();
					 }
					
				 }else{
					 $('#totalMoney').html('--');
					 $('#userMoney').html('--');
			        openAlert("刷新金额失败!");
				 }
				 
			 }else{
				 openAlert("刷新失败");
			 }
        },  
        error : function(data)//服务器响应失败处理函数  
        {  
         
        }  
    }); 
}

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
		 str=str+".000"		
	 }
	 
	 return str.substring(0,str.length-1);
}

</script>
       <div class="main2">
        <div class="web position yahei black">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">出金/提款</b>
                </p>
			<ul class="block total font16">
				<li>账户总金额： ￥<span class="red" id="totalMoney"><fmt:formatNumber value="${totalMoney}"  pattern="#,##0.00"/>  </span>元</li>
				<li>可用金额： ￥ <span  id="userMoney"><fmt:formatNumber value="${userMoney}"  pattern="#,##0.00"/></span> 元 &nbsp;&nbsp;</li>
				<li id="cashmoneyLi" >可出金金额： ￥ <span  id="cashMoney"></span> 元 &nbsp;&nbsp;</li>
				
				<a href="#"
					onclick="freshAccountMoney()" class="fa fa-refresh blue2 block">&nbsp;</a>
			</ul>
			<div class="paying-box hidden">
                    <div class="sys_item_spec">
                        <dl class="sys_item_specpara" data-sid="1">
                            <dd>
                                <ul class="sys_spec_img">
                                    <li><span class="pay-left" style="line-height:64px; margin-bottom:20px">选择提款方式：</span></li>
                                    <li data-aid="1" class="li-border1 position selected"  >
                                        <a href="javascript:;" class="choose ">
                                            <img src="<%=path %>/pay/images/cash.png" class="left block" style="margin:0px 20px 0px 25px">
                                            <span class="left block">实时出金<br><span class="gray font13">实时到账</span></span>     
                                        </a>
                                        <i><span class="fa fa-check white"></span></i>
                                    </li>
                                    <li class="clear" ></li>
                                    <li><span class="pay-left" style="line-height:64px">选择银行账户：</span></li>
                                    
                                     <input type="hidden" name="bankId" id="bankId">  
                                       <input type="hidden" name="bindTypeId" id="bindTypeId">  
                                       
                                    <c:forEach items="${banklist}" var="bankinfo" varStatus="status">
	                                     <li data-aid="1" id="${bankinfo.bindId}" value="${bankinfo.bindTypeId}" class="li-border position li-border2" style="width:390px">
	                                        <a href="javascript:;" class="choose choose2" style="width:390px">
												<img src="<%=path %>/pay/images/bankImages/${bankinfo.bindTypeId}.jpg" class="left block" style="margin:0px 20px 0px 25px;"/>
	                                           <span class=" block blue2 font13">${bankinfo.bindBank}&nbsp;&nbsp;${bankinfo.bankAccountNo}</span>  
	                                        </a>
	                                        <span class="radio"></span>
	                                        <i><span class="fa fa-check white"></span></i>
	                                    </li>
                                    
                                    <p class="clear"></p>
                                    <li><span class="pay-left"></span></li>
         						  </c:forEach>
         						  
         						  <c:choose>
							<c:when test="${banklist==null}">
						            <input type="hidden" name="bankflag" id="bankflag" value="nobank"/>
						       </c:when>
						       	<c:otherwise>
						             <input type="hidden" name="bankflag" id="bankflag" value=bindingbank/>
						       </c:otherwise>
												</c:choose>
         						  
         						  
                                    <li><a href="<%=path %>/rest/accountBind/toBindCard" class="blue2 font14">+ 添加账户</a></li>
                                    <p class="clear"></p>
                                    
                                </ul>
                            </dd>
                        </dl>
                        <ul>
                            <li><span class="pay-left" style="line-height:36px">提款金额：</span></li>
                            <li class="font14"><input type="text" name="drawMoney" onblur="calculate()"  id="drawMoney" class="inform"> 元&nbsp;&nbsp;&nbsp;<span name="poundage" id="poundage" class="gray"></span>
                            </li>
                            <p class="clear"></p>
                            <li><span class="pay-left" style="line-height:36px"></span></li>
                            <li class="btn-m"><a href="#" class="block left back-btn back-btn2" id="Button1" onclick="ShowDiv('MyDiv','fade')" >确认提款</a><a href="<%=path %>/rest/trade/toTrade?type=jy" class="block left back-btn">返回</a></li>
                        </ul>
                        <div class="clear"></div>
                        <div class="fee-txt font13">
                            <p><b>交易手续费</b></p>
                            <table cellpadding="0" cellspacing="0" width="440px">
                                <tr>
                                    <td>交易金额</td>
                                    <td>手续费</td>
                                </tr>
                                <tr>
                                    <td>1万元（含）以下</td>
                                    <td>5.50</td>
                                </tr>
                                <tr>
                                    <td>1-10万元（含）</td>
                                    <td>10.50</td>
                                </tr>
                                <tr>
                                    <td>10-50万元（含）</td>
                                    <td>15.50</td>
                                </tr>
                                <tr>
                                    <td>50-100万元（含）</td>
                                    <td>20.50</td>
                                </tr>
                                <tr>
                                    <td>100万元以上</td>
                                    <td>0.02‰+0.5（最多200.50元）</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
              
                
   <div class="black-bg" id="showmsg">
        <div class="altertt yahei black" id="showmsgcontent">
	         <p style="font-size:18px;line-height:24px;" align="center">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">
	         <span id="alt"  style="font-size:18px">请稍候，正在与银行通讯！<br> 请勿关闭本窗口<br><img src='<%=path%>/pay/images/loading.gif' /></span>
	         </span>
	         </p>
        </div>
    </div>
                
                <script type="text/javascript">
                
	                $(function(){
	        		      
	                	$(document).ajaxStart(function () {
	                		  $("#showmsg").show();
		        		      $("#showmsgcontent").show();
	                	});
	                	$(document).ajaxSuccess(function () {
	                		  $("#showmsg").hide();
		        		      $("#showmsgcontent").hide();
	                	});

						$(".sys_item_spec .sys_item_specpara").each(function(){
							var i=$(this);
							var p=i.find(".li-border");
							p.click(function(){
								
								if(!!$(this).hasClass("selected")){
									$(this).removeClass("selected");
									i.removeAttr("data-attrval");
									 $("#bankId").val("");
									 $("#bindTypeId").val("");
								}else{
									
									$("#bankId").val(this.id);
									$(this).addClass("selected").siblings(".li-border2").removeClass("selected");
									i.attr("data-attrval",$(this).attr("data-aid"))
									$("#bindTypeId").val(this.value);//保存当前选中银行卡的id
									if(this.value!="108"){//不是中信，计算可用余额和手续费
										calculateCashMoney();
									
										calculate();
									}else{
										var cashMoney=${userMoney};
										$("#cashMoney").html(cashMoney.toFixed(2));
									}
								}
							})
						})
					})
						  //弹出隐藏层
						  function ShowDiv(show_div,bg_div){
			                	if($("#bankflag").val()=="nobank"){
			                		openAlert("还没有绑定银行卡，请先添加账户");
									  return;
								  }
							  if($("#drawMoney").val()=="" || $("#drawMoney").val()==null){
								  openAlert("请填写提款金额");
								  return;
							  }
							  if($("#bankId").val()=="" || $("#bankId").val()==null){
								  openAlert("请选择转账银行");
								  return;
							  }
							  
							  if($("#bindTypeId").val()!="108"){//如果不是中信银行卡，计算手续费
								  //如果提款金额大于计算出来的可出金金额，则余额不足
								  if(Number($("#drawMoney").val())>Number($("#cashMoney").html())){
									  openAlert("可用余额不足");
									  return;
								  }
								$("#factorage").html("￥"+figure); //显示出手续费
							  }else{
								  //如果提款金额大于可用金额，则余额不足
								  if(Number($("#drawMoney").val())>Number("${userMoney}")){
									  openAlert("可用余额不足");
									  return;
								  }
								  $("#factorage").html("￥0"); //是中信，0元手续费
							  }
							  
							  $("#showmoney").html("￥"+$("#drawMoney").val()); //显示出提款金额
							
							  
						  //document.getElementById(show_div).style.display='block';
						  document.getElementById(bg_div).style.display='block' ;
						  var bgdiv = document.getElementById(bg_div);
						  bgdiv.style.width = document.body.scrollWidth;
						  $("#"+bg_div).height($(document).height());
						  
						//弹出隐藏层
				        $("#"+show_div).css("display", "block");
				        var top = ($(window).height() - $("#MyDiv").outerHeight()) / 2;
				        var left = ($(window).width() - $("#MyDiv").outerWidth()) / 2;
				        top = top < 0 ? 0 : top;
				        left = left < 0 ? 0 : left;
				        $("#"+show_div).css("top", top + "px");
				        $("#"+show_div).css("left", left + "px");
						  
						  };
						  
						  //关闭弹出层
						  function CloseDiv(show_div,bg_div)
						  {
						 	 document.getElementById(show_div).style.display='none';
						 	 document.getElementById(bg_div).style.display='none';
						 	 
						 	 if(show_div=="MyDiv2"){
						 		window.location="<%=path %>/rest/pay/paypage";
						 	 }
						  };
						  
						  function showNumber(show_div,bg_div,msg){
							  
							    $("#IdentifyGold").unbind("click");
							    setTimeout('$("#IdentifyGold").bind("click",IdentifyGold);',5000);//按钮禁用5s

								CloseDiv("MyDiv","fade");//关闭当前层
								
							  $.ajax({
							  		 type : "POST",
							  		 url : "<%=path %>/rest/pay/deposits",
							  		 data :{
							  		   "drawMoney":$("#drawMoney").val(),
							  		 	"bankId": $("#bankId").val()
							  		 },
							  	 dataType:"json",
							  		 success : function(data) {
							  			document.getElementById(show_div).style.display='block';
										  document.getElementById(bg_div).style.display='block' ;
										  var bgdiv = document.getElementById(bg_div);
										  bgdiv.style.width = document.body.scrollWidth;
										  $("#"+bg_div).height($(document).height());
							  		   if(data.info=='success'){
							  			 $("#serialNumber").text("提款成功!");
							  		   }else{
							  			 $("#mydivStyle").attr("class","block left fa fa-times fa-2x red");
							  			 $("#serialNumber").text(data.info);
							  		   }
							  		   
							  		 
							  		 },
							  		 error:function(data){
							  			openAlert("提款失败");
							  			window.document.getElementById("IdentifyGold").onclick = showNumber("MyDiv2","fade");
							  		 }
							  		 });
							  
							  
							  
						  }
	  		</script>
	  
            </div>
        </div>
		      <div class="black-bg" id="fade">
		        <div class="alter yahei black" id="MyDiv">
		            <span class="block left fa fa-info-circle fa-2x blue">&nbsp;&nbsp;</span>
		            <span class="block left">
		                <b style="font-size:24px">您本次出金金额为 <span id="showmoney" name="showmoney" class="red"></span> 元</b><br>
		                <b style="font-size:24px">手续费<span id="factorage" name="factorage"></span>元</b>
		            </span>
		            <div class="clear"></div>
		            <div style="margin:0px auto; width:374px">
		            <a href="javascript:void(0)" class="close-btn left" id="IdentifyGold"  onclick="showNumber('MyDiv2','fade')">确认提款</a><a href="#" class="close-btn left close-btn2" onclick="CloseDiv('MyDiv','fade')">返回修改</a>
		            </div>
		        </div>
		        <div class="alter yahei black" id="MyDiv2">
		            <span id="mydivStyle" class="block left fa fa-check-circle fa-2x green">&nbsp;&nbsp;</span>
		            <span class="block left">
		                <b id="serialNumber" style="font-size:24px"></b><br>
		            </span>
		            <div class="clear"></div>
		            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv2','fade')" >确 定</a>
		        </div>
		    </div>
    </div>