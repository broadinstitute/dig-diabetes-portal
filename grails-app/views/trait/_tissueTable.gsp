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
                        {   code: 'FEGT',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Effector gene list',
                            displaySubcategory: 'Effector gene list',
                            headerWriter:'dynamicFullEffectorGeneTableHeader',
                            cellBodyWriter:'fegtCellBody',
                            categoryWriter:'sharedCategoryWriter',
                            subCategoryWriter:'dynamicGeneTableEffectorGeneSubCategory',
                            numberRecordsCellPresentationStringWriter:'effectorGeneTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter:'effectorGeneTableSignificanceCellPresentationString',
                            internalIdentifierString:'getFullFromEffectorGeneListTable',
                            customColumnOrdering:{
                                topLevelColumns:[
                                    {   key:"Perturbation_combined",

                                        displayName:"Combined perturbation evidence",
                                        helptext: '<g:helpText title="effectorTable.combined-perturbation-collapsed.help.header" placement="bottom" body="effectorTable.combined-perturbation-collapsed.help.text"/>',
                                        order: 4 }


                                ],
                                constituentColumns:[

                                    {   key: "Combined_category",
                                        display:"Combined prediction",
                                        pos:0,subPos:0,
                                        helptext:'<g:helpText title="effectorTable.combined-prediction.help.header" placement="bottom" body="effectorTable.combined-prediction.help.text"/>'}



                                ]
                            }
                        }

                    ],
                    dynamicTableConfiguration: {
                        domSpecificationForAccumulatorStorage:'#mainTissueDiv',
                        formOfStorage: 'loadOnce'
                    }
                };
                mpgSoftware.effectorGeneTable.setVariablesToRemember(drivingVariables);
                mpgSoftware.effectorGeneTable.initialPageSetUp();
            };




            return {
                effectorTissueTableConfiguration:effectorTissueTableConfiguration
            }
        }());


    })();







    var drivingVariables = {
        phenotypeName: '<%=phenotypeKey%>',
        ajaxClumpDataUrl: '${createLink(controller: "trait", action: "ajaxClumpData")}',
        traitSearchUrl: "${createLink(controller: 'trait', action: 'traitSearch')}",
        retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
        ajaxSampleGroupsPerTraitUrl: '${createLink(controller: "trait", action: "ajaxSampleGroupsPerTrait")}',
        phenotypeAjaxUrl: '${createLink(controller: "trait", action: "phenotypeAjax")}',
        variantInfoUrl: '${createLink(controller: "variantInfo", action: "variantInfo")}',
        requestedSignificance:'<%=requestedSignificance%>',
        local:"${locale}",
        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />'
    };
    mpgSoftware.manhattanplotTableHeader.setMySavedVariables(drivingVariables);

    $( document ).ready(function() {
        mpgSoftware.effectorTissueTableInitializer.effectorTissueTableConfiguration();
    });
</script>

<div id="mainTissueDiv">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Predicted type 2 diabetes effector genes</h1>
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

