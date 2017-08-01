<%@ page import="temporary.BuildInfo" %>

<div id="footer">
    <div class="container">
        <div class="separator"></div>
        <div id="helpus"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="mainpage.send.feedback"/></a></div>
    </div>
</div>

<div id="belowfooter">
    <div class="row">
        <div class="footer">
            <div class="col-lg-6"></div>
            <div class="col-lg-6 small-buildinfo">
                <span class="pull-right" style="padding-right:10px">
                    <g:message code="buildInfo.shared.build_message" args="${[BuildInfo?.buildHost, BuildInfo?.buildTime]}"/>.  <g:message code='buildInfo.shared.version'/>=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}
                </span>
            </div>

        </div>
    </div>
</div>
