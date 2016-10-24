function uploadfile(path, filename, ftype) {
	$.ajaxFileUpload({
		url : path + '/rest/register/uploadmethod?ftype=' + ftype, // 需要链接到服务器地址
		secureuri : false,
		fileElementId : filename, // 文件选择框的id属性
		dataType : 'json', // 服务器返回的格式，可以是json
		success : function(data, status) 
		{
			openAlert(data.info);
			if (data.info == "上传成功") {
				$("#" + filename + "Url").show();
				$("#" + filename + "Url").attr("href", data.fileurl); // 显示链接
				$("#" + filename + "Url").text(data.FileName);// 显示名称
				$("#" + filename + "Text").val(data.fileurl);// 链接隐藏
				$("#" + filename + "name").val(data.FileName);// 名称隐藏
			} else {
				$("#" + filename + "Url").hide();
				$("#" + filename + "Url").attr("href", "#");
				$("#" + filename + "Url").html("");
				$("#" + filename + "Text").val("");
			}
		},
		error : function(data, status, e) 
		{
			openAlert(e);
		}
	});
}

function showprompt() {
	$(".alter-s").show("slow");
	$("#img2").hide("slow");
	$("#words2").hide("slow");
	$("#words2").html("");

	if ($("#password").val() == null || $("#password").val() == "") {
		$("#imgError1").show();
	} else {
		$("#imgError1").hide();
	}
}

function hideprompt() {
	$(".alter-s").hide("slow");
	$("#img2").show();
	$("#words2").show();
	var pwdRlt = checkpwd().toString(2);
	while(pwdRlt.length < 3){
		pwdRlt = "0" + pwdRlt;
	}
	var pwdMsg = '';
	if (Number(pwdRlt.substr(2,1))) {
		pwdMsg = "需要" + $.trim($("#wearing p").eq(1).text());
	} else if (Number(pwdRlt.substr(1,1))) {
		pwdMsg = $.trim($("#wearing p").eq(2).text());
	} else if (Number(pwdRlt.substr(0,1))) {
		pwdMsg = $.trim($("#wearing p").eq(3).text());
	}
	$("#pwdmsg").text(pwdMsg);
	if (pwdRlt == 0) {
		$("#pwdflag").hide();
		$("#pwdmsg").hide();
	} else {
		$("#pwdflag").show();
		$("#pwdmsg").show();
	}
}
function checkpwd() {
	var i = 0; // 包含几种符号
	var result = 0;
	var regNum = /^[\s\S]{6,20}$/;
	var regCharactor = /[^a-zA-Z0-9]+/;  // 只能包含大小写字母、数字以及标点符号（除空格）  ?标点符号待确认
	var reg1 = /[a-z]+/;
	var reg2 = /[A-Z]+/;
	var reg3 = /[0-9]+/;
	var newpwd = $("#password").val();
	
	if (regNum.test(newpwd)) {// 6-20位字符
		$("#ck1").attr("class", "fa fa-check green");
	} else {
		$("#ck1").attr("class", "fa fa-close red");
		result += 1;
	}
	if (regCharactor.test(newpwd)) {// 只能包含大小写字母、数字以及标点符号（除空格）
		$("#ck2").attr("class", "fa fa-close red");
		result += 2;
	} else {
		$("#ck2").attr("class", "fa fa-check green");
	}

	if (reg1.test(newpwd)) {
		i++;
	}
	if (reg2.test(newpwd)) {
		i++;
	}
	if (reg3.test(newpwd)) {
		i++;
	}

	if (i < 2) {// 大写字母、小写字母、数字和标点符号至少包含2种
		$("#ck3").attr("class", "fa fa-close red");
		result += 4;
	} else {
		$("#ck3").attr("class", "fa fa-check green");
	}
	if (result==0) {
		$("#safelv1").attr("class", "block safe-g safe-gr");
		$("#safelv2").attr("class", "block safe-g safe-gr");
		$("#safelv3").attr("class", "block safe-g safe-gr");
		$("#safeprompt").attr("class", "green");
		$("#safeprompt").html("高");
		
	} else if (result == 1 || result == 2 || result == 4) {
		$("#safelv1").attr("class", "block safe-g safe-o");
		$("#safelv2").attr("class", "block safe-g safe-o");
		$("#safelv3").attr("class", "block safe-g");
		$("#safeprompt").attr("class", "orange");
		$("#safeprompt").html("中");
	} else {
		$("#safelv1").attr("class", "block safe-g safe-r");
		$("#safelv2").attr("class", "block safe-g");
		$("#safelv3").attr("class", "block safe-g");
		$("#safeprompt").attr("class", "red");
		$("#safeprompt").html("低");
	}
	return result;
}

var pwd2 = false;
var companyName = false;
var BusinessNo = false;
var companyAdd = false;
var ContactName = false;
var ContactTel = false;
var ContactPhone = false;
var postcode = false;
var bankNameinfo = false;
var bankNoinfo = false;

