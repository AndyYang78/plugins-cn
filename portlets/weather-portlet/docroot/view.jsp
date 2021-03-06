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

<table class="lfr-table">

<%
for (int i = 0; i < zips.length; i++) {
	Weather weather = WeatherUtil.getWeather(zips[i]);

	if ((weather != null) && (((i + 1) % 5) != 0)) {
%>

		<tr>
			<td>
				<span style="font-size: xx-small; font-weight: bold;"><%= HtmlUtil.escape(weather.getZip()) %></span>
			</td>
			<td align="right">
				<span style="font-size: xx-small;">

				<c:if test="<%= fahrenheit %>">
					<%= weather.getCurrentTemp() %> &deg;F
				</c:if>

				<c:if test="<%= !fahrenheit %>">
					<%= Math.round((.5555555555 * (weather.getCurrentTemp() + 459.67)) - 273.15) %> &deg;C
				</c:if>

				</span>
			</td>
			<td align="right">
				<img alt="" src="<%= weather.getIconURL() %>" />
			</td>
		</tr>

<%
	}
}
%>

</table>

<span style="font-size: xx-small;"><liferay-ui:message key="powered-by" /> <a href="http://www.worldweatheronline.com" target="_blank">World Weather Online</a></span>