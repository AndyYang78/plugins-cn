<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/admin/init.jsp" %>

<%
ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);

Interview interview = (Interview)row.getObject();
%>

<liferay-ui:icon-menu>
	<portlet:renderURL var="editURL">
		<portlet:param name="interviewId" value="<%= String.valueOf(interview.getInterviewId()) %>" />
		<portlet:param name="mvcPath" value="/admin/edit_interview.jsp" />
		<portlet:param name="redirect" value="<%= currentURL %>" />
	</portlet:renderURL>

	<liferay-ui:icon
		image="edit"
		url="<%= editURL %>"
	/>

	<portlet:actionURL name="deleteInterview" var="deleteURL">
		<portlet:param name="interviewId" value="<%= String.valueOf(interview.getInterviewId()) %>" />
		<portlet:param name="redirect" value="<%= currentURL %>" />
	</portlet:actionURL>

	<liferay-ui:icon-delete
		url="<%= deleteURL %>"
	/>

	<c:if test="<%= Validator.isNotNull(interview.getResponse()) %>">
		<portlet:renderURL var="viewResponseURL">
			<portlet:param name="interviewId" value="<%= String.valueOf(interview.getInterviewId()) %>" />
			<portlet:param name="mvcPath" value="/admin/view_response.jsp" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
		</portlet:renderURL>

		<liferay-ui:icon
			image="view"
			message="view-response"
			url='<%= viewResponseURL %>'
		/>
	</c:if>
</liferay-ui:icon-menu>