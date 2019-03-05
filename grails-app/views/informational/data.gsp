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
                <h1 class="dk-page-title">Polygenic Risk Scores</h1>

                <p style="font-weight: 300; font-size: 18px;"><g:message code="informational.about.PRS"></g:message></p>
                <p style="font-weight: 300; font-size: 15px;">
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet"></g:message><br>
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet.author"></g:message><g:message code="informational.shared.publications.etal"></g:message><br>
                    <g:message code="informational.shared.publications.Khera_2018_NatGenet.citation"></g:message><br>
                </p>
                <p style="font-weight: 300; font-size: 15px;">
                    <a href="https://personal.broadinstitute.org/mvon/AtrialFibrillation_PRS_LDpred_rho0.003_v3.zip" target="_blank">Atrial fibrillation (297.3 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/BreastCancer_PRS_PT_r2_0.2_p_0.0005_v3.zip" target="_blank">Breast cancer (253 KB)</a> | <a href="https://personal.broadinstitute.org/mvon/CoronaryArteryDisease_PRS_LDpred_rho0.001_v3.zip" target="_blank">Coronary artery disease (292.9 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/InflammatoryBowelDisease_PRS_LDpred_rho0.1_v3.zip" target="_blank">Inflammatory bowel disease (305.1 MB)</a> | <a href="https://personal.broadinstitute.org/mvon/Type2Diabetes_PRS_LDpred_rho0.01_v3.zip" target="_blank">Type 2 diabetes (305.6 MB)</a>
                </p>
                <p>
                    <i><g:message code="informational.mi.prsinfo"></g:message></i>
                </p>
                <hr width="70%" size="10">
                <p style="font-weight: 300; font-size: 18px;">
                    <g:message code="informational.data.download.LTRfile2"></g:message></p>
                <p style="font-weight: 300; font-size: 15px;">
                    <g:message code="informational.shared.publications.Weng_2017_Circulation"></g:message><br>
                    <g:message code="informational.shared.publications.Weng_2017_SciRep.author"></g:message><g:message code="informational.shared.publications.etal"></g:message>
                    <g:message code="informational.shared.publications.Weng_2017_Circulation.citation"></g:message><br>
                </p>
            </div>

            <div class="col-md-12">
                <h1 class="dk-page-title">Download Summary Statistics</h1>
            </div>
            <div class="col-md-12">
                <table class="table table-condensed table-responsive table-striped" border="1">
                    <tr><th><b>PubMed ID</b></th><th><b>Title</b></th><th><b>Download files</b></th><th><b>README files</b></th></tr>


                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30535219" target="_blank">PMID:30535219</a></td><td>Association between titin loss-of-function variants and early-onset atrial fibrillation.</td><td><a href="https://personal.broadinstitute.org/mvon/2018.AF.WGS.TOPMed.zip" target="_blank">Download files</a></td><td><a href="https://s3.amazonaws.com/broad-portal-resources/CVDKP/AF_WGS_TOPMed_Freeze4_GWAS.README.txt" target="_blank">README</a></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30586722" target="_blank">PMID:30586722</a></td><td>Phenotypic Refinement of Heart Failure in a National Biobank Facilitates Genetic Discovery.</td><td><a href="https://personal.broadinstitute.org/mvon/2018.HRC.GWAS.UKBB.zip" target="_blank">Download files</a></td><td><a href="https://s3.amazonaws.com/broad-portal-resources/CVDKP/Heart_failure_GWAS_README.txt" target="_blank">README</a></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30220432" target="_blank">PMID:30220432</a></td><td>Genetic Association of Albuminuria with Cardiometabolic Disease and Blood Pressure.</td><td><a href="https://personal.broadinstitute.org/mvon/UKB.v2.albuminuria.n382500.zip" target="_blank">Download files</a></td><td><a href="https://s3.amazonaws.com/broad-portal-resources/CVDKP/UKB.v2.albuminuria.n382500.README.txt" target="_blank">README</a></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30012220" target="_blank">PMID:30012220</a></td><td>Exome-chip meta-analysis identifies novel loci associated with cardiac conduction, including ADAMTS6.</td><td><a href="https://data.mendeley.com/datasets/7jgbckpdr4/1" target="_blank">Download files</a></td><td><g:message code="informational.data.download.QRS_README"></g:message></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/29892015" target="_blank">PMID:29892015</a></td><td>Multi-ethnic genome-wide association study for atrial fibrillation.</td><td><a href="https://personal.broadinstitute.org/mvon/AF_HRC_GWAS_ALLv11.zip" target="_blank">Download files</a></td><td><g:message code="informational.data.download.AF_HRC_README"></g:message></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/29748316" target="_blank">PMID:29748316</a></td><td>Common and Rare Coding Genetic Variation Underlying the Electrocardiographic PR Interval.</td><td><a href="https://personal.broadinstitute.org/mvon/29748316.PR.interval.ExomeChip.zip" target="_blank">Download files</a></td><td><g:message code="informational.data.download.EPRI_README"></g:message></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/28794112" target="_blank">PMID:28794112</a></td><td>Fifteen Genetic Loci Associated With the Electrocardiographic P Wave.</td><td><a href="https://personal.broadinstitute.org/mvon/28794112.PWI.GWAS.zip" target="_blank">Download files</a></td><td><g:message code="informational.data.download.PWI_README"></g:message></td></tr>
                    <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/28416818" target="_blank">PMID:28416818</a></td><td>Large-scale analyses of common and rare variants identify 12 new loci associated with atrial fibrillation.</td><td><a href="https://personal.broadinstitute.org/mvon/28416818.2017.AFGen.GWAS.zip" target="_blank">Download files</a></td><td><g:message code="informational.data.download.AFGen2017_README"></g:message></td></tr>


                </table>
            </div>

            <div class="col-md-12">
                <h1 class="dk-page-title">Genetic Association Datasets</h1>
            </div>
            <div class="col-md-12">
                <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.MI.descr" default="about the data"/></p>
            </div>


        </g:elseif>

            <g:elseif test="${g.portalTypeString()?.equals('sleep')}">


                <div class="col-md-12">
                    <h1 class="dk-page-title">Download Summary Statistics</h1>
                </div>
                <div class="col-md-12">
                    <table class="table table-condensed table-responsive table-striped" border="1">
                        <tr><th><b>PubMed ID</b></th><th><b>Title</b></th><th><b>Download files</b></th><th><b>README files</b></th></tr>

                        <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30696823" target="_blank">PMID:30696823</a></td><td>Genome-wide association analyses of chronotype in 697,828 individuals provides insights into circadian rhythms.</td>
                            <td>Chronotype associations: <a href="https://personal.broadinstitute.org/mvon/chronotype_raw_BOLT.output_HRC.only_plus.metrics_maf0.001_hwep1em12_info0.3.txt.gz" target="_blank">Download</a><br>
                                Morning person (binary chronotype) associations: <a href="https://personal.broadinstitute.org/mvon/morning_person_BOLT.output_HRC.only_plus.metrics_maf0.001_hwep1em12_info0.3_logORs.txt.gz" target="_blank">Download</a><br>
                                </td><td><a href="https://s3.amazonaws.com/broad-portal-resources/sleep/chronotype_raw_README" target="_blank">Chronotype README</a><br><a href="https://s3.amazonaws.com/broad-portal-resources/sleep/morning_person_README.txt" target="_blank">Morning person README</a></td></tr>

                        <tr><td>Cade <i>et al</i>. 2019, in press</td><td>Associations of Variants In the Hexokinase 1 and Interleukin 18 Receptor Regions with Oxyhemoglobin Saturation During Sleep.</td>
                            <td>Associations with average oxyhemoglobin saturation during sleep (average SpO2): <a href="https://personal.broadinstitute.org/mvon/cade_et_al_2018_average_spo2_multiethnic_discovery_replication.txt.zip" target="_blank">Download</a><br>
                                Associations with minimum oxyhemoglobin saturation during sleep (minimum SpO2): <a href="https://personal.broadinstitute.org/mvon/cade_et_al_2018_minimum_spo2_multiethnic_discovery_replication.txt.zip" target="_blank">Download</a><br>
                                Associations with the percentage of sleep with SpO2 < 90% (Per90): <a href="https://personal.broadinstitute.org/mvon/cade_et_al_2018_percent_sleep_under_90_percent_spo2_multiethnic_discovery_replication.txt.zip" target="_blank">Download</a>
</td><td><a href="https://s3.amazonaws.com/broad-portal-resources/sleep/README_Cade_et_al.txt" target="_blank">README</a></td></tr>

                        <tr><td><a href="https://www.ncbi.nlm.nih.gov/pubmed/30804566" target="_blank">PMID:30804566</a></td><td>Biological and clinical insights from genetics of insomnia symptoms.</td><td><a href="https://personal.broadinstitute.org/mvon/Saxena_fullUKBB_Insomnia_summary_stats.zip" target="_blank">Download files</a></td><td><a href="https://s3.amazonaws.com/broad-portal-resources/sleep/Saxena_fullUKBB_Insomnia_summary_stats_README" target="_blank">README</a></td></tr>


                    </table>
                </div>

                <div class="col-md-12">
                    <h1 class="dk-page-title">Genetic Association Datasets</h1>
                </div>
                <div class="col-md-12">
                    <p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.sleep.title" default="about the data"/></p>
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
%{--<g:elseif test="${g.portalTypeString()?.equals('sleep')}">--}%
    %{--<div class="col-md-12">--}%
        %{--<h1 class="dk-page-title">Data</h1>--}%
    %{--</div>--}%
    %{--<div class="col-md-12">--}%
        %{--<p style="font-weight: 300; font-size: 18px;"><g:message code="aboutTheData.sleep.title" default="about the data"/></p>--}%
    %{--</div>--}%

%{--</g:elseif>--}%


    </div>
</div>
</div>
        <div class="container">
            <g:if test="${portalVersionBean.getExposeDatasetHierarchy()}">
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


                    <div class="row pull-left col-xs-12" style="margin-top: 20px">
                        <div id="sunburstdiv">

                        </div>

                    </div>
                </div>
            </g:if>

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
                    <g:if test="${portalVersionBean.getExposeDatasetHierarchy()}">
                    mpgSoftware.launchSunburst('', '', undefined);
                    </g:if>

                });

            </script>


            <g:if test="${portalVersionBean.getExposeDatasetHierarchy()}">
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
            </g:if>


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
