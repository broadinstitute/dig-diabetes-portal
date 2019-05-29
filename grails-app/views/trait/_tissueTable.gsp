<script>
    // set up the tissue table
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.effectorTissueTableInitializer = (function () {

            var effectorTissueTableConfiguration = function(){
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
                    dataAnnotationTypes: [
                        {
                            code: 'TITA',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Gregor list',
                            displaySubcategory: 'Gregor list',
                            cellBodyWriter:'dynamicGeneTableEffectorGeneBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'gregorTissueTableSubCategory',
                            numberRecordsCellPresentationStringWriter:'gregorTissueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'gregorTissueTableSignificanceCellPresentationString',
                            internalIdentifierString:'getInformationFromGregorForTissueTable'
                        }
                    ],
                    dynamicTableConfiguration: {
                        domSpecificationForAccumulatorStorage:'#mainTissueDiv',
                        formOfStorage: 'loadFromTable'
                    }
                };
                mpgSoftware.tissueTable.setVariablesToRemember(drivingVariables);
                mpgSoftware.tissueTable.initialPageSetUp();
            };




            return {
                effectorTissueTableConfiguration:effectorTissueTableConfiguration
            }
        }());


    })();




    $( document ).ready(function() {
        mpgSoftware.effectorTissueTableInitializer.effectorTissueTableConfiguration();
    });
</script>

<g:render template="/templates/tissueTableTemplate" />

<div id="mainTissueDiv">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Tissue table for <span class="phenotypeSpecifier">${phenotype}</span></h1>
            </div>
            <div class="col-md-12">
                <div id="tissueTableHolder" class="mainEffectorDiv">
                    <table class="tissueTableHolder effector-table">
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

