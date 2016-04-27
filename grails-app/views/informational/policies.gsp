<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

</head>

<body>
<style>
.consortium-spacing {
    padding-top: 15px;
}
</style>

<div id="main">

    <div class="container">
        <h1><g:message code="policies.title" default="Policies"/></h1>

        <div class="row">
            <div class="buttonHolder tabbed-about-page">

<g:if test="${!g.portalTypeString()?.equals('stroke')}">
                <ul class="nav nav-pills">
                    <div class="row">

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="policies_dataUse" class="myPills activated">
                                <a href="#">
                                    <g:message code="policies.dataUse" default="exome"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="policies_citation" class="myPills">
                                <a href="#">
                                    <g:message code="policies.citations" default="papers"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="policies_reusing" class="myPills">
                                <a href="#">
                                    <g:message code="policies.reusing" default="papers"/>
                                </a>
                            </li>
                        </div>

                        <div class="col-md-3 text-center">
                            <li role="presentation" id="policies_tracking" class="myPills active">
                                <a href="#">
                                    <g:message code="policies.tracking" default="cohorts"/>
                                </a>
                            </li>
                        </div>


                    </div>

                </ul>
</g:if>
<g:else>
    <div class="row pull-left medText col-xs-12">
    The Cerebrovascular Disease Knowledge Portal will (a) serve as the gateway to a large and growing aggregation of data relevant to the genetics of cerebrovascular disease and its complications; (b) automate analyses required to interpret those data; and (c) provide a customizable workspace for permitted investigators who wish to perform analyses not otherwise available on the Portal.
    </div>
</g:else>
                <div class="content">
                    <div id="policiesContent">
                        <g:render template="policies/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'policiessection')}",
                "#policiesContent");
    </script>

</div>

</body>
</html>

