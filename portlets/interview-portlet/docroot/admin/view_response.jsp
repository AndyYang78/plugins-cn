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

				<button id="<portlet:namespace />normalSpeedButton" onclick="return <portlet:namespace />replay(this, '<%= question.getQuestionId() %>')"><liferay-ui:message key="replay" /></button>

				<button id="<portlet:namespace />twoSpeedButton" onclick="return <portlet:namespace />replay(this, '<%= question.getQuestionId() %>')"><liferay-ui:message key="replayX2" /></button>

				<button id="<portlet:namespace />fourSpeedButton" onclick="return <portlet:namespace />replay(this, '<%= question.getQuestionId() %>')"><liferay-ui:message key="replayX4" /></button>

				<button id="<portlet:namespace />pauseButton" onclick="return <portlet:namespace />pause('<%= question.getQuestionId() %>')"><liferay-ui:message key="pause" /></button>

				<button id="<portlet:namespace />stopButton" onclick="return <portlet:namespace />stop('<%= question.getQuestionId() %>')"><liferay-ui:message key="stop" /></button>
			</c:when>
		</c:choose>
	</aui:field-wrapper>

<%
}
%>

<aui:script>
	var <portlet:namespace />dmp = new diff_match_patch();

	var <portlet:namespace />recorders = new Array();

	var <portlet:namespace />clickedButtonName;

	var <portlet:namespace />pauseClickedTimes = 1;

	var <portlet:namespace />replayAgainId = 0;

	var <portlet:namespace />timeoutId;

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

	function <portlet:namespace />replay(currentButton, questionId) {
		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		responseTextarea.value = "";

		<portlet:namespace />clickedButtonName = currentButton.id;

		<portlet:namespace />replayEvent(questionId, 0);
	}

	function <portlet:namespace />replayEvent(questionId, i) {
		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		var patches = <portlet:namespace />getPatches(questionId);

		var result = <portlet:namespace />dmp.patch_apply(patches[i].patch, responseTextarea.value);

		responseTextarea.value = result[0];

		if (i < (patches.length - 1)) {
			if (<portlet:namespace />clickedButtonName == "<portlet:namespace />normalSpeedButton") {
				<portlet:namespace />timeoutId = setTimeout("<portlet:namespace />replayEvent(" + questionId +", " + (i+1) +")", (patches[i+1].timestamp - patches[i].timestamp));

				<portlet:namespace />replayAgainId = i + 1;
			}
			else if (<portlet:namespace />clickedButtonName == "<portlet:namespace />twoSpeedButton") {
				<portlet:namespace />timeoutId = setTimeout("<portlet:namespace />replayEvent(" + questionId +", " + (i+1) +")", (patches[i+1].timestamp - patches[i].timestamp) / 2);

				<portlet:namespace />replayAgainId = i + 1;
			}
			else if (<portlet:namespace />clickedButtonName == "<portlet:namespace />fourSpeedButton") {
				<portlet:namespace />timeoutId = setTimeout("<portlet:namespace />replayEvent(" + questionId +", " + (i+1) +")", (patches[i+1].timestamp - patches[i].timestamp) / 4);

				<portlet:namespace />replayAgainId = i + 1;
			}
		}

	}

	function <portlet:namespace />pause(questionId) {
		if (<portlet:namespace />pauseClickedTimes % 2 != 0) {
			clearTimeout(<portlet:namespace />timeoutId);
		}
		else {
			<portlet:namespace />replayEvent(questionId, <portlet:namespace />replayAgainId);
		}

		<portlet:namespace />pauseClickedTimes++;
	}

	function <portlet:namespace />stop(questionId) {
			var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

			responseTextarea.value = "";

			<portlet:namespace />replayEvent(questionId, 0);
	}
</aui:script>