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
                                        {   key:"Combined_category",
                                            displayName:"Combined prediction",
                                            helptext: '',
                                            order: 0 },
                                        {   key:"Gene_name",
                                            displayName:"Gene and locus",
                                            helptext: '<g:helpText title="effectorTable.gene-locus.help.header" placement="bottom" body="effectorTable.gene-locus.help.text"/>',
                                            order: 1 },
                                        {   key:"Genetic_combined",
                                            displayName:"Combined genetic evidence",
                                            helptext: '<g:helpText title="effectorTable.collapsed-combined-genetic.help.header" placement="bottom" body="effectorTable.collapsed-combined-genetic.help.text"/>',
                                            order: 2 },
                                        {   key:"Genomic_combined",
                                            displayName:"Combined regulatory evidence",
                                            helptext: '<g:helpText title="effectorTable.combined-genomic-collapsed.help.header" placement="bottom" body="effectorTable.combined-genomic-collapsed.help.text"/>',
                                            order: 3 },
                                        {   key:"Perturbation_combined",

                                            displayName:"Combined perturbation evidence",
                                            helptext: '<g:helpText title="effectorTable.combined-perturbation-collapsed.help.header" placement="bottom" body="effectorTable.combined-perturbation-collapsed.help.text"/>',
                                            order: 4 }
