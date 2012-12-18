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

int m = 0;
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

		if(!recorded.equals("")) {
			for(int j=0; j<recorded.split("/").length; j++) {
				JSONObject json = JSONFactoryUtil.createJSONObject(recorded.split("/")[j]);

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
				<button onclick="return replay('<%= question.getQuestionId() %>', '<%= m++ %>')">Replay</button>
			</c:when>
		</c:choose>
	</aui:field-wrapper>

<%
}
%>

	<script type="text/javascript">
		var recorder = new Array();
		var dmp = new diff_match_patch();

		<%
		for (JSONArray ja: recordList) {
		%>

			recorder.push(<%= ja%>);

		<%
		}
		%>

		function replay(questionId, i) {
			var textarea = document.getElementById("<portlet:namespace />response" + questionId);

			textarea.value = "";

			replayEvent(0, questionId, i);
		}

		function replayEvent(j, questionId, i) {

			var textarea = document.getElementById("<portlet:namespace />response" + questionId);

			var result = dmp.patch_apply((recorder[i])[j].patch, textarea.value);

			textarea.value = result[0];

			if (j < (recorder[i].length - 1)) {
				setTimeout("replayEvent("+(j+1)+"," + questionId +","+ i +")", ((recorder[i])[j+1].timestamp - (recorder[i])[j].timestamp));
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