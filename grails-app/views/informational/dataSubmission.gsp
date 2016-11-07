<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
    #t2dImageHolder {
        display: flex;
        justify-content: space-around;
        height: 60px;
        width: 100%;
    }

    #t2dImageHolder a, #t2dImageHolder a img {
        height: 100%;
    }

    </style>
</head>


<body>
<style>
.consortium-spacing {
    padding-top: 15px;
}
</style>
<div id="main">
    <div class="container">

    <h2 align="center"><g:message code="informational.dataSubmission.title"></g:message></h2>
        <p><g:message code="informational.dataSubmission.subtitle"></g:message></p>
        <p><g:message code="informational.dataSubmission.section6"></g:message></p>
        <h3><g:message code="informational.dataSubmission.FAQ.title"></g:message></h3>
        <h4><g:message code="informational.dataSubmission.section4title"></g:message></h4>
        <g:message code="informational.dataSubmission.section4"></g:message>


    <h4><g:message code="informational.dataSubmission.section1title"></g:message></h4>
    <g:message code="informational.dataSubmission.section1"></g:message>
    <h4><g:message code="informational.dataSubmission.section2title"></g:message></h4>
    <g:message code="informational.dataSubmission.section2"></g:message>
    <h4><g:message code="informational.dataSubmission.section3title"></g:message></h4>
    <g:message code="informational.dataSubmission.section3a"></g:message>
        <a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.home.collaborate"/></a>
    <g:message code="informational.dataSubmission.section3b"></g:message>
    <h4><g:message code="informational.dataSubmission.section5title"></g:message></h4>
    <g:message code="informational.dataSubmission.section5"></g:message>
        <h4><g:message code="informational.dataSubmission.section5atitle"></g:message></h4>
        <g:message code="informational.dataSubmission.section5a"></g:message>

        <div class="separator"></div>
        <h4 align="center"><g:message code="informational.dataSubmission.section7"></g:message></h4>
            <h4 align="center"><g:message code="informational.dataSubmission.section8"></g:message></h4>
</div>
    </div>


</body>
</html>
