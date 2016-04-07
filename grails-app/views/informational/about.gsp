<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
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
        <h1><g:message code="aboutTheData.title" default="about the data"/></h1>
    </div>
</div>

<div class="row pull-left col-xs-12">
    <div class="medText">
        <g:if test="${!g.portalTypeString()?.equals('stroke')}">
            <g:message code="aboutTheData.descr" default="about the data"/>
        </g:if>
        <g:else>
            <g:message code="aboutTheData.stroke.descr" default="about the data"/>
        </g:else>
    </div>
</div>

<div class="row pull-left col-xs-12" style="margin-top: 10px">
<div class="separator"></div>
</div>

<g:renderBetaFeaturesDisplayedValue>
    <div class="row pull-left col-xs-12" style="margin-top: 5px">
        <div class="col-xs-2"></div>
        <div class="col-xs-10"  style="padding: 5px 0 12px 0; border: 1px solid #aaaaaa">
            <div class="row col-xs-12">

                <div class="col-xs-3">
                    <button id="opener" class="btn btn-primary pull-right" onclick="mpgSoftware.resetSunburst()"    style="margin: 16px 35px 0 0">
                        Apply filters
                    </button>
                </div>

                <div class="col-xs-3">
                    <span style="text-decoration: underline; padding:35px 0 0 30px; margin-bottom: 0">Color mapping</span>
                    <div class="radio" style="margin-top: 0">
                        <div>
                            <label>
                                <input type="radio" id="defaultColoring" name="coloring" value="1" checked/>Default coloring
                            </label>
                        </div>
                        <div>
                            <label>
                                <input type="radio" id="ancestryColoring" name="coloring" value="2" />Color by ancestry
                            </label>
                        </div>

                    </div>
                </div>

                <div class="col-xs-3">
                    <span class="pull-right">Version filter</span>
    <sec:ifAllGranted roles="ROLE_SYSTEM">
        <select id="versionDatasetFilter" class="form-control">
            <option value="mdv1">mdv1 (T2D)</option>
            <option value="mdv2" selected>latest</option>
            <option value="mdv3">mdv3 (T2D)</option>
            <option value="mdv5">mdv5 (stroke)</option>
        </select>
    </sec:ifAllGranted>
    <sec:ifNotGranted roles="ROLE_SYSTEM">
        <select id="versionDatasetFilter" class="form-control" disabled>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <option value="mdv5" selected>mdv5 (stroke)</option>
            </g:if>
            <g:else>
                <option value="mdv1">mdv1 (T2D)</option>
                <option value="mdv2" selected>latest</option>
                <option value="mdv3">mdv3 (T2D)</option>
                <option value="mdv5">mdv5 (stroke)</option>
            </g:else>
        </select>
    </sec:ifNotGranted>
    </div>

    <div class="col-xs-3">
        <span class="pull-right">Technology filter</span>
        <select id="technologyFilter" class="form-control">
            <option selected>all</option>
            <option value="GWAS">GWAS</option>
            <option value="ExSeq">Exome sequencing</option>
            <option value="ExChip">Exome chip</option>
        </select>

    </div>

    </div>

</div>

</g:renderBetaFeaturesDisplayedValue>


<g:renderBetaFeaturesDisplayedValue>
    <div class="row pull-left col-xs-12" style="margin-top: 20px">
        <div id="sunburstdiv">

        </div>

    </div>
</g:renderBetaFeaturesDisplayedValue>

