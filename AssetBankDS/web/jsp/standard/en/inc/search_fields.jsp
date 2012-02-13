<%-- 
	Shows all the search fields

	History:
	 d1		Martin Wilson		24-Oct-2005		Created.
	 d2     Steve Bryan			18-Jul-2006		Changed id of keywords field to avoid clash with META tags
	 d3     Steve Bryan			01-Nov-2006		Restructure for static attributes
	 d4		Matt Stevenson		10-May-2007		Added bulk upload dates
	 d5		Matt Stevenson		23-Nov-2007		Added refine your search functionality
	 13-Nov-2009	Steve Bryan		This is now called via search_fields.jsp from search.jsp, but included the old way by other jsps
	 
--%>		
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/bright-tag.tld" prefix="bright" %>

<bright:applicationSetting id="mainKeywordChooserId" settingName="main-keyword-chooser-id" />
<bright:applicationSetting id="useKeywordChooser" settingName="keyword-search-chooser" />
<bright:applicationSetting id="allowSearchByCompleteness" settingName="allow-search-by-completeness"/>
<bright:applicationSetting id="supportMultiLanguage" settingName="supportMultiLanguage"/>
<bright:applicationSetting id="searchPreviousVersions" settingName="allow-search-for-previous-versions"/>
<bright:applicationSetting id="searchPreviousVersionsAdminOnly" settingName="allow-search-for-previous-versions-admin-only"/>
<bright:applicationSetting id="canCreateAssetVersions" settingName="can-create-asset-versions"/>
<bright:applicationSetting id="agreementsEnabled" settingName="agreements-enabled" />
<bright:applicationSetting id="canSearchAgreements" settingName="can-search-agreements" />
<bright:applicationSetting id="anyAssetEntityAppearsFirst" settingName="any-option-appears-first-in-search"/>
<bright:applicationSetting id="showApprovalOnSearch" settingName="show-approval-status-on-search"/>
<bright:applicationSetting id="daysBeforeMonths" settingName="days-before-months" />
<bright:refDataList id="allowEmptyAssets" componentName="UserManager" methodName="getEmptyAssetsAllowed"/>
<bright:applicationSetting id="emptyAssetsEnabled" settingName="allow-empty-assets"/>


	<table class="form" cellspacing="0" cellpadding="0" border="0" summary="Form for advanced search">

		<c:if test="${not empty searchForm.entityName}">
			<tr>
				<th style="padding-top: 2px;"><bright:cmsWrite identifier="label-asset-type" filter="false"/></th>
				<td><bean:write name="searchForm" property="entityName"/></h3></td>
			</tr>
		</c:if>

		<%-- Always show keywords at the top --%>
		<tr>
			<th style="padding-top: 8px;">
				<label for="keywords_field"><bright:cmsWrite identifier="label-keywords" filter="false"/></label> 
			</th>
			<td style="padding-top: 6px;">
				<div style="position: relative; width: 70%">
				   <input type="text" name="keywords" size="55" class="text" id="keywords_field" <c:if test='${searchForm.refineSearch}'>value='<bean:write name='userprofile' property='searchCriteria.keywords' filter="false"/>'</c:if>/>
				   <c:if test="${useKeywordChooser && mainKeywordChooserId > 0}">
					   <script type="text/javascript">
						   document.write('&nbsp;<a href="javascript:;" onclick="openKeywordChooser(true, <bean:write name='mainKeywordChooserId'/>); return false;" onkeypress="openKeywordChooser(true, <bean:write name='mainKeywordChooserId'/>); return false;" title="Popup keyword selector"><img src="../images/standard/icon/keyword_chooser.gif" class="help" alt="Choose Keywords" height="15" width="15" border="0" /><\/a>'); 
					   </script>
				   </c:if>
				   &nbsp;				
				   <a href="../action/viewSearchHelp" target="_blank" title="<bright:cmsWrite identifier="tooltip-search-help" filter="false"/>" class="help-popup"><img src="../images/standard/icon/help.gif" alt="Help" width="15" height="15" class="help" border="0" /></a>
				</div>
				<div id="autocomplete_keywords" class="autocomplete"></div>
			</td>
		</tr>
		
		<%-- Asset Entity (type) field --%>
		<%@include file="search_entity_field.jsp" %>
		
		<%-- File field --%>
		<logic:notEmpty name="searchForm" property="filenameAttribute">
			<logic:equal name="searchForm" property="filenameAttribute.searchField" value="true">
				<tr>
					<th style="padding-top: 8px;">
						<label for="filename_field"><bean:write name="searchForm" property="filenameAttribute.label"/>:</label> 
					</th>
					<td style="padding-top: 8px;">
						<input type="text" name="filename" size="55" class="text" id="filename_field" <c:if test='${searchForm.refineSearch}'>value='<bean:write name='userprofile' property='searchCriteria.filename' filter="false"/>'</c:if>/>
					</td>
				</tr>
			</logic:equal>
		</logic:notEmpty>
		
		<%-- Go through all searchable attributes (static and flexible) and show the visible ones: --%>
		<logic:iterate name="searchForm" property="assetAttributes" id="attribute">
			<c:if test="${attribute.isVisible && !attribute.hidden}">
				<%@include file="search_field.jsp"%>
			</c:if>
		</logic:iterate>
		
		<%-- Approval status --%>
		<c:if test="${userprofile.isAdmin && showApprovalOnSearch}">
			<tr>
				<th>
					<label for="approvalStatus"><bright:cmsWrite identifier="label-approval-status" filter="false"/></label>
				</th>
				<td>
					<input type="checkbox" name="approvalStatus1" class="checkbox" id="approvalStatus1" value="1,2" <c:if test="${searchForm.refineSearch}"><logic:equal name="userprofile" property="searchCriteria.selectedAwaitingApproval" value="true">checked</logic:equal></c:if>/> <label for="approvalStatus1"><bright:cmsWrite identifier="snippet-awaiting-approval" filter="false"/></label><br/>
					<input type="checkbox" name="approvalStatus2" class="checkbox" id="approvalStatus2" value="3" <c:if test="${searchForm.refineSearch}"><logic:equal name="userprofile" property="searchCriteria.selectedApproved" value="true">checked</logic:equal></c:if>/> <label for="approvalStatus3"><bright:cmsWrite identifier="snippet-approved" filter="false"/></label><br/>
				</td>
			</tr>
		</c:if>
		
		<c:if test="${allowSearchByCompleteness && userprofile.canUpdateAssets}">
			<tr>
				<th>
					<label for="completeness"><bright:cmsWrite identifier="label-completeness" filter="false"/></label>
				</th>
				<td>
					<html:select name="searchForm" property="completeness" styleId="completeness">
						<option value="1" <c:if test="${searchForm.refineSearch && userprofile.searchCriteria.isComplete == null}">selected</c:if>>[<bright:cmsWrite identifier="snippet-any" filter="false"/>]</option>	
						<option value="2" <c:if test="${searchForm.refineSearch && userprofile.searchCriteria.isComplete == true}">selected</c:if>><bright:cmsWrite identifier="snippet-complete" filter="false"/></option>
						<option value="3" <c:if test="${searchForm.refineSearch && userprofile.searchCriteria.isComplete == false}">selected</c:if>><bright:cmsWrite identifier="snippet-incomplete" filter="false"/></option>
					</html:select>
					<c:if test="${not userprofile.currentLanguage.default}">
						<span style="padding-left: 6px;"><bright:cmsWrite identifier="snippet-applies-to-language" filter="false"/>
					</c:if>
				</td>
			</tr>
		</c:if>
		
		<c:if test="${userprofile.isAdmin}">
			<%-- Language selection field --%>
			<%@include file="search_language_field.jsp" %>	
		</c:if>
		
		<c:if test="${canCreateAssetVersions && searchPreviousVersions && (!searchPreviousVersionsAdminOnly || userprofile.isAdmin)}">
			<tr>
				<th>
					<label for="includePrevious"><bright:cmsWrite identifier="label-include-previous-versions" filter="false"/></label>
				</th>
				<td>
					<input type="checkbox" class="checkbox" name="includePreviousVersions" <c:if test="${searchForm.includePreviousVersions || (searchForm.refineSearch && userprofile.searchCriteria.includePreviousVersions)}">checked</c:if>/>
				</td>
			</tr>
		</c:if>

		<logic:notEmpty name="searchForm" property="bulkUploads">
			<tr>
				<th>
					<label for="bulkUploads"><bright:cmsWrite identifier="label-bulk-upload-date" filter="false"/> </label>
				</th>
				<td>
					<select name="bulkUpload" id="bulkUploads" size="1">
						<option value="-1">[<bright:cmsWrite identifier="snippet-any" filter="false"/>]</option>
						<logic:iterate name="searchForm" property="bulkUploads" id="bulk">
							<option value="<bean:write name='bulk' property='time'/>"><bean:write name='bulk' format="dd/MM/yyyy HH:mm"/></option>
						</logic:iterate>
					</select>
				</td>
			</tr>
		</logic:notEmpty>	

		<c:if test="${emptyAssetsEnabled && (userprofile.isAdmin || allowEmptyAssets)}">
			<tr>
				<th>
					<label for="empty"><bright:cmsWrite identifier="label-file-status" filter="false"/></label>
				</th>
				<td>
					<select name="emptyFileStatus" size="1">
						<option value="-1">[<bright:cmsWrite identifier="snippet-any" filter="false"/>]</option>
						<option value="1" <c:if test='${searchForm.refineSearch && userprofile.searchCriteria.emptyFileStatus==1}'>selected</c:if>><bright:cmsWrite identifier="snippet-empty-assets-only" filter="false"/></option>
						<option value="2" <c:if test='${searchForm.refineSearch && userprofile.searchCriteria.emptyFileStatus==2}'>selected</c:if>><bright:cmsWrite identifier="snippet-non-empty-assets-only" filter="false"/></option>
					</select>
				</td>
			</tr>
		</c:if>
		
	</table>	

	<%@include file="search_user_groups.jsp"%>

	<%@include file="search_external_filter.jsp"%>

	<%@include file="search_category_fields.jsp"%>
	
	
	<input type="submit" class="button flush floated" id="submitButton" value="<bright:cmsWrite identifier="button-search" filter="false" />" /> 
	