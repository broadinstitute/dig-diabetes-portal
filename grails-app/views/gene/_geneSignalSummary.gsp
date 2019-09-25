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
                    generalizedInputId:'generalized-dynamic-gene-input',
                    generalizedGoButtonId:'generalized-dynamic-gene-go',
                    vrtUrl:  '${createLink(controller: "VariantSearch", action: "gene")}',
                    redLightImage: '<r:img uri="/images/redlight.png"/>',
                    yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',
                    greenLightImage: '<r:img uri="/images/greenlight.png"/>',
                    suppressBurdenTest: !(${sampleLevelSequencingDataExists}),
                    variantInfoUrl: '${createLink(controller: "VariantInfo", action: "variantInfo")}',
                    currentPhenotype: $('.chosenPhenotype').attr('id'),
                    retrieveTopVariantsAcrossSgsUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',
                    retrieveTopVariantsAcrossSgsMinUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgsMin")}',
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
                    generalizedTypeaheadUrl:"${createLink(controller: 'gene', action: 'index')}",
                    retrievePotentialIgvTracksUrl:"${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                    getDataUrl: "${createLink(controller:'trait', action:'getData', absolute:'false')}",
                    traitInfoUrl: "${createLink(controller:'trait', action:'traitInfo', absolute:'true')}",
                    getLocusZoomUrl: '${createLink(controller:"gene", action:"getLocusZoom")}',
                    retrieveFunctionalDataAjaxUrl: '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',
                    getGRSListOfVariantsAjaxUrl:"${createLink(controller:'grs',action: 'getGRSListOfVariantsAjax')}",
                    getLocusZoomFilledPlotUrl: '${createLink(controller:"gene", action:"getLocusZoomFilledPlot")}',
                    fillCredibleSetTableUrl: '${g.createLink(controller: "RegionInfo", action: "fillCredibleSetTable")}',
                    fillGeneComparisonTableUrl: '${g.createLink(controller: "RegionInfo", action: "fillGeneComparisonTable")}',
                    availableAssayIdsJsonUrl: '${g.createLink(controller: "RegionInfo", action: "availableAssayIdsJson")}',
                    calculateGeneRankingUrl: '${g.createLink(controller: "RegionInfo", action: "calculateGeneRanking")}',
                    retrieveEqtlDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEqtlData")}',
                    retrieveEqtlDataWithVariantsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEqtlDataWithVariants")}',
                    retrieveModDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveModData")}',
                    retrieveAbcDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveAbcData")}',
                    retrieveECaviarDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveECaviarData")}',
                    retrieveColocDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveColocData")}',
                    retrieveDepictDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDepictData")}',
                    retrieveDepictGeneSetUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDepictGeneSetData")}',
                    retrieveDnaseDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDnaseData")}',
                    retrieveH3k27acDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveH3k27acData")}',
                    retrieveGeneLevelAssociationsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveGeneLevelAssociations")}',
                    retrieveListOfGenesInARangeUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveListOfGenesInARange")}',
                    retrieveEffectorGeneInformationUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEffectorGeneInformation")}',
                    geneInfoAjaxUrl: '${g.createLink(controller: "Gene", action: "geneInfoAjax")}',
                    retrieveVariantsWithQtlRelationshipsUrl:'${g.createLink(controller: "RegionInfo", action: "retrieveVariantsWithQtlRelationships")}',
                    assayIdList: "${assayIdList}",
                    geneChromosomeMinusChr:function(){if ('${geneChromosome}'.indexOf('chr')==0) { return '${geneChromosome}'.substr(3)} else {return '${geneChromosome}' }},
                    genePageWarning:"${genePageWarning}",
                    regionSpecificVersion:${regionSpecificVersion},
                    epigeneticAssays:"${portalVersionBean.getEpigeneticAssays()}",
                    tissueRegionOverlapMatcher:"${portalVersionBean.getTissueRegionOverlapMatcher().join(",")}".split(","),
                    tissueRegionOverlapDisplayMatcher:"${portalVersionBean.getTissueRegionOverlapDisplayMatcher().join(",")}".split(","),
                    exposeGeneComparisonTable:"${portalVersionBean.getExposeGeneComparisonTable()}",
                    exposePredictedGeneAssociations:"${portalVersionBean.getExposePredictedGeneAssociations()}",
                    exposeHiCData:"${portalVersionBean.getExposeHiCData()}",
                    exposeDynamicUi:"${portalVersionBean.getExposeDynamicUi()}",
                    exposeCommonVariantTab:"${portalVersionBean.getExposeCommonVariantTab()}",
                    exposeRareVariantTab:"${portalVersionBean.getExposeRareVariantTab()}",
                    exposeGenesInRegionTab:"${portalVersionBean.getExposeGenesInRegionTab()}",
                    exposeRegionAdjustmentOnGenePage:"${portalVersionBean.getExposeRegionAdjustmentOnGenePage()}",
                    exposeGeneTableOnDynamicUi:"${portalVersionBean.getExposeGeneTableOnDynamicUi()}",
                    exposeVariantTableOfDynamicUi:"${portalVersionBean.getExposeVariantTableOfDynamicUi()}",
                    dynamicTableType:'geneTable',
                    utilizeBiallelicGait:"${portalVersionBean.getUtilizeBiallelicGait()}",
                    dataAnnotationTypes: [
                        {   code: 'GHDR', // manages the header.  Most of the records in this particular category have no match in the code, unlike all of the other categories
                            category: 'blank',
                            displayCategory: 'Genes',
                            subcategory: 'Genes subcategory',
                            displaySubcategory: 'Genes subcategory',
                            headerWriter:'dynamicGeneTableHeaderV3',
                            cellBodyWriter:'dynamicGeneTableHeaderV3',
                            categoryWriter:'no category writer',
                            subCategoryWriter:'no subcategory writer',
                            numberRecordsCellPresentationStringWriter:'no record numbers string writer',
                            significanceCellPresentationStringWriter:'no significance string writer',
                            sortingSubroutine:'geneHeader',
                            packagingString:'mpgSoftware.dynamicUi.geneHeaders',
                            internalIdentifierString:'getTissuesFromProximityForLocusContext'
                        },
                        {   code: 'FIR',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'Firth gene associations',
                            displaySubcategory: 'Firth gene associations',
                            cellBodyWriter:'geneFirthAssociationTableBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'geneFirthAssociationTableSubCategory',
                            numberRecordsCellPresentationStringWriter:'geneFirthAssociationTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'geneFirthAssociationTableSignificanceCellPresentationString',
                            sortingSubroutine:'Firth',
                            packagingString:'mpgSoftware.dynamicUi.geneBurdenFirth',
                            internalIdentifierString:'getFirthGeneAssociationsForGeneTable'
                        },
                        {   code: 'SKA',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'SKAT gene associations',
                            displaySubcategory: 'SKAT gene associations',
                            cellBodyWriter:'geneSkatAssociationTableBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'geneSkatAssociationTableSubCategory',
                            numberRecordsCellPresentationStringWriter:'geneSkatAssociationTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'geneSkatAssociationTableSignificanceCellPresentationString',
                            sortingSubroutine:'SKAT',
                            packagingString:'mpgSoftware.dynamicUi.geneBurdenSkat',
                            internalIdentifierString:'getSkatGeneAssociationsForGeneTable'
                        },
                        {   code: 'MET',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'MetaXcan',
                            displaySubcategory: 'MetaXcan',
                            cellBodyWriter:'metaxcanTableBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'metaxcanTableSubCategory',
                            numberRecordsCellPresentationStringWriter:'metaxcanTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'metaxcanTableSignificanceCellPresentationString',
                            sortingSubroutine:'MetaXcan',
                            packagingString:'mpgSoftware.dynamicUi.metaXcan',
                            internalIdentifierString:'getGeneAssociationsForGenesTable'
                        },
                        {   code: 'DEP_GS',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'DEPICT gene set',
                            displaySubcategory: 'DEPICT gene sets',
                            cellBodyWriter:'depictGeneSetBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'depictGeneSetSubCategory',
                            numberRecordsCellPresentationStringWriter:'depictGeneSetTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'depictGeneSetTableSignificanceCellPresentationString',
                            sortingSubroutine:'DEPICT',
                            packagingString:'mpgSoftware.dynamicUi.depictGeneSets',
                            internalIdentifierString:'getDepictGeneSetForGenesTable'
                        },
                        {   code: 'DEP_GP',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'DEPICT gene prioritization',
                            displaySubcategory: 'DEPICT gene prioritization',
                            cellBodyWriter:'depictGeneTableBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'depictGeneTableSubCategory',
                            numberRecordsCellPresentationStringWriter:'depictGenePvalueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'depictGenePvalueTableSignificanceCellPresentationString',
                            sortingSubroutine:'DEPICT',
                            packagingString:'mpgSoftware.dynamicUi.depictGenePvalue',
                            internalIdentifierString:'getInformationFromDepictForGenesTable'
                        },
                        {   code: 'ECA',
                            category: 'Annotation',
                            displayCategory: 'Posterior probability',
                            subcategory: 'eCAVIAR',
                            displaySubcategory: 'eCAVIAR',
                            cellBodyWriter:'eCaviarBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'eCaviarSubCategory',
                            numberRecordsCellPresentationStringWriter:'eCaviarTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'eCaviarTableSignificanceCellPresentationString',
                            sortingSubroutine:'eCAVIAR',
                            packagingString:'mpgSoftware.dynamicUi.eCaviar',
                            internalIdentifierString:'getRecordsFromECaviarForGeneTable'
                        },
                        {   code: 'COL',
                            category: 'Annotation',
                            displayCategory: 'Posterior probability',
                            subcategory: 'COLOC',
                            displaySubcategory: 'COLOC',
                            cellBodyWriter:'colocBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'colocSubCategory',
                            numberRecordsCellPresentationStringWriter:'colocTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'colocTableSignificanceCellPresentationString',
                            sortingSubroutine:'COLOC',
                            packagingString:'mpgSoftware.dynamicUi.coloc',
                            internalIdentifierString:'getRecordsFromColocForGeneTable'
                        },
                        {   code: 'MOD',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'MOD',
                            displaySubcategory: 'Mouse knockout phenotypes',
                            cellBodyWriter:'dynamicGeneTableModBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'dynamicGeneTableModSubCategory',
                            numberRecordsCellPresentationStringWriter:'modTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'modTableSignificanceCellPresentationString',
                            sortingSubroutine:'MOD',
                            packagingString:'mpgSoftware.dynamicUi.mouseKnockout',
                            internalIdentifierString:'getAnnotationsFromModForGenesTable'
                        },
                        {   code: 'EFF',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Effector gene list',
                            displaySubcategory: 'T2D effector gene list',
                            cellBodyWriter:'dynamicGeneTableEffectorGeneBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'dynamicGeneTableEffectorGeneSubCategory',
                            numberRecordsCellPresentationStringWriter:'effectorGeneTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'effectorGeneTableSignificanceCellPresentationString',
                            sortingSubroutine:'straightAlphabetic',
                            packagingString:'mpgSoftware.dynamicUi.effectorGene',
                            internalIdentifierString:'getInformationFromEffectorGeneListTable'
                        }
                        // additional sorting terms
                        ,
                        {
                            sortingSubroutine:'categoryName',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            packagingString:'mpgSoftware.dynamicUi.geneHeaders',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            sortingSubroutine:'geneMethods',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        // ,{   code: 'EQT',
                        //     category: 'Annotation',
                        //     displayCategory: 'Annotation',
                        //     subcategory: 'GTEx eQTL',
                        //     displaySubcategory: 'GTEx eQTL',
                        //     cellBodyWriter:'dynamicGeneTableEqtlSummaryBody',
                        //     categoryWriter:'sharedCategoryWriter',
                        //     subCategoryWriter:'dynamicGeneTableEqtlSummarySubCategory' },
                        // {   code: 'ABC',
                        //     category: 'Annotation',
                        //     displayCategory: 'Annotation',
                        //     subcategory: 'ABC',
                        //     displaySubcategory: 'ABC',
                        //     cellBodyWriter:'dynamicAbcGeneTableBody',
                        //     categoryWriter:'sharedCategoryWriter',
                        //     subCategoryWriter:'dynamicAbcGeneTableSubCategory' }

                    ],
                    dynamicTableConfiguration: {
                        emptyBodyRecord:'#emptyBodyRecord',
                        emptyHeaderRecord:'#emptyHeaderRecord',
                        domSpecificationForAccumulatorStorage:'#configurableUiTabStorage',
                        formOfStorage: 'loadFromTable',
                        initializeSharedTableMemory:  'table.combinedGeneTableHolder',
                        organizingDiv:  '#DataTables_Table_0_wrapper',
                        initialOrientation:'geneTableGeneHeaders'
                    }
                };
                mpgSoftware.geneSignalSummaryMethods.setSignalSummarySectionVariables(drivingVariables);
                mpgSoftware.geneSignalSummaryMethods.initialPageSetUp(drivingVariables);
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariantsDirectlyByPhenotype(drivingVariables.defaultPhenotype,
                    mpgSoftware.geneSignalSummaryMethods.getSingleBestPhenotypeAndLaunchInterface,{favoredPhenotype:drivingVariables['defaultPhenotype'],limit:1,useMinimalCall:true});
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.displayInterestingPhenotypes,
                    {favoredPhenotype:drivingVariables['defaultPhenotype']});
                if (${portalVersionBean.getExposePredictedGeneAssociations()}){
                    mpgSoftware.geneSignalSummaryMethods.selfContainedGeneRanking();
                }
                mpgSoftware.geneSignalSummaryMethods.tableInitialization();
            };




return {
    displayVariantResultsTable:displayVariantResultsTable,
    initializeSignalSummarySection:initializeSignalSummarySection
}
}());


})();

$( document ).ready(function() {
    mpgSoftware.geneSignalSummary.initializeSignalSummarySection();
    if ("${portalVersionBean.getExposeHiCData()}"==="1"){
        mpgSoftware.geneSignalSummaryMethods.hiGlassExperiment(document);
    }
});


</script>

