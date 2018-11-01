<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="datatables"/>
    <r:require modules="geneInfo"/>
    <r:require modules="grsInfo"/>
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
            %{--geneName: '${geneName}',--}%
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

        mpgSoftware.grsInfo.setGrsInfoData(drivingVariables);
        mpgSoftware.grsInfo.buildGrsDisplay();

    });

</script>

<div id="main">

    <div class="container">

        <div class="gene-info-container row">

            <g:render template="/templates/burdenTestSharedTemplate" />

            <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                   'accordionHeaderClass': 'accordion-heading',
                                                                   'modifiedTitle': 'Genetic risk score module',
                                                                   'modifiedGaitSummary': 'The Genetic Risk Score (GRS) tool takes a defined set of T2D risk-associated variants and allows you to calculate the  p-value for association of this set with different phenotypes, potentially revealing genetic relationships between phenotypes. Start by selecting a dataset and a phenotype to compare, edit the set of variants if desired, and click Launch to calculate the p-value.',
                                                                   'allowExperimentChoice': 1,
                                                                   'allowPhenotypeChoice' : 1,
                                                                   'allowStratificationChoice': 1,
                                                                   'grsVariantSet':'anuba_T2D']"/>

        </div>
    </div>

</div>

</body>
</html>

