<style>
/* Popover */
.popover {
    border: 2px dotted red;
}

/* Popover Header */
.popover-title {
    background-color: #73AD21;
    color: #FFFFFF;
    font-size: 28px;
    text-align:center;
}

/* Popover Body */
.popover-content {
    background-color: #DDDDDD;
    color: #000099;
    padding: 25px;
}

/* Popover Arrow */
.arrow {
    border-right-color: red !important;
}
td.tissueTable.informationIsPresent{
    background: #54FF5E;
;
}

</style>
<div id="tableHeaderHolder"></div>



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


return {
    displayVariantResultsTable:displayVariantResultsTable
}
}());


})();

$( document ).ready(function() {
    mpgSoftware.geneTableInitializer.geneTableConfiguration();
    if ("${portalVersionBean.getExposeHiCData()}"==="1"){
        mpgSoftware.geneSignalSummaryMethods.hiGlassExperiment(document);
    }
});


</script>

