var Login = {

	doLogin : function() {
		if (!Login.validate()) {
			return;
		}

		var username = $('#username').val();
		//var password = hex_md5($('#password').val());
		var password = $('#password').val();
		var vCode = $('#vCode').val().toLocaleLowerCase();
		var displayStyle = $('#identifyingcode').css('display');

		username = username.replace(/\s+/g,"");
		password = password.replace(/\s+/g,"");
		
		$.ajax({
			type : "GET",
			url : BASE_URL + "/rest/user/userLogin",
			data : {
				"username" : username,
				"password" : password,
				"vCode" : vCode,
				"displayStyle" : displayStyle
			},
			dataType : "json",
			success : function(res) {
				if (res.code == "RETURN_SUCCESS_CODE") {
					// 成功
					window.location.href = BASE_URL + "/rest/user/loginSucc";
					return;
				} 
				
				pointhide(res.msg);
				$("#identifyingcode").show();
			},
			error : function(data) {
				/* alert(data.responseText,"error"); */
				$("#identifyingcode").show();
			}

		});
	},
	validate : function() {
		var username = $('#username').val();
		var password = $('#password').val();
		var vCode = $('#vCode').val();

		var displayStyle = $('#identifyingcode').css('display');

		var flag = false;
		if (username) {
			flag = true;
		} else {
			flag = false;
			pointhide('请输入用户名');
			return;
		}
		if (password) {
			flag = true;
		} else {
			flag = false;
			pointhide('请输入密码');
			return;
		}
		if (displayStyle != 'none') {
			if (vCode) {
				flag = true;
			} else {
				flag = false;
				pointhide('请输入验证码');
				return;
			}
		}

		return flag;
	},

	verifyCode : function() {

		$("#verifyCode").attr("src",BASE_URL + "/rest/page/verifyCode?time="+new Date().getTime());

	}
}

$(function() {
	$("#vCode").bind("keyup", function(event) {
		if (event.keyCode == 13) {
			$("#tLogin").click();
		}
	});

	$("#vCode").bind("focus", function() {
		var vCodeValue = $("#vCode").val();
		if (vCodeValue == "验证码") {
			$("#vCode").val(null);
		}
	});

	$("#vCode").bind("blur", function() {
		var vCodeValue = $("#vCode").val();
		if (vCodeValue == "") {
			$("#vCode").val('验证码');
		}
	});

	$("#username").bind("focus", function() {
		var usernameValue = $("#username").val();
		if (usernameValue == "请输入注册时填写的邮箱") {
			$("#username").val(null);
		}
	});

	$("#username").bind("blur", function() {
		var usernameValue = $("#username").val();
		if (usernameValue == "") {
			$("#username").val('请输入注册时填写的邮箱');
		}
	});

	$("#username").bind("keypress", function(event) {
		if (event.keyCode == 32)
			var value = $("#username").val();
			if(value != undefined && value != null){
				value = value.replace(/[^\w\.\/]/ig, '');
				$("#username").val(value);
			}
	});
	
	$("#password").bind("keypress", function(event) {
		if (event.keyCode == 32)
			var value = $("#password").val();
			if(value != undefined && value != null){
				value = value.replace(/[^\w\.\/]/ig, '');
				$("#password").val(value);
			}
	});

});

function pointhide(message) {
	$("#errormessage").css("visibility", "visible");
	$("#errormessage").html(message);
	
	setTimeout("codefans()", 2000);
}

function codefans() {
	$("#errormessage").css("visibility", "hidden");
}
