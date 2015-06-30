<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
 <style>
 .aboutIconHolder {
     margin: auto;
     text-align: center;
     vertical-align: middle;
     height: 170px;
 }
 .consortium-spacing {
     padding-top: 25px;
 }
 </style>

<div id="main">
    <div class="container">
        <div class="row pull-left">
            <div>
                <h1><g:message code="aboutTheData.title" default="about the data" /></h1>
            </div>
        </div>

        <div class="row pull-left col-xs-12">
            <div class="medText">
                <g:message code="aboutTheData.descr" default="about the data" />
            </div>
        </div>

        <div class="row pull-left consortium-spacing">
            <div>
                <a href="${createLink(controller:'informational', action:'t2dgenes')}">
                    <img src="${resource(dir: 'images/icons', file: 'basicT2DG.png')}"
                         width="114px" height="144px" alt="T2D Genes"/>
                </a>
            </div>
        </div>

        <div class="row pull-left medText consortium-spacing col-xs-12">
            <g:message code="aboutTheData.datasets.t2dgenes" default="about the data" />
        </div>

        <div class="row pull-left consortium-spacing">
            <div>
                <a href="${createLink(controller:'informational', action:'got2d')}">
                    <img src="${resource(dir: 'images/icons', file: 'GoT2D.png')}"
                         width="114px" height="79px" alt="Go T2D"/>
                </a>
            </div>
        </div>

        <div class="row pull-left medText consortium-spacing col-xs-12">
            <g:message code="aboutTheData.datasets.got2d" default="about the data" />
        </div>

        <div class="row pull-left consortium-spacing">
            <div>
                <a href="http://www.sigmaT2D.org">
                    <img src="${resource(dir: 'images/icons', file: 'SlimSigmaLogo234fromai-outlines.jpg')}"
                         width="180" height="91px" alt="SLIM"/>
                </a>
            </div>
        </div>

        <div class="row medText consortium-spacing col-xs-12">
            <g:message code="aboutTheData.datasets.sigmat2d" default="about the data" />
        </div>


        <div class="row pull-left consortium-spacing">
            <div>
                <a href="http://diagram-consortium.org/about.html">
                    <img src="${resource(dir: 'images/icons', file: 'diagram.png')}"
                         width="180" height="91px" alt="Diagram GWAS"/>
                </a>
            </div>
        </div>

        <div class="row pull-left medText consortium-spacing col-xs-12">
            <g:message code="aboutTheData.datasets.diagram" default="about the data" />
        </div>

        <div class="row pull-left consortium-spacing">
            <div class="medText">
                <a href="${createLink(controller:'informational', action:'hgat')}"><strong>GWAS<br/> meta-analyses</strong></a>
            </div>
        </div>

        <div class="row pull-left medText consortium-spacing col-xs-12">
            <g:message code="aboutTheData.datasets.gwasMetaAnalysis" default="about the data" />
        </div>

    </div>
</div>

</body>
</html>
