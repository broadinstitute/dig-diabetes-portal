<script>
    // set up the tissue table
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.tissueTableInitializer = (function () {

            var tissueTableConfiguration = function(){
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
                    dataAnnotationTypes: [
                        {
                            code: 'TITA',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Gregor list',
                            displaySubcategory: 'Gregor list',
                            headerWriter:'gregorTissueTableTissueHeader',
                            cellBodyWriter:'gregorTissueTableBody',
                            categoryWriter:'gregorTissueTableTissueHeaderLabel',
                            subCategoryWriter:'gregorTissueTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'gregorTissueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'gregorTissueTableSignificanceCellPresentationString',
                            internalIdentifierString:'getInformationFromGregorForTissueTable'
                        },
                        {
                            code: 'LDSR',
                            category: 'LDSR Annotation',
                            displayCategory: 'LDSR Annotation',
                            subcategory: 'LDSR list',
                            displaySubcategory: 'LDSR list',
                            headerWriter:'ldsrTissueTableTissueHeader',
                            cellBodyWriter:'ldsrTissueTableBody',
                            categoryWriter:'ldsrTissueTableTissueHeaderLabel',
                            subCategoryWriter:'ldsrTissueTableTissueRowLabel',
                            numberRecordsCellPresentationStringWriter:'ldsrTissueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'ldsrTissueTableSignificanceCellPresentationString',
                            internalIdentifierString:'getInformationFromLdsrForTissueTable'
                        }
                        // ,
                        // {
                        //     code: 'DEP_TI',
                        //     category: 'DEPICT Tissue',
                        //     displayCategory: 'DEPICT Tissue',
                        //     subcategory: 'DEPICT list',
                        //     displaySubcategory: 'DEPICT list',
                        //     headerWriter:'depictTissuesTissueTableTissueHeader',
                        //     cellBodyWriter:'depictTissuesTissueTableBody',
                        //     categoryWriter:'depictTissuesTissueTableTissueHeaderLabel',
                        //     subCategoryWriter:'depictTissuesTissueTableTissueRowLabel',
                        //     numberRecordsCellPresentationStringWriter:'depictTissuesTissueTableNumberRecordsCellPresentationString',
                        //     significanceCellPresentationStringWriter:'depictTissuesTissueTableSignificanceCellPresentationString',
                        //     internalIdentifierString:'getInformationFromDepictForTissueTable'
                        // }

                    ],
                    dynamicTableConfiguration: {
                        domSpecificationForAccumulatorStorage:'#mainTissueDiv',
                        formOfStorage: 'loadFromTable',
                        initializeSharedTableMemory:  '#mainTissueDiv table.tissueTableHolder'
                    }
                };
                mpgSoftware.tissueTable.setVariablesToRemember(drivingVariables);
                mpgSoftware.tissueTable.initialPageSetUp("${phenotype}");
            };




            return {
                tissueTableConfiguration:tissueTableConfiguration
            }
        }());


    })();




    $( document ).ready(function() {
        mpgSoftware.tissueTableInitializer.tissueTableConfiguration();
    });
</script>
<g:render template="/templates/dynamicUiTemplate" />
<g:render template="/templates/tissueTableTemplate" />
<g:render template="/templates/dynamicUi/TITA" />
<g:render template="/templates/dynamicUi/LDSR" />
<g:render template="/templates/dynamicUi/DEP_TI" />

<div id="mainTissueDiv">

</div>

