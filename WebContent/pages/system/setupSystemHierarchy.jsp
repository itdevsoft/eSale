<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
   <c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${heading}</title>

<script type="text/javascript">
$(document).ready(function() {
	var allFields = $( [] ).add($('#categoryName'));
	<c:if test="${not empty imediateCaregoryList}">
		$("#nextCategory").hide();
		$("#editCategory").hide();
		$("#deleteCategory").hide();
	</c:if>
	<c:if test="${not empty nestedCategory.saleItems}">
		$("#nextCategory").hide();
		$("#addCategory").hide();
		$("#editCategory").hide();
		$("#deleteCategory").hide();
		$("#assignItems").hide();
	</c:if>
	$( "#dialog-form-add" ).dialog({
		autoOpen: false,
		height: 290,
		width: 450,
		modal: true,
		title: 'Add/Modify Category',
		buttons: {
			" Save ": function() {
				
				var bValid = true;
				allFields.removeClass( "ui-state-error" );

				bValid = bValid && checkLength($('#categoryName'),$( ".validateTips" ),"Category Name", 2, 250 );
				bValid = bValid && checkRegexp( $('#categoryName'),$( ".validateTips" ), /^[a-z]([0-9a-z_& ])+$/i, "Category Name may consist of a-z, 0-9, underscores, begin with a letter." );
				bValid = bValid && checkLength($('#diffFactor'),$( ".validateTips" ),"Diff. Factor", 1, 3 );
				bValid = bValid && checkRegexp( $('#diffFactor'),$( ".validateTips" ), /^([0-9])+$/i, "Diff. Factor may consist of 0-9." );
				bValid = bValid && checkValue($('#diffFactor'),$( ".validateTips" ),"Diff. Factor", 0, 100 );
				if ( bValid ) {
					updateTips($( ".validateTips" ), $('#categoryName').val() );
					$("#addCategoryForm").submit();
					//var url = '<c:out value="${contextPath}" />/system/setupSystemHierarchy/add?id='+$('#catList').attr('value')+'&name='+$('#categoryName').val();
					//$(location).attr('href',url);
					$( this ).dialog( "close" );
				}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
			
		}
	});
	$( "#dialog-form-delete" ).dialog({
		autoOpen: false,
		height: 250,
		width: 450,
		modal: true,
		title: 'Delete Category Nodes',
		buttons: {
			" Delete ": function() {
				
				var bValid = true;
				if ( bValid ) {
					$("#delCategoryId").attr('value',$('#catList').attr('value'));
					$("#deleteCategoryForm").submit();
					//var url = '<c:out value="${contextPath}" />/system/setupSystemHierarchy/add?id='+$('#catList').attr('value')+'&name='+$('#categoryName').val();
					//$(location).attr('href',url);
					$( this ).dialog( "close" );
				}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
			
		}
	});
	$('#addCategory').click(function() {
		$("#dialog-form-add" ).show();
		$("#dialog-form-delete" ).hide();
		$('#categoryName').attr('value','');
		$("#addCategoryId").attr('value',$('#catList').attr('value'));
		$("#diffFactor").attr('value','<c:out value="${parentCaregory.category.diffFactor}"/>');
		allFields.removeClass( "ui-state-error" );
		updateTips($( ".validateTips" ), "Please enter the required fields and Save." );
		$("#dialog-form-add" ).dialog( "open" );
		return false;
	});
	$('#editCategory').click(function() {
		$("#dialog-form-add" ).show();
		$("#dialog-form-delete" ).hide();
		if($('#catList').attr('value')>0){
			$('#categoryName').attr('value',$('#catList option:selected').text());
			$("#addCategoryId").attr('value',$('#catList').attr('value'));
			$("#categoryId").attr('value',$('#catList option:selected').attr('categoryid'));
			$("#diffFactor").attr('value',$('#catList option:selected').attr('difffactor'));
			$("#imagePath").attr('value',$('#catList option:selected').attr('imagepath'));
		}else{
			$('#categoryName').attr('value','<c:out value="${parentCaregory.category.name}"/>');
			$("#addCategoryId").attr('value',$('#addParentId').attr('value'));
			$("#categoryId").attr('value','<c:out value="${parentCaregory.category.id}"/>');
			$("#diffFactor").attr('value','<c:out value="${parentCaregory.category.diffFactor}"/>');
			
		}
		
		$('#addCategoryForm').attr('action','edit');
		allFields.removeClass( "ui-state-error" );
		updateTips($( ".validateTips" ), "Please modify the required fields and Save." );
		$("#dialog-form-add" ).dialog( "open" );
		return false;
	});
	$('#assignItems').click(function(){
		$("#assignNestedCategoryId").attr('value',$('#assignParentId').attr('value'));
		$("#assignCategoryId").attr('value','<c:out value="${parentCaregory.category.id}"/>');
		$("#assignItemsForm").submit();
	});
	$('#deleteCategory').click(function() {
		$("#dialog-form-delete" ).css('display','block');
		$("#dialog-form-add" ).css('display','none');
		allFields.removeClass( "ui-state-error" );
		var deleteField='';
		if($('#catList').attr('value')>0)
			deleteField=$('#catList option:selected').text();
		else
			deleteField='<c:out value="${parentCaregory.category.name}"/>';
		
		updateTips($( ".validateTips" ), "Are you sure do you want to delete ''"+deleteField+"''and below category nodes and their assigned items" );
		$("#dialog-form-delete" ).dialog( "open" );
		return false;
	});
	$('#nextCategory').click(function() {
		var categoryId = $('#catList').attr('value');
		var categoryType = $('#catList option:selected').attr('categorytype');
		var url = '<c:out value="${contextPath}" />/system/setupSystemHierarchy/'+categoryId+'?type='+categoryType;   
		if(categoryId>0){
			$(location).attr('href',url);
		}
		
	});
	$("#catList").change(function(){
		if($("#catList").attr('value')>0){
			$("#nextCategory").show();
			$("#deleteCategory").show();
			$("#editCategory").show();
		}else{
			$("#nextCategory").hide();
			$("#deleteCategory").hide();
			$("#editCategory").hide();
		}
	});
});
</script>
</head>
<body>
<c:if test="${not empty message}"><jsp:include page="../messagedisplay.jsp" /></c:if>
<h3>${heading}</h3>


<fieldset>
<c:forEach items="${bredcrumbList}" var="bredcrumb" >
<a href="${contextPath}/system/setupSystemHierarchy/${bredcrumb.id}?type=${bredcrumb.type}" >${bredcrumb.category.name}</a>-->
</c:forEach>

<c:if test="${not empty imediateCaregoryList}">
<select name="listCategory" id="catList">
<option value="-1">--select--</option>
<c:forEach items="${imediateCaregoryList}" var="cat" >
<option title="${cat.category.name}" value="${cat.id}" categoryid="${cat.category.id}" categorytype="${cat.type}" difffactor="${cat.category.diffFactor}" imagepath="${cat.category.imagePath}">${cat.category.name}</option>
</c:forEach>
</select>	
</c:if>

<c:if test="${not empty imediateCaregoryList}">
<input type="button" value="Next" id="nextCategory" >
</c:if>
<input type="button" value="Add" id="addCategory">
<input type="button" value="Edit" id="editCategory">
<c:if test="${not empty imediateCaregoryList}">
<input type="button" value="Delete" id="deleteCategory">
</c:if>
<c:if test="${empty imediateCaregoryList}">
<!-- <input type="button" value="Assign" id="assignItems" > -->
</c:if>
</fieldset>

<c:if test="${not empty nestedCategory.saleItems}">
<jsp:include page="assignSaleItems.jsp" />
</c:if>

<div id="dialog-form-add" title="Create new Category" style="display: none;">
	<p class="validateTips" style="font-size: 11px;font-weight: bold;">Please enter the Category Name and Add.</p>
	<form:form action="add" id="addCategoryForm" commandName="nestedCategory" enctype="multipart/form-data">
	<form:hidden path="id" id="addCategoryId" />
	<form:hidden path="category.id" id="categoryId" />
	<form:hidden path="parentId" id="addParentId" />
	<form:hidden path="type" id="addNestedCategoryType" />
	<fieldset id="categoryNameFieldset">
		<label for="name" id="categoryNameLabel">Name</label>
		<form:input path="category.name" id="categoryName" class="text ui-widget-content ui-corner-all" style="width: 300px;" />
		<br/>
		<label for="name" id="categoryNameLabel">Diff. Factor </label>
		<form:input path="category.diffFactor" id="diffFactor" class="text ui-widget-content ui-corner-all" style="width: 100px;" />
		<br/>
		<label for="imageFile" id="categoryImageFile">Image File</label>
		<form:input type="file" path="category.fileData" id="category.fileData" cssClass="text ui-widget-content ui-corner-all" cssStyle="width:20px;" />
		<form:hidden id="imagePath" path="category.imagePath" />
	</fieldset>
	</form:form>
</div>

<div id="dialog-form-delete" title="Delete Category Nodes" style="display: none;">
	<p class="validateTips" style="font-size: 11px;font-weight: bold;"></p>
	<form:form action="delete" id="deleteCategoryForm" commandName="nestedCategory">
	<form:hidden path="id" id="delCategoryId" />
	<form:hidden path="type" id="delCategoryType" />
	<form:hidden path="parentId" id="delParentId" />
	
	</form:form>
</div>

<div id="" style="display: none;">
<form:form action="assignInit" id="assignItemsForm" commandName="nestedCategory">
	<form:hidden path="id" id="assignNestedCategoryId" />
	<form:hidden path="type" id="assignNestedCategoryType" />
	<form:hidden path="category.id" id="assignCategoryId" />
	<form:hidden path="parentId" id="assignParentId" />
</form:form>
</div>


</body>
</html>