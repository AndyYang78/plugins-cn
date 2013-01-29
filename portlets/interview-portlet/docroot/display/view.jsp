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

<%@ include file="/display/init.jsp" %>

<%
String uuid = PortalUtil.getOriginalServletRequest(request).getParameter("uuid");

if (Validator.isNull(uuid)) {
	uuid = ParamUtil.getString(request, "uuid");
}

Interview interview = null;
Date startDate = null;
Date expireDate = null;
String interviewResponse = null;
QuestionSet questionSet = null;
int timeLimit = 0;

try {
	interview = InterviewLocalServiceUtil.getInterview(uuid);

	startDate = interview.getStartDate();
	expireDate = interview.getExpireDate();
	interviewResponse = interview.getResponse();

	questionSet = QuestionSetLocalServiceUtil.getQuestionSet(interview.getQuestionSetId());

	timeLimit = questionSet.getTimeLimit();
}
catch (Exception e) {
}
%>

<c:choose>
	<c:when test="<%= interview == null %>">
		<liferay-ui:message key="no-interview-selected" />
	</c:when>
	<c:when test="<%= Validator.isNotNull(interviewResponse) %>">
		<liferay-ui:message key="you-have-already-submitted-your-interview" />
	</c:when>
	<c:when test="<%= (interview != null) && InterviewUtil.isExpired(startDate, timeLimit, expireDate) %>">
		<liferay-ui:message key="interview-has-expired" />
	</c:when>
	<c:otherwise>
		<noscript>
			<liferay-ui:message key="your-browser-doesn't-support-the-Javascript" /><br />
		</noscript>
		<liferay-ui:message arguments="<%= timeLimit %>" key="time-limit-x-minutes" />

		<portlet:renderURL var="updateStartDateURL">
			<portlet:param name="mvcPath" value="/display/view_questions.jsp" />
			<portlet:param name="uuid" value="<%= uuid %>" />
		</portlet:renderURL>

		<aui:button-row>
			<aui:button onClick="<%= updateStartDateURL %>" value="start" />
		</aui:button-row>
	</c:otherwise>
</c:choose>