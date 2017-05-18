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
                    <p style="font-weight: 300; font-size: 25px;"><g:message code="aboutTheData.title" default="about the data"/></p>
                </g:if>
                <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                    <p style="font-weight: 300; font-size: 25px;"><g:message code="aboutTheData.MI.descr" default="about the data"/></p>
                </g:elseif>


                <g:else></g:else>

        </div>

        <div class="row" style="margin-top: 10px">

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

            <g:if test="${!g.portalTypeString()?.equals('stroke')}">
                <g:render template="data/t2dData" />

            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                <g:render template="data/strokeData" />




            </g:elseif>
        </div>
    </div>

</body>
</html>
