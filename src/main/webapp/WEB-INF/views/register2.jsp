<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

	String AllProvince = (String) request.getAttribute("AllProvince");
	String AllBank = (String) request.getAttribute("AllBank");
%>
<link type="text/css" rel="stylesheet"
	href="<%=path%>/pay/css/jquery.autocomplete.css" />
<script src="<%=path%>/pay/js/user/register.js" type="text/javascript"></script>

<script type='text/javascript'
	src='<%=path%>/pay/js/jquery.autocomplete.min.js'></script>
<!-- 
<script src="<%=path%>/pay/js/user/chgpwd.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=path%>/pay/js/provinec.js"></script>
 -->
 <style>
input.inform2{
	border-left: 1px solid #cbcbcb ;
	border-right: 1px solid #cbcbcb;
	border-top:0 ;
}
</style>
<script>

$(function(){
    $("#password").val("");
	$("#pwd2").val("");
	$("#password").bind("focus", showprompt).bind("keyup", checkpwd).bind("change", checkpwd).bind("blur", hideprompt);
	$("#pwd2").bind("keyup", testpwd2);
	//加载省级市级联动
	  var sel = $("#selProvince"); 
	  var array = <%=AllProvince%>; 
	  array = eval(array) ;
	  if(array!=null) {
		var option = "";
		for(var i=0; i<array.length; i++) {
			if("${userAccountDTO.provinceName}"== array[i].id){
				option = "<option selected value='" + array[i].id + "'>" + array[i].areaName  + "</option>";  
			} else {
				option = "<option value='" + array[i].id + "'>" + array[i].areaName  + "</option>";  
			}
			sel.append(option);
		}
	}
	provinceChange();
	//加载银行
	var bank=$("#bankBlongs");
	array=<%=AllBank%>
	array = eval(array);
	if(array!=null){
		var option = "";
		for(var i=0; i<array.length; i++) {
			if("${userAccountDTO.bankType}"== array[i].code){
			 option = "<option selected value='" + array[i].code + "'>" + array[i].codeName  + "</option>";     
			}else{
			 option = "<option value='" + array[i].code + "'>" + array[i].codeName  + "</option>";     
			}
			bank.append(option);
		} 
	}
    absoluteBankName();
});

function provinceChange() {
    var $pro = $("#selProvince").val();
    setCity($pro);
}

