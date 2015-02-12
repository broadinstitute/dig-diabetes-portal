<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
 <style>
 .aboutIconHolder  {
     margin: auto;
     text-align:center;
     vertical-align: middle;
     height: 170px;
 }
 </style>

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
                <div class="aboutIconHolder">
                    <a href="${createLink(controller:'informational', action:'t2dgenes')}">
                        <img src="${resource(dir: 'images/icons', file: 'basicT2DG.png')}"
                             width="114px" height="144px" alt="T2D Genes"/>
                    </a>
                </div>
                <g:message code="aboutTheData.datasets.t2dgenes" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="aboutIconHolder center-text" style="padding-top: 40px">
                    <a href="${createLink(controller:'informational', action:'got2d')}">
                        <img src="${resource(dir: 'images/icons', file: 'GoT2D.png')}"
                             width="114px" height="79px" alt="T2D Genes"/>
                    </a>
                </div>
                <g:message code="aboutTheData.datasets.got2d" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="aboutIconHolder" style="padding-top: 61px">
                    <a href="http://diagram-consortium.org/about.html">
                        <img src="${resource(dir: 'images/icons', file: 'diagram.png')}"
                                                                            width="180px" height="91px" alt="Diagram GWAS"/>
                    </a>
                </div>
                <g:message code="aboutTheData.datasets.diagram" default="about the data" />
            </div>

            <div class="col-md-3 medText vertDivider">
                <div class="aboutIconHolder" style="padding-top: 66px">
                    <a href="${createLink(controller:'informational', action:'hgat')}"><strong>GWAS<br/> meta-analyses</strong></a>
                </div>
                <g:message code="aboutTheData.datasets.gwasMetaAnalysis" default="about the data" />
            </div>

         </div>


    </div>
</div>

</body>
</html>
