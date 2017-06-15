<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:set var="bannerClass" value="ui-state-error" />
<c:set var="iconClass" value="ui-icon-alert" />
<c:if test="${success eq true}">
	<c:set var="bannerClass" value="ui-state-highlight" />
	<c:set var="iconClass" value="ui-icon-info" />
</c:if>
<div class="ui-widget">
<div class="${bannerClass} ui-corner-all" style="padding: 0 .7em;">
<p><span class="ui-icon ${iconClass}"
	style="float: left; margin-right: .3em;"></span>
<spring:message	code="${message}" text="${message}" /></p>
</div>
</div>
