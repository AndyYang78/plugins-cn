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

import com.liferay.interview.NameException;
import com.liferay.interview.model.Interview;
import com.liferay.interview.service.base.InterviewLocalServiceBaseImpl;
import com.liferay.portal.UserEmailAddressException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.service.ServiceContext;

import java.util.Date;
import java.util.List;

/**
 * @author Sara Liu
 */
public class InterviewLocalServiceImpl extends InterviewLocalServiceBaseImpl {

	public Interview addInterview(
			long userId, String name, String emailAddress, Date expireDate,
			long questionSetId, ServiceContext serviceContext)
		throws PortalException, SystemException {

		Date now = new Date();

		validate(name, emailAddress);

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

	public List<Interview> getInterviews(int start, int end)
		throws SystemException {

		return interviewPersistence.findAll(start, end);
	}

	public int getInterviewsCount() throws SystemException {
		return interviewPersistence.countAll();
	}

	public Interview updateInterview(
			long userId, long interviewId, String name, String emailAddress,
			Date startDate, Date expireDate, long questionSetId, String response,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		validate(name, emailAddress);

		Interview interview = interviewPersistence.findByPrimaryKey(
			interviewId);

		interview.setUserId(userId);
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

	protected void validate(String name, String emailAddress)
		throws PortalException {

		if (!Validator.isEmailAddress(emailAddress)) {
			throw new UserEmailAddressException();
		}

		if (Validator.isNull(name)) {
			throw new NameException();
		}
	}

}