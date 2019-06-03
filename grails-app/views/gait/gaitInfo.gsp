<%--
  Created by IntelliJ IDEA.
  User: psingh
  Date: 5/21/19
  Time: 1:44 AM
--%>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="gaitInfo"/>
    <r:require modules="geneInfo"/>
    <r:require modules="burdenTest"/>
    <r:layoutResources/>


    <link type="application/font-woff">
    <link type="application/vnd.ms-fontobject">
    <link type="application/x-font-ttf">
    <link type="font/opentype">

</head>

<body>

<div id="rSpinner" class="dk-loading-wheel center-block" style="display:none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<script>

    $( document ).ready(function() {
        "use strict";

        var drivingVariables = {
            %{--portalTypeString:"${g.portalTypeString()}"--}%
            geneName: 'SLC30A8'
            %{--sampleDataSet: "${sampleDataSet}",--}%
            %{--burdenDataSet: "${burdenDataSet}",--}%
            %{--geneChromosome: '${geneChromosome}',--}%
            %{--geneExtentBegin: ${geneExtentBegin},--}%
            %{--geneExtentEnd: ${geneExtentEnd},--}%
            %{--igvIntro:  '${igvIntro}',--}%
            %{--defaultPhenotype: '${defaultPhenotype}',--}%
            %{--identifiedGenes: '${identifiedGenes}',--}%
            %{--firstPropertyName: '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().propertyName}',--}%
            %{--firstStaticPropertyName:'${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().dataType}',--}%
            %{--defaultTissues: ${(defaultTissues as String).encodeAsJSON()},--}%
            %{--defaultTissuesDescriptions: ${(defaultTissuesDescriptions as String).encodeAsJSON()},--}%
            %{--lzCommon: 'lzCommon',--}%
            %{--lzCredSet: 'lzCredSet',--}%
            %{--vrtUrl:  '${createLink(controller: "VariantSearch", action: "gene")}',--}%
            %{--redLightImage: '<r:img uri="/images/redlight.png"/>',--}%
            %{--yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',--}%
            %{--greenLightImage: '<r:img uri="/images/greenlight.png"/>',--}%
            %{--suppressBurdenTest: !(${sampleLevelSequencingDataExists}),--}%
            %{--variantInfoUrl: '${createLink(controller: "VariantInfo", action: "variantInfo")}',--}%
            %{--currentPhenotype: $('.chosenPhenotype').attr('id'),--}%
            %{--retrieveTopVariantsAcrossSgsUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',--}%
            %{--burdenTestAjaxUrl:'${createLink(controller: "gene", action: "burdenTestAjax")}',--}%
            %{--preferIgv:($('input[name=genomeBrowser]:checked').val()==='2'),--}%
            %{--sampleMetadataExperimentAjaxUrl: '${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}',--}%
            %{--sampleMetadataAjaxWithAssumedExperimentUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",--}%
            %{--variantOnlyTypeAheadUrl: "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",--}%
            %{--sampleMetadataAjaxUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",--}%
            %{--generateListOfVariantsFromFiltersAjaxUrl: "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",--}%
            %{--retrieveSampleSummaryUrl: "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",--}%
            %{--variantAndDsAjaxUrl: "${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",--}%
            %{--burdenTestVariantSelectionOptionsAjaxUrl: "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}",--}%
            %{--recomb_rateMsg:"<g:message code='controls.shared.igv.tracks.recomb_rate' />",--}%
            %{--genesMsg:"<g:message code='controls.shared.igv.tracks.genes' />",--}%
            %{--retrievePotentialIgvTracksUrl:"${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",--}%
            %{--getDataUrl: "${createLink(controller:'trait', action:'getData', absolute:'false')}",--}%
            %{--traitInfoUrl: "${createLink(controller:'trait', action:'traitInfo', absolute:'true')}",--}%
            %{--getLocusZoomUrl: '${createLink(controller:"gene", action:"getLocusZoom")}',--}%
            %{--retrieveFunctionalDataAjaxUrl: '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',--}%
            %{--getLocusZoomFilledPlotUrl: '${createLink(controller:"gene", action:"getLocusZoomFilledPlot")}',--}%
            %{--fillCredibleSetTableUrl: '${g.createLink(controller: "RegionInfo", action: "fillCredibleSetTable")}',--}%
            %{--assayIdList: "${assayIdList}",--}%
            %{--geneChromosomeMinusChr:function(){if ('${geneChromosome}'.indexOf('chr')==0) { return '${geneChromosome}'.substr(3)} else {return '${geneChromosome}' }},--}%
            %{--genePageWarning:"${genePageWarning}"--}%
        };

        mpgSoftware.gaitInfo.setGaitInfoData(drivingVariables);
        mpgSoftware.gaitInfo.buildGaitDisplay();


        var pageTitle = $(".accordion-toggle").find("h2").text();
        var textUnderTitle = $(".accordion-inner").find("h5").text();
        $(".accordion-toggle").remove();
        $(".accordion-inner").find("h5").remove();

        var PageTitleDiv = '<div class="row">\n'+
            '<div class="col-md-12">\n'+
            '<h1 class="dk-page-title">' + pageTitle + '</h1>\n'+
            '<div class="col-md-12">\n'+
            '<h5 class="dk-under-header">' + textUnderTitle + '</h5>\n'+
            '</div></div>';

        $(PageTitleDiv).insertBefore(".gene-info-container");
        $(".user-interaction").addClass("col-md-12");


        /* end of DK's script */

    });



</script>

<style>
ul.nav-tabs > li > a { background: none !important; }
ul.nav-tabs > li.active > a { background-color: #fff !important; }
#modeledPhenotypeTabs li.active > a { background-color: #9fd3df !important; }
</style>

<div id="main">

    <div class="container">

        <div class="gene-info-container row">

            <em style="font-weight: 900;"><%=geneName%></em>

            <g:render template="/templates/burdenTestSharedTemplate" model="['variantIdentifier': 'rs13266634', 'accordionHeaderClass': 'accordion-heading']" />



            %{--If its gene Gait page then allowExperimentChoice = 0 and 'geneName':'geneName'--}%
            <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': 'rs13266634',
                                                                   'accordionHeaderClass': 'accordion-heading',
                                                                   'modifiedTitle': 'Variant Interactive burden test',
                                                                   'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.',
                                                                   'allowExperimentChoice': 1,
                                                                   'allowPhenotypeChoice': 1,
                                                                   'allowStratificationChoice': 1,
                                                                   'grsVariantSet':'',
                                                                   'geneName':'']"/>



        </div>
    </div>

</div>

</body>
</html>

