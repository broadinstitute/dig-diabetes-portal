

<div class="row">
    <div class="pull-right" style="display:none">
        <label for="signalPhenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                            default="Change phenotype choice"/></label>
        &nbsp;
        <select id="signalPhenotypeTableChooser" name="phenotypeTableChooser"
                onchange="mpgSoftware.geneSignalSummary.refreshTopVariantsByPhenotype(this,mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay)">
        </select>
    </div>
</div>
<div >%{--should hold the Choose data set panel--}%
    <div class="panel-heading" style="background-color: #E0F3FD">
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
                    <button name="adjustSignalSummaryDisplay"
                        class="btn btn-secondary btn-sm burden-test-btn vcenter"
                        type="button" data-toggle="collapse" data-target="#signalSummaryDisplay" aria-expanded="false" aria-controls="signalSummaryDisplay">Adjust display</button>
                <div class="collapse" id="signalSummaryDisplay">
                    <div class="signalSummaryDisplay">
                        <div class="row" style="margin-bottom: 5px">
                            <div class="col-xs-5">
                                <label class="radio-inline" style="font-weight: bold">Genome browser</label>
                            </div>
                            <div class="col-xs-4">
                                <label class="radio-inline"><input type="radio"  name="genomeBrowser" value=1
                                                                   onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()"
                                                                   checked>LocusZoom</label>
                            </div>
                            <div class="col-xs-3">
                                <label class="radio-inline"><input type="radio"  name="genomeBrowser" value=2
                                                                   onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()">IGV</label>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 5px">
                            <div class="col-xs-5">
                                <label class="text-inline" style="font-weight: bold">LD pruning parameter</label>
                            </div>
                            <div class="col-xs-2">
                                <input type="text"  name="ldPruning"  style="width:60px" disabled>
                            </div>
                            <div class="col-xs-5">
                                <label class="text-inline" style="font-weight: 100">(0&lt;value&lt;1)</label>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 5px">
                            <div class="col-xs-5">
                                <label class="text-inline" style="font-weight: bold; padding-top: 10px">MAF filter</label>
                            </div>
                            <div class="col-xs-3">
                                <input type="text"  name="mafFilterMax"  style="width:100px" value="0">
                                <input type="text"  name="mafFilterMin"  style="width:100px" value="1">
                            </div>
                            <div class="col-xs-4">
                                <label class="text-inline" style="font-weight: 100">&lt; MAF</label><br/>
                                <label class="text-inline" style="font-weight: 100">&gt; MAF</label>
                            </div>
                        </div>




                    </div>

                </div>
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
    <div class="well">

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


<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";

        mpgSoftware.geneSignalSummary = (function () {

                var updateSignificantVariantDisplay = function (data,additionalParameters) {
                    var phenotypeName = additionalParameters.phenotype;
                    var datasetName = additionalParameters.ds;
                    var pName = additionalParameters.pname;
                    var useIgvNotLz = additionalParameters.preferIgv;
                    var renderData = mpgSoftware.geneSignalSummaryMethods.buildRenderData (data,0.05);
                    var signalLevel = mpgSoftware.geneSignalSummaryMethods.assessSignalSignificance(renderData);
                    var commonSectionShouldComeFirst = mpgSoftware.geneSignalSummaryMethods.commonSectionComesFirst(renderData);
                    renderData = mpgSoftware.geneSignalSummaryMethods.refineRenderData(renderData,1);
                    if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                        mpgSoftware.locusZoom.removeAllPanels();
                    }
                    $('#collapseExample div.well').empty();
                    if (commonSectionShouldComeFirst) {
                        $("#collapseExample div.well").empty().append(Mustache.render( $('#organizeSignalSummaryCommonFirstTemplate')[0].innerHTML,{pName:pName}));
                    } else {
                        $("#collapseExample div.well").empty().append(Mustache.render( $('#organizeSignalSummaryHighImpactFirstTemplate')[0].innerHTML,{pName:pName}));

                    }
                    if (useIgvNotLz){
                       $('.locusZoomLocation').css('display','none');
                    } else {
                        $('.igvGoesHere').css('display','none');
                    }
                    if (!useIgvNotLz){
                        $("#locusZoomLocation").empty().append(Mustache.render( $('#locusZoomTemplate')[0].innerHTML,renderData));
                    }

                    $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                    mpgSoftware.geneSignalSummaryMethods.buildHighImpactTable("#highImpactTemplateHolder",
                            "${createLink(controller: 'VariantInfo', action: 'variantInfo')}",renderData.rvar);

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
                    $("#commonVariantsLocation").empty().append(Mustache.render( $('#commonVariantTemplate')[0].innerHTML,renderData));
                    mpgSoftware.geneSignalSummaryMethods.buildCommonTable("#commonVariantsLocationHolder",
                            "${createLink(controller: 'VariantInfo', action: 'variantInfo')}",renderData.cvar);

                    //var phenotypeName = $('#signalPhenotypeTableChooser option:selected').val();
                    var sampleBasedPhenotypeName = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForSampleData(phenotypeName);
                    var hailPhenotypeInfo = mpgSoftware.geneSignalSummaryMethods.phenotypeNameForHailData(phenotypeName);
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
                                    '${createLink(controller:"variantInfo", action:"variantInfo")}', '${lzOptions.first().dataType}');
                        } else {
                            mpgSoftware.locusZoom.resetLZPage('geneInfo', null, positioningInformation,
                                    "#lz-1", "#collapseExample", phenotypeName, pName, datasetName, '${lzOptions.first().propertyName}', 'junk',
                                    '${createLink(controller:"gene", action:"getLocusZoom")}',
                                    '${createLink(controller:"variantInfo", action:"variantInfo")}', '${lzOptions.first().dataType}');
                        }
                    }
                    $('#collapseExample').on('shown.bs.collapse', function (e) {
                        if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                            mpgSoftware.locusZoom.rescaleSVG();
                        }
                    });
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
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                                data: {
                                    geneToSummarize:"${geneName}"},
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




return {
    updateSignificantVariantDisplay:updateSignificantVariantDisplay,
    refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
    refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype,
    refreshTopVariants:refreshTopVariants,
    refreshLZ:refreshLZ,
    updateDisplayBasedOnStoredSignificanceLevel:updateDisplayBasedOnStoredSignificanceLevel
}
}());


})();

$( document ).ready(function() {
   mpgSoftware.geneSignalSummary.refreshTopVariants(mpgSoftware.geneSignalSummaryMethods.displayInterestingPhenotypes,
           {redLightImage:'<r:img uri="/images/redlight.png"/>',
            yellowLightImage:'<r:img uri="/images/yellowlight.png"/>',
            greenLightImage:'<r:img uri="/images/greenlight.png"/>'});
    mpgSoftware.geneSignalSummaryMethods.tableInitialization();
});


</script>

