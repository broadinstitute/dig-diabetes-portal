<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="variantInfo, igv"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:require modules="boxwhisker"/>
    <r:require module="locusZoom"/>
    <r:require modules="core, mustache"/>
    <r:require modules="burdenTest"/>
    <r:require modules="multiTrack"/>
    <r:require modules="matrix"/>


    <r:layoutResources/>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">


    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Google fonts -->
    <link rel="stylesheet" type="text/css" href='//fonts.googleapis.com/css?family=PT+Sans:400,700'>
    <link rel="stylesheet" type="text/css" href='//fonts.googleapis.com/css?family=Open+Sans'>

</head>

<body>
<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<style>

</style>

<script>

    // generate the texts here so that the appropriate one can be selected in initializePage
    // the keys (1,2,3,4) map to the assignments for MOST_DEL_SCORE
    var variantSummaryText = {
        1: "${g.message(code: "variant.summaryText.proteinTruncating")}",
        2: "${g.message(code: "variant.summaryText.missense")}",
        3: "${g.message(code: "variant.summaryText.synonymous")}",
        4: "${g.message(code: "variant.summaryText.noncoding")}"
    };



    // sometimes the headers weren't fully loaded before the initializePage function was called,
    // so don't run it until the DOM is ready
    $(document).ready(function () {
        var loading = $('#spinner').show();
        $.ajax({
            cache: false,
            type: "get",
            url: ('<g:createLink controller="variantInfo" action="variantAjax"/>' + '/${variantToSearch}'),
            async: true
        }).done(function (data, textStatus, jqXHR) {

                mpgSoftware.variantInfo.initializePage(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />",
                    "<%=restServer%>",
                    variantSummaryText,
                    'stroke',"#lz-47","#collapseLZ",'${lzOptions.first().key}','${lzOptions.first().description}','${lzOptions.first().propertyName}','${lzOptions.first().dataSet}',
                        '${createLink(controller:"gene", action:"getLocusZoom")}',
                    '${createLink(controller:"variantInfo", action:"variantInfo")}','${lzOptions.first().dataType}',
                        '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}');
                if ((!data.variant.is_error) && (data.variant.numRecords>0)){
                    mpgSoftware.variantInfo.retrieveFunctionalData(data,mpgSoftware.variantInfo.displayFunctionalData,
                            {retrieveFunctionalDataAjaxUrl:'${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}'});
                }


        }).fail(function (jqXHR, textStatus, errorThrown) {
            loading.hide();
            core.errorReporter(jqXHR, errorThrown)
        });
    });
</script>


<div id="main">

    <div class="container">

        <div class="variant-info-container">
            <div class="variant-info-view">

                <h1>
                    <strong><span id="variantTitle" class="parentsFont"></span> summary</strong>
                </h1>

                <g:render template="variantPageHeader"/>



                <div class="accordion" id="accordionVariant">

                    <g:render template="functionalAnnotation"/>



                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseVariantAssociationStatistics">
                                <h2><strong><g:message code="variant.variantAssociationStatistics.title"
                                                       default="Variant associations at a glance"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseVariantAssociationStatistics" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantAssociationStatistics"/>
                            </div>
                        </div>
                    </div>

                    <div class="separator"></div>

                    <g:render template="/widgets/associatedStatisticsTraitsPerVariant"
                              model="[variantIdentifier: variantToSearch, locale: locale]"/>


                <g:if test="${g.portalTypeString()?.equals('stroke')||
                        g.portalTypeString()?.equals('t2d')||

                        g.portalTypeString()?.equals('mi')}">

                        <div class="separator"></div>

                    <g:render template="/templates/burdenTestSharedTemplate" model="['variantIdentifier': variantToSearch, 'accordionHeaderClass': 'accordion-heading']"/>
                    <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': variantToSearch,
                                                                           'accordionHeaderClass': 'accordion-heading',
                                                                           'allowExperimentChoice': 1,
                                                                           'allowPhenotypeChoice' : 1,
                                                                           'allowStratificationChoice': 1   ]"/>

                    </g:if>


                    <div class="separator"></div>

                    <g:if test="${true}">
                        <g:render template="/widgets/locusZoomPlot"/>

                        <div class="separator"></div>

                    </g:if>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseHowCommonIsVariant">
                                <h2><strong><g:message code="variant.howCommonIsVariant.title"
                                                       default="How common is variant"/></strong></h2>
                            </a>
                        </div>

                        <g:render template="howCommonIsVariant"/>

                    </div>

                    <g:renderBetaFeaturesDisplayedValue>
                    <div class="separator"></div>

                    <div class="accordion-group">
                    <div class="accordion-heading">
                    <a class="accordion-toggle  collapsed" data-toggle="collapse"
                    data-parent="#accordionVariant"
                    href="#collapseCarrierStatusImpact">
                    <h2><strong><g:message code="variant.carrierStatusImpact.title" default="How many carriers in the data set"/></strong></h2>
                    </a>
                    </div>

                    <g:render template="carrierStatusImpact"/>

                    </div>

                    </g:renderBetaFeaturesDisplayedValue>

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionVariant"
                               href="#collapseIgv">
                                <h2><strong><g:message code="variant.igvBrowser.title"
                                                       default="Explore with IGV"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseIgv" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <div class="igvGoesHere"></div>
                                <g:render template="../templates/igvBrowserTemplate"/>
                            </div>
                        </div>
                    </div>

                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse"
                               data-parent="#accordionVariant"
                               href="#collapseFindOutMore">
                                <h2><strong><g:message code="variant.findOutMore.title"
                                                       default="find out more"/></strong></h2>
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
            var igvParms = mpgSoftware.variantInfo.retrieveVariantPosition();

           igvLauncher.setUpIgv(igvParms.locus,
                    '.igvGoesHere',
                    "<g:message code='controls.shared.igv.tracks.recomb_rate' />",
                    "<g:message code='controls.shared.igv.tracks.genes' />",
                    "${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                    "${createLink(controller:'trait', action:'getData', absolute:'false')}",
                    "${createLink(controller:'variantInfo', action:'variantInfo', absolute:'true')}",
                    "${createLink(controller:'trait', action:'traitInfo', absolute:'true')}",
                    '${igvIntro}');
        } else if (e.target.id === "collapseFunctionalData") {
            $("#functionalDataTableGoesHere").DataTable().draw();
        }

    });
    $('#accordionVariant').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseIgv") {

        }
    });

    $('#collapseVariantAssociationStatistics').collapse({hide: false})
</script>

</body>
</html>

