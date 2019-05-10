<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 5/10/2019
  Time: 1:29 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Gene effector table</title>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="geneEffectorTable"/>


    <r:layoutResources/>

    <script>
        var mpgSoftware = mpgSoftware || {};


        (function () {
            "use strict";

            mpgSoftware.effectorGeneTableInitializer = (function () {

                var effectorGeneTableConfiguration = function(){
                    var drivingVariables = {
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
                        dataAnnotationTypes: [
                            {   code: 'GHDR', // manages the header.  Most of the records in this particular category have no match in the code, unlike all of the other categories
                                category: 'blank',
                                displayCategory: 'Genes',
                                subcategory: 'Genes subcategory',
                                displaySubcategory: 'Genes subcategory',
                                cellBodyWriter:'dynamicGeneTableHeaderV3',
                                categoryWriter:'no category writer',
                                subCategoryWriter:'no subcategory writer',
                                numberRecordsCellPresentationStringWriter:'no record numbers string writer',
                                significanceCellPresentationStringWriter:'no significance string writer',
                                internalIdentifierString:'getTissuesFromProximityForLocusContext'
                            },
                            {   code: 'EFF',
                                category: 'Annotation',
                                displayCategory: 'Annotation',
                                subcategory: 'Effector gene list',
                                displaySubcategory: 'Effector gene list',
                                cellBodyWriter:'dynamicGeneTableEffectorGeneBody',
                                categoryWriter:'sharedCategoryWriter',
                                subCategoryWriter:'dynamicGeneTableEffectorGeneSubCategory',
                                numberRecordsCellPresentationStringWriter:'effectorGeneTableNumberRecordsCellPresentationString',
                                significanceCellPresentationStringWriter:'effectorGeneTableSignificanceCellPresentationString',
                                internalIdentifierString:'getInformationFromEffectorGeneListTable'
                            }

                        ],
                        dynamicTableConfiguration: {
                            domSpecificationForAccumulatorStorage:'#mainEffectorDiv'
                        }
                    };
                    mpgSoftware.effectorGeneTable.setVariablesToRemember(drivingVariables);
                    mpgSoftware.effectorGeneTable.initialPageSetUp();
                };




                return {
                    effectorGeneTableConfiguration:effectorGeneTableConfiguration
                }
            }());


        })();

        $( document ).ready(function() {
            mpgSoftware.effectorGeneTableInitializer.effectorGeneTableConfiguration();
        });

</script>

        </head>

<body>
<div id="mainEffectorDiv">

    <div class="container">

        <div class="row">
            <div class="center-text">
               <h2>Gene effector table</h2>
            </div>
            <div class="col-md-12" style="padding-top: 30px;">
                <div id="effectiveGeneTableHolder">

                </div>
            </div>
        </div>
    </div>
</div>



                    <!--
</body>
</html>