<%@ page import="com.bright.assetbank.application.constant.AssetBankSettings" %>
<%--
	Displays the form field for an attribute, according to the attribute type

	History:
	 d1		Martin Wilson		24-Oct-2005		Created.
	 d2		Matt Stevenson		09-Jan-2006		Changed empty check
	 d3     Steve Bryan			22-Feb-2007		Changed empty check to work for all types of attribute 
	 d4		Matt Stevenson		09-Mar-2007		Updated to allow for keyword picker
	 d5		Matt Stevenson		19-Mar-2007		Added empty check for keyword picker
	 d6		Steve Bryan			24-Feb-2010		Added spatial area type
--%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/bright-tag.tld" prefix="bright" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>


<bright:applicationSetting id="dateFormat" settingName="standard-date-format" />
<bright:applicationSetting id="dateFormatYearAndMonth" settingName="year-and-month-date-format" />
<bright:applicationSetting id="dateFormatYearOnly" settingName="year-only-date-format" />
<bright:applicationSetting id="textareaSearchMoreLikeThis" settingName="textarea-value-search-more-like-this"/>
<bright:applicationSetting id="moreLikeThisTokenLimit" settingName="more-like-this-token-limit"/>
<bright:applicationSetting id="keywordAncestorDelimiter" settingName="category-ancestor-delimiter"/>
<bean:define id="keywordDelimiter" value="<%= AssetBankSettings.getKeywordDelimiter() %>"/>
<bright:applicationSetting id="displayKeywordsByRootAncestorIds" settingName="display-keywords-by-root-ancestor-ids"/>
<bright:applicationSetting id="hideEmptyAtts" settingName="hide-empty-attributes" />
<bright:applicationSetting id="nearbyDistance" settingName="spatial-search-nearby-distance" />
<logic:notPresent name="section"><bean:define id="section" value=""/></logic:notPresent>	
<c:set var="hideEmptyAtts" value="${hideEmptyAtts && section != 'contact-sheet' && !showEmptyAtts}"/>

<logic:present name="globalSearchTokens">
	<bean:define id="searchTokens" name="globalSearchTokens" />
</logic:present>
<logic:notPresent name="globalSearchTokens">
	<bean:define id="searchTokens" name="attributeValue" property="attribute.hasSearchTokens" />
</logic:notPresent>


<%-- The attribute must be in a page variable called 'attributeValue' --%>
<%-- It is assumed that this include is called via <jsp:include>, with the following in the request scope:
	attributeValue
	reqLastAttId
	reqHideLabels
 --%>
<%-- Do a check for empty --%>
<c:choose>
	<c:when test="${attributeValue.attribute.isCheckList || attributeValue.attribute.isOptionList}">
		<c:set var="isEmpty" value="true" />
		<logic:iterate name="attributeValue" property="attribute.listOptionValues" id="optionValue">
			<c:if test="${!empty optionValue.value}"><c:set var="isEmpty" value="false" /></c:if>
		</logic:iterate>
	</c:when>
	<c:when test="${attributeValue.attribute.isKeywordPicker}">
		<c:set var="isEmpty" value="true" />
		<logic:notEmpty name="attributeValue" property="keywordCategories">
			<c:set var="isEmpty" value="false" />
		</logic:notEmpty>
	</c:when>
	<c:otherwise>
		<c:set var="isEmpty" value="${empty attributeValue.value || attributeValue.value == ' '}" />
	</c:otherwise>
</c:choose>

