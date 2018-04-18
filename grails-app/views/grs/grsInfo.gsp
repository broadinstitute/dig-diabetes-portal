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

            %{--<g:render template="/templates/burdenTestSharedTemplate" />--}%

            <g:render template="/widgets/burdenTestShared" model="['variantIdentifier': '',
                                                                   'accordionHeaderClass': 'accordion-heading',
                                                                   'modifiedTitle': 'Interactive burden test',
                                                                   'modifiedGaitSummary': 'The Genetic Association Interactive Tool (GAIT) allows you to compute the disease or phenotype burden for this gene, using custom sets of variants, samples, and covariates. In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.',
                                                                   'allowExperimentChoice': 0,
                                                                   'allowPhenotypeChoice' : 1,
                                                                   'allowStratificationChoice': 1    ]"/>

        </div>
    </div>

</div>

</body>
</html>

