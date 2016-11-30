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
    <div class="container dk-static-content">
        <div class="row">
            <div class="col-md-12">
                <h1><g:message code="informational.dataSubmission.title"></g:message></h1>
                <h5 class="dk-under-header"><g:message code="informational.dataSubmission.subtitle"></g:message></h5>
                <h5 class="dk-under-header"><g:message code="informational.dataSubmission.section6"></g:message></h5>
            </div>
        </div>
        <div class="row">
            <div class="col-md-8">
                <h3><g:message code="informational.dataSubmission.FAQ.title"></g:message></h3>
                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section4title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section4"></g:message></ul>


                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section1title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section1"></g:message></ul>

                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section9title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section9"></g:message></ul>

                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section2title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section2"></g:message></ul>

                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section3title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section3a"></g:message>
                    <a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.home.collaborate"/></a>
        <g:message code="informational.dataSubmission.section3b"></g:message>
                </ul>

                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section5title"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section5"></g:message></ul>


                <h4 class="dk-blue-bordered"><g:message code="informational.dataSubmission.section5atitle"></g:message></h4>
                <ul><g:message code="informational.dataSubmission.section5a"></g:message></ul>
            </div>

            <div class="col-md-4" style="padding-top:20px;">
                <div class="dk-notice">
                    <p class="dk-notice-header"><g:message code="informational.dataSubmission.section7header"></g:message></p>
                    <p><g:message code="informational.dataSubmission.section7"></g:message></p>
                </div>
                <div class="dk-notice">
                    <p class="dk-notice-header"><g:message code="informational.dataSubmission.section8header"></g:message></p>
                    <p><g:message code="informational.dataSubmission.section8"></g:message></p>
                </div>
            </div>
        </div>
    </div>
    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="assets/js/jquery.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>


</div>


</body>
</html>
