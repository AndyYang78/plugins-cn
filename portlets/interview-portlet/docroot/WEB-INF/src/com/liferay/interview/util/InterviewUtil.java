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
		Date startDate, int timeLimit, Date expireDate) {

		if (startDate == null) {
			return false;
		}

		Calendar currentDate = Calendar.getInstance();

		currentDate.setTime(new Date());

		Calendar startDateCalendar = Calendar.getInstance();

		startDateCalendar.setTime(startDate);
		startDateCalendar.add(Calendar.MINUTE, timeLimit);

		Calendar expireDateCalendar = Calendar.getInstance();

		expireDateCalendar.setTime(expireDate);

		if (currentDate.after(expireDateCalendar)) {
			return true;
		}
		else if (timeLimit == 0) {
			return false;
		}
		else if (currentDate.after(startDateCalendar)) {
			return true;
		}

		return false;
	}

}