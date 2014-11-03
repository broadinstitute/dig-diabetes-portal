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
            fillTheFields(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />",
                    "${restServer.currentRestServer()}",
                    ${show_gwas},
                    ${show_exchp},
                    ${show_exseq},
                    ${show_sigma});
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
                                <h2><strong>Is <b><span id="variantTitleInAssociationStatistics"></span>
                                </b> associated with T2D or related traits?</strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>

<g:if test="${show_exseq}">

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseDiseaseRisk">
                                <h2><strong>How does carrier status affect disease risk?</strong></h2>
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
                                <h2><strong>How common is <span id="populationsHowCommonIs" class="parentsFont"></span>?
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

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseCarrierStatusImpact">
                                <h2><strong>How many carriers are observed in the data set?</strong></h2>
                            </a>
                        </div>

                        <div id="collapseCarrierStatusImpact" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="carrierStatusImpact"/>
                            </div>
                        </div>
                    </div>

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseAffectOfVariantOnProtein">
                                <div id="effectOfVariantOnProteinTitle"></div>
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
                                <h2><strong>Explore the sequence surrounding
                                    <span id="exploreSurroundingSequenceTitle" class="parentsFont"></span> with IGV.</strong></h2>
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
                                <h2><strong>Find out more</strong></h2>
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
            delayedIgvLaunch.launch();
        }

    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
        console.log('collapseIgv shown')
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof delayedBurdenTestPresentation !== 'undefined') &&
                    (typeof delayedBurdenTestPresentation.launch !== 'undefined')) {
                delayedBurdenTestPresentation.launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseDiseaseRisk") {
            if ((typeof delayedBurdenTestPresentation !== 'undefined') &&
                    (typeof delayedBurdenTestPresentation.launch !== 'undefined')) {
                delayedBurdenTestPresentation.removeBarchart();
            }
        }
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof delayedHowCommonIsPresentation  !== 'undefined') &&
                    (typeof delayedHowCommonIsPresentation .launch !== 'undefined')) {
                delayedHowCommonIsPresentation .launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseHowCommonIsVariant") {
            if ((typeof delayedHowCommonIsPresentation  !== 'undefined') &&
                    (typeof delayedHowCommonIsPresentation .launch !== 'undefined')) {
                delayedHowCommonIsPresentation .removeBarchart();
            }
        }
    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            if ((typeof delayedCarrierStatusDiseaseRiskPresentation  !== 'undefined') &&
                    (typeof delayedCarrierStatusDiseaseRiskPresentation.launch !== 'undefined')) {
                delayedCarrierStatusDiseaseRiskPresentation .launch();
            }
        }
    });
    $('#accordionVariant').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseCarrierStatusImpact") {
            if ((typeof delayedCarrierStatusDiseaseRiskPresentation  !== 'undefined') &&
                    (typeof delayedCarrierStatusDiseaseRiskPresentation .launch !== 'undefined')) {
                delayedCarrierStatusDiseaseRiskPresentation .removeBarchart();
            }
        }
    });

    $('#collapseOne').collapse({hide: true})
</script>

</body>
</html>

