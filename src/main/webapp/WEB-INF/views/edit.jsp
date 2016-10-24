<%@page import="com.eliteams.pay.web.model.User"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
String pwd = ((User)request.getSession().getAttribute("user")).getPassword();
String username = ((User)request.getSession().getAttribute("user")).getUsername();
Long userid = ((User)request.getSession().getAttribute("user")).getId();
%>

<script src="<%=path %>/pay/js/page/md5.js" type="text/javascript"></script>
<script src="<%=path %>/pay/js/user/chgpwd.js" type="text/javascript"></script>
<script>BASE_URL = '<%=path %>'</script>

<div id="all">
    <div class="main2">
        <div class="web yahei black position">
            <div class="payment">
                <p class="index-tt pay-tt2 hidden">
                    <b class="block left">修改密码</b>
                </p>
                <form>
                <div class="regist-box font16 edit-box" style="border-bottom:0px">
                    <label>旧密码</label><input id="oldpwd" type="password" class="inform" onblur="chkoldpwd();">
                    <i id="img1" class="">&nbsp;</i><span id="words1" class=""></span><br>
                    <label class="left">新密码</label>
                        <div class="block position alter-f left">
                            <input type="password" id="newpwd" class="inform" onkeyup="checkpwd();" onfocus="showprompt();" onblur="hideprompt();">
                            <i id="img2" class="">&nbsp;</i><span id="words2" class=""></span>
                            <div class="alter-s font13">
                                <span class="block triangle"></span><span class="block triangle-w"></span>
                                <p>安全程度： <span id="safelv1" class="block safe-g"></span><span id="safelv2" class="block safe-g"></span><span id="safelv3" class="block safe-g"></span>&nbsp;<span id="safeprompt" class="red"></span></p>
                                <p><i class="fa fa-close red" id="ck1">&nbsp;</i>6-20位字符</p>
                                <p><i class="fa fa-close red" id="ck2">&nbsp;</i>只能包含大小写字母、数字以及标点符号（除空格）</p>
                                <p><i class="fa fa-close red" id="ck3">&nbsp;</i>大写字母、小写字母、数字和标点符号至少包含2种</p>
                            </div>
                       </div><br>
                       <div class="clear"></div>
                    <label>重复密码</label><input id="repwd" type="password" class="inform" onkeyup="recheckpwd();">
                    <i id="img3" class="">&nbsp;</i><span id="words3" class=""></span><br>
                    <label></label>
                    <a href="#" class="block next-btn submit-btn" id="Button1" onclick="submitreq();">确认提交</a>
                    <input type="hidden" value="<%=pwd %>">
                </div>                
                </form>
               
            </div>
        </div>
    </div>
    <div class="black-bg" id="fade1">
        <div class="alter yahei black" id="MyDiv1" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码失败！</b><br>
                <span style="font-size:18px">旧密码与原密码不符合！</span> 
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv1','fade1')">确 定</a>
        </div>
    </div>

    <div class="black-bg" id="fade2">
        <div class="alter yahei black" id="MyDiv2" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码失败！</b><br>
                <span style="font-size:18px">密码格式不正确！</span> 
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv2','fade2')">确 定</a>
        </div>
    </div>
    
    <div class="black-bg" id="fade3">
        <div class="alter yahei black" id="MyDiv3" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码失败！</b><br>
                <span style="font-size:18px">新密码输入不一致！</span> 
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv3','fade3')">确 定</a>
        </div>
    </div>
    
    <div class="black-bg" id="fade4">
        <div class="alter yahei black" id="MyDiv4" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码失败！</b><br>
                <span style="font-size:18px">新修改密码和旧密码不能相同！</span> 
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv4','fade4')">确 定</a>
        </div>
    </div>
    
    <div class="black-bg" id="fade5">
        <div class="alter yahei black" id="MyDiv5" >
            <span class="block left fa fa-check-circle fa-2x green">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码成功！</b><br>
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv5','fade5')">确 定</a>
        </div>
    </div>
    
    <div class="black-bg" id="fade6">
        <div class="alter yahei black" id="MyDiv6" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">修改密码错误！</b><br>
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv6','fade6')">确 定</a>
        </div>
    </div>
    
    <div class="black-bg" id="fade7">
        <div class="alter yahei black" id="MyDiv7" >
            <span class="block left fa fa-times-circle fa-2x red">&nbsp;&nbsp;</span>
            <span class="block left">
                <b style="font-size:24px">用户名或密码错误！</b><br>
            </span>
            <div class="clear"></div>
            <a href="#" class="close-btn" onclick="CloseDiv('MyDiv7','fade7')">确 定</a>
        </div>
    </div>
    
</div>

<script type="text/javascript">
	function chgpwd(){
  		$.ajax({
  			type : "POST",
  			url : "<%=path %>/rest/user/chgpwd",
  			dataType:"json",
  			data :{
  				"index":"1",
  				"typeId":"2"
  			},
  			success : function(data) {
  				if(data.info == "success"){

  				}else if(data.info == "error"){
  					
  				}else{
	 			
  				}
  			},
  			error:function(data){

  			}
  		});
  	}
	
	function chkoldpwd(){
		var pwd = '<%=pwd %>';
		var oldpwd = $("#oldpwd").val();
		if(pwd != oldpwd){
			$("#img1").attr("class","fa fa-times-circle red");
			$("#words1").attr("class","red font12");
			$("#words1").html("原始密码错误！");
			return 0;
		}else{
			$("#img1").attr("class","fa fa-check-circle green");
			$("#words1").html("");
			return 1;//1是验证通过，0是验证不通过
		}
	}
	
	function submitreq(){
		//检查输入的旧密码是否符合
		var i = chkoldpwd();
		//检查密码格式是否正确
		var j = checkpwd();
		//检查两次修改的密码是否输入一致
		var k = recheckpwd();
		//检查新密码和旧密码是否相同
		var l = hideprompt();
		if(i<1){
			ShowDiv('MyDiv1','fade1')
			return;
		}
		if(l<1){
			ShowDiv('MyDiv4','fade4')
			return;
		}
		if(j<1){
			ShowDiv('MyDiv2','fade2')
			return;
		}
		if(k<1){
			ShowDiv('MyDiv3','fade3')
			return;
		}
		passwordChange();
	}
	
	function passwordChange(){
		var useridv = '<%=userid %>';
		var usernamev = '<%=username %>';
		var oldpwdv = $("#oldpwd").val();
		var newpwdv = $("#newpwd").val();
		
		$.ajax({
  			type : "POST",
  			url : "<%=path %>/rest/user/passwordChange",
  			dataType:"json",
  			data :{
  				"userid":useridv,
  				"username":usernamev,
  				"oldpwd":oldpwdv,
  				"newpwd":newpwdv
  			},
  			success : function(res) {
  				
  				if (res.code == "RETURN_SUCCESS_CODE") {
					// 成功
					ShowDiv('MyDiv5','fade5');
				} else if (res.code == "CHANGE_PASSWORD_ERROR") {
					ShowDiv('MyDiv6','fade6');
					
				} else if (res.code == "LOGIN_ERROR_CODE") {
					ShowDiv('MyDiv7','fade7');
					
				}
  				
  			},
  			error:function(e){

  			}
  			
  		});
	}
	
	//----------------------------- 弹窗 -----------------------------------
  	//弹出隐藏层
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
  		
  		window.location.reload();
  		
  		//登录成功后跳转登录页，重新登录
  		/* if(show_div == "MyDiv5" && bg_div == "fade5"){
  			window.location.href = BASE_URL + "/rest/page/login";
  		} */
  	}
</script>





