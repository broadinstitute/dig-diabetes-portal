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
        <div class="row" style="margin-bottom: 20px">
            <div class="col-md-2 col-md-offset-5 text-center">
            <img src="${resource(dir: 'images/icons', file: 'basicT2DG.png')}"
                 width="197px" height="250px" alt="T2D Genes"/>
            </div>
            <div class="col-md-5"></div>
        </div>

        <p>
            <g:message code="t2dgenes.mainPage.descr" default="t2dgenes description"/>

        </p>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">
                        <div class="col-md-2 text-center" id="aboutt2dDiv_cohorts">
                            <li role="presentation" id="aboutt2d_cohorts" class="myPills active activated">
                                <a href="#">
                                  <g:message code="got2d.subsection.cohorts" default="cohorts"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center" id="aboutt2dDiv_papers">
                            <li role="presentation" id="aboutt2d_papers" class="myPills">
                                <a href="#">
                                   <g:message code="got2d.subsection.papers" default="papers"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center" id="aboutt2dDiv_people">
                            <li role="presentation" id="aboutt2d_people" class="myPills">
                                <a href="#">
                                   <g:message code="got2d.subsection.people" default="people"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center" id="aboutt2dDiv_project1">
                            <li role="presentation" id="aboutt2d_project1" class="myPills">
                                <a href="#">
                                    <g:message code="beacon.label.project"/> 1
                                </a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center" id="aboutt2dDiv_project2">
                            <li role="presentation" id="aboutt2d_project2" class="myPills">
                                <a href="#">
                                    <g:message code="beacon.label.project"/> 2
                                </a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center" id="aboutt2dDiv_project3">
                            <li role="presentation" id="aboutt2d_project3" class="myPills">
                                <a href="#">
                                    <g:message code="beacon.label.project"/> 3
                                </a>
                            </li>
                        </div>
                    </div>

                </ul>

                <div class="content">
                    <div id="t2dgeneContent">
                        <g:render template="t2dsection/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
            "${createLink(controller:'informational',action:'t2dgenesection')}",
            "#t2dgeneContent");
</script>


</div>

</body>
</html>
