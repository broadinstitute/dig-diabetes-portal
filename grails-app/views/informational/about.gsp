<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>


<div id="main">
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <h1><g:message code="aboutTheData.title" default="about the data" /></h1>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 medText">
                <g:message code="aboutTheData.descr" default="about the data" />
            </div>
        </div>
        <div class="row sectionBuffer">

            <div class="col-md-3 medText">
                <div class="iconHolder">
                    <a href="${createLink(controller:'informational', action:'t2dgenes')}">T2D-GENES:</a>
                </div>
                <g:message code="aboutTheData.datasets.t2dgenes" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="iconHolder center-text">
                    <a href="${createLink(controller:'informational', action:'got2d')}">GoT2D:</a>
                </div>
                <g:message code="aboutTheData.datasets.got2d" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="iconHolder">
                    <a href="http://diagram-consortium.org/about.html">DIAGRAM:</a>
                </div>
                <g:message code="aboutTheData.datasets.diagram" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="iconHolder">
                    <a href="${createLink(controller:'informational', action:'hgat')}">GWAS meta-analyses:</a>
                </div>
                <g:message code="aboutTheData.datasets.gwasMetaAnalysis" default="about the data" />
            </div>

         </div>


    </div>
</div>

</body>
</html>
