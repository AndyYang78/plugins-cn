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
		<div class="interview-introduction"><liferay-ui:message key="interview-introduction" /></div>

		<noscript>
			<liferay-ui:message key="please-enable-javascript-to-start-the-interview" /><br />
		</noscript>

		<c:if test="<%= timeLimit > 0 %>">
			<div class="time-limit-warning portlet-msg-info"></div>

			<aui:script use="aui">
				var timeLimitWarning = A.one(".time-limit-warning");

				timeLimitWarning.set("innerHTML", "<liferay-ui:message arguments="<%= timeLimit %>" key="once-you-start-the-interview-you-will-have-x-minutes-to-complete-the-questions" />");
			</aui:script>
		</c:if>

		<portlet:renderURL var="startInterviewURL">
			<portlet:param name="mvcPath" value="/display/view_questions.jsp" />
			<portlet:param name="uuid" value="<%= uuid %>" />
		</portlet:renderURL>

		<aui:button-row/>

		<aui:script use="aui-button-item">
			var buttonRow = A.one(".interview-display-portlet .aui-button-holder");

			var button = new A.ButtonItem(
				{
					label: Liferay.Language.get("start"),
					handler: function(event) {
						location.href = "<%= startInterviewURL.toString() %>";
					}
				}
			).render(buttonRow);
		</aui:script>
	</c:otherwise>
</c:choose>