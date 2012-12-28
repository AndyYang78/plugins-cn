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

package com.liferay.interview.portlet;

import com.liferay.interview.CannotResubmitResponseException;
import com.liferay.interview.TimeLimitExpiredException;
import com.liferay.interview.model.Interview;
import com.liferay.interview.model.Question;
import com.liferay.interview.service.InterviewLocalServiceUtil;
import com.liferay.interview.service.QuestionLocalServiceUtil;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

/**
 * Portlet implementation class DisplayPortlet
 */
public class DisplayPortlet extends MVCPortlet {

	public void updateInterview(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		String uuid = ParamUtil.getString(actionRequest, "uuid");

		Interview interview = InterviewLocalServiceUtil.getInterview(uuid);

		JSONObject json = JSONFactoryUtil.createJSONObject();

		List<Question> questions =
			QuestionLocalServiceUtil.getQuestionSetQuestions(
				interview.getQuestionSetId());

		for (Question question : questions) {
			long questionId = question.getQuestionId();
			String response = ParamUtil.getString(
				actionRequest, "response" + questionId);

			json.put(String.valueOf(questionId), response);
		}

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			actionRequest);

		try {
			InterviewLocalServiceUtil.updateResponse(
				interview.getUuid(), json.toString(), serviceContext);
		}
		catch (Exception e) {
			if (e instanceof CannotResubmitResponseException ||
				e instanceof TimeLimitExpiredException) {

				SessionErrors.add(actionRequest, e.getClass().getName());

				actionResponse.setRenderParameter(
					"mvcPath", "/display/error.jsp");

				return;
			}
		}

		actionResponse.setRenderParameter("mvcPath", "/display/success.jsp");
	}

}