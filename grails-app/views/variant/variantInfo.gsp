<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="variantInfo"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
    <style>
    .parentsFont {
        font-family: inherit;
        font-weight: inherit;
        font-size: inherit;
    }
    </style>


    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" type="text/css"
          rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Bootstrap -->
    <g:javascript src="lib/igv/vendor/inflate.js"/>
    <g:javascript src="lib/igv/vendor/zlib_and_gzip.min.js"/>

    <!-- IGV js  and css code -->
    <link href="http://www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">
    <g:javascript base="http://www.broadinstitute.org/" src="/igvdata/t2d/igv-all.min.js"/>
    <g:set var="restServer" bean="restServerService"/>





</head>

<body>

<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "get",
        url: "../variantAjax/" + "<%=variantToSearch%>",
        async: true,
        success: function (data) {
            var variantAssociationStrings = {
                genomeSignificance:'<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
                locusSignificance:'<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
                nominalSignificance:'<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
                nonSignificance:'<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
                variantPValues:'<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />'
            };
            var diseaseBurdenStrings = {
                caseBarName:'<g:message code="variant.diseaseBurden.case.barname" default="have T2D" />',
                caseBarSubName:'<g:message code="variant.diseaseBurden.case.barsubname" default="cases" />',
                controlBarName:'<g:message code="variant.diseaseBurden.control.barname" default="do not have T2D" />',
                controlBarSubName:'<g:message code="variant.diseaseBurden.control.barname" default="controls" />'
            };
            var alleleFrequencyStrings = {
                africanAmerican:'<g:message code="variant.alleleFrequency.africanAmerican" default="africanAmerican" />',
                hispanic:'<g:message code="variant.alleleFrequency.hispanic" default="hispanic" />',
                eastAsian:'<g:message code="variant.alleleFrequency.eastAsian" default="eastAsian" />',
                southAsian:'<g:message code="variant.alleleFrequency.southAsian" default="southAsian" />',
                european:'<g:message code="variant.alleleFrequency.european" default="european" />',
                exomeSequence:'<g:message code="variant.alleleFrequency.exomeSequence" default="exomeSequence" />',
                exomeChip:'<g:message code="variant.alleleFrequency.exomeChip" default="exomeChip" />'
             };
            var carrierStatusImpact = {
                casesTitle:'<g:message code="variant.carrierStatusImpact.casesTitle" default="casesTitle" />',
                controlsTitle:'<g:message code="variant.carrierStatusImpact.controlsTitle" default="controlsTitle" />',
                legendTextHomozygous:'<g:message code="variant.carrierStatusImpact.legendText.homozygous" default="legendTextHomozygous" />',
                legendTextHeterozygous:'<g:message code="variant.carrierStatusImpact.legendText.heterozygous" default="legendTextHeterozygous" />',
                legendTextNoncarrier:'<g:message code="variant.carrierStatusImpact.legendText.nonCarrier" default="legendTextNoncarrier" />',
                designationTotal:'<g:message code="variant.carrierStatusImpact.designation.total" default="designationTotal" />'
            };
            var impactOnProtein = {
                chooseOneTranscript:'<g:message code="variant.impactOnProtein.chooseOneTranscript" default="choose one transcript" />',
                subtitle1:'<g:message code="variant.impactOnProtein.subtitle1" default="what effect does" />',
                subtitle2:'<g:message code="variant.impactOnProtein.subtitle2" default="have on the encoded protein" />'
            };
            if ( typeof data !== 'undefined')  {
                variantInfo.fillTheFields(data,
                        "<%=variantToSearch%>",
                        "<g:createLink controller='trait' action='traitInfo' />",
                        "${restServer.currentRestServer()}",
                        ${show_gwas},
                        ${show_exchp},
                        ${show_exseq},
                        ${show_sigma},
                        {variantAssociationStrings:variantAssociationStrings,
                         diseaseBurdenStrings:diseaseBurdenStrings,
                         alleleFrequencyStrings:alleleFrequencyStrings,
                         carrierStatusImpact:carrierStatusImpact,
                         impactOnProtein:impactOnProtein});
            }
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
</script>


<div id="main">

    <div class="container">

        <div class="variant-info-container">
            <div class="variant-info-view">

                <h1>
                    <strong><span id="variantTitle" class="parentsFont"></span></strong>
                </h1>

                <g:render template="variantPageHeader"/>

                <div class="accordion" id="accordionVariant">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong><g:message code="variant.variantAssociationStatistics.title" default="Is variant associated with T2D"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>

<g:if test="${show_exseq || show_sigma}">

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseDiseaseRisk">
                                <h2><strong><g:message code="variant.diseaseRisk.title" default="How does carrier status impact risk"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseDiseaseRisk" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="diseaseRisk"/>
                            </div>
                        </div>
                    </div>
</g:if>

<g:if test="${show_exseq}">

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseHowCommonIsVariant">
                                <h2><strong><g:message code="variant.howCommonIsVariant.title" default="How common is variant"/>
                                </strong></h2>
                            </a>
                        </div>

                        <div id="collapseHowCommonIsVariant" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="howCommonIsVariant"/>
                            </div>
                        </div>
                    </div>
</g:if>
<g:if test="${show_exseq || show_sigma}">

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseCarrierStatusImpact">
                                <h2><strong><g:message code="variant.carrierStatusImpact.title" default="How many carriers in the data set"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseCarrierStatusImpact" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="carrierStatusImpact"/>
                            </div>
                        </div>
                    </div>

</g:if>
                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseAffectOfVariantOnProtein">
                                <g:message code="variant.effectOfVariantOnProtein.title" default="What is the effect of this variant on the associated protein"/>
                            </a>
                        </div>

                        <div id="collapseAffectOfVariantOnProtein" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="effectOfVariantOnProtein"/>
                            </div>
                        </div>

                    </div>


                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseIgv">
                                <h2><strong><g:message code="variant.igvBrowser.title" default="Explorer with IGV"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseIgv" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="igvBrowser"/>
                            </div>
                        </div>
                    </div>


                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseFindOutMore">
                                <h2><strong><g:message code="variant.findOutMore.title" default="find out more"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseFindOutMore" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="findOutMore"/>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>
    </div>

</div>
<script>
    $('#accordionVariant').on('shown.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {
            variantInfo.retrieveDelayedIgvLaunch().launch();
        }

    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
        console.log('collapseIgv shown')
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof variantInfo.retrieveDelayedBurdenTestPresentation() !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedBurdenTestPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedBurdenTestPresentation().launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof variantInfo.retrieveDelayedBurdenTestPresentation() !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedBurdenTestPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedBurdenTestPresentation().removeBarchart();
            }
        }
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof variantInfo.retrieveDelayedHowCommonIsPresentation()  !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedHowCommonIsPresentation().launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof variantInfo.retrieveDelayedHowCommonIsPresentation()  !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedHowCommonIsPresentation().removeBarchart();
            }
        }
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            if ((typeof variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation()  !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            if ((typeof variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation()  !== 'undefined') &&
                    (typeof variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch !== 'undefined')) {
                variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().removeBarchart();
            }
        }
    });

    $('#collapseOne').collapse({hide: true})
</script>

</body>
</html>

