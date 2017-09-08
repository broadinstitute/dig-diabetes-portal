<style>
td.tissueTable.Active_TSS{
    background: #0000FF;
}
td.tissueTable.Weak_TSS{
    background: #4682B4;
}
td.tissueTable.Genic_enhancer{
    background: #1E90FF;
}
td.tissueTable.Active_enhancer_1{
    background: #87CEFA;
}
td.tissueTable.Active_enhancer_2{
    background: #B0E0E6;
}
td.tissueTable.Weak_enhancer{
    background: #E6E6FA;
}
/*h3k27ac corresponds to assay ID = 1*/
td.tissueTable.matchingRegion1_0{
    background: #3333FF;
}
td.tissueTable.matchingRegion1_1{
     background: #3366FF;
}
td.tissueTable.matchingRegion1_2{
      background: #3399FF;
}
td.tissueTable.matchingRegion1_3{
       background: #3399FF;
}
td.tissueTable.matchingRegion1_4{
        background: #33CCFF;
}
td.tissueTable.matchingRegion1_5{
         background: #33FFFF;
}
/*DNase corresponds to assay ID = 2*/
td.tissueTable.matchingRegion2_0{
    background: #FF0033;
}
td.tissueTable.matchingRegion2_1{
    background: #FF3333;
}
td.tissueTable.matchingRegion2_2{
    background: #FF6633;
}
td.tissueTable.matchingRegion2_3{
    background: #FF9933;
}
td.tissueTable.matchingRegion2_4{
    background: #FFCC33;
}
td.tissueTable.matchingRegion2_5{
    background: #FFFF33;
}

.credibleSetTableGoesHere th.niceHeaders{
    background: white;
    transform-origin: left;
    -webkit-transform: rotate(-60deg);
    transform: rotate(-60deg);
    max-width: 2px;
}
.hover {
    position:relative;
    top:0px;
    left:0px;
    line-height: 100%;
    display:inline-block;

}

.tooltip {
    top:-15px;
    width:100px;
    position:absolute;

    background-color:#6b9aff;
    color:white;
    border-radius:5px;
    opacity:0;
    -webkit-transition: opacity 0.5s;
    -moz-transition:  opacity 0.5s;
    -ms-transition: opacity 0.5s;
    -o-transition:  opacity 0.5s;
    transition:  opacity 0.5s;
    line-height: 100%;
}

.hover:hover .tooltip {
    opacity:1;
}

</style>

<div class="row">
    <div class="pull-right" style="display:none">
        <label for="signalPhenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                            default="Change phenotype choice"/></label>
        &nbsp;
        <select id="signalPhenotypeTableChooser" name="phenotypeTableChooser"
                onchange="mpgSoftware.geneSignalSummaryMethods.refreshTopVariantsByPhenotype(this,mpgSoftware.geneSignalSummaryMethods.updateSignificantVariantDisplay,
                        {preferIgv:($('input[name=genomeBrowser]:checked').val()==='2')})">
        </select>
    </div>
</div>
<div >%{--should hold the Choose data set panel--}%
    <div class="panel-heading">
        <div class="row">
            <div class="col-md-2 col-xs-12">
                <div id='trafficLightHolder'>
                    <r:img uri="/images/undeterminedlight.png"/>
                    <div id="signalLevelHolder" style="display:none"></div>
                </div>

            </div>

            <div class="col-md-5 col-xs-12">
                <div class="row">
                    <div class="col-lg-12 trafficExplanations trafficExplanation1">
                        No evidence for signal
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation2">
                        Suggestive evidence for signal
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation3">
                        Strong evidence for signal
                    </div>
                </div>
            </div>

            <div class="col-md-5 col-xs-12">

            </div>

        </div>
        <div class="row interestingPhenotypesHolder">
            <div class="col-xs-12">
                <div id="interestingPhenotypes">

                </div>
            </div>
<g:if test="${g.portalTypeString()?.equals('t2d')}">
            <div class="col-xs-offset-2 col-xs-8" style="font-size:10px">
