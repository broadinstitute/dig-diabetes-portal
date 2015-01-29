<!DOCTYPE html>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="temporary.BuildInfo" %>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<html>
<head>
<title>${grailsApplication.config.site.title}</title>

    <r:require modules="core"/>
    <r:layoutResources/>

    <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>
    <g:external uri="/images/icons/dna-strands.ico"/>


    <g:layoutHead/>

    <g:applyLayout name="analyticsBeacon"/>

</head>

<body>

<g:javascript src="lib/bootstrap.min.js" />

<g:applyLayout name="errorReporter"/>

<div id="spinner" class="spinner" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
</div>
<div id="header">
    <div id="header-top">
        <div class="container">
            <% def locale = RequestContextUtils.getLocale(request) %>
            <g:renderSigmaSection>
                <span id="language">
                    <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'><i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/Mexico.png" alt="Mexico"/></i></a>
                    %{--<a href="/dig-diabetes-portal/home?lang=en"> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>--}%
                    <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>
                </span>

                <div id="branding">
                    SIGMA <strong>T2D</strong> <small><g:rendersSigmaMessage messageSpec="site.subtext"/></small>
                </div>
            </g:renderSigmaSection>
            <g:renderNotSigmaSection>
                <div id="branding">
                    Broad Institute <strong>Beacon</strong>
                </div>
            </g:renderNotSigmaSection>
        </div>
    </div>

    <div id="header-bottom">
        <div class="container">
            <sec:ifLoggedIn>
                <div class="rightlinks">
                    <sec:ifAllGranted roles="ROLE_ADMIN">
                        <g:link controller='admin' action="users" class="mgr">manage  users</g:link>
                        &middot;
                    </sec:ifAllGranted>
                    <sec:ifAllGranted roles="ROLE_SYSTEM">
                        <g:link controller='system' action="systemManager">System Mgr</g:link>
                        &middot;
                    </sec:ifAllGranted>
                    <sec:loggedInUserInfo field="username"/>   &middot;
                    <g:link controller='logout'><g:message code="mainpage.log.out"/></g:link>
                </div>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <div class="rightlinks">
<!--                    <g:link controller='login' action='auth'><g:message code="mainpage.log.in"/></g:link> -->
                </div>
            </sec:ifNotLoggedIn>
            <g:renderSigmaSection>
                <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'aboutSigma')}"><g:message code="localized.aboutTheData"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="localized.contact"/></a>
            </g:renderSigmaSection>
            <g:renderNotSigmaSection>
                <a href="${createLink(controller:'beacon',action:'beaconDisplay')}"><g:message code="localized.home"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'aboutBeacon')}"><g:message code="localized.aboutTheBeaconData"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contactBeacon')}"><g:message code="localized.contact"/></a>
             </g:renderNotSigmaSection>
            </div>
        </div>
    </div>

<g:layoutBody/>

<div id="footer">
    <div class="container">
        <div class="separator"></div>
        <div id="helpus"><a href="${createLink(controller:'informational', action:'contactBeacon')}"><g:message code="mainpage.send.beacon.feedback"/></a></div>
    </div>
</div>
<div id="belowfooter">
    <div class="row">
        <div class="footer">
            <div class="col-lg-6"></div>
            <div class="col-lg-6 small-buildinfo">
                Built on ${BuildInfo?.buildHost} at ${BuildInfo?.buildTime}.  Version=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}
            </div>

        </div>
    </div>
</div>

</body>
</html>