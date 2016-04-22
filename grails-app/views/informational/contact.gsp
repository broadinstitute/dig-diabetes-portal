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
        <g:if test="${g.portalTypeString()?.equals('t2d')}">
            <h1><g:message code="contact.title" default="Contact"/></h1>
        </g:if>
        <g:else>
            <h1><g:message code="contact.title.plural" default="Contact"/></h1>
        </g:else>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_consortium" class="myPills  activated">
                                <a href="#">
                                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                                        <g:message code="contact.consortium.single_word" default="Consortium"/>
                                    </g:if>
                                    <g:else>
                                        <g:message code="contact.consortium" default="Consortium"/>
                                    </g:else>
                                </a>
                            </li>
                        </div>
                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_cohort" class="myPills">
                                <a href="#">
                                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                                        <g:message code="contact.study.single_word" default="Studies"/>
                                    </g:if>
                                    <g:else>
                                        <g:message code="contact.cohort" default="Studies"/>
                                    </g:else>
                                </a>
                            </li>
                        </div>
                        <div class="col-md-3 text-center">
                            <li role="presentation" id="contact_portal" class="myPills active">
                                <a href="#">
                                    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                                        <g:message code="contact.portal.single_word" default="Portal"/>
                                    </g:if>
                                    <g:else>
                                        <g:message code="contact.portal" default="Portal"/>
                                    </g:else>
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