function testpwd2() {

	var password2 = $('#pwd2').val();
	var password = $("#password").val();

	if (null == password2 || "" == password2 || password2 != password) {
		pwd2 = false;
		$("#pwd2msg").text("2次密码输入不一致，请重新输入");
		$("#pwd2msg").show();
		$("#pwd2flag").show();
		return false;
	} else if (password2 == password) {
		pwd2 = true;
		$("#pwd2msg").hide();
		$("#pwd2flag").hide();
		return true;
	}
}

// 获取开户行名称
function getDepositBank(path, isNotDiplay) {
	
	var bankshortName = $("#bankshortName").val();// 隐藏id的值
	var bankName = $("#bankName").val();
	var bankBlongs = $("#bankBlongs").val();
	var selCity = $("#selCity").val();

	if (bankName.length <= 0) {
		$("#subbranchs").html(null);
	}
	if (bankName.length < 4) {
		$("#bankNameflag").show();
		$("#bankNamespan").text("请输入支行名称：xxxx支行");
		bankNameinfo = false;
		return false;
	} else {
		$("#subbranchs").html(null);

		$("#bankNameflag").hide();
		$("#bankNamespan").text("");
		$.ajax({
			type : "POST",
			url : path + "/rest/register/getDepositBank",
			data : {
				"bankName" : bankName,
				"bankBlongs" : bankBlongs,
				"selCity" : selCity
			},
			dataType : 'json',
			success : function(data) {
				if (data != null && data != "") {
					var array = eval(data.info);
					if (array != null && array != "") {
						$("#bankNameflag").hide();
						$("#bankNamespan").text("");
						/*
						 * $("#bankName").val(array[0].shortName);
						 * $("#bankshortName").val(array[0].id);
						 */
						bankNameinfo = true;
						
						if(!isNotDiplay){
							subbranchs(array);
						}
						return true;
					} else {
						bankNameinfo = false;
						/*
						 * $("#bankName").val(""); $("#bankshortName").val("");
						 */
						$("#bankNameflag").show();
						$("#bankNamespan").text("请输入支行名称：xxxx支行");
						return false;
					}
				} else {
					/*
					 * $("#bankName").val(""); $("#bankshortName").val("");
					 */
					$("#bankNameflag").show();
					$("#bankNamespan").text("请输入支行名称：xxxx支行");
					return false;
				}
			},
			error : function(data)// 服务器响应失败处理函数
			{
				$("#bankName").val("");
				$("#bankshortName").val("");
				return false;
			}
		});

	}
}

function testcompanyName() {

	if ($("#companyName").val() == null || $("#companyName").val() == "") {
		$("#companyNameflag").show();
		companyName = false;
		return false;
	} else {
		companyName = true;
		$("#companyNameflag").hide();
		return true;
	}

}
function testBusinessNo() {
	if ($("#certificateNo").val() == null || $("#certificateNo").val() == "") {
		$("#BusinessNoflag").show();
		BusinessNo = false;
		return false;
	} else {
		BusinessNo = true;
		$("#BusinessNoflag").hide();
		return true;
	}
}

function testcompanyAdd() {
	if ($("#companyAddr").val() == null || $("#companyAddr").val() == "") {
		$("#companyAddflag").show();
		companyAdd = false;
		return false;
	} else {
		companyAdd = true;
		$("#companyAddflag").hide();
		return true;
	}
}

function testContactName() {
	if ($("#contactName").val() == null || $("#contactName").val() == "") {
		$("#ContactNameflag").show();
		ContactName = false;
		return false;
	} else {
		ContactName = true;
		$("#ContactNameflag").hide();
		return true;
	}
}

function validateContactTel() {
	var res = /([0-9]{3,4}-)?[0-9]{7,8}/;
	if (!res.test($("#phone").val())) {
		$("#ContactTelflag").show();
		$("#ContactTelSpan").text("联系电话格式不正确");
		ContactTel = false;
		return false;
	} else {
		ContactTel = true;
		$("#ContactTelflag").hide();
		$("#ContactTelSpan").text("");
		return true;
	}
}

function validateContactPhone() {
	var res = /^((\+?86)|(\(\+86\)))?(13[0123456789][0-9]{8}|17[0123456789][0-9]{8}|15[012356789][0-9]{8}|18[02356789][0-9]{8}|147[0-9]{8}|1349[0-9]{7})$/;
	if (!res.test($("#mobilePhone").val())) {
		$("#ContactPhoneflag").show();
		$("#ContactPhoneSpan").text("手机格式不正确");
		ContactPhone = false;
		return false;
	} else {
		ContactPhone = true;
		$("#ContactPhoneflag").hide();
		$("#ContactPhoneSpan").text("");
		return true;
	}
}
function validatepostcode() {
	var res = /^[1-9]\d{5}$/;
	if (!res.test($("#postCode").val())) {
		$("#postcodeflag").show();
		$("#postcodeSpan").text("邮政编码格式不正确");
		postcode = false;
		return false;
	} else {
		postcode = true;
		$("#postcodeflag").hide();
		$("#postcodeSpan").text("");
		return true;
	}
}

