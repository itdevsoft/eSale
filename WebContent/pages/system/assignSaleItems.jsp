<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script type="text/javascript">
	$(document).ready(function () {
        $("#assignItemsTable").styleTable();
    });

</script>

<fieldset>
<form:form action="assignItems" commandName="nestedCategory">
	<form:hidden path="id" />
	<form:hidden path="category.id"  />
	<form:hidden path="parentId"  />
<table border="1" id="assignItemsTable">
<tr>
<th title="Id">Id</th>
<th title="Name">Name</th>
<th title="Image">Picture</th>
<th title="Assign">#</th>
</tr>
<tbody>
<c:forEach items="${nestedCategory.saleItems}" var="saleItem" varStatus="count" >
<form:hidden path="saleItems[${count.index}].id" />
<form:hidden path="saleItems[${count.index}].name" />
<tr>
<td title="${saleItem.id}">${saleItem.id}</td>
<td title="${saleItem.name}">${saleItem.name}</td>
<td title="${saleItem.name}">
<img alt="" src="../../resources/images/saleItems/${saleItem.id}.jpg" width="30px;" height="30px;" />
</td>
<td title="${saleItem.name}">
<form:checkbox path="saleItems[${count.index}].assigned"/>
</td>
</tr>
</c:forEach>
</tbody>
</table>
<div class="formline">
<input name="submit" type="submit" value="Assign Items" class="button ui-state-default ui-corner-all ui-button" />
</div>
</form:form>
</fieldset>
