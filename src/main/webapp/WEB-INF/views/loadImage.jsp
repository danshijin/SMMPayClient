<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div><img src="${requestScope.loadImage }"/></div>

<script type="text/javascript">

  function xx(){
	  var img=document.getElementsByTagName("img");
	  var index = '${requestScope.index}';
	  var width = '${requestScope.width}';
	  var height = '${requestScope.height}';
	  img[0].style.height=width;
	  img[0].style.width=height;
	  
  }
  xx();
</script>
  