<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";


%>
<script src="<%=path %>/pay/js/user/register.js" type="text/javascript"></script>
<script type="text/javascript">
$(function(){
    $("#password").val("");
	$("#pwd2").val("");
	$("#password").bind("focus", showprompt).bind("keyup", checkpwd).bind("change", checkpwd).bind("blur", hideprompt);
	$("#pwd2").bind("keyup", testpwd2);
});
function refer(){
	if (checkpwd() > 0) {
		$("#password").focus();
		return;
	}
	if (!testpwd2()) {
		$("#pwd2").focus();
		return;
	}
	$('#usrForm').submit();
}
</script>
<div class="main2">
    <div class="web yahei black position">
        <div class="payment">
            <p class="index-tt pay-tt"><i></i>找回密码<span class="right gray font14" style="padding-top:10px">客服电话： 400-885-6671</span></p>
            <ul class="step step3 block font14">
                <li class="step-li-b"><a href="#" class="white">填写账户名</a></li>
                <li class="step-li-w"><a href="#" class="white">查收验证邮件</a></li>
                <li class="step-li-w"><a href="#" class="white">重置密码</a></li>
                <li class="step-li-b"><a href="#" class="black">完成</a></li>
            </ul>
            <form id="usrForm" name="usrForm" action="<%=path %>/rest/user/resetPassword" method="post">
            <div class="regist-box font16 edit-box" style="border-bottom:0px">
                <label class="left">新密码</label>
                    <div class="block position alter-f left">
                      	<input type="password" name="password" id="password" class="inform">
			<input type="hidden" value="${userEmail}" name="userEmail" id="userEmail">
			<i id="pwdflag" style="display: none" class="fa fa-times-circle red">&nbsp;</i> <span
						id="pwdmsg" style="display: none" class="red font12"></span><br>
                        <div id="wearing" class="alter-s font13">
                            <span class="block triangle"></span><span class="block triangle-w"></span>
                            <p>安全程度： <span id="safelv1"  class="block safe-g "></span><span id="safelv2"  class="block safe-g "></span>
                            <span id="safelv3" class="block safe-g "></span>&nbsp;<span id="safeprompt" class="orange">低</span></p>
                            <p><i class="fa fa-close red" id="ck1">&nbsp;</i>6-20位字符</p>
                            <p><i class="fa fa-close red" id="ck2">&nbsp;</i>只能包含大小写字母、数字以及标点符号（除空格）</p>
                            <p><i class="fa fa-close red" id="ck3">&nbsp;</i>大写字母、小写字母、数字和标点符号至少包含2种</p>
                        </div>
                   </div><br>
                   <div class="clear"></div>
                <label>重复密码</label><input type="password" name="pwd2"
		id="pwd2" class="inform"><i id="pwd2flag"
		style="display: none" class="fa fa-times-circle red">&nbsp;</i><span
		id="pwd2msg" style="display: none" class="red font12"></span><br>
                <br>
                <label></label><a href="#" class="block next-btn submit-btn" id="Button1" onclick="refer()">确认提交</a>
            </div>
            </form>
        </div>
    </div>
</div>
