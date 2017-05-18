<style>

</style>

<div class="row">
    <div class="pull-right" style="display:none">
        <label for="signalPhenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                            default="Change phenotype choice"/></label>
        &nbsp;
        <select id="signalPhenotypeTableChooser" name="phenotypeTableChooser"
                onchange="mpgSoftware.geneSignalSummary.refreshTopVariantsByPhenotype(this,mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay,
                        {preferIgv:($('input[name=genomeBrowser]:checked').val()==='2')})">
        </select>
    </div>
</div>
<div >%{--should hold the Choose data set panel--}%
    <div class="panel-heading">
        <div class="row">
            <div class="col-md-2 col-xs-12">
                <div id='trafficLightHolder'>
                    <r:img uri="/images/undeterminedlight.png"/>
                    <div id="signalLevelHolder" style="display:none"></div>
                </div>

            </div>

            <div class="col-md-5 col-xs-12">
                <div class="row">
                    <div class="col-lg-12 trafficExplanations trafficExplanation1">
                        No evidence of a signal
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation2">
                        Absence of strong evidence
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation3">
                        Signal exists
                    </div>
                </div>
            </div>

            <div class="col-md-5 col-xs-12">
                %{--<button name="adjustSignalSummaryDisplay"--}%
                        %{--class="btn btn-secondary btn-sm burden-test-btn vcenter"--}%
                        %{--type="button" data-toggle="collapse" data-target="#signalSummaryDisplay" aria-expanded="false" aria-controls="signalSummaryDisplay">Adjust display</button>--}%
                %{--<div class="collapse" id="signalSummaryDisplay">--}%
                    %{--<div class="signalSummaryDisplay">--}%
                        %{--<div class="row" style="margin-bottom: 5px">--}%
                            %{--<div class="col-xs-5">--}%
                                %{--<label class="radio-inline" style="font-weight: bold">Genome browser</label>--}%
                            %{--</div>--}%
                            %{--<div class="col-xs-4">--}%
                                %{--<label class="radio-inline"><input type="radio"  name="genomeBrowser" value=1--}%
                                                                   %{--onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()"--}%
                                                                   %{--checked>LocusZoom</label>--}%
                            %{--</div>--}%
                            %{--<div class="col-xs-3">--}%
                                %{--<label class="radio-inline"><input type="radio"  name="genomeBrowser" value=2--}%
                                                                   %{--onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()">IGV</label>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                %{--</div>--}%
            </div>

        </div>
        <div class="row interestingPhenotypesHolder">
            <div class="col-xs-12">
                <div id="interestingPhenotypes">

                </div>
            </div>
        </div>


    </div>

</div>

<div class="collapse in" id="collapseExample">
    <div class="wellPlace">
        <div id="noAggregatedVariantsLocation">
            <div class="row" style="margin-top: 15px;">
                <div class="col-lg-offset-1">
                    <h4>No information about aggregated variants exists for this phenotype</h4>
                </div>
            </div>
        </div>


    </div>
</div>


<div id="BurdenHiddenHere" style="display:none">
    <g:render template="/templates/burdenTestSharedTemplate" />
</div>
<g:render template="/templates/variantSearchResultsTemplate" />

<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.geneSignalSummary = (function () {

                var rememberSignalSummaryVariables = {};

                var displayVariantResultsTable = function(phenotypeCode){





                    var filtersAsJson = [{"comparator":"<","dataset":"ExChip_CAMP_mdv25","phenotype":"FI","prop":"P_VALUE","value":"0.001"}];

                    var drivingVariables = {
                        interfaceGoesHere: '#variantSearchResultsInterface',
                        variantResultsTableHeader:[],
                        makeAggregatedDataCall: true,
                        chooseAdSubtractPhenotype: [],
                        chooseAdSubtractDataSets: [],
                        chooseAdSubtractCommonProperties: [1],
                        returnToTheVariantResultsTable: [],
                        retrieveTopVariantsAcrossSgs:'<g:createLink controller="variantSearch" action="retrieveTopVariantsAcrossSgsWithSimulatedMetadata" />',
                        geneName:'${geneName}',
                        phenotypeCode:phenotypeCode,
                        retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
                        geneInfoUrl:'<g:createLink controller="gene" action="geneInfo" />',
                        variantInfoUrl:'<g:createLink controller="variantInfo" action="variantInfo" />',
                        variantSearchAndResultColumnsDataUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
                        variantSearchAndResultColumnsInfoUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
                        launchAVariantSearchUrl: "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: '%5B%7B%22phenotype%22%3A%22FI%22%2C%22dataset%22%3A%22ExChip_CAMP_mdv25%22%2C%22prop%22%3A%22P_VALUE%22%2C%22value%22%3A%220.001%22%2C%22comparator%22%3A%22%3C%22%7D%5D']"/>",
                        retrieveDatasetsAjaxUrl:"${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
                        linkBackToSearchDefinitionPage:'<a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams: "%5B17%253DFI%255BExChip_CAMP_mdv25%255DP_VALUE%253C0.001%5D"]'/>">',
                        variantTableResults:'variantTableResults',
                        queryFiltersInfo:"17%3DFI%5BExChip_CAMP_mdv25%5DP_VALUE%3C0.001",
                        proteinEffectsListInfo:"transcript_ablation%3Atranscript+ablation%7Esplice_donor_variant%3Asplice+donor+variant%7Esplice_acceptor_variant%3Asplice+acceptor+variant%7Estop_gained%3Astop+gained%7Eframeshift_variant%3Aframeshift+variant%7Estop_lost%3Astop+lost%7Einitiator_codon_variant%3Ainitiator+codon+variant%7Einframe_insertion%3Ainframe+insertion%7Einframe_deletion%3Ainframe+deletion%7Emissense_variant%3Amissense+variant%7Etranscript_amplification%3Atransript+amplification%7Esplice_region_variant%3Asplice+region+variant%7Eincomplete_terminal_codon_variant%3Aincomplete+terminal+codon+variant%7Esynonymous_variant%3Asynonymous+variant%7Estop_retained_variant%3Astop+retained+variant%7Ecoding_sequence_variant%3Acoding+sequence+variant%7Emature_miRNA_variant%3Amature+miRNA+variant%7E5_prime_UTR_variant%3A5%27+UTR+variant%7E3_prime_UTR_variant%3A3%27+UTR+variant%7Enon_coding_exon_variant%3Anon+coding+exon+variant%7Enc_transcript_variant%3Anc+transcript+variant%7Eintron_variant%3Aintron+variant%7ENMD_transcript_variant%3Anmd+transcript+variant%7Eupstream_gene_variant%3Aupstream+gene+variant%7Edownstream_gene_variant%3Adownstream+gene+variant%7ETFBS_ablation%3Atfbs+ablation%7ETFBS_amplification%3Atfbs+amplification%7ETF_binding_site_variant%3Atf+binding+site+variant%7Eregulatory_region_variant%3Aregulatory+region+variant%7Eregulatory_region_ablation%3Aregulatory+region+ablation%7Eregulatory_region_amplification%3Aregulatory+region+amplification%7Efeature_elongation%3Afeature+elongation%7Efeature_truncation%3Afeature+truncation%7Eintergenic_variant%3Aintergenic+variant",
                        localeInfo:"en_US",
                        translatedFiltersInfo:"Fasting insulin[CAMP GWAS]P-value&lt;0.001",
                        additionalPropertiesInfo:"common-common-CLOSEST_GENE:common-common-VAR_ID:common-common-DBSNP_ID:common-common-Protein_change:common-common-Consequence:common-common-CHROM:common-common-POS",
                        filtersAsJsonInfo:filtersAsJson,
                        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
                        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />',
                        commonPropsMsg:'<g:message code="variantTable.columnHeaders.commonProperties"/>',
                        geneNamesToDisplay:"[]",
                        regionSpecification:'',
                        uniqueRoot:"x"};
                    drivingVariables = mpgSoftware.variantSearchResults.setVarsToRemember(drivingVariables);
                    $("#cDataModalGoesHere").empty().append(
                            Mustache.render( $('#dataModalTemplate')[0].innerHTML,drivingVariables));
                    var fakeData = {cProperties:{dataset:['VAR_ID','DBSNP_ID','Consequence','PVALUE','EFFECT','GENE','MOST_DEL_SCORE','Protein_change','dataset'],
                                                 is_error: false,
                                                 numRecords: 3},
                                     columns:{
                                         pproperty:[],
                                         dproperty:[],
                                         cproperty:['VAR_ID','DBSNP_ID','PVALUE','EFFECT','dataset']
                                     },
                        translationDictionary:{'DBSNP_ID':'dbSNP ID'}};
                    mpgSoftware.variantSearchResults.setTranslationFunction(fakeData);
                    mpgSoftware.variantSearchResults.generateModal(fakeData,drivingVariables,drivingVariables.uniqueRoot);
                };

            var updateCommonTable = function (data,additionalParameters) {
                var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05);
                renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
                renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
                renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
                $("#commonVariantsLocation").empty().append(Mustache.render($('#commonVariantTemplate')[0].innerHTML, renderData));
                mpgSoftware.geneSignalSummaryMethods.buildCommonTable("#commonVariantsLocationHolder",
                        "${createLink(controller: 'VariantInfo', action: 'variantInfo')}", renderData, rememberSignalSummaryVariables);
            }

            var updateHighImpactTable = function (data,additionalParameters) {
                var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05);
                renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
                renderData["propertiesToInclude"] = (data.propertiesToInclude==="[]")?[]:data.propertiesToInclude;
                renderData["propertiesToRemove"] = (data.propertiesToRemove==="[]")?[]:data.propertiesToRemove;
                $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                mpgSoftware.geneSignalSummaryMethods.buildHighImpactTable("#highImpactTemplateHolder",
                        "${createLink(controller: 'VariantInfo', action: 'variantInfo')}",renderData,rememberSignalSummaryVariables);
            }



            var updateSignificantVariantDisplay = function (data,additionalParameters) {
                    var phenotypeName = additionalParameters.phenotype;
                    var datasetName = additionalParameters.ds;
                    var pName = additionalParameters.pname;
                    var useIgvNotLz = additionalParameters.preferIgv;
                    //  until LZ is fixed
                   // useIgvNotLz = true;
                    additionalParameters['gene'] = '<%=geneName%>';
                    additionalParameters['vrtUrl'] =  '<g:createLink absolute="true" controller="variantSearch" action="gene" />';
                    rememberSignalSummaryVariables = additionalParameters;
                    var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05);
                    var signalLevel = mpgSoftware.geneSignalSummaryMethods.assessSignalSignificance(renderData);
                    var commonSectionShouldComeFirst = mpgSoftware.geneSignalSummaryMethods.commonSectionComesFirst(renderData);
                    renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
                    if (useIgvNotLz){
                        renderData["igvChecked"] =  'checked';
                    }
                    if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                        mpgSoftware.locusZoom.removeAllPanels();
                    }
                    $('#collapseExample div.wellPlace').empty();
                    if (commonSectionShouldComeFirst) {
                        $("#collapseExample div.wellPlace").empty().append(Mustache.render( $('#organizeSignalSummaryCommonFirstTemplate')[0].innerHTML,{pName:pName}));
                    } else {
                        $("#collapseExample div.wellPlace").empty().append(Mustache.render( $('#organizeSignalSummaryHighImpactFirstTemplate')[0].innerHTML,{pName:pName}));

                    }
                    if (useIgvNotLz){
                       $('.locusZoomLocation').css('display','none');
                       $('.browserChooserGoesHere').empty().append(Mustache.render( $('#genomeBrowserTemplate')[0].innerHTML,renderData));
                    } else {
                        $('.igvGoesHere').css('display','none');
                        $('.browserChooserGoesHere').empty().append(Mustache.render( $('#genomeBrowserTemplate')[0].innerHTML,renderData));
                        $("#locusZoomLocation").empty().append(Mustache.render( $('#locusZoomTemplate')[0].innerHTML,renderData));
                    }


                    %{--$("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));--}%
                    %{--mpgSoftware.geneSignalSummaryMethods.buildHighImpactTable("#highImpactTemplateHolder",--}%
                            %{--"${createLink(controller: 'VariantInfo', action: 'variantInfo')}",renderData,additionalParameters);--}%
                    updateHighImpactTable(data,additionalParameters);

                    //  set up the gait interface
                    mpgSoftware.burdenTestShared.buildGaitInterface('#burdenGoesHere',{
                                accordionHeaderClass:'toned-down-accordion-heading',
                                modifiedTitle:'Run a custom burden test',
                                modifiedTitleStyling:'font-size: 18px;text-decoration: underline;padding-left: 20px; float: right; margin-right: 20px;',
                                allowExperimentChoice: false,
                                allowPhenotypeChoice: true,
                                allowStratificationChoice: true,
                                defaultPhenotype:phenotypeName
                            },
                            '${geneName}',
                            true,
                            '#datasetFilter',
                            '${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}',
                            "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
                            "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
                            "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
                            "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
                            "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
                            "${createLink(controller: 'VariantInfo', action: 'variantInfo')}",
                            "${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",
                            "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}");

                    $("#aggregateVariantsLocation").empty().append(Mustache.render( $('#aggregateVariantsTemplate')[0].innerHTML,renderData));

                    updateCommonTable(data,additionalParameters);

                    //var phenotypeName = $('#signalPhenotypeTableChooser option:selected').val();
                    var sampleBasedPhenotypeName = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForSampleData(phenotypeName);
                    var hailPhenotypeInfo = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForHailData(phenotypeName);
                    var positioningInformation = {
                        chromosome: '${geneChromosome}'.replace(/chr/g, ""),
                        startPosition:  ${geneExtentBegin},
                        endPosition:  ${geneExtentEnd}
                    };
                    if (useIgvNotLz){
                        igvLauncher.setUpIgv('<%=geneName%>',
                                '.igvGoesHere',
                                "<g:message code='controls.shared.igv.tracks.recomb_rate' />",
                                "<g:message code='controls.shared.igv.tracks.genes' />",
                                "${createLink(controller: 'trait', action: 'retrievePotentialIgvTracks')}",
                                "${createLink(controller:'trait', action:'getData', absolute:'false')}",
                                "${createLink(controller:'variantInfo', action:'variantInfo', absolute:'true')}",
                                "${createLink(controller:'trait', action:'traitInfo', absolute:'true')}",
                                '${igvIntro}',
                                phenotypeName);
                    } else {
                        if (!mpgSoftware.locusZoom.plotAlreadyExists()) {
                            mpgSoftware.locusZoom.initializeLZPage('geneInfo', null, positioningInformation,
                                    "#lz-1", "#collapseExample", phenotypeName, pName, '${lzOptions.first().propertyName}', datasetName, 'junk',
                                    '${createLink(controller:"gene", action:"getLocusZoom")}',
                                    '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                    '${lzOptions.first().dataType}',
                                    '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}'
                            );
                        } else {
                            mpgSoftware.locusZoom.resetLZPage('geneInfo', null, positioningInformation,
                                    "#lz-1", "#collapseExample", phenotypeName, pName, datasetName, '${lzOptions.first().propertyName}', 'junk',
                                    '${createLink(controller:"gene", action:"getLocusZoom")}',
                                    '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                    '${lzOptions.first().dataType}',
                                    '${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}');
                        }
                    }
                if ( ( typeof sampleBasedPhenotypeName !== 'undefined') &&
                    ( sampleBasedPhenotypeName.length > 0)) {
                    $('#aggregateVariantsLocation').css('display','block');
                    $('#noAggregatedVariantsLocation').css('display','none');
                    refreshVariantAggregates(sampleBasedPhenotypeName,"0","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#allVariants");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"1","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#allCoding");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"8","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#allMissense")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"7","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#possiblyDamaging");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"6","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#probablyDamaging")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"5","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",mpgSoftware.geneSignalSummaryMethods.updateAggregateVariantsDisplay,"#proteinTruncating");
                } else {
                    $('#aggregateVariantsLocation').css('display','none');
                    $('#noAggregatedVariantsLocation').css('display','block');
                }

                $('#collapseExample').on('shown.bs.collapse', function (e) {
                        if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                            mpgSoftware.locusZoom.rescaleSVG();
                        }
                    });
                    mpgSoftware.geneSignalSummary.displayVariantResultsTable(phenotypeName);
                    $("#xpropertiesModal").on("shown.bs.modal", function(){
                        $("#xpropertiesModal li a").click();
                    });
                    $('a[href="#highImpactVariantTabHolder"]').on('shown.bs.tab', function (e) {
                        $('#highImpactTemplateHolder').dataTable().fnAdjustColumnSizing();
                    });
                    $('a[href="#commonVariantTabHolder"]').on('shown.bs.tab', function (e) {
                        $('#commonVariantsLocationHolder').dataTable().fnAdjustColumnSizing();
                    });

                };



                var updateGenePageTables = function (domSelectors,domSelectorName) {
                    var matchingSelectedInputs = $('input[data-category="properties"]:checked:not(:disabled)').get();
                    var matchingUnselectedInputs = $('input[data-category="properties"]:not(:checked,:disabled)').get();
                    var valuesToInclude = _.map(matchingSelectedInputs, function (input) {
                        return $(input).val();
                    });
                    var valuesToRemove = _.map(matchingUnselectedInputs, function (input) {
                        return $(input).val();
                    });
                    var currentPhenotype = $('.chosenPhenotype').attr('id');
                    if (domSelectors == 'common'){
                        mpgSoftware.geneSignalSummary.refreshTopVariants(mpgSoftware.geneSignalSummary.updateCommonTable,
                                {   propertiesToInclude:valuesToInclude,
                                    propertiesToRemove:valuesToRemove,
                                    currentPhenotype: currentPhenotype,
                                    gene: '<%=geneName%>',
                                    vrtUrl:  '<g:createLink absolute="true" controller="variantSearch" action="gene" />',
                                    redLightImage: '<r:img uri="/images/redlight.png"/>',
                                    yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',
                                    greenLightImage: '<r:img uri="/images/greenlight.png"/>' });
                    } else {
                        mpgSoftware.geneSignalSummary.refreshTopVariants(mpgSoftware.geneSignalSummary.updateHighImpactTable,
                                {   propertiesToInclude:valuesToInclude,
                                    propertiesToRemove:valuesToRemove,
                                    currentPhenotype: currentPhenotype,
                                    gene: '<%=geneName%>',
                                    redLightImage: '<r:img uri="/images/redlight.png"/>',
                                    yellowLightImage: '<r:img uri="/images/yellowlight.png"/>',
                                    greenLightImage: '<r:img uri="/images/greenlight.png"/>' });

                    }

                };




                        var updateDisplayBasedOnStoredSignificanceLevel = function (newSignificanceLevel) {
                            var currentSignificanceLevel = $('#signalLevelHolder').text();
                            if (newSignificanceLevel>=currentSignificanceLevel){
                                return;
                            }
                            mpgSoftware.geneSignalSummaryMethods.updateDisplayBasedOnSignificanceLevel(newSignificanceLevel,
                                    {redLightImage:'<r:img uri="/images/redlight.png"/>',
                                        yellowLightImage:'<r:img uri="/images/yellowlight.png"/>',
                                        greenLightImage:'<r:img uri="/images/greenlight.png"/>'});
                        };




                        var refreshVariantAggregates = function (phenotypeName, filterNum, sampleDataSet, dataSet,mafOption, mafValue, geneName, callBack,callBackParameter) {
                            var rememberCallBack = callBack;
                            var rememberCallBackParameter = callBackParameter;

                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'gene', action: 'burdenTestAjax')}",
                                data: { geneName:geneName,
                                        dataSet:dataSet,
                                        sampleDataSet:sampleDataSet,
                                        filterNum:filterNum,
                                        burdenTraitFilterSelectedOption: phenotypeName,
                                        mafOption:mafOption,
                                        mafValue:mafValue   },
                                async: true,
                                success: function (data) {
                                    rememberCallBack(data,rememberCallBackParameter);
                                },
                                error: function (jqXHR, exception) {
                                    core.errorReporter(jqXHR, exception);
                                }
                            });

                        };

                        var refreshTopVariants = function ( callBack, params ) {
                            var rememberCallBack = callBack;
                            var rememberParams = params;
                            var propertiesToIncludeQuoted = [];
                            var propertiesToRemoveQuoted = [];
                            _.each(params.propertiesToInclude, function(o){propertiesToIncludeQuoted.push(o)});
                            _.each(params.propertiesToRemove, function(o){propertiesToRemoveQuoted.push(o)});
                            var callingObj = {
                                geneToSummarize:"${geneName}",
                                propertiesToInclude: propertiesToIncludeQuoted.join(","),
                                propertiesToRemove: propertiesToRemoveQuoted.join(",")
                            };
                            if (typeof params.currentPhenotype !== 'undefined') {
                                callingObj["phenotype"] = params.currentPhenotype;
                            };
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                                data: callingObj,
                                async: true,
                                success: function (data) {
                                    rememberCallBack(data,rememberParams);
                                },
                                error: function (jqXHR, exception) {
                                    core.errorReporter(jqXHR, exception);
                                }
                            });

                        };
                        var refreshTopVariantsDirectlyByPhenotype = function (phenotypeName, callBack, parameter) {
                            var rememberCallBack = callBack;
                            var rememberParameter = parameter;
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                                data: {
                                    phenotype: phenotypeName,
                                    geneToSummarize:"${geneName}"},
                                async: true,
                                success: function (data) {
                                    rememberCallBack(data, rememberParameter);
                                },
                                error: function (jqXHR, exception) {
                                    core.errorReporter(jqXHR, exception);
                                }
                            });

                        };
                        var refreshTopVariantsByPhenotype = function (sel, callBack) {
                            var phenotypeName = sel.value;
                            refreshTopVariantsDirectlyByPhenotype(phenotypeName,callBack);
                        };

                var refreshLZ = function(varId,dataSetName,propName,phenotype){
                    var parseId = varId.split("_");
                    var locusZoomRange = 80000;
                    var variantPos = parseInt(parseId[1]);
                    var begPos = 0;
                    var endPos =  variantPos + locusZoomRange;
                    if (variantPos > locusZoomRange ){
                        begPos =  variantPos - locusZoomRange;
                    }
                    var positioningInformation = {
                        chromosome: parseId[0],
                        startPosition: begPos,
                        endPosition: endPos
                    };
                    mpgSoftware.locusZoom.removeAllPanels();


    };
    var setCheckBoxes = function(tableId){
        var hdrMap = {};
        // Get the names of the columns from the table headers and store them in a map
        var hdrs = $(tableId).DataTable().columns().header();
        _.forEach(hdrs,function(o){
            var hdrDom = $(o);
            var classList = hdrDom.attr('class').split(/\s+/);
            var nameWeWant = _.find(classList,function(o){return o.startsWith('codeName_')});
            var codeName = nameWeWant.substr("codeName_".length);
            var displayName = hdrDom.html();
            if (displayName.indexOf('<')>-1){
                displayName = displayName.substr(0,displayName.indexOf('<'));
            }
            hdrMap[codeName] = displayName;
        });
        // now get the elements from the modal box
        var props = $('.dk-modal-form-input-group>div.checkbox>label>input');
        _.forEach(props,function(o){
            var fullPropertyName = $(o).attr('value');
            var propertyName = fullPropertyName.substr('common-common-'.length)
            if (hdrMap[propertyName]){
                $(o).prop('checked',true);
            } else {
                $(o).prop('checked',false);
            }
        });

    }
    var adjustProperties  = function(origDom){
        var whichTable = $(origDom).attr('tableSpec');
        var checkBoxes = $('.dk-modal-form-input-group>div.checkbox>label>input')
        if (whichTable=='common'){
            setCheckBoxes('#commonVariantsLocationHolder');
            $('.confirmPropertyChange').attr('onclick',"mpgSoftware.geneSignalSummary.updateGenePageTables('common','x')");

        } else if (whichTable=='highImpact'){
            setCheckBoxes('#highImpactTemplateHolder');
            $('.confirmPropertyChange').attr('onclick',"mpgSoftware.geneSignalSummary.updateGenePageTables('highImpact','x')");
        }
    }



return {
    updateSignificantVariantDisplay:updateSignificantVariantDisplay,
    refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
    refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype,
    refreshTopVariants:refreshTopVariants,
    refreshLZ:refreshLZ,
    updateDisplayBasedOnStoredSignificanceLevel:updateDisplayBasedOnStoredSignificanceLevel,
    displayVariantResultsTable:displayVariantResultsTable,
    updateGenePageTables:updateGenePageTables,
    updateCommonTable:updateCommonTable,
    updateHighImpactTable:updateHighImpactTable,
    adjustProperties:adjustProperties
}
}());


})();

$( document ).ready(function() {
   mpgSoftware.geneSignalSummary.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.displayInterestingPhenotypes,
           {redLightImage:'<r:img uri="/images/redlight.png"/>',
            yellowLightImage:'<r:img uri="/images/yellowlight.png"/>',
            greenLightImage:'<r:img uri="/images/greenlight.png"/>',
           favoredPhenotype:'T2D'});
    mpgSoftware.geneSignalSummaryMethods.tableInitialization();






});


</script>

