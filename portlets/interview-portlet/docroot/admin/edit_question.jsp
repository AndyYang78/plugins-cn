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

long questionId = ParamUtil.getLong(request, "questionId");
long questionSetId = ParamUtil.getLong(request, "questionSetId");

Question question = null;

try {
	question = QuestionLocalServiceUtil.getQuestion(questionId);

	questionSetId = question.getQuestionSetId();
}
catch (NoSuchQuestionException nsqe) {
}
%>

<liferay-ui:header
	backURL="<%= backURL %>"
	title='<%= (question ==null) ? "new-question" : question.getTitle() %>'
/>

<portlet:actionURL name="updateQuestion" var="updateQuestionURL" />

<aui:form action="<%= updateQuestionURL %>" method="post" name="fm">
	<aui:model-context bean="<%= question %>" model="<%= Question.class %>" />

	<aui:input name="backURL" type="hidden" value="<%= backURL %>" />
	<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
	<aui:input name="questionId" type="hidden" />
	<aui:input name="questionSetId" type="hidden" value="<%= String.valueOf(questionSetId) %>" />

	<liferay-ui:error exception="<%= QuestionTitleException.class %>" message="please-enter-a-valid-title" />

	<aui:fieldset>
		<aui:input name="title">
			<aui:validator name="required" />
		</aui:input>

		<aui:input cssClass="lfr-textarea-container" name="description" type="textarea" />

		<aui:select label="question-type" name="type">
			<aui:option label="one-line" selected="<%= (question != null) && (question.getType() == QuestionTypeConstants.ONE_LINE) %>" value="<%= QuestionTypeConstants.ONE_LINE %>" />
			<aui:option label="multiple-lines" selected="<%= (question != null) && (question.getType() == QuestionTypeConstants.MULTIPLE_LINES) %>" value="<%= QuestionTypeConstants.MULTIPLE_LINES %>" />
			<aui:option label="recorded" selected="<%= (question != null) && (question.getType() == QuestionTypeConstants.RECORDED) %>" value="<%= QuestionTypeConstants.RECORDED %>" />
		</aui:select>
	</aui:fieldset>

	<aui:button-row>
		<aui:button type="submit" />

		<aui:button href="<%= redirect %>" type="cancel" />
	</aui:button-row>
</aui:form>