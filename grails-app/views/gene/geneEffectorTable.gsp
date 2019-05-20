<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 5/10/2019
  Time: 1:29 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Effector gene table</title>
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
                                        {   key:"Combined_category",
                                            displayName:"Combined category",
                                            helptext: '<g:helpText title="variantTable.columnHeaders.shared.effect.help.header" placement="bottom" body="variantTable.columnHeaders.shared.effect.help.text"/>',
                                            order: 0 },
                                        {   key:"Gene_name",
                                            displayName:"Gene name",
                                            helptext: '',
                                            order: 1 },
                                        {   key:"Genetic_combined",
                                            displayName:"Genetic combined",
                                            helptext: '',
                                            order: 2 },
                                        {   key:"Genomic_combined",
                                            displayName:"Genomic combined",
                                            helptext: '',
                                            order: 3 },
                                        {   key:"Perturbation_combined",
                                            displayName:"Perturbation combined",
                                            helptext: '',
                                            order: 4 },
                                        {   key:"Semantic_score",
                                            displayName:"External evidence",
                                            helptext: '',
                                            order: 5 },
                                        {   key:"FishHomo",
                                            displayName:"Homologous genes",
                                            helptext: '',
                                            order: 6 },
                                        {   key:"additional_reference",
                                            displayName:"additional reference",
                                            helptext: '',
                                            order: 7 }

                                    ],
                                    constituentColumns:[

                                {   key: "Combined_category",
                                    display:"Combined category",
                                    pos:0,subPos:0},

                                { key: "Gene_name",
                                    display:"Gene name",
                                    pos:1,subPos:0},
                                { key: "Locus_name",
                                    display:"Locus name",
                                    pos:1,subPos:1},

                                { key: "Genetic_combined",
                                    display:"Genetic combined",
                                    pos:2,subPos:0},
                                { key: "GWAS_coding_causal",
                                    display:"GWAS coding causal",
                                    pos:2,subPos:1},
                                { key: "Exome_array_coding_causal",
                                    display:"Exome array coding causal",
                                    pos:2,subPos:2},
                                { key: "Exome_sequence_burden",
                                    display:"Exome sequence burden",
                                    pos:2,subPos:3},
                                { key: "Monogenic",
                                    display:"Monogenic",
                                    pos:2,subPos:4},
                                { key: "Other_genetic",
                                    display:"Other genetic",
                                    pos:2,subPos:5},
                                { key: "COMBINED",
                                    display:"Combined",
                                    pos:2,subPos:6},

                                { key: "Genomic_combined",
                                    display:"Genomic combined",
                                    pos:3,subPos:0},
                                { key: "ciseQTL_islet",
                                    display:"ciseQTL islet",
                                    pos:3,subPos:1},
                                { key: "ciseQTL_fat_muscle_liver",
                                    display:"ciseQTL fat muscle liver",
                                    pos:3,subPos:2},
                                { key: "Capture_C_or_hiC_Islet",
                                    display:"Capture C or hiC Islet",
                                    pos:2,subPos:3},
                                { key: "Allelic_imbalance",
                                    display:"Allelic imbalance",
                                    pos:2,subPos:4},
                                { key: "Ottosson_Laakso",
                                    display:"Ottosson Laakso",
                                    pos:2,subPos:5},
                                { key: "Other_genomics",
                                    display:"Other genomics",
                                    pos:2,subPos:6},

                                { key: "Perturbation_combined",
                                    display:"Perturbation combined",
                                    pos:4,subPos:0},
                                { key: "Annas_screen",
                                    display:"Anna's screen",
                                    pos:4,subPos:1},
                                { key: "Zebra_Fish",
                                    display:"Zebra Fish",
                                    pos:4,subPos:2},
                                { key: "Mouse_Knockout_viability",
                                    display:"Mouse Knockout viability",
                                    pos:4,subPos:3},
                                { key: "Mouse_MGI",
                                    display:"Mouse MGI",
                                    pos:4,subPos:4},
                                { key: "Drosophila_Heshan_2018",
                                    display:"Drosophila Heshan 2018",
                                    pos:4,subPos:5},
                                { key: "Rat",
                                    display:"Rat",
                                    pos:4,subPos:6},
                                { key: "Other_perturbation",
                                    display:"Other perturbation",
                                    pos:4,subPos:7},

                                { key: "Semantic_score",
                                    display:"Semantic score",
                                    pos:5,subPos:0},
                                { key: "Candidacy_score",
                                    display:"Candidacy score",
                                    pos:5,subPos:1},
                                { key: "OMIM",
                                    display:"OMIM",
                                    pos:5,subPos:2},

                                { key: "FishHomo",
                                    display:"Fish homologous genes",
                                    pos:6,subPos:0},
                                { key: "MouseHomo",
                                    display:"Mouse homologous genes",
                                    pos:6,subPos:1},
                                { key: "RatHomo",
                                    display:"Rat homologous genes",
                                    pos:6,subPos:2}

                                // { key: "Additional_reference",pos:7,subPos:0}
                                // // { key: "GENE",pos:47,subPos:0},
                                // // { key: "Gene_Ensemble_ID",pos:47,subPos:1}
                                //
                                    ]
                                }
                            }

                        ],
                        dynamicTableConfiguration: {
                            domSpecificationForAccumulatorStorage:'#mainEffectorDiv',
                            formOfStorage: 'loadOnce'
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
               <h2>Effector gene table</h2>
            </div>
            <div class="col-md-12" style="padding-top: 30px;">
                <div id="effectiveGeneTableHolder" class="mainEffectorDiv">
                    <table class="fullEffectorGeneTableHolder effector-table">
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<g:render template="../templates/dynamicUi/FEGT" />

</body>
</html>