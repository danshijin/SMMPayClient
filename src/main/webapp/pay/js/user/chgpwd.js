//---------------------------浮窗JS--------------------------------
		function showprompt(){
			$(".alter-s").show("slow");
			$("#img2").hide("slow");
			$("#words2").hide("slow");
			$("#words2").html("");
		}

		function hideprompt(){
			$(".alter-s").hide("slow");
			$("#img2").show();
			$("#words2").show();
			var status = checkpwd();
			var oldpwd = $("#oldpwd").val();
			var newpwd = $("#newpwd").val();
			if(oldpwd == newpwd){
				$("#img2").attr("class","fa fa-times-circle red");
				$("#words2").attr("class","red font12");
				$("#words2").html("新密码不能与旧密码一致。");
				return 0;
			}
			if(status<1){
				$("#img2").attr("class","fa fa-times-circle red");
				$("#words2").attr("class","red font12");
				$("#words2").html("请按照指定格式设置新密码。");
			}else {
				$("#img2").attr("class","fa fa-check-circle green");
				$("#words2").html("");
			}
			return 1;
		}
		
		function checkpwd(){
			var i = 0;	//包含几种符号
			var j = 1;  //安全等级
			var k = 1;  //判断验证结果，小于1则验证不通过
			var reg  = /[a-zA-z0-9\W_]{1,}/;
			var reg1 = /[a-z]{1,}/;
			var reg2 = /[A-Z]{1,}/;
			var reg3 = /[0-9]{1,}/;
			var reg4 = /[\W_]{1,}/;
			var reg5 = /\s/;
			var newpwd = $("#newpwd").val();
			if(newpwd.length<6 || newpwd.length>20){//6-20位字符
				$("#ck1").attr("class","fa fa-close red");
				k--;
			}else{
				$("#ck1").attr("class","fa fa-check green");
			}
			if(!reg.test(newpwd) || reg5.test(newpwd)){//只能包含大小写字母、数字以及标点符号（除空格）
				$("#ck2").attr("class","fa fa-close red");
				k--;
			}else{				
				$("#ck2").attr("class","fa fa-check green");					
			}
		
			if(reg1.test(newpwd)){ i++; }
			if(reg2.test(newpwd)){ i++; }
			if(reg3.test(newpwd)){ i++; }
			if(reg4.test(newpwd)){ i++; }
			
			if(i < 2){//大写字母、小写字母、数字和标点符号至少包含2种
				$("#ck3").attr("class","fa fa-close red");
				k--;
			}else{
				$("#ck3").attr("class","fa fa-check green");
			}
			if(i > 2){ j++; }
			if(newpwd.length > 10 && newpwd.length < 21){ j++; }
			if (j == 1){
				$("#safelv1").attr("class","block safe-g safe-r");
				$("#safelv2").attr("class","block safe-g");
				$("#safelv3").attr("class","block safe-g");
				$("#safeprompt").attr("class","red");
				$("#safeprompt").html("低");
			}
			if (j == 2){
				$("#safelv1").attr("class","block safe-g safe-o");
				$("#safelv2").attr("class","block safe-g safe-o");
				$("#safelv3").attr("class","block safe-g");
				$("#safeprompt").attr("class","orange");
				$("#safeprompt").html("中");
			}
			if (j == 3){
				$("#safelv1").attr("class","block safe-g safe-gr");
				$("#safelv2").attr("class","block safe-g safe-gr");
				$("#safelv3").attr("class","block safe-g safe-gr");
				$("#safeprompt").attr("class","green");
				$("#safeprompt").html("高");
			}
			recheckpwd();
			return k;
		}

		function recheckpwd(){
			var newpwd = $("#newpwd").val();
			var repwd = $("#repwd").val();
			if(repwd.length==0){
				return 0;
			}
			if (newpwd != repwd){
				$("#img3").attr("class","fa fa-times-circle red");
				$("#words3").attr("class","red font12");
				$("#words3").html("密码输入不一致，请重新输入。");
				return 0;
			}else {
				$("#img3").attr("class","fa fa-check-circle green");
				$("#words3").html("");
				return 1; //1是验证通过，0是验证不通过
			}
		}