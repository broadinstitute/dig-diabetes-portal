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

        var genePageExtent = 100000;

        var positioningInformation = {
            chromosome: data.geneInfo.CHROM,
            startPosition: data.geneInfo.BEG - genePageExtent,
            endPosition: data.geneInfo.END + genePageExtent
        };
        $(document).ready(function() {
            // call this inside the ready function because the page is still loading when the the parent
            // ajax calls returns
            var portalType = "t2d";
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
            portalType = "stroke";
            </g:if>
            <g:renderNotBetaFeaturesDisplayedValue>
//            if (portalType === 't2d'){
                mpgSoftware.locusZoom.initializeLZPage('geneInfo', null, positioningInformation,
                        "#lz-47","#collapseLZ",'${phenotype}','${locusZoomDataset}',
                        '${createLink(controller:"gene", action:"getLocusZoom")}',
                        '${createLink(controller:"variantInfo", action:"variantInfo")}',
                        mpgSoftware.locusZoom.broadAssociationSource);
//            }

            </g:renderNotBetaFeaturesDisplayedValue>
            $('span[data-textfield="variantName"]').append(data.geneInfo.ID);
            $('#variantPageText').hide();
            $('#genePageText').show();
        });


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
</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container">
            <div class="gene-info-view">

                <h1>
                    <em><%=geneName%></em>
                </h1>

                <g:render template="geneSummary" model="[geneToSummarize:geneName]"/>

                <g:renderBetaFeaturesDisplayedValue>
                    <g:render template="geneSignalSummary"  model="[signalLevel:1,geneToSummarize:geneName]"/>
                </g:renderBetaFeaturesDisplayedValue>


                <div class="accordion" id="accordion2">
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


                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <g:renderBetaFeaturesDisplayedValue>
                        <div class="separator"></div>
                        <g:render template="/widgets/gwasRegionSummary"
                                  model="['phenotypeList': phenotypeList, 'regionSpecification': regionSpecification]"/>
                        </g:renderBetaFeaturesDisplayedValue>
                    </g:if>
                    <g:if test="${1}">

                        <div class="separator"></div>

                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion2"
                                   href="#collapseIgv">
                                    <h2><strong><g:message code="gene.igv.title"
                                                           default="Explore variants with IGV"/></strong></h2>
                                </a>
                            </div>

                            <div id="collapseIgv" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:render template="../trait/igvBrowser"/>
                                </div>
                            </div>
                        </div>

                        <script>
                            $('#accordion2').on('shown.bs.collapse', function (e) {
                                if (e.target.id === "collapseIgv") {
                                    setUpIgv('<%=geneName%>');
                                }

                            });
                            $('#collapseOne').collapse({hide: true})
                        </script>

                    </g:if>
                    <script>
                        $('#collapseOne').collapse({hide: true})
                    </script>






                    <div class="separator"></div>

                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion2"
                               href="#collapseTwo">
                                <h2><strong><g:message code="gene.continentalancestry.title"
                                                       default="variation across continental ancestry"/></strong>
                                </h2>
                            </a>
                        </div>

                        <g:render template="variationAcrossContinents"/>

                    </div>





                        <g:renderNotBetaFeaturesDisplayedValue>

                            <div class="separator"></div>

                            <g:render template="/widgets/locusZoomPlot"/>

                        </g:renderNotBetaFeaturesDisplayedValue>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">

                        <div class="separator"></div>

                        <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                               'modifiedTitle': 'Interactive burden test',
                                                                               'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.']"/>


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

</body>
</html>

