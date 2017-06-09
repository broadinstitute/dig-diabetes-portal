<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="geneInfo"/>
    <r:require modules="crossMap"/>
    <r:require modules="igv"/>
    <r:require module="locusZoom"/>
    <r:require module="mustache"/>
    <r:require modules="boxwhisker"/>
    <r:require modules="burdenTest"/>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <g:set var="restServer" bean="restServerService"/>


    <style>

</style>
</head>

<body>
<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>
    var loading = $('#spinner').show();
    $(document).ready(function() {
    $.ajax({
        cache: false,
        type: "post",
        url: '<g:createLink controller="gene" action="geneInfoAjax"/>',
        data: {geneName: '<%=geneName%>'},
        async: true
    }).done(function (data) {
        mpgSoftware.geneInfo.fillTheGeneFields(data);
        $('[data-toggle="popover"]').popover({
            animation: true,
            html: true,
            template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
        });
        $('span[data-textfield="variantName"]').append(data.geneInfo.ID);
        var genePageExtent = 100000;

        var positioningInformation = {
            chromosome: data.geneInfo.CHROM,
            startPosition: data.geneInfo.BEG - genePageExtent,
            endPosition: data.geneInfo.END + genePageExtent
        };
        <g:renderNotBetaFeaturesDisplayedValue>
        mpgSoftware.locusZoom.initializeLZPage('geneInfo', null, positioningInformation,
                "#lz-47","#collapseLZ",'${lzOptions.first().key}','${lzOptions.first().description}','${lzOptions.first().propertyName}','${lzOptions.first().dataSet}','junk',
                '${createLink(controller:"gene", action:"getLocusZoom")}',
                '${createLink(controller:"variantInfo", action:"variantInfo")}',
                '${lzOptions.first().dataType}','${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',true);
        </g:renderNotBetaFeaturesDisplayedValue>


        $(".pop-top").popover({placement: 'top'});
        $(".pop-right").popover({placement: 'right'});
        $(".pop-bottom").popover({placement: 'bottom'});
        $(".pop-left").popover({placement: 'left'});
        $(".pop-auto").popover({placement: 'auto'});
        loading.hide();
    }).fail(function (jqXHR, exception) {
        loading.hide();
        core.errorReporter(jqXHR, exception);
    });

        // call this inside the ready function because the page is still loading when the the parent
        // ajax calls returns


        $('#variantPageText').hide();
        $('#genePageText').show();


    });
    $('#collapseVariantAssociationStatistics').collapse({hide: false})

</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container">
            <div class="gene-info-view">

                <h1>
                    <em><%=geneName%></em>
                </h1>
<g:if test="${g.portalTypeString()?.equals('t2d')}">
                <div style="text-align: right;">
                    <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/gene_page_guide.pdf" target="_blank">Gene Page guide</a>
                </div></g:if>
    </div>
                <g:render template="geneSummary" model="[geneToSummarize:geneName]"/>

                <g:renderBetaFeaturesDisplayedValue>
                    <g:render template="../templates/geneSignalSummaryTemplate"/>
                    <g:render template="geneSignalSummary"  model="[signalLevel:1,geneToSummarize:geneName]"/>
                </g:renderBetaFeaturesDisplayedValue>


                <div class="accordion" id="accordion2">
                <g:renderNotBetaFeaturesDisplayedValue>
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseOne" aria-expanded="true">
                                <h2><strong><g:message code="gene.variantassociations.title"
                                                       default="Variants and associations"/></strong></h2>
                            </a>
                        </div>

                        <div id="collapseOne" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantsAndAssociations"/>
                            </div>
                        </div>
                    </div>
                </g:renderNotBetaFeaturesDisplayedValue>
                <g:renderNotBetaFeaturesDisplayedValue>

                    <div class="separator"></div>

                    <g:render template="../templates/igvBrowserTemplate"/>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
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

                </g:renderNotBetaFeaturesDisplayedValue>
                   %{----}%
                    %{--<g:renderBetaFeaturesDisplayedValue>--}%
                    %{--<div class="separator"></div>--}%
                    %{--<g:render template="/widgets/gwasRegionSummary"--}%
                              %{--model="['phenotypeList': phenotypeList, 'regionSpecification': regionSpecification]"/>--}%
                    %{--</g:renderBetaFeaturesDisplayedValue>--}%
                    %{----}%


                <script>
                    $('#accordion2').on('shown.bs.collapse', function (e) {
                        if (e.target.id === "collapseIgv") {

                            igvLauncher.setUpIgv('<%=geneName%>',
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
                    $('#accordion2').on('show.bs.collapse', function (e) {
                        if (e.target.id === "collapseIgv") {

                        }
                    });


                    $('#collapseOne').collapse({hide: true})
                    </script>


                        <g:renderNotBetaFeaturesDisplayedValue>

                            <div class="separator"></div>

                            <g:render template="/widgets/locusZoomPlot"/>

                        </g:renderNotBetaFeaturesDisplayedValue>

                <g:if test="${g.portalTypeString()?.equals('t2d')||
                                g.portalTypeString()?.equals('mi')}">

                    <g:renderNotBetaFeaturesDisplayedValue>
                        <div class="separator"></div>

                        <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                               'accordionHeaderClass': 'accordion-heading',
                                                                               'modifiedTitle': 'Interactive burden test',
                                                                               'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.',
                                                                               'allowExperimentChoice': 0,
                                                                               'allowPhenotypeChoice' : 1,
                                                                               'allowStratificationChoice': 1    ]"/>
                    </g:renderNotBetaFeaturesDisplayedValue>
                    </g:if>



                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
                               href="#findOutMore">
                                <h2><strong><g:message code="gene.findoutmore.title" default="find out more"/></strong>
                                </h2>
                            </a>
                        </div>

                        <div id="findOutMore" class="accordion-body collapse">
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
<g:render template="/templates/burdenTestSharedTemplate" />
</body>
</html>

