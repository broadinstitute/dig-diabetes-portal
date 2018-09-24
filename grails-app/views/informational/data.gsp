<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst,mustache,datasetsPage"/>
    <r:layoutResources/>
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

    .dataset-name {
        font-size: 25px;
        font-weight: 500;
        margin: 0;
    }

    .datapage-body {
        font-size: 16px;
    }

    .panel {
        border: none !important;
    }

    .panel-heading {
        background: none !important;
        padding: 20px 0 35px 0 !important;
        border-bottom: solid 1px #999 !important;
    }

    .panel-body {
        padding: 15px 0 20px 30px !important;
        border: none;
    }

    .dataset-summary {
        display: block;
        position: relative;
        font-size: 18px;
        font-weight: 200;
        float: right;
        color: #36c;
        top: 5px;
    }

    .data-status-open-access {
        color: #393;
    }

    .data-status-early-phase1-access {
        color: red;
    }

    .dataset-info {
        color: #777;
    }

    .open-info {
        display: block;
        color: #39F !important;
        font-size: 14px;
    }
    </style>


</head>

<body>

<div id="main">
    <div class="container">
        <div class="row">

                <g:if test="${g.portalTypeString()?.equals('t2d')}">
                    <div class="col-md-12">
                        <h1 class="dk-page-title">Data</h1>
                    </div>
                    <div class="col-md-12">
                        <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.title" default="about the data"/></p>
                    </div>

                </g:if>
                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <div class="col-md-12">
                        <h1 class="dk-page-title">Polygenic Risk Score Variant Weights</h1>
                        <p style="font-weight: 300; font-size: 18px;"><g:message code="informational.about.PRS"></g:message></p>
                    <p style="font-weight: 300; font-size: 15px;">
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet"></g:message><br>
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message><br>
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet.citation"></g:message>
                </p>
                    <p style="font-weight: 300; font-size: 15px;"><a href="https://personal.broadinstitute.org/mvon/AtrialFibrillation_PRS_LDpred_rho0.003_v3.zip" target="_blank">Atrial fibrillation (297.3 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/BreastCancer_PRS_PT_r2_0.2_p_0.0005_v3.zip" target="_blank">Breast cancer (253 KB)</a> | <a href="https://personal.broadinstitute.org/mvon/CoronaryArteryDisease_PRS_LDpred_rho0.001_v3.zip" target="_blank">Coronary artery disease (292.9 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/InflammatoryBowelDisease_PRS_LDpred_rho0.1_v3.zip" target="_blank">Inflammatory bowel disease (305.1 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/Type2Diabetes_PRS_LDpred_rho0.01_v3.zip" target="_blank">Type 2 diabetes (305.6 MB)</a>
                    </p>
                    <p><i><g:message code="informational.mi.prsinfo"></g:message></i></p>
</table>
                    </div>
                    <div class="col-md-12">
                        <h1 class="dk-page-title">Download Summary Statistics</h1>
                    </div>
                    <div class="col-md-12">
                        <table class="table table-condensed table-responsive table-striped" border="1">
                            <tr><th><b>PubMed ID</b></th><th><b>Title</b></th><th><b>Download files</b></th></tr>

                            <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30220432" target="_blank">PMID:30220432</a></td><td>Genetic Association of Albuminuria with Cardiometabolic Disease and Blood Pressure</td><td><a href="https://personal.broadinstitute.org/mvon/UKB.v2.albuminuria.n382500.zip">UKB.v2.albuminuria.n382500.zip</a></td></tr>
                            <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30012220" target="_blank">PMID:30012220</a></td><td>Exome-chip meta-analysis identifies novel loci associated with cardiac conduction, including ADAMTS6.</td><td><a href="https://data.mendeley.com/datasets/7jgbckpdr4/1" target="_blank">Download files</a></td></tr>


                        </table>
                    </div>

                    <div class="col-md-12">
                        <h1 class="dk-page-title">Genetic Association Datasets</h1>
                    </div>
                    <div class="col-md-12">
                        <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.MI.descr" default="about the data"/></p>
                    </div>


                </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                <div class="col-md-12">
                    <h1 class="dk-page-title">Data</h1>
                </div>
                <div class="col-md-12">
                    <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.epi.descr" default="about the data"/></p>
                </div>
            </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                    <div class="col-md-12">
                        <h1 class="dk-page-title">Data</h1>
                    </div>
                    <div class="col-md-9">
                        <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.stroke.title1" default="about the data"/></p>
                        <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.stroke.title2" default="about the data"/></p>
                    </div>
                    <div class="col-md-3">
                        <div class="dk-go-button dk-t2d-yellow dk-right-column-buttons"><a target="_blank" href="http://cerebrovascularportal.org/informational/downloads">Visit download page</a></div>
                    </div>
                </g:elseif>
<g:elseif test="${g.portalTypeString()?.equals('sleep')}">
    <div class="col-md-12">
        <h1 class="dk-page-title">Data</h1>
    </div>
    <div class="col-md-12">
        <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.sleep.title" default="about the data"/></p>
    </div>

</g:elseif>


    </div>
</div>
</div>
        <div class="container">
            <g:renderBetaFeaturesDisplayedValue>
                <div style="margin-top: 5px">
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

                    <select id="versionDatasetFilter" class="form-control">
                        <g:each in="${allVersions}" var="ver">
                            <option value="${ver}">${ver}</option>
                        </g:each>
                    </select>

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
                function showSection(event) {
                    $(event.target.nextElementSibling).toggle();
                }

                var mpgSoftware = mpgSoftware || {};
                $(document).ready(function () {
                    "use strict";
                    var defaultColoring;
                    var colorByAncestry = d3.scale.ordinal()
                            .domain(['Mixed', 'African American', 'East Asian', 'European', 'Hispanic', 'South Asian'])
                            .range(["#cccccc", "#ff7f0e", "#98df8a", "#d62728", "#aec7e8", "#e377c2"]);
                    mpgSoftware.resetSunburst = function () {
                        var versionDatasetFilter = $("#versionDatasetFilter").val();
                        var technologyFilter = $("#technologyFilter").val();
                        if (technologyFilter === 'all') {
                            technologyFilter = '';
                        }
                        var coloringOption = $("input[name=coloring]:checked").val()
                        $('#sunburstdiv').empty();
                        $('.toolTextAppearance').remove();
                        mpgSoftware.launchSunburst(versionDatasetFilter, technologyFilter, coloringOption);
                    };

                    mpgSoftware.launchSunburst = function (metadataVersion, technology, coloringOption) {
                        var loading = $('#spinner').show();
                        var colorScale;
                        switch (coloringOption) {
                            case "1":
                                colorScale = defaultColoring;
                                break;
                            case "2":
                                colorScale = colorByAncestry;
                                break;
                            default:
                                colorScale = defaultColoring;
                                break;
                        }
                        $.ajax({
                            cache: false,
                            type: "get",
                            url: '<g:createLink controller="informational" action="aboutTheDataAjax" />',
                            data: {
                                metadataVersion: metadataVersion,
                                technology: technology
                            },
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


            %{--<g:if test="${g.portalTypeString()?.equals('stroke')}">--}%
                %{--<g:render template="data/strokeData" />--}%

            %{--</g:if>--}%
            %{--<g:else>--}%
                <g:render template="data/t2dData" />

            %{--</g:else>--}%
        </div>
    </div>
</body>
</html>
