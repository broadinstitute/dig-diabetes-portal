<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="variantInfo, igv"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:require modules="boxwhisker"/>
    <r:require module="locusZoom"/>
    <r:require modules="core, mustache"/>

    <r:layoutResources/>
    <style>
    /* for associations at a glance */
    .smallRow {
        border-top-style: solid;
        border-top-width: 2px;
        border-color: #1fff11;
        margin-top: 10px;
        margin-right: 10px;
        padding: 5px 0px 10px;
    }

    .t2d-info-box-wrapper, .other-traits-info-box-wrapper, #primaryPhenotype {
        padding: 20px 0 0;
    }

    .t2d-info-box-wrapper ul, .other-traits-info-box-wrapper ul {
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .t2d-info-box-wrapper li, .other-traits-info-box-wrapper li {
        display: inline-block;
        vertical-align: top;
    }

    .normal-info-box-holder h3 {
        font-size: 20px;
        line-height: 20px;
        margin-top: 0;
    }

    .normal-info-box-holder > ul > li > h3 {
        font-weight: 400;
    }

    .normal-info-box-holder span.p-value {
        display: block;
        font-size: 18px;
        font-weight: 500;
        margin-bottom: -5px;
    }

    .normal-info-box-holder span.p-value-significance {
        font-size: 11px;
    }

    .normal-info-box-holder span.observation {
        display: block;
        font-size: 14px;
        font-weight: 500;
    }

    .small-info-box-holder {
        margin-top: 10px;
        margin-right: 20px;
        padding: 5px 0 10px;
        border-top: solid 2px; /* color is defined on each item */
    }

    .small-info-box-holder h3 {
        font-size: 14px;
        line-height: 14px;
        font-weight: 600;
        margin-top: 0;
    }

    .small-info-box-holder > ul > li > h3 {
        font-weight: 400;
    }

    /* clear out the margin so the border doesn't have an extra tail */
    .small-info-box-holder > ul > li:nth-last-child(1) {
        margin-right: 0;
    }

    .small-info-box-holder span.p-value {
        display: block;
        font-size: 14px;
        font-weight: 500;
        margin-bottom: -5px;
    }

    .small-info-box-holder span.p-value-significance {
        font-size: 9px;
    }

    .small-info-box-holder span.extra-info {
        font-size: 12px;
    }

    .info-box {
        position: relative;
        margin-right: 10px;
        margin-bottom: 10px;
        padding: 10px;
        text-align: center;
        /* just in case the text isn't otherwise colored */
        color: white;
    }

    .normal-info-box {
        width: 170px;
        height: 170px;
    }

    .small-info-box {
        width: 140px;
        height: 140px;
    }

    .not-significant-box {
        border: solid 1px black;
    }

    .parentsFont {
        font-family: inherit;
        font-weight: inherit;
        font-size: inherit;
    }

    .mbar_xaxis text {
        font-size: 14px;
    }
    </style>


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
<script>
    // generate the texts here so that the appropriate one can be selected in initializePage
    // the keys (1,2,3,4) map to the assignments for MOST_DEL_SCORE
    var variantSummaryText = {
        1: "${g.message(code: "variant.summaryText.proteinTruncating")}",
        2: "${g.message(code: "variant.summaryText.missense")}",
        3: "${g.message(code: "variant.summaryText.synonymous")}",
        4: "${g.message(code: "variant.summaryText.noncoding")}"
    };

    var loading = $('#spinner').show();
    // sometimes the headers weren't fully loaded before the initializePage function was called,
    // so don't run it until the DOM is ready
    $(document).ready(function () {
        $.ajax({
            cache: false,
            type: "get",
            url: ('<g:createLink controller="variantInfo" action="variantAjax"/>' + '/${variantToSearch}'),
            async: true
        }).done(function (data, textStatus, jqXHR) {
            var portalType = "t2d";
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                portalType = "stroke";
            </g:if>
            mpgSoftware.variantInfo.initializePage(data,
                    "<%=variantToSearch%>",
                    "<g:createLink controller='trait' action='traitInfo' />",
                    "<%=restServer%>",
                    variantSummaryText,
                    portalType,"#lz-47","#collapseLZ",'T2D',
                    '${createLink(controller:"gene", action:"getLocusZoom")}',
                    '${createLink(controller:"variantInfo", action:"variantInfo")}');
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




                    %{--<g:renderBetaFeaturesDisplayedValue>--}%
                    <div class="separator"></div>

                    <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': variantToSearch]"/>
                    %{--from the--}%


                    <div class="separator"></div>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
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
                                <g:render template="../trait/igvBrowser"/>
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
            setUpIgv(igvParms.locus, igvParms.server);
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

