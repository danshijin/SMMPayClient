<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
    <div class="main2">
        <div class="web yahei black position">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">验证银行账户</b>
                </p>
                <ul class="step block font14 step3">
                    <li class="step-li-b"><a href="#" class="white">绑定银行账户</a></li>
                    <li class="step-li-w"><a href="#" style="color: #d3d3d3">支付打款</a></li>
                    <li class="step-li-w"><a href="#" style="color: #d3d3d3">输入收到的款项金额</a></li>
                    <li class="step-li-b"><a href="#" style="color: #d3d3d3">绑定成功</a></li>
                </ul>
                <div class="bank-info">
                    <img src="<%=path %>/pay/images/bankImages/${bindTypeId}.jpg" style="margin-top:-4px">
                     <b style="font-size:20px">${bankName }&nbsp;&nbsp;${bankAccountNo}     </b>
                     <br>
                    <p class="font16">请填写您收到的汇款金额&nbsp;&nbsp;&nbsp;
                    <input type="text" class="inform" id="money" style="width:150px">元&nbsp;&nbsp;
                    <span class="font13 red" id="checkMoney" style="display: none">
                    <img id="imgError" src="<%=path %>/pay/images/err.jpg" /> 
                    <span id="moneyNull">所填写的金额与实际不符</span>
                    </span>
                    </p>
                    <div class="a-margin"><a href="#" class="close-btn left"  id="Button1" onclick="checkBankMoney('${bindId }')">确定</a><a href="<%=path %>/rest/accountBind/toBindCard" class="close-btn left close-btn2">返回</a></div>
                </div>
                <div class="clear"></div>
                <p class="font13 bill-txt" style="margin:50px 0px 80px"><b>绑定说明：</b><br>添加绑定账户后，系统将会将您账户汇入一笔款项。<br>收到该金额后，在验证账户页面输入与汇入款项一致的金额数字，系统核对无误后，则绑定成功。<br>需绑定的账户开户名需和注册账户企业名称一直。</p>
                
            </div>
        </div>
    </div>
    <!----------------------------- 弹窗 ----------------------------------->
    <script type="text/javascript">
    var checkNum=0;
	  //弹出隐藏层ShowDiv('MyDiv','fade')
	  function ShowDiv(show_div,bg_div){
		  document.getElementById(show_div).style.display='block';
		  document.getElementById(bg_div).style.display='block' ;
	 	  var bgdiv = document.getElementById(bg_div);
	 	  bgdiv.style.width = document.body.scrollWidth;
	  	  // bgdiv.style.height = $(document).height();
	  	  $("#"+bg_div).height($(document).height());
	  };
	  //关闭弹出层
	  function CloseDiv(show_div,bg_div){
		  document.getElementById(show_div).style.display='none';
		  document.getElementById(bg_div).style.display='none';
	  };
	  function checkBankMoney(bindId){
		  var money=$('#money').val();
		  if(money==null || money==""){
				$('#moneyNull').html("请输入金额");
				$('#checkMoney').show();
			}else{
				$("#checkMoney").hide();
				 $.ajax({  
				        url : '<%=path %>/rest/accountBind/checkBankMoney',   
				        dataType : 'json', 
				        data :{
							"bindId":bindId,
							"money":money
						},
				        success : function(data) {
							 if(data.info=='success'){
								 $('#checkMoney').hide();
								 ShowDiv('MyDivSuccess','fadeSuccess');
							 }else if(data.info=='differ'){
								 $('#moneyNull').html("所填写的金额与实际不符");
								 $('#checkMoney').show();
							 }else if(data.info=='countError'){
								 $('#moneyNull').html("所填写的金额与实际不符");
								 $('#checkMoney').show();
								 $('#money').attr("disabled", true);
								 ShowDiv('MyDiv','fade');
						    }else{
						        openAlert("校验金额失败!");
							 }
				        },  
				        error : function(data)//服务器响应失败处理函数  
				        {  
					        openAlert("请求失败!");
				        }  
				    }); 
			}	
		  
	  }
	  function checkSuccess(){
		  CloseDiv('MyDivSuccess','fadeSuccess');
		  location="<%=path %>/rest/accountBind/toBindCard";
	  }
	  </script>
    <div class="black-bg" id="fade">
        <div class="alter yahei black" id="MyDiv" >
            <span class="block left">
                <b style="font-size:24px">
                <img   src="<%=path %>/pay/images/error.png"/>对不起，您当前输入错误次数过多，请明天再试！ </b><br><br>
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv','fade')">确 定</a>
        </div>
    </div>
    <div class="black-bg" id="fadeSuccess">
        <div class="alter yahei black" id="MyDivSuccess" >
            <span class="block left">
                <b style="font-family:'Arial Negreta', 'Arial';font-weight:700;font-size:24px;line-height:normal;">
                <img  src="<%=path %>/pay/images/success.png"/>绑定账户成功！</b><br><br>
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="checkSuccess()">确 定</a>
        </div>
    </div>

