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
    <r:require modules="gnomad"/>
    %{--Need to call directly or else the images don't come out right--}%
    <link rel="stylesheet" type="text/css"  href="../../css/lib/locuszoom.css">
    <script type="text/javascript" src="../../js/lib/gnomadt2d.js"></script>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>

    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

    <g:set var="restServer" bean="restServerService"/>




    <script>

        $(function () {
            "use strict";

            function goToSelectedItem(item) {
                window.location.href = "${createLink(controller:'gene',action:'findTheRightDataPage')}/" + item;
            }

            /***
             * type ahead recognizing genes
             */
            $('#generalized-input').typeahead({
                source: function (query, process) {
                    $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                        process(data);
                    })
                },
                afterSelect: function(selection) {
                    goToSelectedItem(selection);
                }
            });

            /***
             * respond to end-of-search-line button
             */
            $('#generalized-go').on('click', function () {
                var somethingSymbol = $('#generalized-input').val();
                somethingSymbol = somethingSymbol.replace(/\//g,"_"); // forward slash crashes app (even though it is the LZ standard variant format
                if (somethingSymbol) {
                    goToSelectedItem(somethingSymbol)
                }
            });

            /***
             * capture enter key, make it equivalent to clicking on end-of-search-line button
             */
            $("input").keypress(function (e) { // capture enter keypress
                var k = e.keyCode || e.which;
                if (k == 13) {
                    $('#generalized-go').click();
                }
            });
        });

    </script>
</head>

<body>

<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>
    var loading = $('#spinner').show();
    $(document).ready(function() {
        var positioningInformation = {};
        if ('<%=geneName%>'.indexOf(':')>-1){ // this looks like a range, not a gene
            var rangeList = '<%=geneName%>'.split(':');
            if (rangeList.length === 2){
                positioningInformation['chromosome'] = rangeList[0];
                var genomicPositionList = rangeList[1].split('-');
                if (genomicPositionList.length === 2){
                    positioningInformation['startPosition'] = genomicPositionList[0];
                    positioningInformation['endPosition'] = genomicPositionList[1];
                }
            }

            $('#placeForAUniprotSummary').hide();
            $('div.geneWindowDescription').hide()
        } else { // this looks like a gene, which means that we need to figure out it's genomic coordinates
            $.ajax({
                cache: false,
                type: "post",
                url: '<g:createLink controller="gene" action="geneInfoAjax"/>',
                data: {geneName: '${geneName}'},
                async: true
            }).done(function (data) {
                mpgSoftware.geneInfo.fillTheGeneFields(data); // fills the uniprot summary
                $('[data-toggle="popover"]').popover({
                    animation: true,
                    html: true,
                    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                });
                $('span[data-textfield="variantName"]').append(data.geneInfo.ID);
                var genePageExtent = 100000;

                positioningInformation = {
                    chromosome: data.geneInfo.CHROM,
                    startPosition: data.geneInfo.BEG - genePageExtent,
                    endPosition: data.geneInfo.END + genePageExtent
                };

                $(".pop-top").popover({placement: 'top'});
                $(".pop-right").popover({placement: 'right'});
                $(".pop-bottom").popover({placement: 'bottom'});
                $(".pop-left").popover({placement: 'left'});
                $(".pop-auto").popover({placement: 'auto'});
                loading.hide();
                //massageLZ();



                /**
                 * Pass the TranscriptViewer component as the first arg
                 * Pass the props as the second arg, this could be data from
                 * other parts of your app, such as the current gene user is viewing
                 * or settings for the component, like whether or not to show gtex values,
                 * which could be hooked up to an external button of some kind
                 * the width prop could be set by the parent component width, or page width, e.g.
                 */




            }).fail(function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            });
        }

        // call this inside the ready function because the page is still loading when the the parent
        // ajax calls returns
        $('#variantPageText').hide();
        $('#genePageText').show();

    });
    $('#collapseVariantAssociationStatistics').collapse({hide: false})

