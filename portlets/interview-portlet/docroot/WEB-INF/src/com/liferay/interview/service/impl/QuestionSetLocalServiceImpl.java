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

import com.liferay.interview.QuestionSetTitleException;
import com.liferay.interview.model.QuestionSet;
import com.liferay.interview.service.base.QuestionSetLocalServiceBaseImpl;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.service.ServiceContext;

import java.util.Date;
import java.util.List;

/**
 * @author Sara Liu
 */
public class QuestionSetLocalServiceImpl
	extends QuestionSetLocalServiceBaseImpl {

	public QuestionSet addQuestionSet(
			String title, String introduction, int timeLimit,
			ServiceContext serviceContext)
		throws PortalException, SystemException {

		Date now = new Date();

		validate(title);

		long questionSetId = counterLocalService.increment();

		QuestionSet questionSet = questionSetPersistence.create(questionSetId);

		questionSet.setUserId(serviceContext.getUserId());
		questionSet.setCreateDate(serviceContext.getCreateDate(now));
		questionSet.setModifiedDate(serviceContext.getModifiedDate(now));
		questionSet.setTitle(title);
		questionSet.setIntroduction(introduction);
		questionSet.setTimeLimit(timeLimit);

		questionSetPersistence.update(questionSet, false);

		return questionSet;
	}

	public void deleteQuestionSet(long questionSetId)
		throws PortalException, SystemException {

		questionLocalService.deleteQuestionSetQuestions(questionSetId);

		questionSetPersistence.remove(questionSetId);
	}

	public List<QuestionSet> getQuestionSets(int start, int end)
		throws SystemException {

		return questionSetPersistence.findAll(start, end);
	}

	public int getQuestionSetsCount() throws SystemException {
		return questionSetPersistence.countAll();
	}

	public QuestionSet updateQuestionSet(
			long questionSetId, String title, String introduction,
			int timeLimit, ServiceContext serviceContext)
		throws PortalException, SystemException {

		validate(title);

		QuestionSet questionSet = questionSetPersistence.findByPrimaryKey(
			questionSetId);

		questionSet.setUserId(serviceContext.getUserId());
		questionSet.setModifiedDate(serviceContext.getModifiedDate(null));
		questionSet.setTitle(title);
		questionSet.setIntroduction(introduction);
		questionSet.setTimeLimit(timeLimit);

		questionSetPersistence.updateImpl(questionSet, false);

		return questionSet;
	}

	protected void validate(String title) throws PortalException {
		if (Validator.isNull(title)) {
			throw new QuestionSetTitleException();
		}
	}

}