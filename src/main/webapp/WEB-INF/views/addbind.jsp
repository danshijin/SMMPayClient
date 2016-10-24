<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

String AllProvince=(String)request.getAttribute("AllProvince");
String AllBank=(String)request.getAttribute("AllBank");
%>
<link type="text/css" rel="stylesheet" href="<%=path %>/pay/css/jquery.autocomplete.css" />
<script src="<%=path %>/pay/js/user/register.js" type="text/javascript"></script>

<script type='text/javascript' src='<%=path %>/pay/js/jquery.autocomplete.min.js'></script>
<style>
input.inform2{
	border-left: 1px solid #cbcbcb ;
	border-right: 1px solid #cbcbcb;
	border-top:0 ;
}
</style>
<script>

	$(function(){
		//加载省级市级联动
	  	var sel = $("#selProvince"); 
	    var array = <%=AllProvince%>; 
	    array = eval(array)  
	    for(var i=0; i<array.length; i++)  {  
	   		 var option = "<option value='" + array[i].id + "'>" + array[i].areaName  + "</option>";   
	    	 sel.append(option);   
	    } 
		provinceChange();
		  
		//加载银行
		var bank=$("#bankBlongs");
		array=<%=AllBank%>
		array = eval(array);
		for(var i=0; i<array.length; i++)  {  
	   		var option = "<option value='" + array[i].code + "'>" + array[i].codeName  + "</option>";     
	   		bank.append(option);   
		} 
		  
	});

	function provinceChange(){	
		 var $pro = $("#selProvince").val();  
	     setCity($pro);  
	}

	function setCity(provinec){
		  var $city = $("#selCity"); 
		  $city.empty();    
		  $.ajax({  
		        url : '<%=path%>/rest/intoGold/getCity?provinec='+provinec,   
		        dataType : 'json', 
		        success : function(data) {  
		            var array = eval(data.info) ; 
				    for(var i=0; i<array.length; i++)  {  
				    var option = "<option value='" + array[i].id + "'>" + array[i].areaName  + "</option>";     
				 	   $city.append(option);   
				    } 
		        },  
		        error : function(data){  
		        	openAlert("城市加载失败!");
		        }  
		    });    
	}
	var checkbankno=true;

	function showRet(){
		if($("#bankName").val()==null || $("#bankName").val()==""){
			$("#bankNameflag").show();
			return;
		}else{
			$("#bankNameflag").hide();
		}	
		
		if($("#bankNo").val()==null || $("#bankNo").val()==""){
			$("#bankNoflag").show();
			return;
		}else if(checkbankno){
			$("#bankNoflag").hide();
			var selProvince=$('#selProvince').val();
			var selCity=$('#selCity').val();
			var bankBlongs=$('#bankBlongs').val();
			var bankshortName=$('#bankshortName').val();
			var bankNo=$('#bankNo').val();
			$.ajax({  
		        url : '<%=path %>/rest/accountBind/bindCardForm',   
		        dataType : 'json', 
		        data :{
					"selProvince":selProvince,
					"selCity":selCity,
					"bankBlongs":bankBlongs,
					"bankshortName":bankshortName,
					"bankNo":bankNo,
				},
		        success : function(data) {
					 if(data.info=='success'){
						 ShowDiv('MyDiv','fade');
					 }else if(data.info=='exist'){
						 ShowDiv('MyDivExist','fadeExist');
					 }else{
				        	openAlert("绑定失败，请重试!");
					 }
		        },  
		        error : function(data)//服务器响应失败处理函数  
		        {  
		        	openAlert("请求失败!");
		        }  
		    });  
		}
		
	}

