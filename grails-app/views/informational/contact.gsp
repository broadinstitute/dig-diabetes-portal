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
        <h1><g:message code="contact.title" default="Contact"/></h1>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">
                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_portal" class="myPills active  activated">
                                <a href="#">
                                    <g:message code="contact.portal" default="cohorts"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_consortium" class="myPills">
                                <a href="#">
                                    <g:message code="contact.consortium" default="exome"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_cohort" class="myPills">
                                <a href="#">
                                    <g:message code="contact.cohort" default="papers"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                        </div>

                    </div>

                </ul>

                <div class="content">
                    <div id="contactContent">
                        <g:render template="contact/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'contactsection')}",
                "#contactContent");
    </script>

</div>

</body>
</html>

