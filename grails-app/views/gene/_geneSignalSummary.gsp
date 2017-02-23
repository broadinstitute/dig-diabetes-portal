

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
<div class="panel panel-default">%{--should hold the Choose data set panel--}%
    <div class="panel-heading" style="background-color: #E0F3FD">
        <div class="row">
            <div class="col-md-2 col-xs-12">
                <div id='trafficLightHolder'>
                    <r:img uri="/images/undeterminedlight.png"/>
                    <div id="signalLevelHolder" style="display:none"></div>
                </div>

            </div>

            <div class="col-md-8 col-xs-12">
                <div class="row">
                    <div class="col-lg-12 trafficExplanations trafficExplanation1">
                        Evidence of no signal
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation2">
                        Absence of strong evidence
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation3">
                        Signal exists
                    </div>
                </div>
            </div>

            <div class="col-md-2 col-xs-12">
                <button name="singlebutton"
                        class="btn btn-secondary btn-lg burden-test-btn vcenter"
                        type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">Summary</button>
                <button name="adjustSignalSummaryDisplay"
                        class="btn btn-secondary btn-sm burden-test-btn vcenter"
                        type="button" data-toggle="collapse" data-target="#signalSummaryDisplay" aria-expanded="false" aria-controls="signalSummaryDisplay">Adjust display</button>
                <div class="collapse" id="signalSummaryDisplay">
                    <div class="signalSummaryDisplay">
                        <label>
                            <input class="preferIgv" type="checkbox" onclick="mpgSoftware.geneSignalSummary.refreshSignalSummaryBasedOnPhenotype()">Use IGV
                        </label>
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
            var buildRenderData = function (data, mafCutoff) {
                var renderData = {variants: [],
                    rvar: [],
                    cvar: []};
                if ((typeof data !== 'undefined') &&
                        (typeof data.variants !== 'undefined') &&
                        (typeof data.variants.variants !== 'undefined') &&
                        (data.variants.variants.length > 0)) {
                    var obj;
                    _.forEach(data.variants.variants, function (v, index, y) {
                        if (_.flatten(v).length == 0) {
                            renderData.variants.push(mpgSoftware.geneSignalSummaryMethods.processAggregatedData(v));
                        } else {
                            renderData.variants.push(mpgSoftware.geneSignalSummaryMethods.processAggregatedData(v));
                        }

                    });
                }
                ;
                return renderData;
            };


            var updateAggregateVariantsDisplay = function (data, locToUpdate) {
                var updateHere = $(locToUpdate);
                updateHere.empty();
                if ((data) &&
                        (data.stats)) {
                    updateHere.append("<ul class='aggregateVariantsDescr list-group'>" +
                            "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.pValue) + "</li>" +
                            "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.beta) + "</li>" +
                            "<li class='list-group-item'>" + UTILS.realNumberFormatter(data.stats.ciLower) + " : " + UTILS.realNumberFormatter(data.stats.ciUpper) + "</li>" +
                            "</ul>");
                    if (data.stats.pValue < 0.000001) {
                        updateDisplayBasedOnStoredSignificanceLevel(3);//green light
                    } else if (data.stats.pValue < 0.01) {
                        updateDisplayBasedOnStoredSignificanceLevel(2);//yellow light
                    }

                }
            };


            var commonSectionComesFirst = function (renderData) { // returns true or false
                var returnValue;
                var sortedVariants = _.sortBy(renderData.variants, function (o) {
                    return o.P_VALUEV
                });
                for (var i = 0; (i < sortedVariants.length) && (typeof returnValue === 'undefined'); i++) {
                    var oneVariant = sortedVariants[i];
                    if ((typeof oneVariant.MAF !== 'undefined') && (oneVariant.MAF !== "")) {
                        if (oneVariant.MAF < 0.05) {
                            returnValue = false;
                        } else {
                            returnValue = true;
                        }
                    }
                    if (typeof oneVariant.MOST_DEL_SCORE !== 'undefined') {
                        if ((oneVariant.MOST_DEL_SCORE < 3)&&
                                ((typeof returnValue !== 'undefined')&&(returnValue !== true))) {
                            returnValue = false;
                        }
                    }
                }
                return returnValue;
            }


            var buildListOfInterestingPhenotypes = function (renderData) {
                var listOfInterestingPhenotypes = [];
                _.forEach(renderData.variants, function (v) {
                    var newSignalCategory = assessOneSignalsSignificance(v);
                    if (newSignalCategory > 0) {
                        var existingRecIndex = _.findIndex(listOfInterestingPhenotypes, {'phenotype': v['pheno']});
                        if (existingRecIndex > -1) {
                            var existingRec = listOfInterestingPhenotypes[existingRecIndex];
                            if (existingRec['signalStrength'] < newSignalCategory) {
                                existingRec['signalStrength'] = newSignalCategory;
                            }
                            if (existingRec['pValue'] > v['P_VALUEV']) {
                                existingRec['pValue'] = v['P_VALUEV'];
                                existingRec['ds'] = v['ds'];
                                existingRec['pname'] = v['pname'];
                            }
                        } else {
                            listOfInterestingPhenotypes.push({  'phenotype': v['pheno'],
                                'ds': v['ds'],
                                'pname': v['pname'],
                                'signalStrength': newSignalCategory,
                                'pValue': v['P_VALUEV']})
                        }
                    }
                });
                return _.sortBy(listOfInterestingPhenotypes,[function(o){return o.pValue}]);
            };

            function toggleOtherPhenoBtns(){
                var otherBtns = $('.nav>li.redPhenotype');
                if ((typeof otherBtns !== 'undefined')&&
                        (otherBtns.length>0)){
                    if ($(otherBtns[0]).css('display')==='none') {
                        $(otherBtns).css('display','block');
                    } else {
                        $(otherBtns).css('display','none');
                    }
                }
            };
            var launchUpdateSignalSummaryBasedOnPhenotype = function (phenocode,ds,phenoName) {
                $('.phenotypeStrength').removeClass('chosenPhenotype');
                $('#'+phenocode).addClass('chosenPhenotype');
                mpgSoftware.geneSignalSummary.refreshTopVariantsDirectlyByPhenotype(phenocode,
                        mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay,{updateLZ:true,phenotype:phenocode,pname:phenoName,ds:ds,preferIgv:$('.preferIgv').is(":checked")});
            };
            var updateSignalSummaryBasedOnPhenotype = function () {
                var phenocode = $(this).attr('id');
                var ds = $(this).attr('ds');
                var phenoName = $(this).text();
                launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName);
            };
            var refreshSignalSummaryBasedOnPhenotype = function () {
                var phenocode = $('.phenotypeStrength.chosenPhenotype').attr('id');
                var ds = $('.phenotypeStrength.chosenPhenotype').attr('ds');
                var phenoName = $('.phenotypeStrength.chosenPhenotype').text();
                launchUpdateSignalSummaryBasedOnPhenotype(phenocode,ds,phenoName);
            };
            var displayInterestingPhenotypes = function (data) {
                var renderData = buildRenderData(data, 0.05);
                var signalLevel = assessSignalSignificance(renderData);
                updateDisplayBasedOnSignificanceLevel(signalLevel);
                var listOfInterestingPhenotypes = buildListOfInterestingPhenotypes(renderData);
                if (listOfInterestingPhenotypes.length > 0) {
                    $('.interestingPhenotypesHolder').css('display','block');
                    var phenotypeDescriptions = '<label>Phenotypes with signals</label>'+
                            '<button type="button" class="btn btn-outline-secondary  btn-sm" onclick="mpgSoftware.geneSignalSummary.toggleOtherPhenoBtns()">Additional phenotypes</button>'+
                            '<ul class="nav nav-pills">';
                    _.forEach(listOfInterestingPhenotypes, function (o) {
                        if (o['signalStrength'] == 1) {
                            phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" class="nav-item redPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                        } else if (o['signalStrength'] == 2) {
                            phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" class="nav-item yellowPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                        } else if (o['signalStrength'] == 3) {
                            phenotypeDescriptions += ('<li id="'+o['phenotype']+'" ds="'+o['ds']+'" class="nav-item greenPhenotype phenotypeStrength">' + o['pname'] + '</li>');
                        }
                    });
                    phenotypeDescriptions += '</ul>';
                    $('#interestingPhenotypes').append(phenotypeDescriptions);

                }

                $('.phenotypeStrength').on("click",updateSignalSummaryBasedOnPhenotype);
                $('.phenotypeStrength').first().click();
            };

                var updateSignificantVariantDisplay = function (data,additionalParameters) {
                    var phenotypeName = additionalParameters.phenotype;
                    var datasetName = additionalParameters.ds;
                    var pName = additionalParameters.pname;
                    var useIgvNotLz = additionalParameters.preferIgv;
                    var renderData = buildRenderData (data,0.05);
                    var signalLevel = assessSignalSignificance(renderData);
                    var commonSectionShouldComeFirst = commonSectionComesFirst(renderData);
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
                        refreshVariantAggregates(sampleBasedPhenotypeName,"0","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allVariants");
                        refreshVariantAggregates(sampleBasedPhenotypeName,"1","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allCoding");
                        refreshVariantAggregates(sampleBasedPhenotypeName,"8","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allMissense")
                        refreshVariantAggregates(sampleBasedPhenotypeName,"7","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#possiblyDamaging");
                        refreshVariantAggregates(sampleBasedPhenotypeName,"6","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#probablyDamaging")
                        refreshVariantAggregates(sampleBasedPhenotypeName,"5","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#proteinTruncating");
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


                        var assessOneSignalsSignificance = function (v,signalCategory) {
                            var signalCategory = 1;
                            var mdsValue = parseInt(v['MOST_DEL_SCORE']);
                            var pValue = parseFloat(v['P_VALUEV']);
                            if (((pValue < 0.00000005)) ||
                                    ( (pValue < 0.000005) &&
                                            (mdsValue < 3) )) {
                                signalCategory = 3;
                            } else if (pValue < 0.0005) {
                                signalCategory = 2;
                            }
                            return signalCategory;
                        };
                        var assessSignalSignificance = function (renderData){
                           var signalCategory = 1; // 1 == red (no signal), 3 == green (signal)
                            _.forEach(renderData.variants,function(v){
                                var newSignalCategory = assessOneSignalsSignificance(v);
                                if (newSignalCategory>signalCategory){
                                    signalCategory = newSignalCategory;
                                }
                            });
                            return signalCategory;
                        };





                        var updateDisplayBasedOnSignificanceLevel = function (significanceLevel) {


                                var significanceLevelDoms = $('.trafficExplanations');

                                            significanceLevelDoms.removeClass('emphasize');
                                            significanceLevelDoms.addClass('unemphasize');


                            $('#trafficLightHolder').empty();
                            var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
                            significanceLevelDom.removeClass('unemphasize');
                            significanceLevelDom.addClass('emphasize');
                            if (significanceLevel == 1){
                                $('#trafficLightHolder').append('<r:img uri="/images/redlight.png"/>');
                            } else if (significanceLevel == 2){
                                $('#trafficLightHolder').append('<r:img uri="/images/yellowlight.png"/>');
                            } else if (significanceLevel == 3){
                                $('#trafficLightHolder').append('<r:img uri="/images/greenlight.png"/>');
                            }
                            $('#signalLevelHolder').text(significanceLevel);
                        };





                        var updateDisplayBasedOnStoredSignificanceLevel = function (newSignificanceLevel) {
                            var currentSignificanceLevel = $('#signalLevelHolder').text();
                            if (newSignificanceLevel>=currentSignificanceLevel){
                                return;
                            }
                            updateDisplayBasedOnSignificanceLevel(newSignificanceLevel);
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

                        var refreshTopVariants = function ( callBack ) {
                            var rememberCallBack = callBack;
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                                data: {
                                    geneToSummarize:"${geneName}"},
                                async: true,
                                success: function (data) {
                                    rememberCallBack(data);
                                },
                                error: function (jqXHR, exception) {
                                    core.errorReporter(jqXHR, exception);
                                }
                            });

                        };
                        var refreshTopVariantsDirectlyByPhenotype = function (phenotypeName, callBack, parameter) {
                            var rememberCallBack = callBack;
                            $.ajax({
                                cache: false,
                                type: "post",
                                url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                                data: {
                                    phenotype: phenotypeName,
                                    geneToSummarize:"${geneName}"},
                                async: true,
                                success: function (data) {
                                    rememberCallBack(data, parameter);
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
    assessOneSignalsSignificance: assessOneSignalsSignificance,
    updateSignificantVariantDisplay:updateSignificantVariantDisplay,
    displayInterestingPhenotypes:displayInterestingPhenotypes,
    updateDisplayBasedOnSignificanceLevel: updateDisplayBasedOnSignificanceLevel,
    refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
    refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype,
    refreshTopVariants:refreshTopVariants,
    toggleOtherPhenoBtns:toggleOtherPhenoBtns,
    refreshLZ:refreshLZ,
    refreshSignalSummaryBasedOnPhenotype:refreshSignalSummaryBasedOnPhenotype
}
}());


})();

$( document ).ready(function() {
   mpgSoftware.geneSignalSummary.refreshTopVariants(mpgSoftware.geneSignalSummary.displayInterestingPhenotypes);
});


</script>

