<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Setup System Hierachy Sales Items</title>
<script type="text/javascript">
    $(document).ready(function () {
        $("#setupItemsTable").styleTable();

        $('#catList').change(function() {
    		var categoryId = $('#catList').attr('value');
    		var url = '<c:out value="${contextPath}" />/system/setupSystemHierarchySaleItems/init/'+categoryId;   
    		if(categoryId>0){
    			$(location).attr('href',url);
    		}
    		
    	});

        $( "#dialog-message" ).dialog({
    		autoOpen: false,
    		height: 200,
    		width: 350,
    		modal: true,
    		title: 'Information Message',
    		buttons: {
        	" Ok ": function() {
				$( this ).dialog( "close" );
			}
			}
		});
    });

    function goToSave(itemId,categoryId){
        var idPrefix=itemId+'_'+categoryId;
        var displayNameId='#'+idPrefix+'_displayName';
        var descriptionId='#'+idPrefix+'_description';
        var priceId='#'+idPrefix+'_price';
        var assignedId='#'+idPrefix+'_assigned';

		var displayName = $(displayNameId).val();
		var description = $(descriptionId).val();
		var price = $(priceId).val();
		var assigned=false;
		if($(assignedId).attr('checked')=='checked'){
			assigned=true;
		}
		var url = '<c:out value="${contextPath}" />/system/setupSystemHierarchySaleItems/assign';   
		
		var request = $.ajax({
			  type: "POST",
			  url: url,
			  data:{itemId : itemId,categoryId : categoryId,displayName : displayName,description:description,price:price,assigned:assigned},
			  dataType: "text"
			});
		request.done(function(msg) {
			$("#dialog-message-text").html(msg);
			$("#dialog-message").show();
			$("#dialog-message" ).dialog( "open" );
		});

		request.fail(function(jqXHR, textStatus) {
			$("#dialog-message-text").html(textStatus);
			$("#dialog-message").show();
			$("#dialog-message" ).dialog( "open" );
		});
    }
</script>
</head>
<body>
<c:if test="${not empty message}"><jsp:include page="../messagedisplay.jsp" /></c:if>
<h3>Setup System Hierachy Sales Items</h3>
<fieldset>
<c:forEach items="${bredcrumbList}" var="bredcrumb" >
<a href="${contextPath}/system/setupSystemHierarchySaleItems/init/${bredcrumb.id}" >${bredcrumb.category.name}</a>-->
</c:forEach>

<c:if test="${not empty imediateCaregoryList}">
<select name="listCategory" id="catList">
<option value="-1">--select--</option>
<c:forEach items="${imediateCaregoryList}" var="cat" >
<option title="${cat.category.name}" value="${cat.id}" categoryid="${cat.category.id}" difffactor="${cat.category.diffFactor}">${cat.category.name}</option>
</c:forEach>
</select>	
</c:if>	
</fieldset>

<c:if test="${not empty nestedCategory.nestedCategorySaleItems}">
<fieldset>
<form:form action="/eSale/system/setupSystemHierarchySaleItems/assignItems" commandName="nestedCategory" >
	<form:hidden path="id" />
	<form:hidden path="category.id"  />
	<form:hidden path="parentId"  />
<table border="1" id="setupItemsTable">
<tr>
<th title="Id">Id</th>
<th title="Name">Display Name</th>
<th title="description">Description</th>
<th title="Price">Price</th>
<th title="Assigned">Assigned</th>
<th title="Save"><input name="submit" type="submit" value="Save All" class="button ui-state-default ui-corner-all ui-button" /></th>
</tr>
<tbody>
<c:forEach items="${nestedCategory.nestedCategorySaleItems}" var="nestedCategorySaleItem" varStatus="count" >
<form:hidden path="nestedCategorySaleItems[${count.index}].saleItem.id" /> 
<form:hidden path="nestedCategorySaleItems[${count.index}].nestedCategory.id"  />
<tr>
<td title="${nestedCategorySaleItem.saleItem.id}">${nestedCategorySaleItem.saleItem.id}</td>
<td title="${nestedCategorySaleItem.saleItem.name}"><form:input id="${nestedCategorySaleItem.saleItem.id}_${nestedCategorySaleItem.nestedCategory.id}_displayName" path="nestedCategorySaleItems[${count.index}].displayName"/></td>
<td title="${nestedCategorySaleItem.saleItem.name}"><form:textarea id="${nestedCategorySaleItem.saleItem.id}_${nestedCategorySaleItem.nestedCategory.id}_description" path="nestedCategorySaleItems[${count.index}].description"/></td>
<td title="${nestedCategorySaleItem.saleItem.name}"><form:input  id="${nestedCategorySaleItem.saleItem.id}_${nestedCategorySaleItem.nestedCategory.id}_price" path="nestedCategorySaleItems[${count.index}].price"/></td>
<td title="${nestedCategorySaleItem.saleItem.name}"><form:checkbox  id="${nestedCategorySaleItem.saleItem.id}_${nestedCategorySaleItem.nestedCategory.id}_assigned" path="nestedCategorySaleItems[${count.index}].assigned"/></td>
<td title="${nestedCategorySaleItem.saleItem.name}"><input  type="button" value="Save" class="button ui-state-default ui-corner-all ui-button" onclick="javascript:goToSave('${nestedCategorySaleItem.saleItem.id}','${nestedCategorySaleItem.nestedCategory.id}','${nestedCategorySaleItem.nestedCategory.id}')" /></td>
</tr>
</c:forEach>
</tbody>
</table>
<div class="formline">
<input name="submit" type="submit" value="Save All" class="button ui-state-default ui-corner-all ui-button" />
</div>
</form:form>
</fieldset>
</c:if>
<div id="dialog-message" title="Information" style="display: none;">
<div id="dialog-message-text" style="font-size: 11px;font-weight: bold;"></div>
</div>
</body>
</html>