function setCity(provinec) {
    var $city = $("#selCity");
    $city.empty();
    $.ajax({
        url: '<%=path%>/rest/register/getCity?provinec=' + provinec,
        dataType: 'json',
        success: function(data) {
            var array = eval(data.info);
            if (array != null ) {
                for (var i = 0; i < array.length; i++) {
                    if ("${userAccountDTO.cityName}" == array[i].id) {
                        var option = "<option selected value='" + array[i].id + "'>" + array[i].areaName + "</option>";
                    } else {
                        var option = "<option value='" + array[i].id + "'>" + array[i].areaName + "</option>";
                    }
                    $city.append(option);
                }
            }
        },
        error: function(data) { //服务器响应失败处理函数  
            openAlert("获取城市信息失败");
        }
    });
}
function getfilename(number,filepath){
	var url=filepath;	
	url=url.split("\\"); //这里要将 \ 转义一下
	$("#textfield"+number+"span").text(url[url.length-1]);
	$("#fileField" + number + "Url").attr("href", ""); // 显示链接
	$("#fileField" + number + "Url").text("");// 显示名称
}
//关闭弹出层
function CloseDiv(show_div, bg_div) {
    document.getElementById(show_div).style.display = 'none';
    document.getElementById(bg_div).style.display = 'none';
    window.location = "<%=path%>/rest/login";
};
function absoluteBankName() {
    var e = document.getElementById("bankName");
    var div_show = document.getElementById("subbranchs");
    var sWidth = 0;
    var sHeight = 0;
    while (e) {
        sWidth += e.offsetLeft;
        sHeight += e.offsetTop;
        e = e.offsetParent;
    }
    div_show.style.display = "none";
}
function checkBank(obj) {
    if (obj == 0) {
        $("#bankDisplayOrNot").show();
    } else {
        $("#bankDisplayOrNot").hide();
    }
    $("#bankName").val("");
    $("#bankshortName").val("");
}
function checkfile(obj) {
    var html = $("#file").html();
    $("#file").html($("#file3").html());
    $("#file3").html(html);
}
function uploadfiles(path) {
    if ($("input[name=isCommon]:checked").val() == 'true') {
        if (!($("#textfield4span").text() && $("#textfield5span").text() && $("#textfield6span").text())) {
            openAlert("上传文件不能为空！");
            return;
        }
    } else {
        if (!($("#textfield1span").text() && $("#textfield2span").text() && $("#textfield3span").text() && $("#textfield4span").text() && $("#textfield5span").text())) {
            openAlert("上传文件不能为空！");
            return;
        }
    }
    var uploadCount = 0
    $("#credentialsImages span.file-box").each(function(index, element){
    	var data_index = $(element).attr("data_index");
    	if(!$("#fileField" + data_index + "Url").attr("href")){
    		uploadfile(path, 'fileField' + data_index, data_index);
    		uploadCount++;
    		$("#fileField"+data_index+"flag").hide();
    	}
    });
    if(uploadCount == 0){
    	openAlert("没有需要上传的文件");
    }
}
</script>
<div class="main2">
	<div class="web yahei black position">
		<div class="payment">
			<div class="index-tt pay-tt">
				<i></i>欢迎签约SMM支付系统服务
				<div
					style="float: right; font-size: 13px; font-family: 'Arial Normal', 'Arial'">
					客服电话：400-885 6671</div>
			</div>
			<ul class="step block font14 step2">
				<li class="step-li-b"><a href="javascript:void(0)"
					class="white">创建账户</a></li>
				<li class="step-li-w"><a href="javascript:void(0)"
					class="white">填写账户信息</a></li>
				<li class="step-li-w"><a href="javascript:void(0)"
					class="black">有色网审核信息</a></li>
				<li class="step-li-b"><a href="javascript:void(0)"
					class="black">正式使用</a></li>
			</ul>
			<form id="usrForm" name="usrForm"
				action="<%=path%>/rest/register/registerForm" method="post">
				<input type="hidden" name="accountName" id="accountName"
					value="${accountName}"> <input name="accountNo"
					id="accountNo" type="hidden" value="${accountNo }"> <input
					name="msg" id="msg" type="hidden" value="${msg }">

				<div class="regist-box font16">
					<label class="left">登录密码</label>
					<div class="block position alter-f left">
						<input type="password" name="password" id="password" autocomplete="off"
							class="inform" ><i id="pwdflag"
							style="display: none" class="fa fa-times-circle red">&nbsp;</i><span
						id="pwdmsg" style="display: none" class="red font12"></span><br>

						<div id="wearing" class="alter-s font13">
							<span class="block triangle"></span><span
								class="block triangle-w"></span>
							<p>
								安全程度： <span id="safelv1" class="block safe-g "></span><span
									id="safelv2" class="block safe-g"></span><span id="safelv3"
									class="block safe-g"></span>&nbsp;<span id="safeprompt"
									class="red"></span>
							</p>
							<p>
								<i class="fa fa-close red" id="ck1">&nbsp;</i>6-20位字符
							</p>
							<p>
								<i class="fa fa-close red" id="ck2">&nbsp;</i>只能包含大小写字母、数字以及标点符号（除空格）
							</p>
							<p>
								<i class="fa fa-close red" id="ck3">&nbsp;</i>大写字母、小写字母、数字和标点符号至少包含2种
							</p>
						</div>
					</div>
					<br>
					<div class="clear"></div>
					<label>请再次输入密码</label><input type="password"  name="pwd2"  id="pwd2" class="inform">
						<i id="pwd2flag"
						style="display: none" class="fa fa-times-circle red">&nbsp;</i><span
						id="pwd2msg" style="display: none" class="red font12"></span><br>
				</div>
				<div class="regist-box regist-box2 font16">
					<label>公司全称</label><input type="text" id="companyName"
						onblur="testcompanyName()" value="${userAccountDTO.companyName}"
						name="companyName" class="inform"><i id="companyNameflag"
						name="companyNameflag" style="display: none"
						class="fa fa-times-circle red">&nbsp;</i> <br> <label>营业执照号</label><input
						type="text" id="certificateNo" onblur="testBusinessNo()"
						value="${userAccountDTO.certificateNo}" name="certificateNo"
						class="inform"><i id="BusinessNoflag"
						style="display: none" class="fa fa-times-circle red">&nbsp;</i> <br>

					<label>公司地址</label><input type="text" id="companyAddr"
						name="companyAddr" onblur="testcompanyAdd()"
						value="${userAccountDTO.companyAddr}" class="inform"><i
						id="companyAddflag" style="display: none"
						class="fa fa-times-circle red">&nbsp;</i> <br> <label>联系人姓名</label><input
						type="text" id="contactName" onblur="testContactName()"
						value="${userAccountDTO.contactName}" name="contactName"
						class="inform"><i id="ContactNameflag"
						style="display: none" class="fa fa-times-circle red">&nbsp;</i> <br>

					<label>联系电话</label><input type="text" id="phone" name="phone"
						onblur="validateContactTel()" value="${userAccountDTO.phone}"
						class="inform"><i id="ContactTelflag"
						style="display: none" class="fa fa-times-circle red">&nbsp;</i><span
						class="red font12" id="ContactTelSpan"></span> <br> <label>手机号</label><input
						type="text" id="mobilePhone" onblur="validateContactPhone()"
						value="${userAccountDTO.mobilePhone}" name="mobilePhone"
						class="inform"><i id="ContactPhoneflag"
						style="display: none" class="fa fa-times-circle red">&nbsp;</i><span
						class="red font12" id="ContactPhoneSpan"></span> <br> <label>邮政编码</label><input
						type="text" id="postCode" name="postCode"
						onblur="validatepostcode()" value="${userAccountDTO.postCode}"
						class="inform"><i id="postcodeflag" style="display: none"
						class="fa fa-times-circle red">&nbsp;</i><span class="red font12"
						id="postcodeSpan"></span> <br>

				</div>
				<div align="center">
					<label style="cursor: pointer;"><input size="4"
						type="radio" value="0" name="checbank" onclick="checkBank(0)"
						checked="checked" style="cursor: pointer; visibility: visible">&nbsp;&nbsp;<span
						class="font14">绑定银行账户</span></label>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label
						style="cursor: pointer;"><input size="4" type="radio"
						value="1" name="checbank" onclick="checkBank(1)"
						style="cursor: pointer; visibility: visible">&nbsp;&nbsp;<span
						class="font14">暂不绑定</span></label>
				</div>
				<div id="bankdiv" class="regist-box regist-box2 font16">
					<br>
					<div id="bankDisplayOrNot">
						<label class="v-top left">账户所属银行</label>
						<div align="center" class="block left" id="sel">
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
						<label class="v-top ">开户银行名称</label>
						<div style="position:relative;display:inline-block;"><input id="bankName"
							name="bankName" value="${userAccountDTO.bankName}" type="text"
							autocomplete="off" oninput="getDepositBank('<%=path %>')"
							class="inform" onpaste="return false;" />
							<div id="subbranchs"
								style="display: none; position: absolute; width: 280px; z-index: 99999"></div>
						</div>
						<input id="bankshortName" name="bankshortName" type="hidden"
							value="${bankid }" /> <i id="bankNameflag" name="bankNameflag"
							style="display: none" class="fa fa-times-circle red">&nbsp;</i> <span
							id="bankNamespan" class="red font12"></span> <br> <label
							class="v-top">银行账号</label><input id="bankNo"
							onblur="checkBankNo()" value="${userAccountDTO.bankAccountNo}"
							name="bankAccountNo" type="text" class="inform"> <i
							id="bankNoflag" name="bankNoflag" style="display: none"
							class="fa fa-times-circle red">&nbsp;</i> <span id="bankspan"
							class="red font12"></span>
					</div>
				</div>
				<div align="center">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label style="cursor: pointer;"><input size="4"
						type="radio" value="false" name="isCommon" onclick="checkfile(0)"
						checked="checked" style="cursor: pointer; visibility: visible">&nbsp;&nbsp;<span
						class="font14">绑定银行账户</span></label>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <label
						style="cursor: pointer;"><input size="4" type="radio"
						value="true" name="isCommon" onclick="checkfile(1)"
						style="cursor: pointer; visibility: visible">&nbsp;&nbsp;<span
						class="font14">多证合一营业执照</span></label> <br> <br> <br>
				</div>
				<div class="regist-box regist-box2 font16" id="credentialsImages"
					style="margin-bottom: 0px; border: none">
					<div id="file">
						<label class="v-top left">企业法人营业执照影印件</label>
						<div class="block left position">
							<span name='textfield1span' id='textfield1span' data_index="1"
								class="file-box block"></span> <input type="file"
								name="fileField1" class="file"
								onchange="getfilename(1,this.value)" id="fileField1" /> <i
								id="fileField1flag" name="fileField1flag"
								class="fc fa-times-circle red" style="display: none">&nbsp;</i>

							<a id="fileField1Url" class="file-href" href="${fileField1Text }"
								name="fileField1Url" target="_blank">${fileField1name}</a> <input
								type="hidden" name="fileField1Text" id="fileField1Text"
								value="${fileField1Text }" /> <input type="hidden"
								name="fileField1name" id="fileField1name"
								value="${fileField1name}" />
						</div>
						<div class="clear"></div>
						<label class="v-top left">组织机构代码影印件</label>
						<div class="block left position">
							<span name='textfield2span' id='textfield2span'  data_index="2"
								class="file-box block"></span> <input type="file"
								name="fileField2" class="file"
								onchange="getfilename(2,this.value)" id="fileField2" /> <i
								id="fileField2flag" name="fileField2flag"
								class="fc fa-times-circle red" style="display: none">&nbsp;</i>
							<a href="${fileField2Text }" id="fileField2Url" class="file-href"
								name="fileField2Url" target="_blank">${fileField2name}</a> <input
								type="hidden" name="fileField2Text" id="fileField2Text"
								value="${fileField2Text }" /> <input type="hidden"
								name="fileField2name" id="fileField2name"
								value="${fileField2name}" />
						</div>
						<div class="clear"></div>
						<label class="v-top left">税务登记证影印件</label>
						<div class="block left position">
							<span name='textfield3span' id='textfield3span'  data_index="3"
								class="file-box block"></span> <input type="file"
								name="fileField3" class="file"
								onchange="getfilename(3,this.value)" id="fileField3" /> <i
								id="fileField3flag" name="fileField3flag"
								class="fc fa-times-circle red" style="display: none">&nbsp;</i>

							<a href="${fileField3Text }" id="fileField3Url" class="file-href"
								name="fileField3Url" target="_blank">${fileField3name}</a> <input
								type="hidden" name="fileField3Text" id="fileField3Text"
								value="${fileField3Text }" /> <input type="hidden"
								name="fileField3name" id="fileField3name"
								value="${fileField3name}" />
						</div>


					</div>
					<div class="clear"></div>
					<label class="v-top left">银行基本开户证明</label>
					<div class="block left position">
						<span name='textfield5span' id='textfield5span'  data_index="5"
							class="file-box block"></span> <input type="file"
							name="fileField5" class="file"
							onchange="getfilename(5,this.value)" id="fileField5" /> <i
							id="fileField5flag" name="fileField5flag"
							class="fc fa-times-circle red" style="display: none">&nbsp;</i> <a
							href="${fileField4Text }" id="fileField5Url" class="file-href"
							name="fileField5Url" target="_blank">${fileField4name}</a> <input
							type="hidden" name="fileField5Text" id="fileField5Text"
							value="${fileField4Text }" /> <input type="hidden"
							name="fileField5name" id="fileField5name"
							value="${fileField4name}" />
					</div>
					<div class="clear"></div>
					<label class="v-top left">管理员授权委托书</label>
					<div class="block left position">
						<span name='textfield4span' id='textfield4span'  data_index="4"
							class="file-box block"></span> <input type="file"
							name="fileField4" class="file"
							onchange="getfilename(4,this.value)" id="fileField4" /> <i
							id="fileField4flag" name="fileField4flag"
							class="fc fa-times-circle red" style="display: none">&nbsp;</i> <a
							href="${fileField4Text }" id="fileField4Url" class="file-href"
							name="fileField4Url" target="_blank">${fileField4name}</a> <input
							type="hidden" name="fileField4Text" id="fileField4Text"
							value="${fileField4Text }" /> <input type="hidden"
							name="fileField4name" id="fileField4name"
							value="${fileField4name}" />

					</div>

					<div class="clear"></div>
					<input class="block next-btn"
						style="margin-top: 5px; margin-left: 190px; width: 260px; cursor: pointer; font-family: 'Microsoft Yahei', 'Simsun'; font-size: 16px;"
						type="button" class="file-btn" value="上&nbsp;&nbsp;传"
						onclick="uploadfiles('<%=path%>')" />
					<div class="clear"></div>

					<p class="gray2 font16"
						style="margin-top: 20px; padding-left: 116px; line-height: 30px">注：以上信息都必须全部填写完整，否则将无法提交注册信息</p>

					<div class="block left" style="margin: 20px 0 10px 250px;">
						<div class="checkbox left" style="margin-top: 3px;">
							<input type="checkbox" id="checkboxOneInput"
								style="visibility: visible">
						</div>
						<span class="block left font16">我同意<a
							href="<%=path%>/rest/common/agreement" target="_blank"
							style="text-decoration: underline;">支付服务协议</a></span>
					</div>
					<div class="clear"></div>
					<div class="clear"></div>
					<div class="block left"
						style="margin-top: 5px; margin-left: 190px;">
						<div class="checkbox left">
							<a href="javascript:void(0)" class="block next-btn" id="Button1"
								onclick="subFrom('<%=path%>')" style="width: 260px;">确认提交</a>
						</div>
					</div>


				</div>
			</form>


			<div class="black-bg" id="fade">
				<div class="alter yahei black" id="MyDiv">
					<span class="block left fa fa-check-circle fa-2x green">&nbsp;&nbsp;</span>
					<span class="block left"> <b style="font-size: 24px">感谢您注册有色大额支付系统！</b><br>
						<span style="font-size: 18px">稍后有色网审核人员审核通过后，即进行登录进行交易！</span>
					</span>
					<div class="clear"></div>
					<a href="#" class="close-btn" onclick="CloseDiv('MyDiv','fade')">确
						定</a>
				</div>
				<div id="file3" style="display: none;">
					<label class="v-top left">多证合一营业执照影印件</label>
					<div class="block left position">
						<span name='textfield6span' id='textfield6span'  data_index="6"
							class="file-box block"></span> <input type="file"
							name="fileField6" class="file"
							onchange="getfilename(6,this.value)" id="fileField6" /> <i
							id="fileField6flag" name="fileField6flag"
							class="fc fa-times-circle red" style="display: none">&nbsp;</i> <a
							id="fileField6Url" class="file-href" href="${fileField6Text }"
							name="fileField6Url" target="_blank">${fileField6name}</a> <input
							type="hidden" name="fileField6Text" id="fileField6Text"
							value="${fileField6Text }" /> <input type="hidden"
							name="fileField6name" id="fileField6name"
							value="${fileField6name}" />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
