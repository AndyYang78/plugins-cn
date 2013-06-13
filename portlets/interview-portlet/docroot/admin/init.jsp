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

<%@ include file="/init.jsp" %>

<%@ page import="com.liferay.interview.InterviewEmailAddressException" %><%@
page import="com.liferay.interview.InterviewNameException" %><%@
page import="com.liferay.interview.QuestionSetTitleException" %><%@
page import="com.liferay.interview.QuestionTitleException" %><%@
page import="com.liferay.interview.util.PortletPropsValues" %><%@
page import="com.liferay.portal.kernel.dao.orm.QueryUtil" %><%@
page import="com.liferay.portal.kernel.dao.search.ResultRow" %><%@
page import="com.liferay.portal.kernel.util.CalendarFactoryUtil" %><%@
page import="com.liferay.portal.kernel.util.Constants" %><%@
page import="com.liferay.portal.kernel.util.GetterUtil" %><%@
page import="com.liferay.portal.kernel.util.ParamUtil" %><%@
page import="com.liferay.portal.kernel.util.WebKeys" %><%@
page import="com.liferay.portlet.PortletPreferencesFactoryUtil" %>

<%@ page import="java.util.Calendar" %>

<%@ page import="javax.portlet.PortletPreferences" %>

<%
PortletPreferences preferences = renderRequest.getPreferences();

String portletResource = ParamUtil.getString(request, "portletResource");

if (Validator.isNotNull(portletResource)) {
	preferences = PortletPreferencesFactoryUtil.getPortletSetup(request, portletResource);
}

int defaultInterviewValidPeriod = GetterUtil.getInteger(preferences.getValue("defaultInterviewValidPeriod", PortletPropsValues.DEFAULT_INTERVIEW_VALID_PERIOD));

String displayPortletPageURL = preferences.getValue("displayPortletPageURL", null);
%>