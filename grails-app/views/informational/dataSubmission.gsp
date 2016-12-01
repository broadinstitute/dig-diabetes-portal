<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
.dk-static-content {
    padding-top: 30px;
}

.dk-under-header {
    font-weight: 300; line-height: 20px; font-size: 16px;
}

.dk-notice {
    padding: 10px 20px 10px 20px;
    margin: 10px 0 10px 0;
    background-color: #7aa1fc;
    color: #fff;
    background-image:url(../images/logo_bg2.jpg);
    background-repeat:no-repeat;
    background-size:100% 100%;

}

.dk-notice a {
    color:#def;
    font-weight: 200;
    font-size: 18px;
}

.dk-notice p {
    margin-bottom: 0;
}

.dk-notice-header {
    font-size: 26px;
    font-weight: 100;
}

.dk-blue-bordered {
    display:block;
    border-top: solid 1px #39F;
    border-bottom: solid 1px #39F;
    color: #39f;
    padding: 5px 0;
    text-align:left;
    line-height:22px;
}
.dk-team-list {
    width: 100%;
    font-size: 14px;
    line-height: 22px;
}

.dk-team-list td:last-child {
    width: 50%;
}

.dk-team-list td {
    padding-right: 25px;
    padding-bottom: 15px;
    vertical-align:top;
}

.dk-team-list strong {
    float: right;
}

.dk-team-list td > p {
    padding-left: 15px;
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
