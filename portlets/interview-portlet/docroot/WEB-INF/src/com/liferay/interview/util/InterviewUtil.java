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

package com.liferay.interview.util;

import java.util.Calendar;
import java.util.Date;

/**
 * @author Samuel Kong
 */
public class InterviewUtil {

	public static boolean isExpired(
		Date interviewStartDate, int timeLimit, Date interviewExpireDate) {

		Calendar currentTime = Calendar.getInstance();

		currentTime.setTime(new Date());

		Calendar interviewExpiration = Calendar.getInstance();

		interviewExpiration.setTime(interviewExpireDate);

		if (currentTime.after(interviewExpiration)) {
			return true;
		}

		if ((interviewStartDate == null) || (timeLimit == 0)) {
			return false;
		}

		Calendar timeLimitExpiration = Calendar.getInstance();

		timeLimitExpiration.setTime(interviewStartDate);
		timeLimitExpiration.add(Calendar.MINUTE, timeLimit);

		return currentTime.after(timeLimitExpiration);
	}

}