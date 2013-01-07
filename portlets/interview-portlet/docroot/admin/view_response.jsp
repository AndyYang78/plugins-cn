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

JSONObject JSONResponse = JSONFactoryUtil.createJSONObject(interview.getResponse());

List<JSONArray> recordList = new ArrayList<JSONArray>();
%>

<liferay-ui:header
	backURL="<%= backURL %>"
	title="<%= interview.getName() %>"
/>

<%
for (Question question : questions) {
	if(question.getType() == QuestionTypeConstants.RECORDED) {
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();

		String recorded = JSONResponse.getString(String.valueOf(question.getQuestionId()));

		if(Validator.isNotNull(recorded)) {
			String recordResponse[] = recorded.split("/");

			for(int j=0; j<recordResponse.length; j++) {
				JSONObject json = JSONFactoryUtil.createJSONObject(recordResponse[j]);

				jsonArray.put(json);
			}

		}

		recordList.add(jsonArray);
	}

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

				<button onclick="return replay('<%= question.getQuestionId() %>')">Replay</button>
			</c:when>
		</c:choose>
	</aui:field-wrapper>

<%
}
%>

<script type="text/javascript">
	var dmp = new diff_match_patch();

	var recorders = new Array();

	var i = 0;

	function <portlet:namespace />getRecorded(i, questionId) {

		if(i == 0) {
				recorders.push({
					"questionId": questionId,
					"recorderArray": <%= recordList%>
				})
			}
		else {
				for(var j = 0; j < recorders.length; j++) {
					if(recorders[j].questionId == questionId) {
						break;
					}

					if(j == recorders.length - 1){
						recorders.push({
							"questionId": questionId,
							"recorderArray": <%= recordList%>
						})
					}

				}
			}

		for (var h = 0; h < recorders.length; h++) {
			var recorder = recorders[h];

			if (recorder.questionId == questionId) {
				return recorder.recorderArray[h];
			}

		}

	}

	function replay(questionId) {
		var recordedResponse = document.getElementById("<portlet:namespace />response" + questionId);

		recordedResponse.value = "";

		var recorder = <portlet:namespace />getRecorded(i, questionId);

		i++;

		replayEvent(0, questionId, recorder);

	}

	function replayEvent(j, questionId, recorder) {
		var recordedResponse = document.getElementById("<portlet:namespace />response" + questionId);

		if(recorder[j] != null) {
			var result = dmp.patch_apply(recorder[j].patch, recordedResponse.value);

			recordedResponse.value = result[0];

			if (j < (recorder.length - 1)) {
				setTimeout(recorderReplay(j+1, questionId, recorder), (recorder[j+1].timestamp - recorder[j].timestamp));
			}
		}
		else {
			return;
		}

	}

	function recorderReplay(j, questionId, recorder) {
		return function() {
			replayEvent(j, questionId, recorder);
		}
	}

</script>

<aui:script>
	Alloy.on('domready', function (event) {
		var responseJSON = <%= interview.getResponse() %>;

		var keys = Object.keys(responseJSON);

		for (var i = 0; i < keys.length; i++) {
			var key = keys[i];

			var inputElement = document.getElementById("<portlet:namespace />response" + key);

			inputElement.value = responseJSON[key];
		}
	});
</aui:script>