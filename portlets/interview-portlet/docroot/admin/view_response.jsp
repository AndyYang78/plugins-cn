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

				<button onclick="return <portlet:namespace />replay('<%= question.getQuestionId() %>')">Replay</button>
			</c:when>
		</c:choose>
	</aui:field-wrapper>

<%
}
%>

<aui:script>
	var dmp = new diff_match_patch();

	var responseJSON = <%= interview.getResponse() %>;

	Alloy.on('domready', function (event) {
		var keys = Object.keys(responseJSON);

		for (var i = 0; i < keys.length; i++) {
			var key = keys[i];

			var inputElement = document.getElementById("<portlet:namespace />response" + key);

			inputElement.value = responseJSON[key];
		}
	});

	function <portlet:namespace />getRecorded(questionId) {
		var recorder = eval('(' + responseJSON[questionId] + ')');

		return recorder;
	}

	function <portlet:namespace />replay(questionId) {
		var recordedResponse = document.getElementById("<portlet:namespace />response" + questionId);

		recordedResponse.value = "";

		var recorder = <portlet:namespace />getRecorded(questionId);

		<portlet:namespace />replayEvent(0, questionId, recorder);
	}

	function <portlet:namespace />replayEvent(i, questionId, recorder) {
		var recordedResponse = document.getElementById("<portlet:namespace />response" + questionId);

		var result = dmp.patch_apply(recorder[i].patch, recordedResponse.value);

		recordedResponse.value = result[0];

		if (i < (recorder.length - 1)) {
			setTimeout(<portlet:namespace />recorderReplay(i+1, questionId, recorder), (recorder[i+1].timestamp - recorder[i].timestamp));
		}
	}

	function <portlet:namespace />recorderReplay(i, questionId, recorder) {
		return function() {
			<portlet:namespace />replayEvent(i, questionId, recorder);
		}
	}
</aui:script>