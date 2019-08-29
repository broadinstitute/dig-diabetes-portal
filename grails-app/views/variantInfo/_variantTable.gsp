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
                    retrieveGeneLevelAssociationsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveGeneLevelAssociations")}',
                    retrieveListOfGenesInARangeUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveListOfGenesInARange")}',
                    retrieveEffectorGeneInformationUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEffectorGeneInformation")}',
                    getAllPhenotypesAjaxUrl: '${g.createLink(controller: "trait", action: "getAllPhenotypesAndTranslationAjax")}',
                    retrieveLdsrDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveLdsrData")}',
                    retrieveDepictTissueDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDepictTissues")}',
                    retrieveVariantsWithQtlRelationshipsUrl:'${g.createLink(controller: "RegionInfo", action: "retrieveVariantsWithQtlRelationships")}',
                    retrieveTopVariantsAcrossSgsUrl:'${g.createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',
                    getVariantsForRangeAjaxUrl:"${createLink(controller:'RegionInfo',action: 'retrieveVariantsInRange')}",
                    dynamicTableType:'variantTable',
                    dataAnnotationTypes: [
                        {
                            code: 'VHDR',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Variant list',
                            displaySubcategory: 'Variant list',
                            headerWriter:'gregorTissueTableTissueHeader',
                            cellBodyWriter:'dynamicVariantTableHeader',
                            categoryWriter:'gregorTissueTableTissueHeaderLabel',
                            subCategoryWriter:'gregorTissueTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'gregorTissueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'gregorTissueTableSignificanceCellPresentationString',
                            internalIdentifierString:'getVariantsWeWillUseToBuildTheVariantTable',
                            nameOfAccumulatorField:'variantInfoArray',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_CODING',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Coding indicator',
                            displaySubcategory: 'Coding indicator',
                            cellBodyWriter:'variantIsCodingBody',
                            categoryWriter:'variantIsCodingCategoryLabel',
                            subCategoryWriter:'variantIsCodingSubcategoryLabel',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_SPLICE',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Coding indicator',
                            displaySubcategory: 'Coding indicator',
                            cellBodyWriter:'variantIsSplicingBody',
                            categoryWriter:'variantIsSplicingCategoryLabel',
                            subCategoryWriter:'variantIsSplicingSubcategoryLabel',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'VAR_UTR',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Coding indicator',
                            displaySubcategory: 'Coding indicator',
                            cellBodyWriter:'variantIsUtrBody',
                            categoryWriter:'variantIsUtrCategoryLabel',
                            subCategoryWriter:'variantIsUtrSubcategoryLabel',
                            internalIdentifierString:'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField:'notUsed',
                            nameOfAccumulatorFieldWithIndex:'notUsed'
                        }
                        ,
                        {
                            code: 'ABC_VAR',
                            category: 'ABC Tissue',
                            displayCategory: 'ABC Tissue',
                            subcategory: 'ABC list',
                            displaySubcategory: 'ABC list',
                            headerWriter:'abcVariantTableTissueHeader',
                            cellBodyWriter:'abcVariantTableBody',
                            categoryWriter:'abcVariantTableTissueHeaderLabel',
                            subCategoryWriter:'abcVariantTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'abcVariantTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'abcVariantTableSignificanceCellPresentationString',
                            internalIdentifierString:'getABCGivenVariantList',
                            nameOfAccumulatorField:'abcVariantInfo',
                            nameOfAccumulatorFieldWithIndex:'variantInfoArray'
                        }

                    ],
                    dynamicTableConfiguration: {
                        emptyBodyRecord:'#emptyBodyRecord',
                        emptyHeaderRecord:'#emptyHeaderRecord',
                        domSpecificationForAccumulatorStorage:'#mainVariantDivHolder',
                        formOfStorage: 'loadFromTable',
                        initializeSharedTableMemory:  '#mainVariantDiv table.variantTableHolder',
                        organizingDiv:  '#mainVariantDiv'
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
