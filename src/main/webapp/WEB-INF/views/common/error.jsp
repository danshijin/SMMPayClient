<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>返回结果</title>
</head>
<body>

<%
String retMsg=(String)request.getAttribute("retMsg");
String retCode = (String)request.getAttribute("retCode");
%>
<table>
	<tr>
		<td>返回信息</td>
		<td><%=retMsg %></td>
	</tr>
	<p></p>

</table>
<a href="Javascript:window.history.go(-1)" >返回上一页</a>
</body>
</html>