<c:if test="${!attributeValue.attribute.isDataLookupButton && attributeValue.attribute.id != reqLastAttId  && (!hideEmptyAtts || (!isEmpty || (attributeValue.attribute.isHyperlink && not empty attributeValue.attribute.defaultValue)))}">
	<tr <c:if test='${attributeValue.attribute.highlight}'>class="highlight"</c:if>>
		<c:if test="${!reqHideLabels}">
			<th>
				<%-- Only display the : if there is a label (it could be 'other' value for an attribute --%>
				<bean:write name="attributeValue" property="attribute.label" filter="false"/><c:if test="${!empty attributeValue.attribute.label && attributeValue.attribute.label != ' ' }">:</c:if>
			</th>
		</c:if>
		<td class="padded html" <c:if test="${reqHideLabels}">colspan="2"</c:if>>
			<%-- add an anchor for linking from search result/ iconfiles/ lists --%>
			<c:if test="${ not empty attributeValue.iconFile }">
				<a name="<c:out value="${ attributeValue.anchorIdentifier }"/>" />
			</c:if>	
			<c:choose>
				<c:when test="${attributeValue.attribute.isTextarea}">
					<c:choose>
						<c:when test="${attributeValue.attribute.maxDisplayLength >= 0 && !searchTokens}">
							<bean:define id="fieldLength" name="attributeValue" property="attribute.maxDisplayLengthString"/>
							<bright:writeWithTruncateTag name="attributeValue" property="valueHTML" filter="false" maxLengthBean="fieldLength" endString="..."/>&nbsp;<a href="" target="_blank" onclick="attributePopup(<c:out value='${assetIdForAttributes}'/>,<c:out value='${attributeValue.attribute.id}'/>,<c:out value='${attributeValue.attribute.dataFromChildren}'/>); return false;">Read more &raquo;</a>
						</c:when>
						<c:otherwise>
							<c:if test="${not searchTokens}">
								<c:if test="${!attributeValue.attribute.filtered}">
									<bean:write name="attributeValue" property="valueHTML" filter="false"/>
								</c:if>
								<c:if test="${attributeValue.attribute.filtered}">
<pre><bean:write name="attributeValue" property="value" filter="true"/></pre> <%-- Leave this against the left hand edge to avoid padding in the value --%>
								</c:if>
							</c:if>
							<c:if test="${searchTokens}">
								<c:choose>	
									<c:when test="${textareaSearchMoreLikeThis && empty attributeValue.attribute.tokenDelimiterRegex}">
										<bean:write name="attributeValue" property="valueHTML" filter="false"/>
										<bean:define id="moreLikeThisTokenLimit" name="moreLikeThisTokenLimit"/>
										<c:set var="searchString"><bright:write name="attributeValue" property="value" filter="false" case="lower" tokenDelimiter='[^a-zA-Z0-9]+' ignoreTokens="and|the|for|that|this|but|are" tokenDelimiterReplacement=" OR " maxTokens="<%= Integer.parseInt((String)moreLikeThisTokenLimit) %>"/></c:set>										
										<c:if test="${not empty searchString}">
											&nbsp;[<a href="search?attribute_<c:out value="${attributeValue.attribute.id}"/>=<c:out value="${searchString}"/>"><bright:cmsWrite identifier="link-more-like-this" filter="false"/></a>]
										</c:if>
									</c:when>
									<c:otherwise>
										<bean:define id="delimiter" name="attributeValue" property="attribute.tokenDelimiterRegex"/>
										<bean:define id="attributeId" name="attributeValue" property="attribute.id"/>
										<bright:write name="attributeValue" property="value" formatCR="true" filter="false" tokenDelimiter="<%= String.valueOf(delimiter) %>" outputTokenWrapper="<%= \" <a href='search?attribute_\" + attributeId + \"=%22[enc-token]%22'>[token]</a>\"%>"/>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${attributeValue.attribute.isCheckList || attributeValue.attribute.isOptionList}">
					<%-- Check list or option list --%>
					<bean:size name="attributeValue" property="attribute.listOptionValues" id="noOfOptions"/>
					<logic:iterate name="attributeValue" property="attribute.listOptionValues" id="optionValue" indexId="optionIndex">
						<c:choose>
							<c:when test="${optionValue.additionalValue != null && optionValue.additionalValue != ''}">
							    <c:if test="${searchTokens}"><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='optionValue' property='additionalValue' encodeForUrl="true"/>"></c:if>
									<bean:write name="optionValue" property="additionalValue" />
								<c:if test="${searchTokens}"></a></c:if>
							</c:when>
							<c:otherwise>
							    <c:if test="${searchTokens}"><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='optionValue' property='value' encodeForUrl="true"/>"></c:if>
								  <bean:write name="optionValue" property="value" filter="false"/>
								<c:if test="${searchTokens}"></a></c:if>
							</c:otherwise>
						</c:choose><c:if test="${(optionIndex+1) lt noOfOptions}">, </c:if>
					</logic:iterate>
				</c:when>
				<c:when test="${attributeValue.attribute.isKeywordPicker}">
					<logic:empty name="attributeValue" property="keywordCategories">
						none&nbsp;
					</logic:empty>
					<logic:notEmpty name="attributeValue" property="keywordCategories">
						<c:set var="displayKeywordsByRootAncestor" value="false"/>
						<c:forTokens items="${displayKeywordsByRootAncestorIds}" delims=", " var="id">
							<c:if test="${not empty id && id==attributeValue.attribute.treeId}">
								<c:set var="displayKeywordsByRootAncestor" value="true"/>
							</c:if>
						</c:forTokens>
						<c:if test="${!displayKeywordsByRootAncestor}">
							<bean:size name="attributeValue" property="keywordCategories" id="noOfCategories"/>
							<%-- This is all on one line to prevent whitespace in the display --%>
							<logic:iterate name="attributeValue" property="keywordCategories" id="category" indexId="index"><logic:notEmpty name="category" property="ancestors"><logic:iterate name="category" property="ancestors" id="ancestor"><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='ancestor' property='name' encodeForUrl="true"/>"><bean:write name="ancestor" property="name" filter="false"/></a><c:out value="${keywordAncestorDelimiter}"/></logic:iterate></logic:notEmpty><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='category' property='name' encodeForUrl="true"/>"><bean:write name="category" property="name" filter="false"/></a><c:if test="${(index+1) < noOfCategories}"><c:out value="${keywordDelimiter}"/> </c:if></logic:iterate>&nbsp;
						</c:if>
						<c:if test="${displayKeywordsByRootAncestor}">
							<logic:iterate name="attributeValue" property="keywordMap" id="entry" indexId="parentIndex">
								<c:if test="${parentIndex>0}"><br/></c:if>
								<bean:write name="entry" property="key.name"/>:
								<bean:size name="entry" property="value" id="noOfChildren"/>
								<logic:iterate name="entry" property="value" id="cat" indexId="childIndex">
									<logic:notEmpty name="cat" property="ancestors"><logic:iterate name="cat" property="ancestors" id="ancestor" offset="1"><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='ancestor' property='name' encodeForUrl="true"/>"><bean:write name="ancestor" property="name" filter="false"/></a><c:out value="${keywordAncestorDelimiter}"/></logic:iterate></logic:notEmpty><a href="../action/search?attribute_<bean:write name='attributeValue' property='attribute.id'/>=<bright:write name='cat' property='name' encodeForUrl="true"/>"><bean:write name="cat" property="name" filter="false"/></a><c:if test="${(childIndex+1) < noOfChildren}"><c:out value="${keywordDelimiter}"/></c:if>
								</logic:iterate>
							</logic:iterate>
						</c:if>
					</logic:notEmpty>
				</c:when>
				
				<%-- Hyperlink --%>
				<c:when test="${attributeValue.attribute.isHyperlink}">
					<%-- Display alternative url if no values specified --%>
					<c:if test="${isEmpty && not empty attributeValue.attribute.defaultValue}">
						<a href="<bean:write name="attributeValue" property="attribute.defaultValue" filter="false"/>" TITLE="<bean:write name="attributeValue" property="attribute.altText" filter="false"/>" target="_blank"><bean:write name="attributeValue" property="attribute.displayName" filter="false"/></a><br/>
					</c:if>
					
					<%-- Iterate over all the generated URLs --%>
					<c:if test="${!isEmpty}">
						<c:set var="nameValuePairs" value="${attributeValue.nameValuePairs}"/>
						<logic:iterate name="nameValuePairs" id="pair" indexId="optionIndex">
							<c:if test="${not empty pair.value || not empty pair.name}">
								<c:set var="linkUrl"><bean:write name="attributeValue" property="attribute.baseUrl" filter="false"/><c:if test="${attributeValue.attribute.baseUrl == ''}"><bright:write name="pair" property="value"/></c:if><c:if test="${attributeValue.attribute.baseUrl != ''}"><bright:write name="pair" property="value" encodeForUrl="true"/></c:if></c:set>
								<c:choose>
									<c:when test="${empty attributeValue.attribute.tokenDelimiterRegex}">
										<c:if test="${not empty pair.value}"><a href="<bean:write name="linkUrl"/>" TITLE="<bean:write name="attributeValue" property="attribute.altText" filter="false"/>" target="_blank"></c:if><c:if test="${empty pair.name}"><c:if test="${not empty attributeValue.attribute.displayName}"><bean:write name="attributeValue" property="attribute.displayName" filter="false"/>: </c:if><bean:write name="pair" property="value"/></c:if><c:if test="${not empty pair.name}"><c:if test="${not empty pair.value}"><bean:write name="pair" property="value" filter="false"/> - </c:if><bean:write name="pair" property="name" filter="false"/></c:if><c:if test="${not empty pair.value}"></a></c:if>
										<c:if test="${searchTokens && not empty pair.value}">
											| <a href="../action/search?attribute_<c:out value="${attributeValue.attribute.id}"/>=%22<bright:write name="pair" property="value" encodeForUrl="true"/>%22"><bright:cmsWrite identifier="link-more-like-this" filter="false"/></a>
										</c:if>
									</c:when>
									<c:otherwise>
										<c:if test="${not empty pair.value}">
											<a href="../action/search?attribute_<c:out value="${attributeValue.attribute.id}"/>=%22<bright:write name="pair" property="value" encodeForUrl="true"/>%22"><bean:write name="pair" property="value" filter="false"/></a>
											<c:if test="${not empty pair.name}">-</c:if>
										</c:if>              
										<bean:write name="pair" property="name"/>
										<c:if test="${not empty pair.value}">
											&nbsp;[<a href="<bean:write name="linkUrl"/>" TITLE="<bean:write name="attributeValue" property="attribute.altText" filter="false"/>" target="_blank"><bright:cmsWrite identifier="link-follow-link" filter="false"/></a>]
										</c:if>
									</c:otherwise>
								</c:choose>
								<br/>
							</c:if>
						</logic:iterate>
					</c:if>
				</c:when>
				
				<%-- Attribute File --%>
				<c:when test="${attributeValue.attribute.isFile}">
					
					<a href="downloadAttributeFile?assetId=<bean:write name="assetForm" property="asset.id" filter="false"/>&attributeId=<bean:write name="attributeValue" property="attribute.id" filter="false"/>" 
					   title="<bean:write name="attributeValue" property="attribute.altText" filter="false"/>" target="_blank"><bean:write name="attributeValue" property="filename" filter="false"/></a><br/>

				</c:when>
				
				<%-- Date Picker --%>
				<c:when test="${attributeValue.attribute.isDatepicker}">
					<c:choose>
						<c:when test="${attributeValue.attribute.dateFormatTypeId==1}">
							<fmt:formatDate value="${attributeValue.dateValue.date}" pattern="${dateFormatYearAndMonth}" />
						</c:when>
						<c:when test="${attributeValue.attribute.dateFormatTypeId==2}">
							<fmt:formatDate value="${attributeValue.dateValue.date}" pattern="${dateFormatYearOnly}" />
						</c:when>
						<c:otherwise>
							<fmt:formatDate value="${attributeValue.dateValue.date}" pattern="${dateFormat}" />
						</c:otherwise>
					</c:choose>
				</c:when>
				
				<%--  Spatial area --%>
				<c:when test="${attributeValue.attribute.isSpatialArea}">
					<%--  See if we can unpack the value into the four fields, regardless of validity of each field. --%>
					<c:choose>
						<c:when test="${!attributeValue.canUnpackSpatialAreaValue}">
							<c:set var="oldBadValue" value="${attributeValue.value}" />
							<bright:cmsWrite identifier="snippet-failed-to-unpack-spatial-area" replaceVariables="true" />
						</c:when>
						<c:otherwise>
							<c:if test="${!empty attributeValue.value}">
							<%--  See if we have a fully valid spatial area, else just display the parts --%>
							<c:choose>
								<c:when test="${!attributeValue.isValidSpatialAreaValue}">
									<c:set var="parts" value="${attributeValue.unpackedSpatialAreaParts}" />
									<bright:cmsWrite identifier="snippet-invalid-spatial-area"/><br/>
									<bright:cmsWrite identifier="label-spatial-area-west"/>:
									<span class="wLng"><c:out value="${parts[0]}" /></span>
									<br/>
									<bright:cmsWrite identifier="label-spatial-area-south"/>:
									<span class="sLat"><c:out value="${parts[1]}" /></span>
									<br/>
									<bright:cmsWrite identifier="label-spatial-area-east"/>:
									<span class="eLng"><c:out value="${parts[2]}" /></span>
									<br/>
									<bright:cmsWrite identifier="label-spatial-area-north"/>:
									<span class="nLat"><c:out value="${parts[3]}" /></span>
								</c:when>
								<c:otherwise>
								
									<%--  Valid spatial area --%>
									<c:set var="area" value="${attributeValue.validSpatialArea}" />
									
									<%--  Show 4 area bounds or single point --%>
									<c:choose>
										<c:when test="${area.isSinglePoint}">
										
											<%--  Get point from area --%>
											<c:set var="point" value="${area.southWestCoordinate}" />
											<div class="floatLeft">
												<bright:cmsWrite identifier="label-latitude"/>:
												<span class="sLat"><c:out value="${point.latitudeAsString}" /></span>
												<br/>					
												<bright:cmsWrite identifier="label-longitude"/>:
												<span class="wLng"><c:out value="${point.longitudeAsString}" /></span>
											</div>
											<div class="mapPopupWrap">
												<a href="viewSpatialSearchMap?view=true&amp;attributeId=<c:out value='${attributeValue.attribute.id}' />" target="_blank" class="mapPopup" ><bright:cmsWrite identifier="link-view-on-map" filter="false"/></a>
												<span> &nbsp;| 
												<a href="<c:out value='search?advancedSearch=1&amp;choose_search_area_${attributeValue.attribute.id}=searchPoint&amp;attribute_${attributeValue.attribute.id}_lat=${point.latitudeAsString}&amp;attribute_${attributeValue.attribute.id}_long=${point.longitudeAsString}&amp;attribute_${attributeValue.attribute.id}_radius=${nearbyDistance}' escapeXml='false' />"><bright:cmsWrite identifier="link-find-nearby-items" filter="false"/></a></span>
											</div>	 
										</c:when>
										<c:otherwise>
											<div class="floatLeft">
												<bright:cmsWrite identifier="label-spatial-area-west"/>:
												<span class="wLng"><c:out value="${area.westBoundAsString}" /></span>
												<br/>
												<bright:cmsWrite identifier="label-spatial-area-south"/>:
												<span class="sLat"><c:out value="${area.southBoundAsString}" /></span>
												<br/>
												<bright:cmsWrite identifier="label-spatial-area-east"/>:
												<span class="eLng"><c:out value="${area.eastBoundAsString}" /></span>
												<br/>
												<bright:cmsWrite identifier="label-spatial-area-north"/>:
												<span class="nLat"><c:out value="${area.northBoundAsString}" /></span>
											</div>
											<div class="mapPopupWrap">
												<a href="viewSpatialSearchMap?view=true&amp;attributeId=<c:out value='${attributeValue.attribute.id}' />" target="_blank" class="mapPopup" ><bright:cmsWrite identifier="link-view-on-map" filter="false"/></a>
												<span> &nbsp;| 
												<a href="<c:out value='search?advancedSearch=1&amp;choose_search_area_${attributeValue.attribute.id}=searchPoint&amp;attribute_${attributeValue.attribute.id}_lat=${area.southBoundAsString}&amp;attribute_${attributeValue.attribute.id}_long=${area.westBoundAsString}&amp;attribute_${attributeValue.attribute.id}_radius=${nearbyDistance}' escapeXml='false' />"><bright:cmsWrite identifier="link-find-nearby-items" filter="false"/></a></span>
											</div>	 
										</c:otherwise>
									</c:choose>
																	
								</c:otherwise>
							</c:choose>	

							</c:if>	
						</c:otherwise>
					</c:choose>
					
				</c:when>
				
				<c:otherwise>
					<c:choose>
						<c:when test="${attributeValue.additionalValue != null && attributeValue.additionalValue != ''}">
							<bean:write name="attributeValue" property="additionalValue" filter="false"/>
						</c:when>
						<c:otherwise>
							<c:if test="${not searchTokens}">
								<bean:write name="attributeValue" property="value" filter="false"/>
							</c:if>
							<c:if test="${searchTokens}">
								<bean:define id="attributeId" name="attributeValue" property="attribute.id"/>
								<c:if test="${attributeValue.attribute.isDropdownList || attributeValue.attribute.isDatepicker}">
									<c:set var="tokenWrapper" value=" <a href='search?attribute_${attributeId}=[enc-token]'>[token]</a>"/>
								</c:if>
								<c:if test="${!attributeValue.attribute.isDropdownList && !attributeValue.attribute.isDatepicker}">
									<c:set var="tokenWrapper" value=" <a href='search?attribute_${attributeId}=[enc-token]'>[token]</a>"/>
								</c:if>
								<bean:define id="tokenWrapper" name="tokenWrapper"/>								
								<c:if test="${not empty attributeValue.attribute.tokenDelimiterRegex}">
									<bean:define id="delimiter" name="attributeValue" property="attribute.tokenDelimiterRegex"/>
									<bright:write name="attributeValue" property="value" filter="false" tokenDelimiter="<%= delimiter %>" outputTokenWrapper="<%= tokenWrapper %>"/>
								</c:if>
								<c:if test="${empty attributeValue.attribute.tokenDelimiterRegex}">
									<bright:write name="attributeValue" property="value" filter="false" outputTokenWrapper="<%= tokenWrapper %>"/>
								</c:if>
							</c:if>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
			
			<c:if test="${empty attributeValue.value}">
				<c:if test="${showEmptyValueText}">
					<span class="disabled"><bright:cmsWrite identifier="snippet-no-value" filter="false"/></span>
				</c:if>
				<c:if test="${not showEmptyValueText}">
					&nbsp;
				</c:if>
			</c:if>
			
			
		</td>
	</tr>
</c:if>