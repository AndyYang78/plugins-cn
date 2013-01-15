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

import com.liferay.interview.InterviewEmailAddressException;
import com.liferay.interview.InterviewNameException;
import com.liferay.interview.QuestionSetTitleException;
import com.liferay.interview.QuestionTitleException;
import com.liferay.interview.model.Interview;
import com.liferay.interview.service.InterviewLocalServiceUtil;
import com.liferay.interview.service.QuestionLocalServiceUtil;
import com.liferay.interview.service.QuestionSetLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.HttpUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.util.Calendar;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

/**
 * @author Samuel Kong
 * @author Sara Liu
 * @author Andy Yang
 */
public class AdminPortlet extends MVCPortlet {

	public void deleteInterview(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long interviewId = ParamUtil.getLong(actionRequest, "interviewId");

		InterviewLocalServiceUtil.deleteInterview(interviewId);

		sendRedirect(actionRequest, actionResponse);
	}

	public void deleteQuestion(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long questionId = ParamUtil.getLong(actionRequest, "questionId");

		QuestionLocalServiceUtil.deleteQuestion(questionId);

		sendRedirect(actionRequest, actionResponse);
	}

	public void deleteQuestionSet(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long questionSetId = ParamUtil.getLong(actionRequest, "questionSetId");

		QuestionSetLocalServiceUtil.deleteQuestionSet(questionSetId);

		sendRedirect(actionRequest, actionResponse);
	}

	public void updateInterview(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		String currentURL = ParamUtil.getString(actionRequest, "currentURL");

		long interviewId = ParamUtil.getLong(actionRequest, "interviewId");
		long questionSetId = ParamUtil.getLong(actionRequest, "questionSetId");
		String name = ParamUtil.getString(actionRequest, "name");
		String emailAddress = ParamUtil.getString(
			actionRequest, "emailAddress");

		int expireDateYear = ParamUtil.getInteger(
			actionRequest, "expireDateYear");
		int expireDateMonth = ParamUtil.getInteger(
			actionRequest, "expireDateMonth");
		int expireDateDay = ParamUtil.getInteger(
			actionRequest, "expireDateDay");
		int expireDateHour = ParamUtil.getInteger(
			actionRequest, "expireDateHour");
		int expireDateMinute = ParamUtil.getInteger(
			actionRequest, "expireDateMinute");
		int expireDateAmPm = ParamUtil.getInteger(
			actionRequest, "expireDateAmPm");

		if (expireDateAmPm == Calendar.PM) {
			expireDateHour += 12;
		}

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			actionRequest);

		try {
			Interview interview = null;

			if (interviewId <= 0) {
				interview = InterviewLocalServiceUtil.addInterview(
					name, emailAddress, questionSetId, expireDateMonth,
					expireDateDay, expireDateYear, expireDateHour,
					expireDateMinute, serviceContext);
			}
			else {
				interview = InterviewLocalServiceUtil.updateInterview(
					interviewId, name, emailAddress, questionSetId,
					expireDateMonth, expireDateDay, expireDateYear,
					expireDateHour, expireDateMinute, serviceContext);
			}

			currentURL = HttpUtil.setParameter(
				currentURL, actionResponse.getNamespace() + "interviewId",
				interview.getInterviewId());
		}
		catch (Exception e) {
			if (e instanceof InterviewEmailAddressException ||
				e instanceof InterviewNameException) {

				SessionErrors.add(actionRequest, e.getClass().getName());

				actionResponse.setRenderParameter(
					"mvcPath", "/admin/edit_interview.jsp");
				actionResponse.setRenderParameter("redirect", currentURL);

				return;
			}
			else {
				throw e;
			}
		}

		actionRequest.setAttribute(WebKeys.REDIRECT, currentURL);

		sendRedirect(actionRequest, actionResponse);
	}

	public void updateQuestion(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long questionId = ParamUtil.getLong(actionRequest, "questionId");
		long questionSetId = ParamUtil.getLong(actionRequest, "questionSetId");
		String title = ParamUtil.getString(actionRequest, "title");
		String description = ParamUtil.getString(actionRequest, "description");
		int type = ParamUtil.getInteger(actionRequest, "type");

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			actionRequest);

		try {
			if (questionId <= 0) {
				QuestionLocalServiceUtil.addQuestion(
					questionSetId, title, description, type, serviceContext);
			}
			else {
				QuestionLocalServiceUtil.updateQuestion(
					questionId, title, description, type, serviceContext);
			}

		}
		catch (Exception e) {
			if (e instanceof QuestionTitleException ) {

				SessionErrors.add(actionRequest, e.getClass().getName());

				actionResponse.setRenderParameter(
					"mvcPath", "/admin/edit_question.jsp");

				return;
			}
			else {
				throw e;
			}
		}

		sendRedirect(actionRequest, actionResponse);
	}

	public void updateQuestionSet(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long questionSetId = ParamUtil.getLong(actionRequest, "questionSetId");
		String title = ParamUtil.getString(actionRequest, "title");
		int timeLimit = ParamUtil.getInteger(actionRequest, "timeLimit");

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			actionRequest);

		try {
			if (questionSetId <= 0) {
				QuestionSetLocalServiceUtil.addQuestionSet(
					title, timeLimit, serviceContext);
			}
			else {
				QuestionSetLocalServiceUtil.updateQuestionSet(
					questionSetId, title, timeLimit, serviceContext);
			}

		}
		catch (Exception e) {
			if (e instanceof QuestionSetTitleException ) {

				SessionErrors.add(actionRequest, e.getClass().getName());

				actionResponse.setRenderParameter(
					"mvcPath", "/admin/edit_question_set.jsp");

				return;
			}
			else {
				throw e;
			}
		}

		sendRedirect(actionRequest, actionResponse);
	}

}