</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container row">
            <div class="gene-info-view">
                <h1 class="dk-page-title" style="vertical-align: bottom; margin-bottom: 0; ">
                    <em style="font-weight: 900;"><%=geneName%></em>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <div class="dk-t2d-green dk-reference-button dk-right-column-buttons-compact f" style="float:right; border-radius: 2px; margin: 0 15px 0 -140px; font-size:12px;">
                        <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/gene_page_guide.pdf" style="border-radius: 2px;" target="_blank">Gene Page guide</a>
                        </div>
                    </g:if>
                    <g:elseif test="${g.portalTypeString()?.equals('stroke')}">
                        <div class="dk-t2d-green dk-reference-button dk-right-column-buttons-compact" style="float:right; border-radius: 2px; margin: 0 15px 0 -140px; font-size:12px;">
                            <a href="https://s3.amazonaws.com/broad-portal-resources/stroke/tutorials/CDKP_gene_page_guide.pdf" style="border-radius: 2px;" target="_blank">Gene Page guide</a>
                        </div>
                    </g:elseif>
                    <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                        <div class="dk-t2d-green dk-reference-button dk-right-column-buttons-compact" style="float:right; border-radius: 2px; margin: 0 15px 0 -140px; font-size:12px;">
                            <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/CVDKP_gene_page_guide.pdf" style="border-radius: 2px;" target="_blank">Gene Page guide</a>
                        </div>
                    </g:elseif>
                </h1>
                <div class="col-md-6" style="height: 40px; padding:0 0 0 15px; border-bottom: solid 1px #ccc; ">
                    <div id='trafficLightHolder' style="width:200px; float: left; margin-top: -12px;">
                        <r:img uri="/images/undeterminedlight2.png"/>
                        <div id="signalLevelHolder" style=""></div>
                    </div>
                    <div class="trafficExplanations trafficExplanation1 unemphasize" style="font-size:16px; text-align: left;">
                        No evidence for signal&nbsp;<g:helpText title="no.evidence.help.header" placement="right" body="no.evidence.help.text"/>
                    </div>
                    <div class="trafficExplanations trafficExplanation2 unemphasize" style="font-size:18px; text-align: left;">
                        Suggestive evidence for signal&nbsp;<g:helpText title="suggestive.evidence.help.header" placement="right" body="suggestive.evidence.help.text"/>
                    </div>
                    <div class="trafficExplanations trafficExplanation3 unemphasize" style="font-size:18px; text-align: left;">
                        Strong evidence for signal&nbsp;<g:helpText title="strong.evidence.help.header" placement="right" body="strong.evidence.help.text"/>
                    </div>
                </div>
                <div class="form-inline col-md-6" style="height: 40px; padding:0; border-bottom: solid 1px #ccc; ">

                    <button id="generalized-go" class="btn btn-primary" type="button" style="float: right; height: 41px; width:45px; border-radius:2px; margin: -1px 15px 0 0;">Go</button>
                    <input id="generalized-input" value="" type="text" class="form-control input-default" style="float: right; height: 41px; width:200px; border-radius: 2px; margin: -1px 0 0 0;">
                    <div style="padding:10px 15px 0 0; text-align: right; float: right; ">Look for another gene</div>

                </div>



                <div class="col-md-12" style="padding-top: 30px;">
<!--
                    <a class="find-out-more-opener" data-toggle="collapse" data-parent="#accordion2" href="#findOutMoreCompact2">
                        <span class="glyphicon glyphicon-share-alt" aria-hidden="true"></span><br />External<br />resources</a>

                    <div class="find-out-more-content collapse" id="findOutMoreCompact2">
                        <div class="accordion-inner">
                            <g:render template="findOutMoreCompact"/>
                        </div>
                    </div>

                    -->

                    <g:render template="geneSummary" model="[geneToSummarize:geneName]"/>

                </div>



                <g:renderNotBetaFeaturesDisplayedValue>
                    <g:render template="../templates/geneSignalSummaryTemplate"/>
                    <g:render template="../templates/variantSearchResultsTemplate" />
                    <g:render template="geneSignalSummary"  model="[signalLevel:1,geneToSummarize:geneName]"/>
                    <g:render template="../templates/variantSearchResultsTemplate" />
                </g:renderNotBetaFeaturesDisplayedValue>


                <div class="accordion" id="accordion2">
                <g:renderBetaFeaturesDisplayedValue>
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
                </g:renderBetaFeaturesDisplayedValue>
                <g:renderBetaFeaturesDisplayedValue>

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

                </g:renderBetaFeaturesDisplayedValue>
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


                        <g:renderBetaFeaturesDisplayedValue>

                            <div class="separator"></div>

                            <g:render template="/widgets/locusZoomPlot"/>

                        </g:renderBetaFeaturesDisplayedValue>

                <g:if test="${g.portalTypeString()?.equals('t2d')||
                                g.portalTypeString()?.equals('mi')}">

                    <g:renderBetaFeaturesDisplayedValue>
                        <div class="separator"></div>

                        <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                               'accordionHeaderClass': 'accordion-heading',
                                                                               'modifiedTitle': 'Interactive burden test',
                                                                               'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.',
                                                                               'allowExperimentChoice': 0,
                                                                               'allowPhenotypeChoice' : 1,
                                                                               'allowStratificationChoice': 1,
                                                                               'grsVariantSet':'']"/>
                    </g:renderBetaFeaturesDisplayedValue>
                    </g:if>




                <div class="accordion-group" style="padding: 7px; border: solid 1px #ddd; border-radius: 3px; margin-top: 15px; background-color:#eee;">

                    <a data-toggle="collapse" data-parent="#accordion2" href="#findOutMoreCompact3" style="outline: none; font-size: 16px;"><span class="glyphicon glyphicon-link" aria-hidden="true"></span> External resources</a>

                    <div id="findOutMoreCompact3" class="" style="margin-top: 10px;">
                        <div class="accordion-inner">
                            <g:render template="findOutMoreCompact"/>
                        </div>
                    </div>
                </div>

<!--
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
                    -->

                </div>
            </div>
        </div>
    </div>

</div>
<g:render template="/templates/burdenTestSharedTemplate" />
</body>
</html>