<script>
    var mpgSoftware = mpgSoftware || {};
    $(document).ready(function () {
        "use strict";
        var defaultColoring;
        var colorByAncestry = d3.scale.ordinal()
                .domain(['Mixed','African American','East Asian','European','Hispanic','South Asian'])
                .range(["#cccccc", "#ff7f0e","#98df8a", "#d62728","#aec7e8", "#e377c2"]);
        mpgSoftware.resetSunburst = function () {
            var versionDatasetFilter = $("#versionDatasetFilter").val();
            var technologyFilter = $("#technologyFilter").val();
            if (technologyFilter==='all'){
                technologyFilter = '';
            }
            var coloringOption = $("input[name=coloring]:checked").val()
            $('#sunburstdiv').empty();
            $('.toolTextAppearance').remove();
            mpgSoftware.launchSunburst(versionDatasetFilter, technologyFilter,coloringOption);
        };

        mpgSoftware.launchSunburst = function (metadataVersion, technology,coloringOption) {
            var loading = $('#spinner').show();
            var colorScale;
            switch (coloringOption)  {
                case "1": colorScale =  defaultColoring;  break;
                case "2": colorScale =  colorByAncestry;  break;
                default: colorScale =  defaultColoring;  break;
            }
            $.ajax({
                cache: false,
                type: "get",
                url: '<g:createLink controller="informational" action="aboutTheDataAjax" />',
                data: {metadataVersion: metadataVersion,
                    technology: technology},
                async: false,
                success: function (data) {
                    //sunburst =  baget.createASunburst;
                    if (data.children !== undefined) {
                        baget.createASunburst(1200, 1200, 5, 1000, colorScale, 'div#sunburstdiv', data);
                    } else {
                        d3.select('div#sunburstdiv')
                                .append('div')
                                .attr("width", 4000)
                                .attr("height", 1400)
                                .style("padding-top", '200px')
                                .style("text-align", 'center')
                                .append("h1")
                                .html("No off-embargo assay data are  available for this compound.<br /><br />" +
                                        "Please either choose a different compound, or else come<br />" +
                                        "back later when more assay data may have accumulated.");
                    }

                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
<g:renderBetaFeaturesDisplayedValue>
        mpgSoftware.launchSunburst('', '', undefined);
</g:renderBetaFeaturesDisplayedValue>

    });

</script>


<g:renderBetaFeaturesDisplayedValue>
<div class="span3" style="padding-top: 50px;  height: 600px;">
    <div style="float:right;">

        <div id="legendGoesHere"></div>
        <script>

            //                    if ($data[0].children !== undefined) {
            //                        createALegend(120, 200, 100, continuousColorScale, 'div#legendGoesHere', minimumValue, maximumValue);
            //                    }
        </script>

    </div>

    <div style="text-align: center; vertical-align: bottom;">

        <select id="coloringOptions" style="visibility: hidden">
            <option value="1">Color by activity</option>
            <option value="2">Split classes by activity</option>
            <option value="3">Color by class</option>
        </select>

        <div style="padding-top: 320px;"></div>
        <select id="activity" style="visibility: hidden">
            <option value="1">Active only</option>
            <option value="2">Inactive only</option>
            <option value="3"
                    selected>Active and Inactive</option>
        </select>

    </div>

</div>
</g:renderBetaFeaturesDisplayedValue>

<g:if test="${!g.portalTypeString()?.equals('stroke')}">
<div class="row pull-left consortium-spacing">
    <div>
        <a href="${createLink(controller: 'informational', action: 't2dgenes')}">
            <img src="${resource(dir: 'images/icons', file: 'basicT2DG.png')}"
                 width="114px" height="144px" alt="T2D Genes"/>
        </a>
    </div>
</div>

<div class="row pull-left medText consortium-spacing col-xs-12">
    <g:message code="aboutTheData.datasets.t2dgenes" default="about the data"/>
</div>

<div class="row pull-left consortium-spacing">
    <div>
        <a href="${createLink(controller: 'informational', action: 'got2d')}">
            <img src="${resource(dir: 'images/icons', file: 'GoT2D.png')}"
                 width="114px" height="79px" alt="Go T2D"/>
        </a>
    </div>
</div>

<div class="row pull-left medText consortium-spacing col-xs-12">
    <g:message code="aboutTheData.datasets.got2d" default="about the data"/>
</div>

<div class="row pull-left consortium-spacing">
    <div>
        <a href="http://www.sigmaT2D.org">
            <g:if test="${locale?.startsWith('es')}">
                <img src="${resource(dir: 'images/', file: 'LogoSIGMASPANISH.png')}"
                     width="180" height="91px" alt="SLIM"/>
            </g:if>
            <g:else>
                <img src="${resource(dir: 'images/', file: 'LogoSigmaENGLISH.png')}"
                     width="180" height="91px" alt="SLIM"/>
            </g:else>
        </a>
    </div>
</div>

<div class="row medText consortium-spacing col-xs-12">
    <g:message code="aboutTheData.datasets.sigmat2d" default="about the data"/>
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
    <g:message code="aboutTheData.datasets.diagram" default="about the data"/>
</div>

<div class="row pull-left consortium-spacing">
    <div class="medText">
        <a href="${createLink(controller: 'informational', action: 'hgat')}"><strong><g:message
                code='gene.variantassociations.table.rowhdr.gwas'/><br/> <g:message
                code='gene.variantassociations.table.rowhdr.meta_analyses'/></strong></a>
    </div>
</div>

<div class="row pull-left medText consortium-spacing col-xs-12">
    <g:message code="aboutTheData.datasets.gwasMetaAnalysis" default="about the data"/>
</div>

</g:if>
<g:else>
    <div class="row pull-left consortium-spacing">
        <div class="medText">
            <strong><g:message code="aboutTheData.stroke.datasets.race.title"/></strong>
        </div>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <g:message code="aboutTheData.stroke.datasets.race" default="about the data"/>
    </div>

    <div class="row pull-left consortium-spacing">
        <div class="medText">
            <strong><g:message code="aboutTheData.stroke.datasets.gerfhs.title"/></strong>
        </div>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <g:message code="aboutTheData.stroke.datasets.gerfhs" default="about the data"/>
    </div>

    <div class="row pull-left consortium-spacing">
        <div class="medText">
            <strong><g:message code="aboutTheData.stroke.datasets.gocha.title"/></strong>
        </div>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <g:message code="aboutTheData.stroke.datasets.gocha" default="about the data"/>
    </div>

    <div class="row pull-left consortium-spacing">
        <div class="medText">
            <strong><g:message code="aboutTheData.stroke.datasets.gwas_eu.title"/></strong>
        </div>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <g:message code="aboutTheData.stroke.datasets.gwas_eu" default="about the data"/>
    </div>

    <div class="row pull-left consortium-spacing">
        <div class="medText">
            <strong><g:message code="aboutTheData.stroke.datasets.malmo.title"/></strong>
        </div>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <g:message code="aboutTheData.stroke.datasets.malmo" default="about the data"/>
    </div>

</g:else>
</div>
</div>

</body>
</html>
