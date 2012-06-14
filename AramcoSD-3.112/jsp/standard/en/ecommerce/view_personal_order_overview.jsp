<%@include file="../inc/doctype_html_admin.jsp" %>
<!-- Website designed and developed by Bright Interactive, http://www.bright-interactive.com -->
<%-- History:
	d1		Kevin Bennett		08-Jan-2007		Created
	d2      Matt Woollard       11-Feb-2008     Replaced content with list items
--%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/bright-tag.tld" prefix="bright" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>


<bright:applicationSetting id="dateFormat" settingName="standard-date-format" />
<bright:applicationSetting id="showCommercialOptions" settingName="commercial-options"/>

<c:set var="pagetitle"><bright:cmsWrite identifier="e-subhead-personal-orders" filter="false" replaceVariables="true" /></c:set>

<head>
	<bean:define id="section" value="orders"/>
	<title><bean:write name="pagetitle" filter="false"/></title> 
	<%@include file="../inc/head-elements.jsp"%>
	
	<bean:define id="tabId" value="personalOrders"/>
	<script type="text/JavaScript">
		$j(function () {
			initDatePicker();
		});
	</script>
</head>


<body id="adminPage">
	<%@include file="../inc/body_start.jsp"%>

	<h1><bean:write name="pagetitle" filter="false"/></h1> 
	
	<%@include file="../ecommerce/inc_order_tabs.jsp"%>
	
	<p>
		<h3 class="report"><bright:cmsWrite identifier="e-search-orders" filter="false"/></h3>
		<logic:present name="orderForm"> 
			<logic:equal name="orderForm" property="hasErrors" value="true"> 
				<div class="error">
					<logic:iterate name="orderForm" property="errors" id="errorText">
						<bean:write name="errorText" filter="false"/><br />
					</logic:iterate>
				</div>
			</logic:equal>
		</logic:present>
		<html:form action="viewPersonalOrderOverview" method="get">
			<input type="hidden" name="orderWorkflow" value="1" />
			<%@include file="../ecommerce/inc_order_search_fields.jsp"%>
		</html:form>
	</p>	
	<div class="hr"></div>	
		
	<logic:empty name="orderForm" property="orderList">
		<p><bright:cmsWrite identifier="e-no-orders-found" filter="false"/></p>
	</logic:empty>
	<logic:notEmpty name="orderForm" property="orderList">
		<p>
			<%@include file="../ecommerce/inc_order_overview_details.jsp"%>
		</p>
	</logic:notEmpty>
																													
	<%@include file="../inc/body_end.jsp"%>
</body>
</html>