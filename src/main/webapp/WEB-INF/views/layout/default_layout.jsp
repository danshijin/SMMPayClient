<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="renderer" content="webkit">
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta HTTP-EQUIV="pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store, must-revalidate">
<meta HTTP-EQUIV="expires" CONTENT="0">

<title>SMM支付系统服务</title>


<link type="text/css" rel="stylesheet" href="<%=path %>/pay/css/payment.css" />

<script src="<%=path %>/pay/js/jquery-1.8.3.min.js"></script>
<script src="<%=path %>/pay/js/ajaxfileupload.js" type="text/javascript"></script>

<script type="text/javascript" src="<%=path %>/pay/js/banner.js"></script>
<script type="text/javascript" src="<%=path %>/pay/js/jquery.hoverIntent.minified.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
<script type="text/javascript" src="<%=path %>/pay/js/message.js"></script>
<script type="text/javascript" src="<%=path %>/pay/js/payClientCommon.js"></script>
    </head>
    <body>
   		<div>
    		<tiles:insertAttribute name="header" />
    	</div>
    	
    	<div >
			<tiles:insertAttribute name="body"/>
		</div>
		<tiles:insertAttribute name="footer" />
    </body>
</html>