//                                        {   key:"Semantic_score",
//                                            displayName:"External evidence",
//                                            helptext: '',
//                                            order: 5 },
//                                        {   key:"FishHomo",
//                                            displayName:"Homologous genes",
//                                            helptext: '',
//                                            order: 6 },
//                                        {   key:"additional_reference",
//                                            displayName:"additional reference",
//                                            helptext: '',
//                                            order: 7 }

                                    ],
                                    constituentColumns:[

                                {   key: "Combined_category",
                                    display:"Combined prediction",
                                    pos:0,subPos:0,
                                     helptext:'<g:helpText title="effectorTable.combined-prediction.help.header" placement="bottom" body="effectorTable.combined-prediction.help.text"/>'},

                                { key: "Gene_name",
                                    display:"Predicted T2D effector gene",
                                    pos:1,subPos:0,
                                    helptext: '<g:helpText title="effectorTable.gene.help.header" placement="bottom" body="effectorTable.gene.help.text"/>'},
                                { key: "Locus_name",
                                    display:"Previously associated loci",
                                    pos:1,subPos:1,
                                    helptext: '<g:helpText title="effectorTable.locus.help.header" placement="bottom" body="effectorTable.locus.help.text"/>'},
                                { key: "Genetic_combined",
                                    display:"Combined genetic evidence",
                                    pos:2,subPos:0,
                                    helptext: '<g:helpText title="effectorTable.expanded-combined-genetic.help.header" placement="bottom" body="effectorTable.expanded-combined-genetic.help.text"/>'},
                                { key: "GWAS_coding_causal",
                                    display:"GWAS coding evidence",
                                    pos:2,subPos:1,
                                    helptext: '<g:helpText title="effectorTable.GWAS-evidence.help.header" placement="bottom" body="effectorTable.GWAS-evidence.help.text"/>'},
                                { key: "Exome_array_coding_causal",
                                    display:"Exome array evidence",
                                    pos:2,subPos:2,
                                    helptext: '<g:helpText title="effectorTable.ExChip-evidence.help.header" placement="bottom" body="effectorTable.ExChip-evidence.help.text"/>'},
                                { key: "Exome_sequence_burden",
                                    display:"Burden test evidence",
                                    pos:2,subPos:3,
                                    helptext: '<g:helpText title="effectorTable.ExSeq-evidence.help.header" placement="bottom" body="effectorTable.ExSeq-evidence.help.text"/>'},
                                { key: "Monogenic",
                                    display:"Monogenic associations",
                                    pos:2,subPos:4,
                                    helptext: '<g:helpText title="effectorTable.monogenic.help.header" placement="bottom" body="effectorTable.monogenic.help.text"/>'},
                                { key: "Other_genetic",
                                    display:"Other genetic evidence",
                                    pos:2,subPos:5,
                                    helptext: '<g:helpText title="effectorTable.other-genetic.help.header" placement="bottom" body="effectorTable.other-genetic.help.text"/>'},
                                { key: "COMBINED",
                                    display:"Combined genetic evidence classification",
                                    pos:2,subPos:6,
                                    helptext: '<g:helpText title="effectorTable.classified-genetic.help.header" placement="bottom" body="effectorTable.classified-genetic.help.text"/>'},
                                { key: "Genomic_combined",
                                    display:"Combined regulatory evidence",
                                    pos:3,subPos:0,
                                    helptext: '<g:helpText title="effectorTable.combined-genomic.help.header" placement="bottom" body="effectorTable.combined-genomic.help.text"/>'},
                                { key: "ciseQTL_islet",
                                    display:"Islet cis-eQTLs",
                                    pos:3,subPos:1,
                                    helptext: '<g:helpText title="effectorTable.islet-ciseQTL.help.header" placement="bottom" body="effectorTable.islet-ciseQTL.help.text"/>'},
                                { key: "ciseQTL_fat_muscle_liver",
                                    display:"Other relevant cis-eQTLs",
                                    pos:3,subPos:2,
                                    helptext: '<g:helpText title="effectorTable.other-ciseQTL.help.header" placement="bottom" body="effectorTable.other-ciseQTL.help.text"/>'},
                                { key: "Capture_C_or_hiC_Islet",
                                    display:"Islet chromatin conformation",
                                    pos:3,subPos:3,
                                    helptext: '<g:helpText title="effectorTable.islet-chromConf.help.header" placement="bottom" body="effectorTable.islet-chromConf.help.text"/>'},
                                { key: "Allelic_imbalance",
                                    display:"Allelic imbalance",
                                    pos:3,subPos:4,
                                    helptext: '<g:helpText title="effectorTable.allelic-imbalance.help.header" placement="bottom" body="effectorTable.allelic-imbalance.help.text"/>'},
                                { key: "Ottosson_Laakso",
                                    display:"Glucose regulation",
                                    pos:3,subPos:5,
                                    helptext: '<g:helpText title="effectorTable.Ottosson_Laakso.help.header" placement="bottom" body="effectorTable.Ottosson_Laakso.help.text"/>'},
                                { key: "Other_genomics",
                                    display:"Other regulatory evidence",
                                    pos:3,subPos:6,
                                    helptext: '<g:helpText title="effectorTable.otherReg.help.header" placement="bottom" body="effectorTable.otherReg.help.text"/>'},

                                { key: "Perturbation_combined",
                                    display:"Combined perturbation evidence",
                                    pos:4,subPos:0,
                                    helptext: '<g:helpText title="effectorTable.combined-perturbation.help.header" placement="bottom" body="effectorTable.combined-perturbation.help.text"/>',},
                                { key: "Annas_screen",
                                    display:"RNA interference evidence",
                                    pos:4,subPos:1,
                                    helptext: '<g:helpText title="effectorTable.Annas-screen.help.header" placement="bottom" body="effectorTable.Annas-screen.help.text"/>'},
                                { key: "Zebra_Fish",

                                    display:"Zebrafish mutant phenotype",
                                    pos:4,subPos:2,
                                    helptext: '<g:helpText title="effectorTable.zfin.help.header" placement="bottom" body="effectorTable.zfin.help.text"/>'},
//                                { key: "Mouse_Knockout_viability",
//                                    display:"Mouse Knockout viability",
//                                    pos:4,subPos:3},
                                { key: "Mouse_MGI",
                                    display:"Mouse mutant phenotype",
                                    pos:4,subPos:4,
                                    helptext: '<g:helpText title="effectorTable.mouse.help.header" placement="bottom" body="effectorTable.mouse.help.text"/>'},
                                { key: "Drosophila_Heshan_2018",
                                    display:"Drosophila mutant phenotype",
                                    pos:4,subPos:5,
                                    helptext: '<g:helpText title="effectorTable.Dros.help.header" placement="bottom" body="effectorTable.Dros.help.text"/>'},
                                { key: "Rat",
                                    display:"Rat mutant phenotype",
                                    pos:4,subPos:6,
                                    helptext: '<g:helpText title="effectorTable.rat.help.header" placement="bottom" body="effectorTable.rat.help.text"/>'},
                                { key: "Other_perturbation",

                                    display:"Other perturbation evidence",
                                    pos:4,subPos:7,
                                    helptext: '<g:helpText title="effectorTable.other-perturbation.help.header" placement="bottom" body="effectorTable.other-perturbation.help.text"/>'},

                                // { key: "Semantic_score",
                                //     display:"Semantic score",
                                //     pos:5,subPos:0},
                                // { key: "Candidacy_score",
                                //     display:"Candidacy score",
                                //     pos:5,subPos:1},
                                // { key: "OMIM",
                                //     display:"OMIM",
                                //     pos:5,subPos:2},
                                //
                                // { key: "FishHomo",
                                //     display:"Fish homologous genes",
                                //     pos:6,subPos:0},
                                // { key: "MouseHomo",
                                //     display:"Mouse homologous genes",
                                //     pos:6,subPos:1},
                                // { key: "RatHomo",
                                //     display:"Rat homologous genes",
                                //     pos:6,subPos:2}

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

<div id="mainTissueDiv">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Predicted type 2 diabetes effector genes</h1>
            </div>
            <div class="col-md-12">
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