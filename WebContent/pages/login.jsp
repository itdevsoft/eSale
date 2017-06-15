<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>Login Page</title>

<link type="text/css" href="resources/css/jquery-ui-1.8.16.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="resources/js/jquery-1.7.js"></script>
<script type="text/javascript"
	src="resources/js/jquery-ui-1.8.16.custom.min.js"></script>
<link type="text/css" href="resources/css/jquery.ui.button.css"
	rel="stylesheet" />
<link type="text/css" href="resources/css/jquery.ui.core.css"
	rel="stylesheet" />
<link type="text/css" href="resources/css/extra.css" rel="stylesheet" />
</head>
<body onload='document.f.j_username.focus();'>
<h3>Please Login</h3>

<c:if test="${not empty error}">
	<div class="ui-widget">
	<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
	<p><span class="ui-icon ui-icon-alert"
		style="float: left; margin-right: .3em;"></span> Your login attempt
	was not successful, try again.<br />
	${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}</p>
	</div>
	</div>

</c:if>
<div class="linebreak-10"></div>
<form name='f' action="<c:url value='j_spring_security_check' />"
	method='POST'>
<fieldset>
<div class="formline"><label for="name">User Name</label> <input
	type="text" name="j_username" id="name"
	class="text ui-widget-content ui-corner-all" /></div>
<div class="formline"><label for="password">Password</label> <input
	type="password" name="j_password" id="password" value=""
	class="text ui-widget-content ui-corner-all" /></div>
<div class="linebreak-10"></div>
<div class="formline"><input name="submit" type="submit" value="submit"
	class="button ui-state-default ui-corner-all ui-button" /> <input
	name="reset" type="reset"
	class="button ui-state-default ui-corner-all ui-button" /></div>
</fieldset>
</form>



</body>
</html>