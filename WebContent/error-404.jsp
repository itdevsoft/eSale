<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
	<title>Page Not Found</title>
<body>
	<h1>Page Not Found</h1>
	<h3>Message : ${message}</h3>	
	<p>We're sorry, couldn't find the requested page.</p>
	<a href="<c:url value="/welcome" />" >Home</a>
</body>
</html>
