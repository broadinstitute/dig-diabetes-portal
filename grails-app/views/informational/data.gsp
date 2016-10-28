<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
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

            <p style="font-weight: 300; font-size: 25px;">
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <g:message code="aboutTheData.stroke.descr" default="about the data"/>
                </g:if>
                <g:else><g:message code="aboutTheData.title" default="about the data"/></g:else>
            </p>
        </div>

        <div class="row pull-left col-xs-12" style="margin-top: 10px">

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

            <g:if test="${!g.portalTypeString()?.equals('stroke')}">
                <g:render template="data/t2dData" />

            </g:if>
            <g:else>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.gocha.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.gocha.pi" default="about the data"/>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.gocha" default="about the data"/>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.gerfhs.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.gerfhs.pi" default="about the data"/>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.gerfhs" default="about the data"/>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.european_centers.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.european_centers" default="about the data"/>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.hospital_del_mar.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.hospital_del_mar.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.juhss.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.juhss.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.lund_stroke.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.lund_stroke.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.vhh_ich.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.vhh_ich.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.for_published_results"/><br/>
                    <g:message code="aboutTheData.stroke.datasets.isgc.pi.reference" default="about the data"/>
                </div>


                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>


                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.metastroke.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.metastroke.pi" default="about the data"/>
                </div>

                <div class="row pull-left medText col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.metastroke" default="about the data"/>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.asgc.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.asgc.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.brains.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.brains.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.geos.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.geos.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.hps.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.hps.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.isgs_swiss.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.isgs_swiss.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.gasros.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.gasros.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.milan.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.milan.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.wtccc_deutschland.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.wtccc_deutschland.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.wtccc_england.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.wtccc_england.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.visp.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.visp.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>

                    <div class="pull-left medText col-xs-11">
                        <strong><g:message code="aboutTheData.stroke.datasets.whi.title"/></strong><br/>
                        <g:message code="aboutTheData.stroke.datasets.whi.pi" default="about the data"/>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <g:message code="aboutTheData.stroke.datasets.for_published_results"/><br/>
                    <g:message code="aboutTheData.stroke.datasets.metastroke.pi.reference" default="about the data"/>
                </div>

                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.CADISP.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
     <div class="pull-left col-xs-1"></div>
     </div>

                <div class="pull-left medText col-xs-11">
                <g:message code="aboutTheData.stroke.datasets.CADISP.project"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
     <div class="pull-left col-xs-1"></div>
     </div>

 <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.CADISP.publications"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
     <div class="pull-left col-xs-1"></div>
     </div>

     <div class="pull-left medText col-xs-11">
                <g:message code="aboutTheData.stroke.datasets.CADISP.phenotypes"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
     <div class="pull-left col-xs-1"></div>
     </div>


                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.CADISP.subjects"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
     <div class="pull-left col-xs-1"></div>
     </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.CADISP.criteria"></g:message>
                </div>


                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.Cincinnati.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.Cincinnati.project"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.Cincinnati.phenotypes"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.Cincinnati.subjects"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.Cincinnati.criteria"></g:message>
                </div>

                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.SIGN.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.SIGN.project"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.SIGN.publications"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.SIGN.phenotypes"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.SIGN.subjects1"></g:message>
                    <g:message code="aboutTheData.stroke.datasets.SIGN.subjects2"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.SIGN.criteria"></g:message>
                </div>

                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>

                <div class="row pull-left consortium-spacing">
                    <div class="medText">
                        <strong><g:message code="aboutTheData.stroke.datasets.MEGASTROKE.title"/></strong>
                    </div>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.MEGASTROKE.phenotypes"></g:message>
                </div>

                <div class="row pull-left medText consortium-spacing col-xs-12">
                    <div class="pull-left col-xs-1"></div>
                </div>

                <div class="pull-left medText col-xs-11">
                    <g:message code="aboutTheData.stroke.datasets.MEGASTROKE.subjects1"></g:message>
                    <g:message code="aboutTheData.stroke.datasets.MEGASTROKE.subjects2"></g:message>
                    <g:message code="aboutTheData.stroke.datasets.MEGASTROKE.subjects3"></g:message>
                </div>
                <div class="row pull-left col-xs-12" style="margin-top: 10px">
                    <div class="separator"></div>
                </div>

            </g:else>
        </div>
    </div>

</body>
</html>
