<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
   <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${heading}</title>
</head>
<body>
<fieldset>
<ul>
<c:forEach items="${systemHierarchySetupList}" var="hierarchyType" >
<li><a href="${contextPath}/system/${operation}/${hierarchyType.key}?type=${hierarchyType.value}" >${hierarchyType.value}</a></li>
</c:forEach>
</ul>
</fieldset>
</body>
</html>