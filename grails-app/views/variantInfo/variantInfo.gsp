<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
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
                variantPValues:'<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />',
                sourceDiagram:'<g:message code="variant.variantAssociations.source.diagram" default="diagram GWAS" />',
                sourceDiagramQ:'<g:helpText title="variant.variantAssociations.source.diagramQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.diagramQ.help.text"/>',
                sourceExomeChip:'<g:message code="variant.variantAssociations.source.exomeChip" default="Exome chip" />',
                sourceExomeChipQ:'<g:helpText title="variant.variantAssociations.source.exomeChipQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeChipQ.help.text"/>',
                sourceExomeSequence:'<g:message code="variant.variantAssociations.source.exomeSequence" default="Exome sequence" />',
                sourceExomeSequenceQ:'<g:helpText title="variant.variantAssociations.source.exomeSequenceQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeSequenceQ.help.text"/>',
                sourceSigma:'<g:message code="variant.variantAssociations.source.sigma" default="Sigma" />',
                sourceSigmaSequenceQ:'<g:helpText title="variant.variantAssociations.source.sigmaQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.sigmaQ.help.text"/>',
                associationPValueQ:'<g:helpText title="variant.variantAssociations.pValue.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.pValue.help.text"/>',
                associationOddsRatioQ:'<g:helpText title="variant.variantAssociations.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.oddsRatio.help.text"/>'
            };
            var diseaseBurdenStrings = {
                caseBarName:'<g:message code="variant.diseaseBurden.case.barname" default="have T2D" />',
                caseBarSubName:'<g:message code="variant.diseaseBurden.case.barsubname" default="cases" />',
                controlBarName:'<g:message code="variant.diseaseBurden.control.barname" default="do not have T2D" />',
                controlBarSubName:'<g:message code="variant.diseaseBurden.control.barsubname" default="controls" />',
                diseaseBurdenPValueQ:'<g:helpText title="variant.diseaseBurden.control.pValue.help.header"  qplacer="2px 0 0 6px" placement="left" body="variant.variantAssociations.pValue.help.text"/>',
                diseaseBurdenOddsRatioQ:'<g:helpText title="variant.diseaseBurden.control.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="left" body="variant.variantAssociations.oddsRatio.help.text"/>'
            };
            var alleleFrequencyStrings = {
                africanAmerican:'<g:message code="variant.alleleFrequency.africanAmerican" default="africanAmerican" />',
                africanAmericanQ:'<g:helpText title="variant.alleleFrequency.africanAmericanQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.africanAmericanQ.help.text"/>',
                hispanic:'<g:message code="variant.alleleFrequency.hispanic" default="hispanic" />',
                hispanicQ:'<g:helpText title="variant.alleleFrequency.hispanicQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.hispanicQ.help.text"/>',
                eastAsian:'<g:message code="variant.alleleFrequency.eastAsian" default="eastAsian" />',
                eastAsianQ:'<g:helpText title="variant.alleleFrequency.eastAsianQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.eastAsianQ.help.text"/>',
                southAsian:'<g:message code="variant.alleleFrequency.southAsian" default="southAsian" />',
                southAsianQ:'<g:helpText title="variant.alleleFrequency.southAsianQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.southAsianQ.help.text"/>',
                european:'<g:message code="variant.alleleFrequency.european" default="european" />',
                europeanQ:'<g:helpText title="variant.alleleFrequency.europeanQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.europeanQ.help.text"/>',
                exomeSequence:'<g:message code="variant.alleleFrequency.exomeSequence" default="exomeSequence" />',
                exomeSequenceQ:'<g:helpText title="variant.alleleFrequency.exomeSequenceQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.exomeSequenceQ.help.text"/>',
                exomeChip:'<g:message code="variant.alleleFrequency.exomeChip" default="exomeChip" />',
                exomeChipQ:'<g:helpText title="variant.alleleFrequency.exomeChipQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.exomeChipQ.help.text"/>'
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
                subtitle:'<g:message code="variant.impactOnProtein.subtitle" default="have on the encoded protein" />'
            };
            if ( typeof data !== 'undefined')  {
                mpgSoftware.variantInfo.fillTheFields(data,
                        "<%=variantToSearch%>",
                        "<g:createLink controller='trait' action='traitInfo' />",
                        "${restServer.currentRestServer()}");
            }
            $(".pop-top").popover({placement : 'top'});
            $(".pop-right").popover({placement : 'right'});
            $(".pop-bottom").popover({placement : 'bottom'});
            $(".pop-left").popover({ placement : 'left'});
            $(".pop-auto").popover({ placement : 'auto'});
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

<g:if test="${show_exseq}">

    <g:render template="diseaseRisk"/>

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
<g:if test="${show_exseq}">

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
                                <h2><strong><g:message code="variant.effectOfVariantOnProtein.title" default="What is the effect of this variant on the associated protein"/></strong></h2>
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
            mpgSoftware.variantInfo.retrieveDelayedIgvLaunch().launch();
        }

    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
    });

    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {

             mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant();
       }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation()  !== 'undefined') &&
                    (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().removeBarchart();
            }
        }
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            mpgSoftware.carrierStatusImpact.loadDiseaseRisk();
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            if ((typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation()  !== 'undefined') &&
                    (typeof mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().launch !== 'undefined')) {
                mpgSoftware.variantInfo.retrieveDelayedCarrierStatusDiseaseRiskPresentation().removeBarchart();
            }
        }
    });

    $('#collapseVariantAssociationStatistics').collapse({hide: false})
</script>

</body>
</html>

