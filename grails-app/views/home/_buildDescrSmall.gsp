<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 12/29/2014
  Time: 12:52 PM
--%>
<%@ page import="temporary.BuildInfo" %>
<div class="row clearfix" style="margin-top:5px">

    <div class="col-md-4"></div>
    <div class="col-md-4">
        <div style="font-size: 8pt">
            <g:if test="${('UNKNOWN'!=BuildInfo?.buildNumber)}">
                <g:message code="buildInfo.shared.build_number" />: ${BuildInfo?.buildNumber}.<br />
            </g:if>
            <g:message code="buildInfo.shared.build_message" args="${[BuildInfo?.buildHost, BuildInfo?.buildTime]}"/>.
        </div>
    </div>
    <div class="col-md-4"></div>

</div>