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
String backURL = ParamUtil.getString(request, "backURL");
String redirect = ParamUtil.getString(request, "redirect");

long interviewId = ParamUtil.getLong(request, "interviewId");

Calendar expiredDate = CalendarFactoryUtil.getCalendar();

if (interviewId <= 0) {
	expiredDate.add(Calendar.DATE, defaultInterviewValidPeriod);
}

Interview interview = null;

try {
	interview = InterviewLocalServiceUtil.getInterview(interviewId);

	expiredDate.setTime(interview.getExpireDate());
}
catch (NoSuchInterviewException nsie) {
}
%>

<liferay-ui:header
	backURL="<%= backURL %>"
	title='<%= (interview == null) ? "new-interview" : interview.getName() %>'
/>

<portlet:actionURL name="updateInterview" var="updateInterviewURL" />

<aui:form action="<%= updateInterviewURL %>" method="post" name="fm">
	<aui:model-context bean="<%= interview %>" model="<%= Interview.class %>" />

	<aui:input name="currentURL" type="hidden" value="<%= currentURL %>" />
	<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
	<aui:input name="interviewId" type="hidden" />

	<liferay-ui:error exception="<%= InterviewEmailAddressException.class %>" message="please-enter-a-valid-email-address" />
	<liferay-ui:error exception="<%= InterviewNameException.class %>" message="please-enter-a-valid-name" />

	<c:if test="<%= interview != null %>">
		<aui:field-wrapper label="uuid">
			<c:choose>
				<c:when test="<%= Validator.isNotNull(displayPortletPageURL) %>">
					<aui:a href='<%= displayPortletPageURL + "?uuid=" + interview.getUuid() %>' target="_blank"><%= interview.getUuid() %></aui:a>
				</c:when>
				<c:otherwise>
					<%= interview.getUuid() %>
				</c:otherwise>
			</c:choose>
		</aui:field-wrapper>
	</c:if>

	<aui:fieldset>
		<aui:input name="name">
			<aui:validator name="required" />
		</aui:input>

		<aui:input name="emailAddress">
			<aui:validator name="required" />
		</aui:input>

		<aui:input name="expireDate" value="<%= expiredDate %>" />

		<aui:select label="question-set" name="questionSetId">

			<%
			List<QuestionSet> questionSets = QuestionSetLocalServiceUtil.getQuestionSets(QueryUtil.ALL_POS, QueryUtil.ALL_POS);

			for (QuestionSet questionSet : questionSets) {
			%>

				<aui:option label="<%= questionSet.getTitle() %>" selected="<%= (interview != null) && (interview.getQuestionSetId() == questionSet.getQuestionSetId()) %>" value="<%= questionSet.getQuestionSetId() %>" />

			<%
			}
			%>

		</aui:select>
	</aui:fieldset>

	<aui:button-row>
		<aui:button type="submit" />

		<aui:button href="<%= redirect %>" type="cancel" />
	</aui:button-row>
</aui:form>