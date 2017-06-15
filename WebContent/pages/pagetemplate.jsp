<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html>
	<head>
		<title><sitemesh:write property='title'/> - eSale</title>
		<link type="text/css" href="${contextPath}/resources/css/jquery-ui-1.8.16.custom.css" rel="stylesheet" />	
		<script type="text/javascript" src="${contextPath}/resources/js/jquery-1.7.js"></script>
		<script type="text/javascript" src="${contextPath}/resources/js/jquery-ui-1.8.16.custom.min.js"></script>
		<script type="text/javascript" src="${contextPath}/resources/js/extra.js"></script>
		<link type="text/css" href="${contextPath}/resources/css/extra.css" rel="stylesheet" />
		<sitemesh:write property='head'/>
	</head>
	<body>
		<div id="doc">
			<div id="hd">
				<div class="banner">Main banner goes here...</div>
				<div class="linebreak-25"></div>
				<div>
					<a href="${contextPath}/welcome">Home</a> |
					<a href="${contextPath}/system/setupSaleItem">Setup Sale Item</a> |
					<a href="${contextPath}/system/initSystemHierarchySetup">Setup Hierarchy</a> |
					<a href="${contextPath}/system/initSetupSystemHierarchySaleItems">Assign Sale Items to Hierarchy</a> |
					<a href="${contextPath}/j_spring_security_logout">Logout</a>
				</div>
			</div>
			<div class="linebreak-25"></div>
			<sitemesh:write property='body'/>
			<div class="linebreak-25"></div>
			<div id="ft">
				<div>Footer goes here..</div>
				<div class="linebreak-25"></div>
				<div>
					<a href="${contextPath}/welcome">Home</a> |
					<a href="${contextPath}/about.html">About</a> |
					<a href="${contextPath}/contact.html">Contact</a> |
					<a href="${contextPath}/legal.html">Legal</a>
				</div>
			</div> 
		</div>
	</body>
</html>
