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

package com.liferay.interview.service.impl;

import com.liferay.interview.CannotEditStartDateException;
import com.liferay.interview.CannotResubmitResponseException;
import com.liferay.interview.ExpireDateException;
import com.liferay.interview.InterviewEmailAddressException;
import com.liferay.interview.InterviewNameException;
import com.liferay.interview.TimeLimitExpiredException;
import com.liferay.interview.model.Interview;
import com.liferay.interview.model.QuestionSet;
import com.liferay.interview.service.base.InterviewLocalServiceBaseImpl;
import com.liferay.interview.util.InterviewUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.util.PortalUtil;

import java.util.Date;
import java.util.List;

/**
 * @author Sara Liu
 */
public class InterviewLocalServiceImpl extends InterviewLocalServiceBaseImpl {

	public Interview addInterview(
			String name, String emailAddress, long questionSetId,
			int expireDateMonth, int expireDateDay, int expireDateYear,
			int expireDateHour, int expireDateMinute,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		Date now = new Date();

		validate(name, emailAddress);

		Date expireDate = PortalUtil.getDate(
			expireDateMonth, expireDateDay, expireDateYear, expireDateHour,
			expireDateMinute, new ExpireDateException());

		long interviewId = counterLocalService.increment();

		Interview interview = interviewPersistence.create(interviewId);

		interview.setUuid(serviceContext.getUuid());
		interview.setUserId(serviceContext.getUserId());
		interview.setCreateDate(serviceContext.getCreateDate(now));
		interview.setModifiedDate(serviceContext.getModifiedDate(now));
		interview.setName(name);
		interview.setEmailAddress(emailAddress);
		interview.setExpireDate(expireDate);
		interview.setQuestionSetId(questionSetId);

		interviewPersistence.update(interview, false);

		return interview;
	}

	public Interview getInterview(String uuid) throws SystemException{

		List<Interview> interview = interviewPersistence.findByUuid(uuid);

		return interview.get(0);
	}

	public List<Interview> getInterviews(int start, int end)
		throws SystemException {

		return interviewPersistence.findAll(start, end);
	}

	public int getInterviewsCount() throws SystemException {
		return interviewPersistence.countAll();
	}

	public Interview updateInterview(
			long interviewId, String name, String emailAddress, Date startDate,
			Date expireDate, long questionSetId, String response,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		validate(name, emailAddress);

		Interview interview = interviewPersistence.findByPrimaryKey(
			interviewId);

		interview.setUserId(serviceContext.getUserId());
		interview.setModifiedDate(serviceContext.getModifiedDate(null));
		interview.setName(name);
		interview.setEmailAddress(emailAddress);
		interview.setStartDate(startDate);
		interview.setExpireDate(expireDate);
		interview.setQuestionSetId(questionSetId);
		interview.setResponse(response);

		interviewPersistence.updateImpl(interview, false);

		return interview;
	}

	public Interview updateInterview(
			long interviewId, String name, String emailAddress,
			long questionSetId, int expireDateMonth, int expireDateDay,
			int expireDateYear, int expireDateHour, int expireDateMinute,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		validate(name, emailAddress);

		Date expireDate = PortalUtil.getDate(
			expireDateMonth, expireDateDay, expireDateYear, expireDateHour,
			expireDateMinute, new ExpireDateException());

		Interview interview = interviewPersistence.findByPrimaryKey(
			interviewId);

		interview.setUserId(serviceContext.getUserId());
		interview.setModifiedDate(serviceContext.getModifiedDate(null));
		interview.setName(name);
		interview.setEmailAddress(emailAddress);
		interview.setExpireDate(expireDate);
		interview.setQuestionSetId(questionSetId);

		interviewPersistence.updateImpl(interview, false);

		return interview;
	}

	public Interview updateResponse(
			String uuid, String response, ServiceContext serviceContext)
		throws PortalException, SystemException {

		Interview interview = getInterview(uuid);

		if (Validator.isNotNull(interview.getResponse())) {
			throw new CannotResubmitResponseException();
		}

		QuestionSet questionSet = questionSetPersistence.findByPrimaryKey(
			interview.getQuestionSetId());

		if (InterviewUtil.isExpired(
				interview.getStartDate(), questionSet.getTimeLimit(),
				interview.getExpireDate())) {
			throw new TimeLimitExpiredException();
		}

		interview.setResponse(response);

		interviewPersistence.update(interview, false);

		return interview;
	}

	public Interview updateStartDate(String uuid, Date startDate)
		throws PortalException, SystemException {

		Interview interview = getInterview(uuid);

		if (interview.getStartDate() != null) {
			throw new CannotEditStartDateException();
		}

		interview.setStartDate(startDate);

		interviewPersistence.update(interview, false);

		return interview;
	}

	protected void validate(String name, String emailAddress)
		throws PortalException {

		if (!Validator.isEmailAddress(emailAddress)) {
			throw new InterviewEmailAddressException();
		}

		if (Validator.isNull(name)) {
			throw new InterviewNameException();
		}
	}

}