function checkBankNo() {
	var bankNo = $('#bankNo').val();
	var reg = /^(\d{16}|\d{19})$/;
	
	if (!bankNo) {
		$("#bankNoflag").show();
		$("#bankspan").text("银行卡号不能为空");
		bankNoinfo = false;
		return false;
	}else {
		$("#bankNoflag").hide();
		$("#bankspan").text("");
		return true;
	}
}

function subFrom(path) {
	
	if (checkpwd() > 0) {
		$("#password").focus();
		return;
	}
	if (!testpwd2()) {
		$("#pwd2").focus();
		return;
	}
	if (!testcompanyName()) {
		$("#companyName").focus();
		return;
	}
	if (!testBusinessNo()) {
		$("#certificateNo").focus();
		return;
	}
	if (!testcompanyAdd()) {
		$("#companyAddr").focus();
		return;
	}
	if (!testContactName()) {
		$("#contactName").focus();
		return;
	}
	if (!validateContactTel()) {
		$("#phone").focus();
		return;
	}
	if (!validateContactPhone()) {
		$("#mobilePhone").focus();
		return;
	}
	if (!validatepostcode()) {
		$("#postCode").focus();
		return;
	}
	var b = $("input[name=checbank]:checked").val();
	if (b != null && b == 0) {
		if (getDepositBank(path, true) == false) {
			$("#bankName").focus();
			return;
		}

		if (!checkBankNo()) {
			$("#bankNo").focus();
			return;
		}
	}
	var b = $("input[name=isCommon]:checked").val();
	if (b == 'true') {
		if ($("#fileField6Text").val() == null
				|| $("#fileField6Text").val() == "") {
			$("#fileField6flag").show();
			return;
		} else {
			$("#fileField6flag").hide();
		}
		if ($("#fileField4Text").val() == null
				|| $("#fileField4Text").val() == "") {
			$("#fileField4flag").show();
			return;
		} else {
			$("#fileField5flag").hide();
		}
		if ($("#fileField5Text").val() == null
				|| $("#fileField5Text").val() == "") {
			$("#fileField5flag").show();
			return;
		} else {
			$("#fileField5flag").hide();
		}

	} else {

		if ($("#fileField1Text").val() == null
				|| $("#fileField1Text").val() == "") {
			$("#fileField1flag").show();
			return;
		} else {
			$("#fileField1flag").hide();
		}

		if ($("#fileField2Text").val() == null
				|| $("#fileField2Text").val() == "") {
			$("#fileField2flag").show();
			return;
		} else {
			$("#fileField2flag").hide();
		}

		if ($("#fileField3Text").val() == null
				|| $("#fileField3Text").val() == "") {
			$("#fileField3flag").show();
			return;
		} else {
			$("#fileField3flag").hide();
		}

		if ($("#fileField4Text").val() == null
				|| $("#fileField4Text").val() == "") {
			$("#fileField4flag").show();
			return;
		} else {
			$("#fileField4flag").hide();
		}
		if ($("#fileField5Text").val() == null
				|| $("#fileField5Text").val() == "") {
			$("#fileField5flag").show();
			return;
		} else {
			$("#fileField5flag").hide();
		}
	}

	if (!$('#checkboxOneInput').attr('checked')) {
		openAlert("尚未同意支付服务协议");
		return;
	}

	$.post(path + "/rest/register/registerForm", $('#usrForm').serialize(), function(data){
		var jsonObj = eval('(' + data + ')');
		if(jsonObj.status =='ok') {
			$("#fade").css("display", "block").width($(document).width()).height($(document).height());
	        //弹出隐藏层
	        $("#MyDiv").css("display", "block");
	        makeDivCenterInWindow("MyDiv");
		} else {
			openAlert(jsonObj.msg);
		}
	});
}

function closeaa(o) {
	$("#bankName").val($(o).val());
	$("#bankshortName").val($(o).attr("title"));
	$("#subbranchs").hide();
}

function subbranchs(array) {
	var innerHTMLValue = '<ul>';
	for ( var o in array) {
		innerHTMLValue += '<li style="background-color:none;border:0px;"> <input class="inform2" style="background-color:white;color:black;width:260px;" title="'
				+ array[o].id
				+ '" value="'
				+ array[o].shortName
				+ '" onClick="closeaa(this);" type="button"> </li>'
	}
	innerHTMLValue += '</ul>';
	var rightLength = $("#bankName").css("right");
	$("#subbranchs").show();
	$("#subbranchs").html(innerHTMLValue);

}
