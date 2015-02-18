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
<g:renderSigmaSection>
    <g:applyLayout name="analyticsSigma"/>
</g:renderSigmaSection>
<g:renderT2dGenesSection>
    <g:applyLayout name="analyticsT2dGenes"/>
</g:renderT2dGenesSection>


</head>

<body>

<g:javascript src="lib/bootstrap.min.js" />


<g:applyLayout name="errorReporter"/>


<div id="spinner" class="spinner" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
</div>
<div id="header">

        <g:applyLayout name="headerTopT2dgenes"/>

        <g:applyLayout name="headerBottomT2dgenes"/>

    </div>
</div>

<g:layoutBody/>


<div id="footer">
    <div class="container">
        <div class="row">
            <div class="separator"></div>
        </div>
        <div class="row" style="margin-top: 0">
            <div class="col-xs-2 footerFeedbackHolder">
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="mainpage.send.feedback"/></a>
            </div>
            <div class="col-xs-6"></div>
            <div class="col-xs-4 footerLogoHolder">
                <span class="">
                    <span class=""></span>
                    <img class="footerLogo" src="${resource(dir: 'images', file: 'BroadInstLogoforDigitalRGB.png')}"
                         width="100%" alt="Broad Institute"/>
                </span>
            </div>
        </div>


    </div>
</div>

<div id="belowfooter">
    <div class="row">
        <div class="footer">
            <div class="container">
                <div class="row">
            <div class="col-xs-8"></div>
            <div class="col-xs-4 small-buildinfo footerLogoHolder">
                <span class="">
                    Built on ${BuildInfo?.buildHost} at ${BuildInfo?.buildTime}.  Version=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}
                </span>
            </div>
                </div>
            </div>
        </div>
    </div>
</div>

<g:applyLayout name="activatePopups"/>

</body>
</html>