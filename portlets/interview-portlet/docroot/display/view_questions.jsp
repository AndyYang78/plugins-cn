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
String uuid = ParamUtil.getString(request, "uuid");

try{
	InterviewLocalServiceUtil.updateStartDate(uuid, new Date());
}
catch (CannotEditStartDateException e){
}

Interview interview = InterviewLocalServiceUtil.getInterview(uuid);

List<Question> questions = QuestionLocalServiceUtil.getQuestionSetQuestions(interview.getQuestionSetId());
%>

<portlet:actionURL name="updateInterview" var="updateInterviewURL" />

<aui:form action="<%= updateInterviewURL %>" method="post" name="fm">
	<aui:input name="uuid" value="<%= interview.getUuid() %>" type="hidden" />

	<%
	for (Question question : questions) {
	%>

		<aui:field-wrapper label="<%= HtmlUtil.escape(question.getTitle()) %>">
			<div class="description"><%= HtmlUtil.escape(question.getDescription()) %></div>

			<c:choose>
				<c:when test="<%= question.getType() == QuestionTypeConstants.ONE_LINE %>">
					<input id="<portlet:namespace />response<%= question.getQuestionId() %>" name="<portlet:namespace />response<%= question.getQuestionId() %>" type="input" />
				</c:when>
				<c:when test="<%= question.getType() == QuestionTypeConstants.MULTIPLE_LINES %>">
					<textarea id="<portlet:namespace />response<%= question.getQuestionId() %>" name="<portlet:namespace />response<%= question.getQuestionId() %>"></textarea>
				</c:when>
				<c:when test="<%= question.getType() == QuestionTypeConstants.RECORDED %>">
					<input id="<portlet:namespace />response<%= question.getQuestionId() %>" name="<portlet:namespace />recorder<%= question.getQuestionId() %>" type="hidden" />

					<textarea id="<portlet:namespace />recordedResponse<%= question.getQuestionId() %>" name="<portlet:namespace />response<%= question.getQuestionId() %>" onkeyup="return <portlet:namespace />record(event, '<%= question.getQuestionId() %>');"></textarea>
				</c:when>
			</c:choose>
		</aui:field-wrapper>

	<%
	}
	%>

	<aui:button-row>
		<aui:button type="submit" onClick="saveRecordedResponses()" />
	</aui:button-row>
</aui:form>

<script type="text/javascript">
	var dmp = new diff_match_patch();

	var recorders = new Array();

	function <portlet:namespace />getRecorder(questionId) {
		for (var i = 0; i < recorders.length; i++) {
			var recorder = recorders[i];

			if (recorder.questionId == questionId) {
				return recorder;
			}
		}

		recorders.push({
			"questionId": questionId,
			"patches": new Array(),
			"previousValue": ""
		})
	}

	function <portlet:namespace />record(event, questionId) {
		var now = new Date();

		var recorder = <portlet:namespace />getRecorder(questionId);

		var recordedResponse = document.getElementById("<portlet:namespace />recordedResponse" + questionId);

		var patch = dmp.patch_make(recorder.previousValue, recordedResponse.value);

		recorder.patches.push({"patch": patch, "timestamp": now.getUTCMilliseconds()});

		recorder.previousValue = recordedResponse.value;

		return true;
	}

	function saveRecordedResponses() {
		for (var i = 0; i < recorders.length; i++) {
			var recorder = recorders[i];

			var jsonString = "";

			for(var j = 0; j < recorder.patches.length; j++) {
				jsonString += JSON.stringify(recorder.patches[j]) + "/";
			}

			document.getElementById("<portlet:namespace />response" + recorder.questionId).value = jsonString;
		}

	}
</script>