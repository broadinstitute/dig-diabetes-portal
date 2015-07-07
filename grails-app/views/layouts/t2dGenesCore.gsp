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

        <g:applyLayout name="notice"/>

</div>
</div>

<g:layoutBody/>


<div class="row column-center" style="background-color: #65A1DC;padding-top:7px;padding-bottom: 7px;">
    <div class="text-center" style="color: #ffffff;">Please use the following citation when referring to data from this portal: AMP T2D-GENES Program, SIGMA; Year Month Date of Access; URL of page you are citing. </div>
</div>

<div>
    <div class="row column-center">
        <div class="text-center" style="padding-top:10px;"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="mainpage.send.feedback"/></a><div>
    </div>


    <div class="row column-center" style="display: flex;  display: -webkit-flex;align-content: center; align-items: center;padding-top: 10px;">
        <div class="col-xs-5"></div>
        <div class="col-xs-2">Built at</div>
        <div class="col-xs-5"></div>
    </div>

    <div class="row column-center" style="display: flex; align-content: center; align-items: center;">
        <div class="col-xs-5"></div>
        <img class="img-responsive col-xs-2" src="${resource(dir: 'images', file: 'BroadInstLogoforDigitalRGB.png')}" alt="Broad Institute"/>
        <div class="col-xs-5"></div>
    </div>
    <div class="row column-center"  style="padding-top:5px;">
        <div style="font-size: 10px;">Built  on ${BuildInfo?.buildHost} at ${BuildInfo?.buildTime}.  Version=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}</div>
    </div>
</div>

<g:applyLayout name="activatePopups"/>

</body>
</html>