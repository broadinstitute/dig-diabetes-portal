<!DOCTYPE html>
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
        <h1><g:message code="got2d.title" default="GoT2D"/></h1>

        <p>
            <g:message code="got2d.descr" default="GoT2D descr"/>
        </p>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">
                        <div class="col-md-3 text-center">
                            <li role="presentation" id="got2d_cohorts" class="myPills active activated">
                                <a  href="#">
                                    <g:message code="got2d.subsection.cohorts" default="cohorts"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="got2d_exomechip" class="myPills">
                                <a href="#">
                                    <g:message code="got2d.subsection.exome" default="exome"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="got2d_papers" class="myPills">
                                <a href="#">
                                    <g:message code="got2d.subsection.papers" default="papers"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="got2d_people" class="myPills">
                                <a href="#">
                                    <g:message code="got2d.subsection.people" default="people"/>
                                </a>
                            </li>
                        </div>

                    </div>

                </ul>

                <div class="content">
                    <div id="got2dContent">
                        <g:render template="got2dsection/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                       "${createLink(controller:'informational',action:'got2dsection')}",
                       "#got2dContent");
    </script>

</div>

</body>
</html>
