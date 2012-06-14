<%@include file="../inc/doctype_html_admin.jsp" %>

<!-- Website designed and developed by Bright Interactive, http://www.bright-interactive.com -->
<%-- History:
	 d1		Matt Stevenson	05-Jul-2007		Created
	 d2		Marco Primiceri	18-Apr-2011 	Modified to work in a new "Name Attributes" tab
--%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/bright-tag.tld" prefix="bright" %>
<%@page import="org.apache.lucene.search.SortField"%>
<%@page import="com.bright.assetbank.attribute.bean.SortAttribute"%>


<bright:applicationSetting id="ecommerce" settingName="ecommerce" />


<head>
	
	<title><bright:cmsWrite identifier="company-name" filter="false" /> | Name Attributes</title> 
	<%@include file="../inc/head-elements.jsp"%>
	<bean:define id="section" value="displayAttributes"/>
	<bean:define id="pagetitle" value="Name Attribute Saved"/>
	<bean:define id="tabId" value="nameAttributes"/>
</head>

<body id="adminPage">
	<%@include file="../inc/body_start.jsp"%>
	
	<bean:parameter id="browse" name="browse" value="0"/>
	<h1><bean:write name="pagetitle" filter="false"/></h1> 

	<%@include file="../attribute-admin/inc_attribute_tabs.jsp"%>
	
	<p>You have successfully set the name attributes for your <bright:cmsWrite identifier="items" filter="false" />.</p>
	
	<p>Return to the <a href="viewManageNameAttributes">name attribute management page &raquo;</a></p>

	<%@include file="../inc/body_end.jsp"%>
	
</body>
</html>