Note: traits from the Oxford Biobank exome chip dataset are currently missing from this analysis.  We hope to rectify this problem soon.
            </div></g:if>
            <div class="col-xs-2">

            </div>
        </div>


    </div>

</div>

<div class="collapse in" id="collapseExample">
    <div class="wellPlace">
        <div id="noAggregatedVariantsLocation">
            <div class="row" style="margin-top: 15px;">
                <div class="col-lg-offset-1">
                    <h4>No information about aggregated variants exists for this phenotype</h4>
                </div>
            </div>
        </div>


    </div>
</div>


<div id="BurdenHiddenHere" style="display:none">
    <g:render template="/templates/burdenTestSharedTemplate" />
    <g:render template="/templates/igvBrowserTemplate" />
</div>
<g:render template="/templates/variantSearchResultsTemplate" />

<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.geneSignalSummary = (function () {

                //var rememberSignalSummaryVariables = {};

                var displayVariantResultsTable = function(phenotypeCode){





                    var filtersAsJson = [{"comparator":"<","dataset":"ExChip_CAMP_mdv25","phenotype":"FI","prop":"P_VALUE","value":"0.001"}];

                    var drivingVariables = {
                        interfaceGoesHere: '#variantSearchResultsInterface',
                        variantResultsTableHeader:[],
                        makeAggregatedDataCall: true,
                        chooseAdSubtractPhenotype: [],
                        chooseAdSubtractDataSets: [],
                        chooseAdSubtractCommonProperties: [1],
                        returnToTheVariantResultsTable: [],
                        retrieveTopVariantsAcrossSgs:'<g:createLink controller="variantSearch" action="retrieveTopVariantsAcrossSgsWithSimulatedMetadata" />',
                        geneName:'${geneName}',
                        phenotypeCode:phenotypeCode,
                        retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
                        geneInfoUrl:'<g:createLink controller="gene" action="geneInfo" />',
                        variantInfoUrl:'<g:createLink controller="variantInfo" action="variantInfo" />',
                        variantSearchAndResultColumnsDataUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
                        variantSearchAndResultColumnsInfoUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
                        launchAVariantSearchUrl: "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: '%5B%7B%22phenotype%22%3A%22FI%22%2C%22dataset%22%3A%22ExChip_CAMP_mdv25%22%2C%22prop%22%3A%22P_VALUE%22%2C%22value%22%3A%220.001%22%2C%22comparator%22%3A%22%3C%22%7D%5D']"/>",
                        retrieveDatasetsAjaxUrl:"${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
                        linkBackToSearchDefinitionPage:'<a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams: "%5B17%253DFI%255BExChip_CAMP_mdv25%255DP_VALUE%253C0.001%5D"]'/>">',
                        variantTableResults:'variantTableResults',
                        queryFiltersInfo:"17%3DFI%5BExChip_CAMP_mdv25%5DP_VALUE%3C0.001",
                        proteinEffectsListInfo:"transcript_ablation%3Atranscript+ablation%7Esplice_donor_variant%3Asplice+donor+variant%7Esplice_acceptor_variant%3Asplice+acceptor+variant%7Estop_gained%3Astop+gained%7Eframeshift_variant%3Aframeshift+variant%7Estop_lost%3Astop+lost%7Einitiator_codon_variant%3Ainitiator+codon+variant%7Einframe_insertion%3Ainframe+insertion%7Einframe_deletion%3Ainframe+deletion%7Emissense_variant%3Amissense+variant%7Etranscript_amplification%3Atransript+amplification%7Esplice_region_variant%3Asplice+region+variant%7Eincomplete_terminal_codon_variant%3Aincomplete+terminal+codon+variant%7Esynonymous_variant%3Asynonymous+variant%7Estop_retained_variant%3Astop+retained+variant%7Ecoding_sequence_variant%3Acoding+sequence+variant%7Emature_miRNA_variant%3Amature+miRNA+variant%7E5_prime_UTR_variant%3A5%27+UTR+variant%7E3_prime_UTR_variant%3A3%27+UTR+variant%7Enon_coding_exon_variant%3Anon+coding+exon+variant%7Enc_transcript_variant%3Anc+transcript+variant%7Eintron_variant%3Aintron+variant%7ENMD_transcript_variant%3Anmd+transcript+variant%7Eupstream_gene_variant%3Aupstream+gene+variant%7Edownstream_gene_variant%3Adownstream+gene+variant%7ETFBS_ablation%3Atfbs+ablation%7ETFBS_amplification%3Atfbs+amplification%7ETF_binding_site_variant%3Atf+binding+site+variant%7Eregulatory_region_variant%3Aregulatory+region+variant%7Eregulatory_region_ablation%3Aregulatory+region+ablation%7Eregulatory_region_amplification%3Aregulatory+region+amplification%7Efeature_elongation%3Afeature+elongation%7Efeature_truncation%3Afeature+truncation%7Eintergenic_variant%3Aintergenic+variant",
                        localeInfo:"en_US",
                        translatedFiltersInfo:"Fasting insulin[CAMP GWAS]P-value&lt;0.001",
                        additionalPropertiesInfo:"common-common-CLOSEST_GENE:common-common-VAR_ID:common-common-DBSNP_ID:common-common-Protein_change:common-common-Consequence:common-common-CHROM:common-common-POS",
                        filtersAsJsonInfo:filtersAsJson,
                        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
                        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />',
                        commonPropsMsg:'<g:message code="variantTable.columnHeaders.commonProperties"/>',
                        geneNamesToDisplay:"[]",
                        regionSpecification:'',
                        uniqueRoot:"x"};
                    drivingVariables = mpgSoftware.variantSearchResults.setVarsToRemember(drivingVariables);
                    $("#cDataModalGoesHere").empty().append(
                            Mustache.render( $('#dataModalTemplate')[0].innerHTML,drivingVariables));
                    var fakeData = {cProperties:{dataset:['VAR_ID','DBSNP_ID','Consequence','Reference_allele','Effect_allele','PVALUE','EFFECT','GENE','MOST_DEL_SCORE','Protein_change','dataset'],
                                                 is_error: false,
                                                 numRecords: 3},
                                     columns:{
                                         pproperty:[],
                                         dproperty:[],
                                         cproperty:['VAR_ID','DBSNP_ID','PVALUE','EFFECT','dataset']
                                     },
                        translationDictionary:{'DBSNP_ID':'dbSNP ID',
                            'VAR_ID': 'Variant ID',
                            'PVALUE': 'p-Value',
                            'EFFECT':'Effect',
                            'GENE': 'Gene',
                            'MOST_DEL_SCORE': 'Deleteriousness category',
                            'Protein_change': 'Protein change',
                            'Consequence':' Predicted impact',
                            'Reference_allele': 'Major allele',
                            'Effect_allele': 'Minor allele',
                            'dataset': 'Data set'}};
                    mpgSoftware.variantSearchResults.setTranslationFunction(fakeData);
                    mpgSoftware.variantSearchResults.generateModal(fakeData,drivingVariables,drivingVariables.uniqueRoot);
                };




            var initializeSignalSummarySection = function(){
                var drivingVariables = {
                    portalTypeString:"${g.portalTypeString()}",
                    geneName: '${geneName}',
                    sampleDataSet: "${sampleDataSet}",
                    burdenDataSet: "${burdenDataSet}",
                    geneChromosome: '${geneChromosome}',
                    geneExtentBegin: ${geneExtentBegin},
                    geneExtentEnd: ${geneExtentEnd},
                    igvIntro:  '${igvIntro}',
                    defaultPhenotype: '${defaultPhenotype}',
                    identifiedGenes: '${identifiedGenes}',
                    firstPropertyName: '${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().propertyName}',
                    firstStaticPropertyName:'${lzOptions.findAll{it.defaultSelected&&it.dataType=='static'}.first().dataType}',
                    defaultTissues: ${(defaultTissues as String).encodeAsJSON()},
                    defaultTissuesDescriptions: ${(defaultTissuesDescriptions as String).encodeAsJSON()},
                    lzCommon: 'lzCommon',
                    lzCredSet: 'lzCredSet',
                    vrtUrl:  '${createLink(controller: "VariantSearch", action: "gene")}',
                    redLightImage: '<r:img uri="/images/redlight.png"/>',
                    yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',
                    greenLightImage: '<r:img uri="/images/greenlight.png"/>',
                    suppressBurdenTest: ("<%=burdenDataSet%>".indexOf('GWAS')>-1),
                    variantInfoUrl: '${createLink(controller: "VariantInfo", action: "variantInfo")}',
                    currentPhenotype: $('.chosenPhenotype').attr('id'),
                    retrieveTopVariantsAcrossSgsUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',
                    burdenTestAjaxUrl:'${createLink(controller: "gene", action: "burdenTestAjax")}',
                    preferIgv:($('input[name=genomeBrowser]:checked').val()==='2'),
                    sampleMetadataExperimentAjaxUrl: '${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}',
                    sampleMetadataAjaxWithAssumedExperimentUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
                    variantOnlyTypeAheadUrl: "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
                    sampleMetadataAjaxUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
                    generateListOfVariantsFromFiltersAjaxUrl: "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
                    retrieveSampleSummaryUrl: "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
                    variantAndDsAjaxUrl: "${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",
                    burdenTestVariantSelectionOptionsAjaxUrl: "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}",
                    recomb_rateMsg:"<g:message code='controls.shared.igv.tracks.recomb_rate' />",
                    genesMsg:"<g:message code='controls.shared.igv.tracks.genes' />",
                    retrievePotentialIgvTracksUrl:"${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                    getDataUrl: "${createLink(controller:'trait', action:'getData', absolute:'false')}",
                    traitInfoUrl: "${createLink(controller:'trait', action:'traitInfo', absolute:'true')}",
                    getLocusZoomUrl: '${createLink(controller:"gene", action:"getLocusZoom")}',
                    retrieveFunctionalDataAjaxUrl: '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',
                    getLocusZoomFilledPlotUrl: '${createLink(controller:"gene", action:"getLocusZoomFilledPlot")}',
                    fillCredibleSetTableUrl: '${g.createLink(controller: "RegionInfo", action: "fillCredibleSetTable")}',
                    experimentAssays:[]
                };
                // ${experimentAssays}
                mpgSoftware.geneSignalSummaryMethods.setSignalSummarySectionVariables(drivingVariables);
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.displayInterestingPhenotypes,
                    {favoredPhenotype:drivingVariables['defaultPhenotype']});
                mpgSoftware.geneSignalSummaryMethods.tableInitialization();
                %{--var setToRecall = {chromosome: "${geneChromosome}",--}%
                    %{--start: ${geneExtentBegin},--}%
                    %{--end: ${geneExtentEnd},--}%
                    %{--phenotype: 'T2D',--}%
                    %{--propertyName: 'P_VALUE',--}%
                    %{--dataSet: 'GWAS_DIAGRAM_eu_onlyMetaboChip_CrdSet_mdv27',--}%
                    %{--fillCredibleSetTableUrl:"${g.createLink(controller: 'RegionInfo', action: 'fillCredibleSetTable')}"--}%
                %{--};--}%
                %{--mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall);--}%
                %{--var identifiedGenes = "${identifiedGenes}";--}%
                %{--var drivingVariables = {};--}%
                %{--drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');--}%
                %{--drivingVariables["namedGeneArray"] = [];--}%
                %{--drivingVariables["supressTitle"] = [1];--}%
                %{--if ((drivingVariables["allGenes"].length>0)&&--}%
                    %{--(drivingVariables["allGenes"][0].length>0)) {--}%
                    %{--drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {--}%
                        %{--return {'name': o}--}%
                    %{--});--}%
                %{--}--}%
                %{--$(".matchedGenesGoHere").empty().append(--}%
                    %{--Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)--}%
                %{--);--}%

            };




return {
    displayVariantResultsTable:displayVariantResultsTable,
    initializeSignalSummarySection:initializeSignalSummarySection
}
}());


})();

$( document ).ready(function() {
    mpgSoftware.geneSignalSummary.initializeSignalSummarySection();

});


</script>

