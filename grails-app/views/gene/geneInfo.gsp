<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="geneInfo"/>
    <r:require module="locusZoom"/>
    %{--<r:require modules="higlass"/>--}%

    %{--Need to call directly or else the images don't come out right--}%
    <link rel="stylesheet" type="text/css"  href="../../css/lib/locuszoom.css">
    %{--<script type="text/javascript" src="../../js/lib/gnomadt2d.js"></script>--}%
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

            $("#gene-info-summary-header").find(".gene-name").css({"display":"none"});
            $("#gene-info-summary-content").find(".gene-name").css({"display":"none"});

            $("#gene-info-summary-header").find(".gene-chromosome").css({"width":"55%"});
            $("#gene-info-summary-content").find(".gene-chromosome").css({"width":"55%", "font-size":"2em", "padding-top":"0"});

            var geneName = "<%=geneName%>";
            var geneNameSplit = geneName.split(":");
            var chromosomeNum = geneNameSplit[0].replace("CHR","");
            var genePosition = geneNameSplit[1].split("-");

            $("#gene-info-summary-content").find(".gene-chromosome").append("CHR<span class='chromosome'>"+chromosomeNum+"</span>: <span class='start-position'>"+ genePosition[0] +"</span> - <span class='end-position'>"+genePosition[1]+"</span>");

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
            $('div.geneWindowDescription').hide();

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


                $("#gene-info-summary-content").find(".gene-chromosome").append("<span class='chromosome'>"+positioningInformation.chromosome+"</span>: <span class='start-position'>"+ positioningInformation.startPosition +"</span> - <span class='end-position'>"+positioningInformation.endPosition+"</span>");
                //$("#gene-info-summary-content").find(".gene-region-start").append(""+positioningInformation.startPosition);
                //$("#gene-info-summary-content").find(".gene-region-end").append(""+positioningInformation.endPosition);

                $(".pop-top").popover({placement: 'top'});
                $(".pop-right").popover({placement: 'right'});
                $(".pop-bottom").popover({placement: 'bottom'});
                $(".pop-left").popover({placement: 'left'});
                $(".pop-auto").popover({placement: 'auto'});
                loading.hide();



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

    <div class="container-fluid" style="padding: 0 2.5%;">

        <div class="gene-info-container row">
            <div class="gene-info-view col-md-12">
                <div id="gene-info-summary-wrapper">
                    <div id="gene-info-summary-header">
                        <div class="gene-name" style="width:25%;">Gene<a class="edit-btn" onclick="showHideElement('#geneSearchHolder')">Edit</a></div>
                        <div class="gene-chromosome" style="width:30%;">Chromosome: Start position - End position<a class="edit-btn" onclick="showHideElement('#regionSearchHolder'); feedInitialInput('#regionSearchHolder');">Edit</a></div>
                        <div class="gene-phenotype" style="width:45%;">Phenotype<a class="edit-btn" onclick="showHideElement('#phenotypeSearchHolder')">Edit</a></div>
                    </div>
                    <div id="gene-info-summary-content">
                        <div class="gene-name" style="width:25%; font-size: 2em; height: 65px; "><%=geneName%>

                            <div class="gene-search-holder" id="geneSearchHolder" style="display: none;">
                                <div class="gene-search">
                                    <input id="generalized-input" value="" type="text" class="form-control input-default">
                                    <button id="generalized-go" class="btn btn-primary" type="button" >GO</button>
                                </div>
                            </div>
                        </div>
                        <div class="gene-chromosome" style="width:30%; height: 65px; font-size: 1.25em; padding-top: 12px;">
                            <div class="region-search-holder hide-element" id="regionSearchHolder" style="display: none;">
                                <div class="region-search">
                                    <div class="col-md-2 input-wrapper">
                                        <input id="chromosomeInput" value="" type="text" class="form-control input-default">
                                    </div>
                                    <div class="col-md-4 input-wrapper">
                                        <input id="startPositionInput" value="" type="text" class="form-control input-default">
                                    </div>
                                    <div class="col-md-4 input-wrapper">
                                        <input id="endPositionInput" value="" type="text" class="form-control input-default">
                                    </div>
                                    <div class="col-md-2">
                                        <button id="regionSearchGo" class="btn btn-primary" type="button" onclick="mpgSoftware.geneInfo.launchRegionPage($('#chromosomeInput').val(),$('#startPositionInput').val(),$('#endPositionInput').val());">GO</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="gene-phenotype" style="width:45%; height: 65px; font-size: 1.25em; padding-top: 12px;">
                            <div class="phenotype-search-holder hide-element" id="phenotypeSearchHolder" style="display: none;">
                                <div class="phenotype-search">
                                    <select id="phenotypeInput" class="form-control input-sm trait-input selectpicker" data-live-search="true">
                                    </select>
                                </div>
                            </div>
                            <span class="pname"></span>
                        </div>
                    </div>
                </div>

                <div class="gene-info-bellow-title">
                    <div class="gene-traffic-light" style="width:30%; float: left;">
                        <div id='trafficLightHolder'>
                            <div class='signal-level-2'>&nbsp;</div>
                            <div class='signal-level-3'>&nbsp;</div>
                        </div>
                        <div class="trafficExplanations trafficExplanation1 unemphasize" style="font-size:18px; text-align: left;">
                            No evidence for signal&nbsp;<g:helpText title="no.evidence.help.header" placement="right" body="no.evidence.help.text"/>
                        </div>
                        <div class="trafficExplanations trafficExplanation2 unemphasize" style="font-size:18px; text-align: left;">
                            Suggestive evidence for signal&nbsp;<g:helpText title="suggestive.evidence.help.header" placement="right" body="suggestive.evidence.help.text"/>
                        </div>
                        <div class="trafficExplanations trafficExplanation3 unemphasize" style="font-size:18px; text-align: left;">
                            Strong evidence for signal&nbsp;<g:helpText title="strong.evidence.help.header" placement="right" body="strong.evidence.help.text"/>
                        </div>
                    </div>
<!--
                    <div class="gene-search-holder" style="width: 70%; float: right; position: relative;">
                        <div class="gene-search" style=" text-align: right; position: absolute; top: 10px; right: 305px;">Look for another gene or region</div>
                        <div class="gene-search" style=" position: absolute; padding: 0; top: 0; right: 0;">
                            <input id="generalized-input" value="" type="text" class="form-control input-default">
                            <button id="generalized-go" class="btn btn-primary" type="button" >Go</button>

                        </div>
                    </div>-->
                </div>

                <div class="gene-page-section-header">
                    <h2><span style="">Genes in the region</span></h2>
                </div>

                <div class="matchedGenesGoHere well well-gene-page"></div>

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





<!--
                <div class="col-md-12" style="padding-top: 30px;">

                    <g:render template="geneSummary" model="[geneToSummarize:geneName]"/>

                </div>
                -->



                <g:render template="../templates/dynamicUiTemplate"/>
                <g:render template="../templates/geneSignalSummaryTemplate"/>
                <g:render template="../templates/variantSearchResultsTemplate" />
                <g:render template="geneSignalSummary"  model="[signalLevel:1,geneToSummarize:geneName]"/>
                <g:render template="../templates/variantSearchResultsTemplate" />


                <div class="accordion" id="accordion2">
                <g:if test="${portalVersionBean.exposeVariantAndAssociationTable}">
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
                </g:if>
                <g:if test="${portalVersionBean.exposeIgvDisplay}">

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

                </g:if>



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


                <g:if test="${portalVersionBean.exposeIgvDisplay}">
                    <div class="separator"></div>

                    <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                           'accordionHeaderClass': 'accordion-heading',
                                                                           'modifiedTitle': 'Interactive burden test',
                                                                           'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.',
                                                                           'allowExperimentChoice': 0,
                                                                           'allowPhenotypeChoice' : 1,
                                                                           'allowStratificationChoice': 1,
                                                                           'grsVariantSet':'']"/>
                </g:if>




                <div style="padding: 7px 0 3px 15px; border-radius: 0px; margin-top: 15px; background-color:#fff; ">

                    <span class="glyphicon glyphicon-link" aria-hidden="true"></span> External resources:&nbsp;
                        <g:render template="findOutMoreCompact"/>

                </div>



                </div>
            </div>
        </div>
    </div>

</div>
<g:render template="/templates/burdenTestSharedTemplate" />
</body>
</html>

