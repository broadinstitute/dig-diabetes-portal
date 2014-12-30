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
                Build number: ${BuildInfo?.buildNumber}.<br />
            </g:if>
            Built on ${BuildInfo?.buildHost} at ${BuildInfo?.buildTime}.
        </div>
    </div>
    <div class="col-md-4"></div>

</div>