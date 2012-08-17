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

package com.liferay.interview.model;

import com.liferay.portal.kernel.bean.AutoEscape;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.BaseModel;
import com.liferay.portal.model.CacheModel;
import com.liferay.portal.service.ServiceContext;

import com.liferay.portlet.expando.model.ExpandoBridge;

import java.io.Serializable;

import java.util.Date;

/**
 * The base model interface for the QuestionSet service. Represents a row in the &quot;Interview_QuestionSet&quot; database table, with each column mapped to a property of this class.
 *
 * <p>
 * This interface and its corresponding implementation {@link com.liferay.interview.model.impl.QuestionSetModelImpl} exist only as a container for the default property accessors generated by ServiceBuilder. Helper methods and all application logic should be put in {@link com.liferay.interview.model.impl.QuestionSetImpl}.
 * </p>
 *
 * @author Sara Liu
 * @see QuestionSet
 * @see com.liferay.interview.model.impl.QuestionSetImpl
 * @see com.liferay.interview.model.impl.QuestionSetModelImpl
 * @generated
 */
public interface QuestionSetModel extends BaseModel<QuestionSet> {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never modify or reference this interface directly. All methods that expect a question set model instance should use the {@link QuestionSet} interface instead.
	 */

	/**
	 * Returns the primary key of this question set.
	 *
	 * @return the primary key of this question set
	 */
	public long getPrimaryKey();

	/**
	 * Sets the primary key of this question set.
	 *
	 * @param primaryKey the primary key of this question set
	 */
	public void setPrimaryKey(long primaryKey);

	/**
	 * Returns the question set ID of this question set.
	 *
	 * @return the question set ID of this question set
	 */
	public long getQuestionSetId();

	/**
	 * Sets the question set ID of this question set.
	 *
	 * @param questionSetId the question set ID of this question set
	 */
	public void setQuestionSetId(long questionSetId);

	/**
	 * Returns the user ID of this question set.
	 *
	 * @return the user ID of this question set
	 */
	public long getUserId();

	/**
	 * Sets the user ID of this question set.
	 *
	 * @param userId the user ID of this question set
	 */
	public void setUserId(long userId);

	/**
	 * Returns the user uuid of this question set.
	 *
	 * @return the user uuid of this question set
	 * @throws SystemException if a system exception occurred
	 */
	public String getUserUuid() throws SystemException;

	/**
	 * Sets the user uuid of this question set.
	 *
	 * @param userUuid the user uuid of this question set
	 */
	public void setUserUuid(String userUuid);

	/**
	 * Returns the create date of this question set.
	 *
	 * @return the create date of this question set
	 */
	public Date getCreateDate();

	/**
	 * Sets the create date of this question set.
	 *
	 * @param createDate the create date of this question set
	 */
	public void setCreateDate(Date createDate);

	/**
	 * Returns the modified date of this question set.
	 *
	 * @return the modified date of this question set
	 */
	public Date getModifiedDate();

	/**
	 * Sets the modified date of this question set.
	 *
	 * @param modifiedDate the modified date of this question set
	 */
	public void setModifiedDate(Date modifiedDate);

	/**
	 * Returns the time limit of this question set.
	 *
	 * @return the time limit of this question set
	 */
	public int getTimeLimit();

	/**
	 * Sets the time limit of this question set.
	 *
	 * @param timeLimit the time limit of this question set
	 */
	public void setTimeLimit(int timeLimit);

	/**
	 * Returns the title of this question set.
	 *
	 * @return the title of this question set
	 */
	@AutoEscape
	public String getTitle();

	/**
	 * Sets the title of this question set.
	 *
	 * @param title the title of this question set
	 */
	public void setTitle(String title);

	public boolean isNew();

	public void setNew(boolean n);

	public boolean isCachedModel();

	public void setCachedModel(boolean cachedModel);

	public boolean isEscapedModel();

	public Serializable getPrimaryKeyObj();

	public void setPrimaryKeyObj(Serializable primaryKeyObj);

	public ExpandoBridge getExpandoBridge();

	public void setExpandoBridgeAttributes(ServiceContext serviceContext);

	public Object clone();

	public int compareTo(QuestionSet questionSet);

	public int hashCode();

	public CacheModel<QuestionSet> toCacheModel();

	public QuestionSet toEscapedModel();

	public String toString();

	public String toXmlString();
}