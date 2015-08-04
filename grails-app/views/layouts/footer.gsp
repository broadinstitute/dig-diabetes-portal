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
                    Built on ${BuildInfo?.buildHost} at ${BuildInfo?.buildTime}.  Version=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}
                </span>
            </div>

        </div>
    </div>
</div>
