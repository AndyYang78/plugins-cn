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
				<textarea id="<portlet:namespace />response<%= question.getQuestionId() %>" readonly="readonly"></textarea><br />
				<div class="playControl">
					<button class="rewindButton" onclick="return <portlet:namespace />rewind('<%= question.getQuestionId() %>')" title="<liferay-ui:message key="rewind" />"></button>
					<button class="pauseButton" onclick="return <portlet:namespace />play('<%= question.getQuestionId() %>', 0)" title="<liferay-ui:message key="pause" />"></button>
					<button class="playNormalButton" onclick="return <portlet:namespace />play('<%= question.getQuestionId() %>', 1)" title="<liferay-ui:message key="x1" />"></button>
					<button class="playTwoSpeedButton"onclick="return <portlet:namespace />play('<%= question.getQuestionId() %>', 2)" title="<liferay-ui:message key="x2" />"></button>
					<button class="playFourSpeedButton"onclick="return <portlet:namespace />play('<%= question.getQuestionId() %>', 4)" title="<liferay-ui:message key="x4" />"></button>
					<button class="playStepButton"onclick="return <portlet:namespace />playStepper('<%= question.getQuestionId() %>')" title="<liferay-ui:message key="play-step" />"></button>
				</div>
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
					"patches" : responseJSON[questionId],
					"playBackStep" : 0,
					"timeoutId" : 0
				}

				<portlet:namespace />recorders.push(recorder);

				<portlet:namespace />getFinalResponse(recorder);
			}
			else {
				inputElement.value = responseJSON[questionId];
			}
		}
	});

	function <portlet:namespace />clearResponseTextarea(questionId) {
		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		responseTextarea.value = "";
	}

	function <portlet:namespace />clearTimeout(recorder) {
		clearTimeout(recorder.timeoutId);

		recorder.timeoutid = "";
	}

	function <portlet:namespace />getFinalResponse(recorder) {
		<portlet:namespace />clearResponseTextarea(recorder.questionId);
	}

	function <portlet:namespace />getRecorder(questionId) {
		for (var i = 0; i < <portlet:namespace />recorders.length; i++) {
			var recorder = <portlet:namespace />recorders[i];

			if (recorder.questionId == questionId) {
				return recorder;
			}
		}

		return null;
	}

	function <portlet:namespace />play(questionId, speed) {
		var recorder = <portlet:namespace />getRecorder(questionId);

		if (speed == 0) {
			<portlet:namespace />clearTimeout(recorder);
		}
		else if (recorder.playBackStep == 0) {
			<portlet:namespace />clearResponseTextarea(questionId);

			<portlet:namespace />playEvent(questionId, speed, 0);
		}
		else {
			<portlet:namespace />clearTimeout(recorder);

			<portlet:namespace />playEvent(questionId, speed, (recorder.playBackStep + 1));
		}
	}

	function <portlet:namespace />playEvent(questionId, speed, i) {
		var recorder = <portlet:namespace />getRecorder(questionId);

		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		var patches = recorder.patches;

		var result = <portlet:namespace />dmp.patch_apply(patches[i].patch, responseTextarea.value);

		responseTextarea.value = result[0];

		recorder.playBackStep = i;

		if (i < (patches.length - 1)) {
			var timeoutId = setTimeout("<portlet:namespace />playEvent(" + questionId +", " + speed + ", " + (i+1) +")", ((patches[i+1].timestamp - patches[i].timestamp) / speed));

			recorder.timeoutId = timeoutId;
		}
		else {
			<portlet:namespace />clearTimeout(recorder);

			recorder.playBackStep = 0;
		}
	}

	function <portlet:namespace />rewind(questionId) {
		var recorder = <portlet:namespace />getRecorder(questionId);

		<portlet:namespace />clearTimeout(recorder);

		<portlet:namespace />clearResponseTextarea(questionId);

		recorder.playBackStep = 0;
	}

	function <portlet:namespace />playStepper(questionId) {
		var recorder = <portlet:namespace />getRecorder(questionId);

		var responseTextarea = document.getElementById("<portlet:namespace />response" + questionId);

		var patches = recorder.patches;

		if(recorder.playBackStep == 0) {
			<portlet:namespace />clearResponseTextarea(questionId);
		}
		else if(recorder.playBackStep < recorder.patches.length - 1) {
			<portlet:namespace />clearTimeout(recorder);

			var result = <portlet:namespace />dmp.patch_apply(patches[recorder.playBackStep + 1].patch, responseTextarea.value);

			responseTextarea.value = result[0];

			recorder.playBackStep++;
		}
		else {
			<portlet:namespace />clearResponseTextarea(questionId);

			recorder.playBackStep = 0;
		}

	}
</aui:script>