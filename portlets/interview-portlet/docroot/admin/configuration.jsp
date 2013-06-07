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

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />

<aui:form action="<%= configurationURL %>" method="post" name="fm">
	<liferay-ui:error key="displayPortletPageURL" message="please-enter-a-valid-display-portlet-page-url" />
	<liferay-ui:error key="defaultInterviewValidPeriod" message="please-enter-a-valid-default-interview-valid-period" />

	<aui:fieldset>
		<aui:input name="<%= Constants.CMD %>" value="<%= Constants.UPDATE %>" type="hidden" />

		<aui:input label="display-portlet-page-url" name="preferences--displayPortletPageURL--" value="<%= displayPortletPageURL %>" />

		<aui:input name="preferences--defaultInterviewValidPeriod--" size="3" suffix="days" type="text" value="<%= defaultInterviewValidPeriod %>" />
	</aui:fieldset>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>