</script>

    <div class="main2">
        <div class="web yahei black position">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">验证银行账户</b>
                </p>
                <ul class="step block font14 step">
                    <li class="step-li-b"><span  class="white">绑定银行账户</span></li>
                    <li class="step-li-w"><span style="color: #d3d3d3">支付打款</span></li>
                    <li class="step-li-w"><span style="color: #d3d3d3">输入收到的款项金额</span></li>
                    <li class="step-li-b"><span style="color: #d3d3d3">绑定成功</span></li>
                </ul>
                
                <div class="regist-box regist-box2 font16" style="margin-top:60px; border-bottom:none">
                    <!----------------------------------JS模拟Select------------------------------------------->
                    <script>
                    
                   /* $(function() {
	        			$('#bankName').autocomplete(emails, {
			                  max: 12,    				//列表里的条目数
			                  minChars: 0,    			//自动完成激活之前填入的最小字符
			                  width: 400,     			//提示的宽度，溢出隐藏
			                  scrollHeight: 300,   		//提示的高度，溢出显示滚动条
			                  matchContains: true,    	//包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
			                  autoFill: false,    		//自动填充
			                  
			                  formatItem: function(row, i, max) {
			                    return row.name;
		                  	  },
				              formatMatch: function(row, i, max) {
				                    return row.name + row.to;
				              },
				              formatResult: function(row) {
				                    return row.name;
				              }
				          }).result(function(event, row, formatted) {
			                    //alert(row.to);
			              });
                     }); */
                    
                     function absoluteBankName(){
	               		  var e = document.getElementById("bankName");
	               	      var div_show=document.getElementById("subbranchs");
	               	      var sWidth=0;
	               	      var sHeight=0;
	               	      debugger;
	               	      while(e){
	               	        sWidth+=e.offsetLeft;
	               	        sHeight+=e.offsetTop;
	               	        e=e.offsetParent;
	               	      }
	               	      div_show.style.display="none";
	                   }
                     
                     	$(function(){
                    		absoluteBankName();
                    	});
                     
						 window.onload=function(){
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
					
					 }
						 
					</script>
					<form id="usrForm" name="usrForm"
				action="" method="post">
                    <label class="v-top left">账户所属银行</label>
					<div class="block left" id="sel">
						<dl>
							<dt>
								<select id="bankBlongs" name="bankBlongs" class="select-box"
									style="overflow-y: auto; overflow-x: hidden; width: 250px">
								</select>
							</dt>
							<dt class="left block select-sf">
								<select id="selProvince" name="selProvince"
									onchange="provinceChange()" class="select-box"
									style="overflow-y: auto; overflow-x: hidden; width: 138px">
								</select>
							</dt>
							<dt class="left block select-sf">
								<select id="selCity" name="selCity" class="select-box"
									style="overflow-y: auto; overflow-x: hidden; width: 100px">
									<option></option>
								</select>
							</dt>
						</dl>
					</div>
                    <div class="clear"></div>
                    <label class="v-top" style="margin-right: 10px;">开户银行名称</label>
                    	<div style="position:relative;display:inline-block;"><input id="bankName" autocomplete="off"
							name="bankName" type="text" oninput="getDepositBank('<%=path %>')" class="inform" onpaste="return false;">
							<div id="subbranchs" style="display: none;position:absolute;width:280px;z-index:99999"></div>
						</div>
						<input id="bankshortName" name="bankshortName" type="hidden" />
						<img id="bankNameflag" src="<%=path %>/pay/images/err.jpg" style="display: none"/>
						 <span id="bankNamespan" class="red font12" ></span>
						 <br>
                     <label class="v-top">银行账号</label><input id="bankNo"
						name="bankNo" type="text" class="inform" onblur="checkBankNo()">
						<img id="bankNoflag" src="<%=path %>/pay/images/err.jpg" style="display: none"/><span id="bankNoError" class="red font12"></span> <br>
                    <label></label><a href="#" class="block next-btn submit-btn" id="Button1" onclick="showRet()">确认提交</a>
                    </form>
                </div>
                
                <div class="clear"></div>
                <p class="font13 bill-txt" style="margin:50px 0px 80px"><b>绑定说明：</b><br>添加绑定账户后，系统将会将您账户汇入一笔款项。<br>收到该金额后，在验证账户页面输入与汇入款项一致的金额数字，系统核对无误后，则绑定成功。<br>需绑定的账户开户名需和注册账户企业名称一致。</p>
                
            </div>
        </div>
    </div>

    <!----------------------------- 弹窗 ----------------------------------->
    <script type="text/javascript">
	  //弹出隐藏层
	  //ShowDiv('MyDiv','fade')
	  function ShowDiv(show_div,bg_div){
		  document.getElementById(show_div).style.display='block';
		  document.getElementById(bg_div).style.display='block' ;
		  var bgdiv = document.getElementById(bg_div);
		  bgdiv.style.width = document.body.scrollWidth;
		  // bgdiv.style.height = $(document).height();
		  $("#"+bg_div).height($(document).height());
	  };
	  //关闭弹出层
	  function CloseDiv(show_div,bg_div,type){
		  document.getElementById(show_div).style.display='none';
		  document.getElementById(bg_div).style.display='none';
		  if(type=='success'){
			  location="<%=path %>/rest/accountBind/toBindCard";
		  }else if(type=='faild'){
			  location.reload();
		  }
		  
	  };
	  
	  </script>
    <div class="black-bg" id="fade">
        <div class="alter yahei black" id="MyDiv" >
	         <p style="font-size:24px;line-height:normal;">
	         <span style="font-family:'Arial Negreta', 'Arial';font-weight:700;font-size:24px;line-height:normal;">
	         
	         <img  src="<%=path %>/pay/images/success.png"/>添加银行帐户成功！</span>
	         </p>
	         <p style="font-size:18px;line-height:24px;">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">稍候</span>
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">系统会支付一笔款项到该帐户</span>
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">，请在收到款项后在验证</span>
	         </p>
	         <p style="font-size:18px;line-height:24px;">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">帐户页面输入所收到的金额</span>
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">。</span>
	         </p>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv','fade','success')">确 定</a>
        </div>
    </div>
    
     <div class="black-bg" id="fadeExist">
        <div class="alter yahei black" id="MyDivExist" >
	         <p style="font-size:18px;line-height:24px;">
	         <span style="font-family:'Arial Normal', 'Arial';font-weight:400;font-size:18px;line-height:24px;">
	         <img   src="<%=path %>/pay/images/error.png"/>您已提交过该帐户的绑定申请，请更换后重试！</span>
	         </p>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDivExist','fadeExist','faild')">确 定</a>
        </div>
    </div>
    
    


