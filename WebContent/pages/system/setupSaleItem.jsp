<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<title>${heading}</title>
<head>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
<script type="text/javascript">
	$(document).ready(function () {
	    $(function() {
			$( "#saleItemTabs" ).tabs();
		});
		<c:if test="${operation eq 'search'}">
	    $( "#saleItemTabs" ).tabs({ selected: 1 });
	    $("#searchBy").attr('value','<c:out value="${searchBy}" />');
	    $("#keyword").attr('value','<c:out value="${keyword}" />');
	    </c:if>
		$("#serachBtn").click(function(){
			var url = '/eSale/system/searchSaleItems?searchBy='+$("#searchBy").val()+'&keyword='+$("#keyword").val();
			$(location).attr('href',url);
		});
		
	});
    function goToEdit(itemId){
        var url = 'editSaleItem/'+itemId;
    	$(location).attr('href',url);
    }
</script>
</head>
<body>

<c:if test="${not empty message}"><jsp:include page="../messagedisplay.jsp" /></c:if>

<div id="saleItemTabs">
<ul>
	<li><a href="#saleItemTabs-1">Add Sale Item</a></li>
	<li><a href="#saleItemTabs-2">Search Sale Items</a></li>
</ul>
<div id="saleItemTabs-1" title="Create new Sale Item">
<form:form action="${action}" commandName="saleItem" enctype="multipart/form-data">
	
<fieldset title="Item Details" >
<label class="fieldsetLabel" for="itemDetails">Item Details</label>
<div class="linebreak-10"></div>
<c:if test="${saleItem.id>0}">
<div class="formline"><label for="id">Item Id</label>
<form:input path="id" id="id" cssClass="text ui-widget-content ui-corner-all" title="id" readonly="${success}" /></div>
</c:if>
<div class="formline"><label for="title">Name</label>
<form:input path="name" id="name" cssClass="text ui-widget-content ui-corner-all" /></div>
<div class="formline"><label for="title">Description</label>
<form:textarea path="description" id="description" cssClass="text ui-widget-content ui-corner-all" /></div>
<div class="formline"><label for="basePrice">Base Price</label>
<form:input path="basePrice" id="basePrice" cssClass="text ui-widget-content ui-corner-all" cssStyle="width:60px;" />
<form:select path="priceFor" cssClass="select ui-widget-content ui-corner-all" items="${priceForList}" />
</div>
<div class="formline"><label for="title">Image File</label>
<form:input type="file" path="fileData" id="fileData" cssClass="text ui-widget-content ui-corner-all" cssStyle="width:20px;" /></div>
 <div class="formline"><label for="enabled">Activate</label>
<form:checkbox path="enabled" />
<form:hidden path="imagePath" />
</div>
<div class="formline"><input name="submit" type="submit"
	value="${buttonLabel}" class="button ui-state-default ui-corner-all ui-button" />
</div>
</fieldset>
</form:form>

</div>
<div id="saleItemTabs-2">
	<fieldset title="Item Details" >
		<div class="formline">
		<label for="serachBy">Search By</label>
		<select name="searchBy" id="searchBy">
			<c:forEach items="${searchByList}" var="serachByItem" varStatus="count" >
			<option value="${serachByItem}" label="${serachByItem}" title="${serachByItem}">${serachByItem}</option>
			</c:forEach>
		</select>
		</div>
		<div class="formline">
		<label for="keyword">Keyword</label>
		<input type="text" name="keyword" id="keyword">
		</div>
	
<div class="formline">
<input type="button" id="serachBtn" value="Search" class="button ui-state-default ui-corner-all ui-button" />
</div>
</fieldset>
<c:if test="${not empty searchItems}">
<fieldset>
<form:form action="assignItems" commandName="searchItems">
	
<table border="1" id="assignItemsTable">
<tr>
<th title="Id">Id</th>
<th title="Name">Name</th>
<th title="Name">Description</th>
<th title="Name">Base Price</th>
<th title="Image">Image</th>
<th title="Active">Active</th>
<th title="Edit">#</th>
</tr>
<tbody>
<c:forEach items="${searchItems}" var="saleItem" varStatus="count" >
<tr>
<td title="${saleItem.id}">${saleItem.id}</td>
<td title="${saleItem.name}">${saleItem.name}</td>
<td title="${saleItem.description}">${saleItem.description}</td>
<td title="${saleItem.basePrice}">${saleItem.basePrice} ${saleItem.priceFor}</td>
<td title="${saleItem.name}" align="center">
<img alt="" src="/eSaleImages/${saleItem.id}.${saleItem.imageExt}" width="30px;" height="30px;" />
</td>
<td title="${saleItem.name}">
<c:choose>
<c:when test="${saleItem.enabled eq true}">
Yes
</c:when>
<c:otherwise>
No
</c:otherwise>
</c:choose>
</td>
<td title="${saleItem.name}"><input  type="button" value="Edit" onclick="javascript:goToEdit('${saleItem.id}')" /></td>
</tr>
</c:forEach>
</tbody>
</table>

</form:form>
</fieldset>
</c:if>

</div>
</div>
</body>
</html>