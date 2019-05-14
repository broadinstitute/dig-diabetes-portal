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
                                        "Combined_category",
                                        "Genetic_combined",
                                        "Genomic_combined",
                                        "Perturbation_combined",
                                        "external_evidence",
                                        "homologous_gene",
                                        "additional_reference"
                                    ],
                                    constituentColumns:[
                                        { key: "EXTRA_NonT2D_locus",pos:0,subPos:0},
                                        { key: "Combined_category",pos:0,subPos:1},
                                        { key: "Combined_category_noNames",pos:0,subPos:2},
                                        { key: "Perturbation_combined",pos:0,subPos:3},
                                        { key: "Genomic_combined",pos:0,subPos:4},
                                        { key: "Genetic_combined",pos:0,subPos:5},
                                        { key: "Gene_name",pos:0,subPos:6},
                                        { key: "Locus_name",pos:0,subPos:7},
                                        { key: "GWAS_coding_causal",pos:1,subPos:0},
                                        { key: "Exome_array_coding_causal",pos:1,subPos:1},
                                        { key: "Exome_sequence_burden",pos:1,subPos:2},
                                        { key: "Monogenic",pos:1,subPos:3},
                                        { key: "Other_genetic",pos:1,subPos:4},
                                        { key: "COMBINED",pos:1,subPos:5},
                                        { key: "ciseQTL_islet",pos:2,subPos:0},
                                        { key: "ciseQTL_fat_muscle_liver",pos:2,subPos:1},
                                        { key: "Capture_C_or_hiC_Islet",pos:2,subPos:2},
                                        { key: "Allelic_imbalance",pos:2,subPos:3},
                                        { key: "Ottosson_Laakso",pos:2,subPos:4},
                                        { key: "Other_genomics",pos:2,subPos:5},
                                        { key: "Annas_screen",pos:3,subPos:0},
                                        { key: "Zebra_Fish",pos:3,subPos:1},
                                        { key: "Mouse_Knockout_viability",pos:3,subPos:2},
                                        { key: "Mouse_MGI",pos:3,subPos:3},
                                        { key: "Drosophila_Heshan_2018",pos:3,subPos:4},
                                        { key: "Rat",pos:3,subPos:5},
                                        { key: "Other_perturbation",pos:3,subPos:6},
                                        { key: "Semantic_score",pos:4,subPos:0},
                                        { key: "Candidacy_score",pos:4,subPos:1},
                                        { key: "OMIM",pos:4,subPos:2},
                                        { key: "FishHomo",pos:5,subPos:0},
                                        { key: "MouseHomo",pos:5,subPos:1},
                                        { key: "RatHomo",pos:5,subPos:2},
                                        { key: "Additional_reference",pos:6,subPos:0},
                                        { key: "GENE",pos:47,subPos:0},
                                        { key: "Gene_Ensemble_ID",pos:47,subPos:1},

                                    ]
                                }
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
                <div id="effectiveGeneTableHolder" class="mainEffectorDiv">
                    <table class="fullEffectorGeneTableHolder">
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<g:render template="../templates/dynamicUi/FEGT" />

</body>
</html>