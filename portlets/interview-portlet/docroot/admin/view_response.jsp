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

long interviewId = ParamUtil.getLong(request, "interviewId");

Interview interview = InterviewLocalServiceUtil.getInterview(interviewId);

QuestionSet questionSet = QuestionSetLocalServiceUtil.getQuestionSet(interview.getQuestionSetId());

List<Question> questions= QuestionLocalServiceUtil.getQuestionSetQuestions(interview.getQuestionSetId());
%>

<liferay-ui:header
	backURL="<%= backURL %>"
	title="<%= interview.getName() %>"
/>

<%
for (Question question : questions) {
%>

	<aui:field-wrapper label="<%= HtmlUtil.escape(question.getTitle()) %>">
		<div class="description"><%= HtmlUtil.escape(question.getDescription()) %></div>

		<c:choose>
			<c:when test="<%= question.getType() == QuestionTypeConstants.ONE_LINE %>">
				<input id="<portlet:namespace />response<%= question.getQuestionId() %>" type="input" readonly="readonly" />
			</c:when>
			<c:when test="<%= question.getType() == QuestionTypeConstants.MULTIPLE_LINES %>">
				<textarea id="<portlet:namespace />response<%= question.getQuestionId() %>" readonly="readonly"></textarea>
			</c:when>
			<c:when test="<%= question.getType() == QuestionTypeConstants.RECORDED %>">
				<textarea id="<portlet:namespace />response<%= question.getQuestionId() %>" readonly="readonly"></textarea>

				<button onclick="return <portlet:namespace />replay('<%= question.getQuestionId() %>')"><liferay-ui:message key="replay" /></button>
			</c:when>
		</c:choose>
	</aui:field-wrapper>

<%
}
%>

<aui:script>
	var <portlet:namespace />dmp = new diff_match_patch();

	var <portlet:namespace />recorders = new Array();

	Alloy.on('domready', function (event) {
		var responseJSON = <%= interview.getResponse() %>;

		var keys = Object.keys(responseJSON);

		for (var i = 0; i < keys.length; i++) {
			var questionId = keys[i];

			var inputElement = document.getElementById("<portlet:namespace />response" + questionId);

			if ((typeof responseJSON[questionId]) == "object") {
				var recorder = {
					"questionId" : questionId,
					"patches" : responseJSON[questionId]
				}

				<portlet:namespace />recorders.push(recorder);

				inputElement.value = <portlet:namespace />getFinalResponse(recorder);
 			}
 			else {
 				inputElement.value = responseJSON[questionId];
 			}
 		}
	});

	function <portlet:namespace />getFinalResponse(recorder) {
		return "";
	}

	function <portlet:namespace />getPatches(questionId) {
		for (var i = 0; i < <portlet:namespace />recorders.length; i++) {
			var recorder = <portlet:namespace />recorders[i];

			if (recorder.questionId == questionId) {
				return recorder.patches;
			}
		}

		return null;
	}

	function <portlet:namespace />replay(questionId) {
		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		responseTextarea.value = "";

		<portlet:namespace />replayEvent(questionId, 0);
	}

	function <portlet:namespace />replayEvent(questionId, i) {
		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		var patches = <portlet:namespace />getPatches(questionId);

		var result = <portlet:namespace />dmp.patch_apply(patches[i].patch, responseTextarea.value);

		responseTextarea.value = result[0];

		if (i < (patches.length - 1)) {
			setTimeout("<portlet:namespace />replayEvent(" + questionId +", " + (i+1) +")", (patches[i+1].timestamp - patches[i].timestamp));
		}
	}
</aui:script>