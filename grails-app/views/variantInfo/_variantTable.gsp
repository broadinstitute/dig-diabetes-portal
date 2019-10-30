<script>
    // set up the tissue table
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.variantTableInitializer = (function () {

            var variantTableConfiguration = function(){
                var drivingVariables = {
                    getGRSListOfVariantsAjaxUrl:"${createLink(controller:'grs',action: 'getGRSListOfVariantsAjax')}",
                    getLocusZoomFilledPlotUrl: '${createLink(controller:"gene", action:"getLocusZoomFilledPlot")}',
                    fillCredibleSetTableUrl: '${g.createLink(controller: "RegionInfo", action: "fillCredibleSetTable")}',
                    retrieveGregorDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveGregorData")}',
                    getVariantsForNearbyCredibleSetsUrl: '${g.createLink(controller: "RegionInfo", action: "getVariantsForNearbyCredibleSets")}',
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
                    retrieveChromatinStateUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveChromatinState")}',
                    retrieveGeneLevelAssociationsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveGeneLevelAssociations")}',
                    retrieveListOfGenesInARangeUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveListOfGenesInARange")}',
                    retrieveEffectorGeneInformationUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEffectorGeneInformation")}',
                    getAllPhenotypesAjaxUrl: '${g.createLink(controller: "trait", action: "getAllPhenotypesAndTranslationAjax")}',
                    retrieveLdsrDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveLdsrData")}',
                    retrieveDepictTissueDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDepictTissues")}',
                    retrieveVariantsWithQtlRelationshipsUrl:'${g.createLink(controller: "RegionInfo", action: "retrieveVariantsWithQtlRelationships")}',
                    retrieveTopVariantsAcrossSgsUrl:'${g.createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',
                    retrieveOnlyTopVariantsAcrossSgsUrl:'${g.createLink(controller: "VariantSearch", action: "retrieveOnlyTopVariantsAcrossSgs")}',
                    getVariantsForRangeAjaxUrl:"${createLink(controller:'RegionInfo',action: 'retrieveVariantsInRange')}",
                    retrieveECaviarDataViaCredibleSetsUrl:"${createLink(controller:'RegionInfo',action: 'retrieveECaviarDataViaCredibleSets')}",
                    retrieveVariantAnnotationsUrl:"${createLink(controller:'RegionInfo',action: 'retrieveVariantAnnotations')}",
                    retrieveTfMotifUrl:"${createLink(controller:'RegionInfo',action: 'retrieveTfMotif')}",
                    dynamicTableType:'variantTable',
                    dataAnnotationTypes: [
                        {
                            code: 'VHDR',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'VariantFocusHeader',
                            displaySubcategory: 'Variant list',
                            headerWriter:'gregorTissueTableTissueHeader',
                            cellBodyWriter:'dynamicVariantTableHeader',
                            categoryWriter:'gregorTissueTableTissueHeaderLabel',
                            subCategoryWriter:'gregorTissueTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'gregorTissueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'gregorTissueTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantFocusHeader',
                            packagingString:'mpgSoftware.dynamicUi.variantTableHeaders',
                            internalIdentifierString:'getVariantsWeWillUseToBuildTheVariantTable',
                            nameOfAccumulatorField:'variantInfoArray',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_CODING',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'VariantCoding',
                            displaySubcategory: 'Coding indicator',
                            cellBodyWriter:'variantIsCodingBody',
                            categoryWriter:'variantIsCodingCategoryLabel',
                            subCategoryWriter:'variantIsCodingSubcategoryLabel',
                            sortingSubroutine:'VariantCoding',
                            packagingString:'mpgSoftware.dynamicUi.variantTableHeaders',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_SPLICE',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'VariantSplicing',
                            displaySubcategory: 'Splicing indicator',
                            cellBodyWriter:'variantIsSplicingBody',
                            categoryWriter:'variantIsSplicingCategoryLabel',
                            subCategoryWriter:'variantIsSplicingSubcategoryLabel',
                            sortingSubroutine:'VariantSplicing',
                            packagingString:'mpgSoftware.dynamicUi.variantTableHeaders',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_UTR',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'VariantUtr',
                            displaySubcategory: 'UTR indicator',
                            cellBodyWriter:'variantIsUtrBody',
                            categoryWriter:'variantIsUtrCategoryLabel',
                            subCategoryWriter:'variantIsUtrSubcategoryLabel',
                            sortingSubroutine:'VariantUtr',
                            packagingString:'mpgSoftware.dynamicUi.variantTableHeaders',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_PVALUE',
                            category: 'Association',
                            displayCategory: 'Association',
                            subcategory: 'VariantAssociationPValue',
                            displaySubcategory: 'Association with phenotype',
                            cellBodyWriter:'variantPValueBody',
                            categoryWriter:'variantPValueCategoryLabel',
                            subCategoryWriter:'variantPValueSubcategoryLabel',
                            sortingSubroutine:'VariantAssociationPValue',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_POSTERIORPVALUE',
                            category: 'Association',
                            displayCategory: 'Association',
                            subcategory: 'VariantAssociationPosterior',
                            displaySubcategory: 'Association with phenotype',
                            cellBodyWriter:'variantPosteriorPValueBody',
                            categoryWriter:'variantPosteriorPValueCategoryLabel',
                            subCategoryWriter:'variantPosteriorPValueSubcategoryLabel',
                            sortingSubroutine:'VariantAssociationPosterior',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'ABC_VAR',
                            category: 'ABC Tissue',
                            displayCategory: 'ABC Tissue',
                            subcategory: 'VariantAbc',
                            displaySubcategory: 'ABC list',
                            headerWriter:'abcVariantTableTissueHeader',
                            cellBodyWriter:'abcVariantTableBody',
                            categoryWriter:'abcVariantTableTissueHeaderLabel',
                            drillDownCategoryWriter:'abcVariantTableTissueHeaderLabel',
                            subCategoryWriter:'abcVariantTableTissueRowLabel',
                            drillDownSubCategoryWriter:'abcVariantTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'abcVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'abcVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantAbc',
                            internalIdentifierString:'getABCGivenVariantList',
                            nameOfAccumulatorField:'abcVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }
                        ,
                        {
                            code: 'TFMOTIF_VAR',
                            category: 'TFMOTIF',
                            displayCategory: 'TF motif',
                            subcategory: 'VariantTfMotif',
                            displaySubcategory: 'TfMotif',
                            headerWriter:'tfMotifVariantTableTissueHeader',
                            cellBodyWriter:'tfMotifVariantTableBody',
                            categoryWriter:'tfMotifVariantTableTissueHeaderLabel',
                            drillDownCategoryWriter:'tfMotifVariantTableTissueHeaderLabel',
                            subCategoryWriter:'tfMotifVariantTableTissueRowLabel',
                            drillDownSubCategoryWriter:'tfMotifVariantTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'tfMotifVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'tfMotifVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantTfMotif',
                            internalIdentifierString:'getTfMotifGivenVariantList',
                            processEachRecord:mpgSoftware.dynamicUi.tfMotifVariantTable.processRecordsFromTfMotif,
                            displayEverythingFromThisCall:mpgSoftware.dynamicUi.tfMotifVariantTable.displayTissueInformationFromTfMotif,
                            nameOfAccumulatorField:'tfMotifVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }
                        ,
                        {
                            code: 'DNASE_VAR',
                            category: 'DNASE Tissue',
                            displayCategory: 'DNASE Tissue',
                            subcategory: 'VariantDnase',
                            displaySubcategory: 'DNASE list',
                            headerWriter:'dnaseVariantTableTissueHeader',
                            cellBodyWriter:'dnaseVariantTableBody',
                            categoryWriter:'dnaseVariantTableTissueHeaderLabel',
                            drillDownCategoryWriter:'dnaseVariantTableTissueHeaderLabel',
                            subCategoryWriter:'dnaseVariantTableTissueRowLabel',
                            drillDownSubCategoryWriter:'dnaseVariantTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'dnaseVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'dnaseVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantDnase',
                            internalIdentifierString:'getDnaseGivenVariantList',
                            processEachRecord:mpgSoftware.dynamicUi.dnaseVariantTable.processRecordsFromDnase,
                            displayEverythingFromThisCall:mpgSoftware.dynamicUi.dnaseVariantTable.displayTissueInformationFromDnase,
                            nameOfAccumulatorField:'dnaseVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }
                        ,
                        {
                            code: 'TFBS_VAR',
                            category: 'TFBS Tissue',
                            displayCategory: 'TFBS Tissue',
                            subcategory: 'VariantTfbs',
                            displaySubcategory: 'TFBS list',
                            headerWriter:'tfbsVariantTableTissueHeader',
                            cellBodyWriter:'tfbsVariantTableBody',
                            categoryWriter:'tfbsVariantTableTissueHeaderLabel',
                            drillDownCategoryWriter:'tfbsVariantTableTissueHeaderLabel',
                            subCategoryWriter:'tfbsVariantTableTissueRowLabel',
                            drillDownSubCategoryWriter:'tfbsVariantTableIndividualAnnotationLabel',
                            numberRecordsCellPresentationStringWriter:'tfbsVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'tfbsVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantDnase',
                            internalIdentifierString:'getTfbsGivenVariantList',
                            processEachRecord:mpgSoftware.dynamicUi.tfbsVariantTable.processRecordsFromTfbs,
                            displayEverythingFromThisCall:mpgSoftware.dynamicUi.tfbsVariantTable.displayTissueInformationFromTfbs,
                            nameOfAccumulatorField:'tfbsVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }
                        ,
                        {
                            code: 'GREGOR_FOR_VAR',
                            category: 'not for focus table display',
                            displayCategory: 'not for focus table display',
                            subcategory: 'gregorTable',
                            displaySubcategory: 'gregorTable',
                            headerWriter:'gregorSubTableHeaderHeader',
                            cellBodyWriter:'gregorVariantTableBody',
                            categoryWriter:'gregorVariantTableRowHeaderLabel',
                            subCategoryWriter:'gregorVariantTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'gregorVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'gregorVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantGregor',
                            internalIdentifierString:'gregorSubTable',
                            processEachRecord:mpgSoftware.dynamicUi.gregorSubTableVariantTable.processRecordsFromGregor,
                            displayEverythingFromThisCall:mpgSoftware.dynamicUi.gregorSubTableVariantTable.displayGregorSubTable,
                            nameOfAccumulatorField:'gregorVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'none'
                        }
                        ,



                        // {
                        //     code: 'K27AC_VAR',
                        //     category: 'H3K27ac',
                        //     displayCategory: 'H3K27ac',
                        //     subcategory: 'VariantK27ac',
                        //     displaySubcategory: 'H3K27ac list',
                        //     headerWriter:'k27acVariantTableTissueHeader',
                        //     cellBodyWriter:'k27acVariantTableBody',
                        //     categoryWriter:'k27acVariantTableTissueHeaderLabel',
                        //     subCategoryWriter:'k27acVariantTableTissueRowLabel',
                        //     numberRecordsCellPresentationStringWriter:'k27acVariantTableNumberRecordsCellPresentationString',
                        //     significanceCellPresentationStringWriter:'k27acVariantTableSignificanceCellPresentationString',
                        //     sortingSubroutine:'VariantK27ac',
                        //     internalIdentifierString:'getH3k27acGivenVariantList',
                        //     nameOfAccumulatorField:'h3k27acVariantInfo',
                        //     nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        // }
                        // ,
                        {
                            code: 'CHROMESTATE_VAR',
                            category: 'ChromState',
                            displayCategory: 'ChromState state',
                            subcategory: 'VariantChromHmm',
                            displaySubcategory: 'ChromState list',
                            headerWriter:'chromStateVariantTableTissueHeader',
                            cellBodyWriter:'chromStateVariantTableBody',
                            categoryWriter:'chromStateVariantTableTissueHeaderLabel',
                            drillDownCategoryWriter:'chromStateVariantTableTissueHeaderLabel',
                            subCategoryWriter:'chromStateVariantTableTissueRowLabel',
                            drillDownSubCategoryWriter:'chromStateVariantTableIndividualAnnotationLabel',
                            numberRecordsCellPresentationStringWriter:'chromStateVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'chromStateVariantTableSignificanceCellPresentationString',
                            sortingSubroutine:'VariantChromHmm',
                            internalIdentifierString:'getChromStateGivenVariantList',
                            processEachRecord:mpgSoftware.dynamicUi.chromStateVariantTable.processRecordsFromChromState,
                            displayEverythingFromThisCall:mpgSoftware.dynamicUi.chromStateVariantTable.displayTissueInformationFromChromState,
                            nameOfAccumulatorField:'chromStateVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }

                    ],
                    dynamicTableConfiguration: {
                        emptyBodyRecord:'#emptyBodyRecord',
                        emptyHeaderRecord:'#emptyHeaderRecord',
                        domSpecificationForAccumulatorStorage:'#mainVariantDivHolder',
                        formOfStorage: 'loadFromTable',
                        initializeSharedTableMemory:  '#mainVariantDiv table.variantTableHolder',
                        organizingDiv:  '#mainVariantDiv',
                        initialOrientation:'variantTableVariantHeaders',
                        defaultSort:{
                            columnNumberValue: 1,
                            currentSort: "sortMethodsInVariantTable",
                            sortOrder: "asc",
                            table: "#mainVariantDiv table.variantTableHolder",
                            dataAnnotationType: {packagingString:'mpgSoftware.dynamicUi.variantTableHeaders'},
                            desiredSearchTerm: "sortField"
                        }
                    }
                };
                mpgSoftware.variantTable.setVariablesToRemember(drivingVariables);
                mpgSoftware.variantTable.initialPageSetUp("${phenotype}");
            };




            return {
                variantTableConfiguration:variantTableConfiguration
            }
        }());


    })();




    $( document ).ready(function() {
        mpgSoftware.variantTableInitializer.variantTableConfiguration();
    });
</script>
<g:render template="/templates/dynamicUi/VARIANT_TABLE" />


<div id="mainVariantDivHolder">

</div>
