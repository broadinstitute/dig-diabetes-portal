<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>
</head>

<body>

<div id="main">
    <div class="container">
        <h1>About the data</h1>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="aboutSigma_about" class="myPills  activated">
                                <a href="#">
                                    <g:message code="sigma.information.home"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="aboutSigma_cohorts" class="myPills">
                                <a href="#">
                                    <g:message code="sigma.information.data"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="aboutSigma_papers" class="myPills active">
                                <a href="#">
                                    <g:message code="sigma.information.papers"/>
                                </a>
                            </li>
                        </div>


                        <div class="col-md-3 text-center">
                            <li role="presentation" id="aboutSigma_people" class="myPills active">
                                <a href="#">
                                    <g:message code="sigma.information.people"/>
                                </a>
                            </li>
                        </div>

                    </div>

                </ul>

                <div class="content" style="margin-top:40px">
                    <div id="sigmaAboutTheData">
                        <g:render template="sigma/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'aboutSigmaSection')}",
                "#sigmaAboutTheData");
    </script>


</body>
</html>
