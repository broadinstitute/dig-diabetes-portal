<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.geneTableInitializer = (function () {
            var geneTableConfiguration = function (parametersToOverride) {
                var drivingVariables = {
                    portalTypeString: "${g.portalTypeString()}",
                    geneName: '${geneName}',
                    sampleDataSet: "${sampleDataSet}",
                    burdenDataSet: "${burdenDataSet}",
                    geneChromosome: '${geneChromosome}',
                    geneExtentBegin: ${geneExtentBegin},
                    geneExtentEnd: ${geneExtentEnd},
                    igvIntro: '${igvIntro}',
                    defaultPhenotype: '${defaultPhenotype}',
                    identifiedGenes: '${identifiedGenes}',
                    firstPropertyName: '${lzOptions.findAll {
    it.defaultSelected && it.dataType == 'static'
}.first().propertyName}',
                    firstStaticPropertyName: '${lzOptions.findAll {
    it.defaultSelected && it.dataType == 'static'
}.first().dataType}',
                    defaultTissues: ${(defaultTissues as String).encodeAsJSON()},
                    defaultTissuesDescriptions: ${(defaultTissuesDescriptions as String).encodeAsJSON()},
                    lzCommon: 'lzCommon',
                    lzCredSet: 'lzCredSet',
                    generalizedInputId: 'generalized-dynamic-gene-input',
                    generalizedGoButtonId: 'generalized-dynamic-gene-go',
                    vrtUrl: '${createLink(controller: "VariantSearch", action: "gene")}',
                    redLightImage: '<r:img uri="/images/redlight.png"/>',
                    yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',
                    greenLightImage: '<r:img uri="/images/greenlight.png"/>',
                    suppressBurdenTest: !(${sampleLevelSequencingDataExists}),
                    variantInfoUrl: '${createLink(controller: "VariantInfo", action: "variantInfo")}',
                    currentPhenotype: $('.chosenPhenotype').attr('id'),
                    retrieveTopVariantsAcrossSgsUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgs")}',
                    retrieveTopVariantsAcrossSgsMinUrl: '${createLink(controller: "VariantSearch", action: "retrieveTopVariantsAcrossSgsMin")}',
                    burdenTestAjaxUrl: '${createLink(controller: "gene", action: "burdenTestAjax")}',
                    preferIgv: ($('input[name=genomeBrowser]:checked').val() === '2'),
                    sampleMetadataExperimentAjaxUrl: '${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}',
                    sampleMetadataAjaxWithAssumedExperimentUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
                    variantOnlyTypeAheadUrl: "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
                    sampleMetadataAjaxUrl: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
                    generateListOfVariantsFromFiltersAjaxUrl: "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
                    retrieveSampleSummaryUrl: "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
                    variantAndDsAjaxUrl: "${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",
                    burdenTestVariantSelectionOptionsAjaxUrl: "${createLink(controller: 'gene', action: 'burdenTestVariantSelectionOptionsAjax')}",
                    recomb_rateMsg: "<g:message code='controls.shared.igv.tracks.recomb_rate'/>",
                    genesMsg: "<g:message code='controls.shared.igv.tracks.genes'/>",
                    generalizedTypeaheadUrl: "${createLink(controller: 'gene', action: 'index')}",
                    retrievePotentialIgvTracksUrl: "${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                    getDataUrl: "${createLink(controller: 'trait', action: 'getData', absolute: 'false')}",
                    traitInfoUrl: "${createLink(controller: 'trait', action: 'traitInfo', absolute: 'true')}",
                    getLocusZoomUrl: '${createLink(controller: "gene", action: "getLocusZoom")}',
                    retrieveFunctionalDataAjaxUrl: '${createLink(controller: "variantInfo", action: "retrieveFunctionalDataAjax")}',
                    getGRSListOfVariantsAjaxUrl: "${createLink(controller: 'grs', action: 'getGRSListOfVariantsAjax')}",
                    getLocusZoomFilledPlotUrl: '${createLink(controller: "gene", action: "getLocusZoomFilledPlot")}',
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
                    retrieveMagmaDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveMagmaData")}',
                    retrieveDepictGeneSetUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDepictGeneSetData")}',
                    retrieveDnaseDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveDnaseData")}',
                    retrieveH3k27acDataUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveH3k27acData")}',
                    retrieveGeneLevelAssociationsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveGeneLevelAssociations")}',
                    retrieveListOfGenesInARangeUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveListOfGenesInARange")}',
                    retrieveEffectorGeneInformationUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveEffectorGeneInformation")}',
                    aggregationCovarianceUrl: "${g.createLink(controller: "gene", action: "aggregationCovariance")}",
                    aggregationMetadataUrl: '${g.createLink(controller: "gene", action: "aggregationMetadata")}',
                    geneInfoAjaxUrl: '${g.createLink(controller: "Gene", action: "geneInfoAjax")}',
                    retrieveVariantsWithQtlRelationshipsUrl: '${g.createLink(controller: "RegionInfo", action: "retrieveVariantsWithQtlRelationships")}',
                    assayIdList: "${assayIdList}",
                    geneChromosomeMinusChr: function () {
                        if ('${geneChromosome}'.indexOf('chr') == 0) {
                            return '${geneChromosome}'.substr(3)
                        } else {
                            return '${geneChromosome}'
                        }
                    },
                    genePageWarning: "${genePageWarning}",
                    regionSpecificVersion:${regionSpecificVersion},
                    epigeneticAssays: "${portalVersionBean.getEpigeneticAssays()}",
                    tissueRegionOverlapMatcher: "${portalVersionBean.getTissueRegionOverlapMatcher().join(",")}".split(","),
                    tissueRegionOverlapDisplayMatcher: "${portalVersionBean.getTissueRegionOverlapDisplayMatcher().join(",")}".split(","),
                    exposeGeneComparisonTable: "${portalVersionBean.getExposeGeneComparisonTable()}",
                    exposePredictedGeneAssociations: "${portalVersionBean.getExposePredictedGeneAssociations()}",
                    exposeHiCData: "${portalVersionBean.getExposeHiCData()}",
                    exposeDynamicUi: "${portalVersionBean.getExposeDynamicUi()}",
                    exposeCommonVariantTab: "${portalVersionBean.getExposeCommonVariantTab()}",
                    exposeRareVariantTab: "${portalVersionBean.getExposeRareVariantTab()}",
                    exposeGenesInRegionTab: "${portalVersionBean.getExposeGenesInRegionTab()}",
                    exposeRegionAdjustmentOnGenePage: "${portalVersionBean.getExposeRegionAdjustmentOnGenePage()}",
                    exposeGeneTableOnDynamicUi: "${portalVersionBean.getExposeGeneTableOnDynamicUi()}",
                    exposeVariantTableOfDynamicUi: "${portalVersionBean.getExposeVariantTableOfDynamicUi()}",
                    dynamicTableType: 'geneTable',
                    utilizeBiallelicGait: "${portalVersionBean.getUtilizeBiallelicGait()}",
                    dataAnnotationTypes: [
                        {
                            code: 'GHDR', // manages the header.  Most of the records in this particular category have no match in the code, unlike all of the other categories
                            category: 'blank',
                            displayCategory: 'Genes',
                            subcategory: 'Genes subcategory',
                            displaySubcategory: 'Genes subcategory',
                            headerWriter: 'dynamicGeneTableHeaderV3',
                            cellBodyWriter: 'dynamicGeneTableHeaderV3',
                            categoryWriter: 'no category writer',
                            subCategoryWriter: 'no subcategory writer',
                            numberRecordsCellPresentationStringWriter: 'no record numbers string writer',
                            significanceCellPresentationStringWriter: 'no significance string writer',
                            sortingSubroutine: 'geneHeader',
                            packagingString: 'mpgSoftware.dynamicUi.geneHeaders',
                            internalIdentifierString: 'getTissuesFromProximityForLocusContext',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'FIR',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'Firth gene associations',
                            displaySubcategory: 'Firth gene associations',
                            cellBodyWriter: 'geneFirthAssociationTableBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'geneFirthAssociationTableSubCategory',
                            numberRecordsCellPresentationStringWriter: 'geneFirthAssociationTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'geneFirthAssociationTableSignificanceCellPresentationString',
                            sortingSubroutine: 'Firth',
                            packagingString: 'mpgSoftware.dynamicUi.geneBurdenFirth',
                            internalIdentifierString: 'getFirthGeneAssociationsForGeneTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'SKA',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'SKAT gene associations',
                            displaySubcategory: 'SKAT gene associations',
                            cellBodyWriter: 'geneSkatAssociationTableBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'geneSkatAssociationTableSubCategory',
                            numberRecordsCellPresentationStringWriter: 'geneSkatAssociationTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'geneSkatAssociationTableSignificanceCellPresentationString',
                            sortingSubroutine: 'SKAT',
                            packagingString: 'mpgSoftware.dynamicUi.geneBurdenSkat',
                            internalIdentifierString: 'getSkatGeneAssociationsForGeneTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'MET',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'MetaXcan',
                            displaySubcategory: 'MetaXcan',
                            cellBodyWriter: 'metaxcanTableBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'metaxcanTableSubCategory',
                            numberRecordsCellPresentationStringWriter: 'metaxcanTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'metaxcanTableSignificanceCellPresentationString',
                            sortingSubroutine: 'MetaXcan',
                            packagingString: 'mpgSoftware.dynamicUi.metaXcan',
                            internalIdentifierString: 'getGeneAssociationsForGenesTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'DEP_GS',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'DEPICT gene set',
                            displaySubcategory: 'DEPICT gene sets',
                            cellBodyWriter: 'depictGeneSetBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'depictGeneSetSubCategory',
                            numberRecordsCellPresentationStringWriter: 'depictGeneSetTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'depictGeneSetTableSignificanceCellPresentationString',
                            sortingSubroutine: 'DEPICT',
                            packagingString: 'mpgSoftware.dynamicUi.depictGeneSets',
                            internalIdentifierString: 'getDepictGeneSetForGenesTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'DEP_GP',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'DEPICT gene prioritization',
                            displaySubcategory: 'DEPICT gene prioritization',
                            cellBodyWriter: 'depictGeneTableBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'depictGeneTableSubCategory',
                            numberRecordsCellPresentationStringWriter: 'depictGenePvalueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'depictGenePvalueTableSignificanceCellPresentationString',
                            sortingSubroutine: 'DEPICT',
                            packagingString: 'mpgSoftware.dynamicUi.depictGenePvalue',
                            internalIdentifierString: 'getInformationFromDepictForGenesTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'ECA',
                            category: 'Annotation',
                            displayCategory: 'Posterior probability',
                            subcategory: 'eCAVIAR',
                            displaySubcategory: 'eCAVIAR',
                            cellBodyWriter: 'eCaviarBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'eCaviarSubCategory',
                            numberRecordsCellPresentationStringWriter: 'eCaviarTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'eCaviarTableSignificanceCellPresentationString',
                            sortingSubroutine: 'eCAVIAR',
                            packagingString: 'mpgSoftware.dynamicUi.eCaviar',
                            internalIdentifierString: 'getRecordsFromECaviarForGeneTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'COL',
                            category: 'Annotation',
                            displayCategory: 'Posterior probability',
                            subcategory: 'COLOC',
                            displaySubcategory: 'COLOC',
                            cellBodyWriter: 'colocBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'colocSubCategory',
                            numberRecordsCellPresentationStringWriter: 'colocTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'colocTableSignificanceCellPresentationString',
                            sortingSubroutine: 'COLOC',
                            packagingString: 'mpgSoftware.dynamicUi.coloc',
                            internalIdentifierString: 'getRecordsFromColocForGeneTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'MOD',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'MOD',
                            displaySubcategory: 'Mouse knockout phenotypes',
                            cellBodyWriter: 'dynamicGeneTableModBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'dynamicGeneTableModSubCategory',
                            numberRecordsCellPresentationStringWriter: 'modTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'modTableSignificanceCellPresentationString',
                            sortingSubroutine: 'MOD',
                            packagingString: 'mpgSoftware.dynamicUi.mouseKnockout',
                            internalIdentifierString: 'getAnnotationsFromModForGenesTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'EFF',
                            category: 'Annotation',
                            displayCategory: 'Annotation',
                            subcategory: 'Effector gene list',
                            displaySubcategory: 'T2D effector gene list',
                            cellBodyWriter: 'dynamicGeneTableEffectorGeneBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'dynamicGeneTableEffectorGeneSubCategory',
                            numberRecordsCellPresentationStringWriter: 'effectorGeneTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'effectorGeneTableSignificanceCellPresentationString',
                            sortingSubroutine: 'straightAlphabetic',
                            packagingString: 'mpgSoftware.dynamicUi.effectorGene',
                            internalIdentifierString: 'getInformationFromEffectorGeneListTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        },
                        {
                            code: 'MAGMA',
                            category: 'Annotation',
                            displayCategory: 'Significance of association',
                            subcategory: 'MAGMA gene prioritization',
                            displaySubcategory: 'MAGMA gene prioritization',
                            cellBodyWriter: 'magmaTableBody',
                            categoryWriter: 'sharedCategoryWriter',
                            subCategoryWriter: 'magmaTableSubCategory',
                            numberRecordsCellPresentationStringWriter: 'magmaPvalueTableNumberRecordsCellPresentationString',
                            significanceCellPresentationStringWriter: 'magmaPvalueTableSignificanceCellPresentationString',
                            sortingSubroutine: 'MAGMA',
                            packagingString: 'mpgSoftware.dynamicUi.depictGenePvalue',
                            internalIdentifierString: 'getInformationFromMagmaForGenesTable',
                            nameOfAccumulatorFieldWithIndex:'geneInfoArray'
                        }
                        // additional sorting terms
                        ,
                        {
                            sortingSubroutine: 'categoryName',
                            internalIdentifierString: 'doesNotHaveAnIndependentFunction',
                            packagingString: 'mpgSoftware.dynamicUi.geneHeaders',
                            nameOfAccumulatorField: 'notUsed',
                            nameOfAccumulatorFieldWithIndex: 'notUsed'
                        }
                        ,
                        {
                            sortingSubroutine: 'geneMethods',
                            internalIdentifierString: 'doesNotHaveAnIndependentFunction',
                            nameOfAccumulatorField: 'notUsed',
                            nameOfAccumulatorFieldWithIndex: 'notUsed'
                        }

                    ],
                    dynamicTableConfiguration: {
                        emptyBodyRecord: '#emptyBodyRecord',
                        emptyHeaderRecord: '#emptyHeaderRecord',
                        domSpecificationForAccumulatorStorage: '#configurableUiTabStorage',
                        formOfStorage: 'loadFromTable',
                        initializeSharedTableMemory: 'table.combinedGeneTableHolder',
                        organizingDiv: '#DataTables_Table_0_wrapper',
                        initialOrientation: 'geneTableGeneHeaders'
                    }
                };
                mpgSoftware.geneSignalSummaryMethods.setSignalSummarySectionVariables(drivingVariables);
                mpgSoftware.geneSignalSummaryMethods.initialPageSetUp(drivingVariables);
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariantsDirectlyByPhenotype(drivingVariables.defaultPhenotype,
                    mpgSoftware.geneSignalSummaryMethods.getSingleBestPhenotypeAndLaunchInterface, {
                        favoredPhenotype: drivingVariables['defaultPhenotype'],
                        limit: 1,
                        useMinimalCall: true
                    });
                mpgSoftware.geneSignalSummaryMethods.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.displayInterestingPhenotypes,
                    {favoredPhenotype: drivingVariables['defaultPhenotype']});
                if (${portalVersionBean.getExposePredictedGeneAssociations()}) {
                    mpgSoftware.geneSignalSummaryMethods.selfContainedGeneRanking();
                }
                mpgSoftware.geneSignalSummaryMethods.tableInitialization();
            };
            return {
                geneTableConfiguration: geneTableConfiguration
            }
        })()

    })();

</script>