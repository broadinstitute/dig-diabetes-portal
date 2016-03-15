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
        <g:message code="aboutTheData.descr" default="about the data"/>
    </div>
</div>

<div class="row pull-left col-xs-12" style="margin-top: 10px">
<div class="separator"></div>
</div>

<div class="row pull-left col-xs-12" style="margin-top: 10px">
    <div class="col-xs-3"></div>

    <div class="col-xs-3 pull-right">
        <select id="versionDatasetFilter" class="form-control">
            <option>mdv1</option>
            <option selected>mdv2</option>
            <option>mdv3</option>
            <option>mdv5</option>
        </select>
    </div>

    <div class="col-xs-3 pull-right">
        <select id="technologyFilter" class="form-control">
            <option selected>none</option>
            <option>GWAS</option>
            <option>ExSeq</option>
            <option>ExChip</option>
        </select>

    </div>

    <div class="col-xs-3">
        <button id="opener" class="btn btn-primary pull-right" onclick="mpgSoftware.resetSunburst()">
            Reset graphic
        </button>
    </div>
</div>

<div class="row pull-left col-xs-12" style="margin-top: 20px">
    <div id="sunburstdiv">

    </div>

</div>

<script>
    var mpgSoftware = mpgSoftware || {};
    $(document).ready(function () {
        "use strict";
        mpgSoftware.resetSunburst = function () {
            var versionDatasetFilter = $("#versionDatasetFilter").val();
            var technologyFilter = $("#technologyFilter").val();
            $('#sunburstdiv').empty();
            mpgSoftware.launchSunburst(versionDatasetFilter, technologyFilter);
        };

        mpgSoftware.launchSunburst = function (metadataVersion, technology) {
            var loading = $('#spinner').show();
            var continuousColorScale = d3.scale.linear()
                    .domain([0.5, 0.5])
                    .range(["#000", "#000"]);
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
                        baget.createASunburst(1200, 1200, 5, 1000, continuousColorScale, 'div#sunburstdiv', data);
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
        mpgSoftware.launchSunburst('', '');
    });

</script>


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

</div>
</div>

</body>
</html>
