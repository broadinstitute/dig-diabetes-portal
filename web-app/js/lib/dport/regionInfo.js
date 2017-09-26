var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var assayExtremes = {"1":{minimum:127,maximum:9213115},
            "2":{minimum:83,maximum:854238}};
        var numberOfQuantiles =5;

        var developingTissueGrid = {};
        var sampleGroupsWithCredibleSetNames = [];
        var getDevelopingTissueGrid = function (){
            return developingTissueGrid;
        };
        var setDevelopingTissueGrid = function (myDevelopingTissueGrid){
            developingTissueGrid = myDevelopingTissueGrid;
        };
        var getSampleGroupsWithCredibleSetNames = function (){
            return sampleGroupsWithCredibleSetNames;
        };
        var setSampleGroupsWithCredibleSetNames = function (mySampleGroupsWithCredibleSetNames){
            sampleGroupsWithCredibleSetNames = mySampleGroupsWithCredibleSetNames;
        };


        var getCurrentSequenceExtents = function (){
            return {start: parseInt($('input.credSetStartPos').val()),
                    end:parseInt($('input.credSetEndPos').val())};
        }

        var buildRenderData = function (data,additionalParameters){
            var renderData = {  variants: [],
                                const:{
                                    coding:[],
                                    spliceSite:[],
                                    utr:[],
                                    promoter:[],
                                    CTCFmotif:[],
                                    posteriorProbability: [],
                                    pValue: []
                                },
                                cellTypeSpecs: [
                                ]};
            if (typeof data !== 'undefined'){
                var allVariants = _.flatten([{}, data.variants]);
                var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                _.forEach(flattendVariants.sort(function (a, b) {return a.POS - b.POS;}), function (v){
                    var posteriorProbability = "";
                    _.forEach(v.POSTERIOR_PROBABILITY, function (ppvalue){
                        _.forEach(ppvalue,function (phenotype){
                            posteriorProbability=phenotype;
                        })
                    });
                    v['extractedPOSTERIOR_PROBABILITY'] = posteriorProbability;
                    var credibleSetId = "";
                    _.forEach(v.CREDIBLE_SET_ID, function (csvalue){
                        _.forEach(csvalue,function (phenotype){
                            credibleSetId=phenotype;
                        })
                    });
                    v['extractedCREDIBLE_SET_ID'] = credibleSetId;
                    var pValue = "";
                    _.forEach(v.P_VALUE, function (csvalue){
                        _.forEach(csvalue,function (phenotype){
                            pValue=phenotype;
                        })
                    });
                    v['extractedP_VALUE'] = pValue;

                    if ((typeof v.extractedPOSTERIOR_PROBABILITY !== 'undefined')&&
                        ($.isNumeric(v.extractedPOSTERIOR_PROBABILITY))){
                        renderData.const.posteriorProbability.push({val:UTILS.realNumberFormatter(v.extractedPOSTERIOR_PROBABILITY)});
                    }
                    if ((typeof v.extractedP_VALUE !== 'undefined')&&
                        ($.isNumeric(v.extractedP_VALUE))) {
                        renderData.const.pValue.push({val:UTILS.realNumberFormatter(v.extractedP_VALUE)});
                    }
                    renderData.const.pValue.push();
                    if (typeof v.VAR_ID !== 'undefined') {
                        renderData.variants.push({name:v.VAR_ID, details:v, assayIdList: additionalParameters.assayIdList});
                    }
                    if (typeof v.MOST_DEL_SCORE !== 'undefined') {
                        if ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4)){
                            renderData.const.coding.push({val:'',descr:'present'});
                        } else {
                            renderData.const.coding.push({val:'',descr:'absent'});
                        }
                    }
                    if (typeof v.Consequence !== 'undefined'){
                        if (v.Consequence.indexOf('splice')>-1){
                            renderData.const.spliceSite.push({val:'',descr:'present'});
                        } else {
                            renderData.const.spliceSite.push({val:'',descr:'absent'});
                        }
                        if (v.Consequence.indexOf('UTR')>-1){
                            renderData.const.utr.push({val:'',descr:'present'});
                        } else {
                            renderData.const.utr.push({val:'',descr:'absent'});
                        }
                        if (v.Consequence.indexOf('promoter')>-1){
                            renderData.const.promoter.push({val:'',descr:'present'});
                        } else {
                            renderData.const.promoter.push({val:'',descr:'absent'});
                        }
                        renderData.const.CTCFmotif.push({val:'',descr:'absent'});
                    }
                });
            }

            return renderData;
        };

        var filterRenderData = function (oldRenderData,assayIdList,variantsToInclude){
            var newRenderData = {  variants: [],
                const:{
                    coding:[],
                    spliceSite:[],
                    utr:[],
                    promoter:[],
                    CTCFmotif:[],
                    posteriorProbability: [],
                    pValue: []
                },
                cellTypeSpecs: [
                ]
            };
            var arrayOfIndexesToInclude = [];
            if (variantsToInclude === 'ALL'){
                _.forEach(oldRenderData.variants,function(v,i){
                    arrayOfIndexesToInclude.push(i)
                });
            } else { //
                var extractedVariantIds = _.map(oldRenderData.variants,function(v){return v.name;});
                _.forEach(variantsToInclude,function(varId){
                    arrayOfIndexesToInclude.push(extractedVariantIds.indexOf(varId))
                });
            }



            _.forEach(arrayOfIndexesToInclude, function (i){


                newRenderData.variants.push(oldRenderData.variants[i]);
                newRenderData.const.coding.push(oldRenderData.const.coding[i]);
                newRenderData.const.spliceSite.push(oldRenderData.const.spliceSite[i]);
                newRenderData.const.utr.push(oldRenderData.const.utr[i]);
                newRenderData.const.promoter.push(oldRenderData.const.promoter[i]);
                newRenderData.const.CTCFmotif.push(oldRenderData.const.CTCFmotif[i]);
                newRenderData.const.posteriorProbability.push(oldRenderData.const.posteriorProbability[i]);
                newRenderData.const.pValue.push(oldRenderData.const.pValue[i]);

             });

            return newRenderData;
        };




        var oneCallbackForEachVariant = function(variants,
                                                 additionalData,
                                                 includeRecord,
                                                 assayIdList){
            var promiseArray = [];
            _.forEach(variants,function (variant){
                var args = _.flatten([{}, variant]);
                var variantObject = _.merge.apply(_, args);
                promiseArray.push(
                    $.ajax({
                    cache: false,
                    type: "post",
                    url: additionalData.retrieveFunctionalDataAjaxUrl,
                    data: {
                        chromosome: variantObject.CHROM,
                        startPos: ""+variantObject.POS,
                        endPos: ""+variantObject.POS,
                        lzFormat:0,
                        assayIdList:""+additionalData.assayIdList
                    },
                    async: true
                    }).done(function (data, textStatus, jqXHR) {
                        var tissueGrid = getDevelopingTissueGrid();
                        if ((typeof data !== 'undefined') &&
                            (typeof data.variants !== 'undefined') &&
                            (typeof data.variants.region_start !== 'undefined')&&
                            (typeof data.variants.variants !== 'undefined')) {
                            _.forEach(data.variants.variants, function (record){
                                if (includeRecord(record)){
                                    if(typeof tissueGrid[record.source_trans] === 'undefined') {
                                        tissueGrid[record.source_trans] = {};
                                    }
                                    var tissueRow = tissueGrid[record.source_trans];
                                    if(typeof tissueRow[''+data.variants.region_start] === 'undefined') {
                                        tissueRow[''+data.variants.region_start] = record;
                                    }
                                }
                            });
                        }

                    }).fail(function (jqXHR, textStatus, errorThrown) {
                        loading.hide();
                        core.errorReporter(jqXHR, errorThrown)
                    })
                );


            });
            return promiseArray;
        }


        var specificCredibleSetSpecificDisplay = function(currentButton,variantsToInclude){

            $('.credibleSetChooserButton').removeClass('active');
            $('.credibleSetChooserButton').addClass('inactive');
            $(currentButton).removeClass('inactive');
            $(currentButton).addClass('active');
            var allRenderData = $.data($('#dataHolderForCredibleSets')[0],'allRenderData');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var filteredRenderData = filterRenderData(allRenderData,assayIdList,variantsToInclude);
            buildTheCredibleSetHeatMap(filteredRenderData,false);


            // var tissueGrid = $.data($('#dataHolderForCredibleSets')[0],'tissueGrid');
            // var dataVariants = $.data($('#dataHolderForCredibleSets')[0],'dataVariants');
            // var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            // var filteredDataVariants = _.filter(dataVariants,function(v){return ($.inArray(v[0].VAR_ID,variants)>-1)})
            // displayAParticularCredibleSet(tissueGrid, filteredDataVariants, assayIdList );

        };
        var determineColorIndex = function (val,quantileArray){
            var index = 0;
            while (index<quantileArray.length&& val>=quantileArray[index].min){index++};
            return index-1;
        };
        var determineCategoricalColorIndex = function (elementName){
            var returnVal = 5;
            if (typeof elementName !== 'undefined'){
                if (elementName.indexOf("Active_enhancer_2")>-1){
                    returnVal = 4;
                } else if (elementName.indexOf("Active_enhancer_1")>-1){
                    returnVal = 3;
                } else if (elementName.indexOf("Genic_enhancer")>-1){
                    returnVal = 2;
                } else if (elementName.indexOf("Weak_enhancer")>-1){
                    returnVal = 1;
                }
            }
            return returnVal;
        }

        var writeOneLineOfTheHeatMap = function(tissueGrid,tissueKey,quantileArray,variantRec){
            var lineToAdd ="";
            if ((typeof variantRec !== 'undefined')&&
                (typeof variantRec.details !== 'undefined')&&
                (typeof variantRec.details.POS !== 'undefined')){
                var positionString = ""+variantRec.details.POS;
                var record = tissueGrid[tissueKey][positionString];
                var worthIncluding = false;
                if ((typeof record !== 'undefined') && (typeof record.source_trans !== 'undefined') && (record.source_trans !== null)){
                    var elementName = record.source_trans;
                    if (record.ASSAY_ID === 3){
                        lineToAdd = ("<td class='tissueTable matchingRegion"+record.ASSAY_ID + "_"+determineCategoricalColorIndex(record.element)+" "+
                            elementName+"' data-toggle='tooltip' title='chromosome:"+ record.CHROM +
                            ", position:"+ positionString +", tissue:"+ record.source_trans +"'></td>");
                    } else {
                        lineToAdd = ("<td class='tissueTable matchingRegion"+record.ASSAY_ID + "_" +determineColorIndex(record.VALUE,quantileArray)+" "+
                            elementName+"' data-toggle='tooltip' title='chromosome:"+ record.CHROM +
                            ", position:"+ positionString +", tissue:"+ record.source_trans +"'></td>");
                    }
                } else {
                    lineToAdd = ("<td class='tissueTable "+elementName+"'></td>");

                }
            }
            return lineToAdd;
        };

        var createQuantilesArray = function(everySingleValue){
            var everySingleValueSorted = everySingleValue.sort(function(a,b){return a-b});
            var maximumValue = everySingleValueSorted[everySingleValueSorted.length-1];
            var minimumValue = everySingleValueSorted[0];
            var quantileArray = [];
            var widthOfOneQuintile = (maximumValue-minimumValue)/numberOfQuantiles;
            for ( var i = 0 ; i < numberOfQuantiles ; i++ ){
                quantileArray.push({min:minimumValue+(widthOfOneQuintile*i),max:minimumValue+(widthOfOneQuintile*(i+1))});
            }
            return quantileArray;
        };
        // this next routine only makes sense if we have already gone through and calculated the maximum and minimum over the entire set of available values
        var createStaticQuantileArray = function( assayId ){
            var quantileArray = [];
            if ((assayId) &&
                (typeof assayExtremes[""+assayId] !== 'undefined') ){
                var maximumValue = assayExtremes[""+assayId].maximum;
                var minimumValue = assayExtremes[""+assayId].minimum;
                var widthOfOneQuintile = (maximumValue-minimumValue)/numberOfQuantiles;
                for ( var i = 0 ; i < numberOfQuantiles ; i++ ){
                    quantileArray.push({min:minimumValue+(widthOfOneQuintile*i),max:minimumValue+(widthOfOneQuintile*(i+1))});
                }
            }
            return quantileArray;
        }
        var filterTissueGrid = function(incomingTissueGrid,assayId){
            var retVal = {};
            _.forEach(Object.keys(incomingTissueGrid),function(tissueKey){
                var variantsToKeep = {};
                _.forEach(Object.keys(incomingTissueGrid[tissueKey]),function(variantPos){
                    var variantRecord = incomingTissueGrid[tissueKey][variantPos];
                    if (variantRecord.ASSAY_ID===assayId){
                        variantsToKeep[variantPos]=variantRecord;
                    }
                });
                if (Object.keys(variantsToKeep).length>0){
                    retVal[tissueKey] = variantsToKeep;
                }
            });
            return retVal;
        };
        var extractValuesForTissueDisplay = function (tissueGrid){
            var sortableTissueArray = [];
            _.forEach(Object.keys(tissueGrid),function(tissueKey){
                sortableTissueArray.push(tissueGrid[tissueKey]);
            });
            var everySingleValue = [];
            var assayId = 0; // we require that there be no more than one assay ID and the entire array
            var sortedArrayOfArrays = _.sortBy(sortableTissueArray, function(objArray){
                var bestVariantPerTissue = _.sortBy(objArray, function(singleVariant){
                    var oneValue = singleVariant.VALUE;
                    assayId = singleVariant.ASSAY_ID;
                    everySingleValue.push(oneValue);
                    return oneValue;
                })[0];
                return bestVariantPerTissue.VALUE
            });
            return {
                sortedTissues: _.map(sortedArrayOfArrays, function(oneRec){return oneRec[Object.keys(oneRec)[0]].source_trans}),
               // quantileArray: createStaticQuantileArray(assayId)
                quantileArray: createQuantilesArray(everySingleValue)
            };
        };
        var buildTheCredibleSetHeatMap = function (drivingVariables,setDefaultButton){
            $(".credibleSetTableGoesHere").empty().append(
                Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
            );
          //  mpgSoftware.geneSignalSummaryMethods.updateCredibleSetTable(data, additionalParameters);
            var additionalParameters = $.data($('#dataHolderForCredibleSets')[0],'additionalParameters');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var allDataVariants = $.data($('#dataHolderForCredibleSets')[0],'dataVariants',allDataVariants);
            var includeRecord  = function() {return true;};
            if (assayIdList=='[3]') {
                includeRecord = function(o) {return ((o.element.indexOf('nhancer')>-1))};
            }
            setDevelopingTissueGrid({});
            var promises = oneCallbackForEachVariant(allDataVariants,additionalParameters,includeRecord);

            $.when.apply($, promises).then(function(schemas) {
                var tissueGrid = getDevelopingTissueGrid();
                $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid);


                displayAParticularCredibleSet(tissueGrid, drivingVariables.variants, assayIdList,setDefaultButton );

            }, function(e) {
                console.log("My ajax failed");
            });
            $('.credibleSetTableGoesHere td.tissueTable').popover({
                html : true,
                title: function() {
                    //return $(this).parent().find('.head').html();
                    console.log('title');
                    return "foo";
                },
                content: function() {
                    //return $(this).parent().find('.content').html();
                    return "fii";
                },
                container: 'body',
                placement: 'bottom',
                trigger: 'hover'
            });
            $('.credibleSetTableGoesHere th.niceHeaders').popover({
                html : true,
                title: function() {
                    var var_id = $(this).attr('chrom')+":"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"/"+$(this).attr('defeffa');
                    return var_id;
                },
                content: function() {
                    var retString = "<div class='credSetLine'><scan class='credSetPopUpTitle'>Posterior probability:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('postprob')+"</scan></div>"+
                        "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan></div>"+
                        "<div class='credSetLine'><a onclick='mpgSoftware.locusZoom.replaceTissuesWithOverlappingEnhancersFromVarId(\""+
                        $(this).attr('chrom')+"_"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"_"+$(this).attr('defeffa')+"\",\"dom\",\""+assayIdList+"\")' href='#'>"+
                        "Tissues with overlapping enhancer regions</a></div>";
                    if (additionalParameters.portalTypeString==='ibd'){
                        retString = "<div class='credSetLine'><scan class='credSetPopUpTitle'>Posterior probability:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('postprob')+"</scan></div>"+
                            "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan></div>"+
                            "<div class='credSetLine'><scan class='credSetPopUpTitle'>Click to see overlapping DNase active regions</scan></div>";
                    }
                    return retString;
                },
                container: 'body',
                placement: 'top',
                trigger: 'hover'
            });
        };

        var displayAParticularCredibleSet = function(tissueGrid, dataVariants, assayIdList, setDefaultButton ){

            $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid)
            // In some cases we may have one primary tissue grid that drives the display, and a subsidiary tissue grid that is displayed only if
            // the primary tissue is displayed
            var primaryTissueGrid = {};
            var subsidiaryTissueGrid = {};
            if (assayIdList==='[3]'){
                primaryTissueGrid = tissueGrid;
            } else {
                primaryTissueGrid = filterTissueGrid(tissueGrid,2); // DNase drives
                subsidiaryTissueGrid = filterTissueGrid(tissueGrid,1);
            }

            var primaryTissueObject = extractValuesForTissueDisplay(primaryTissueGrid);
            // we only need to consider the subsidiary tissues that match a primary tissue
            var subsidiaryTissueObject = extractValuesForTissueDisplay(_.filter(subsidiaryTissueGrid,function(v,k){return typeof primaryTissueGrid[k]!=='undefined' }));


            // var allVariants = _.flatten([{}, dataVariants]);
            // var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
            // var sortedVariants = flattendVariants.sort(function (a, b) {return a.POS - b.POS;});
            var sortedVariants = dataVariants;
            _.forEach(primaryTissueObject.sortedTissues,function(tissueKey){
                var lineToAdd = "<tr><td></td><td>"+tissueKey+"</td>";
                _.forEach(sortedVariants,function(variantRec){
                    lineToAdd+=writeOneLineOfTheHeatMap(primaryTissueGrid,tissueKey,primaryTissueObject.quantileArray,variantRec)
                });
                lineToAdd += '</tr>';
                var drivingTissueRecordExists = false;
                if (lineToAdd.indexOf('matchingRegion')>-1){
                    $('.credibleSetTableGoesHere tr:last').parent().append(lineToAdd);
                    drivingTissueRecordExists = true;
                }


                // do we want to add a follow up lines?
                if (drivingTissueRecordExists&&(Object.keys(subsidiaryTissueGrid).length>0)){
                    if (typeof subsidiaryTissueGrid[tissueKey] !== 'undefined') {
                        var lineToAdd = "<tr><td></td><td></td>";
                        _.forEach(sortedVariants,function(variantRec){
                            lineToAdd+=writeOneLineOfTheHeatMap(subsidiaryTissueGrid,tissueKey,subsidiaryTissueObject.quantileArray,variantRec)
                        });
                        lineToAdd += '</tr>';
                        $('.credibleSetTableGoesHere tr:last').parent().append(lineToAdd);
                    }
                }


            });
            $.data($('#dataHolderForCredibleSets')[0],'sortedVariants',sortedVariants);
            if (setDefaultButton){
                if ($('.credibleSetChooserButton').length > 1){
                    $($('.credibleSetChooserButton')[0]).click();
                }
            }


        };

        var fillRegionInfoTable = function(vars,additionalParameters) {
            var currentSequenceExtents = getCurrentSequenceExtents();
            vars.start = currentSequenceExtents.start;
            vars.end = currentSequenceExtents.end;
            var promise = $.ajax({
                cache: false,
                type: "post",
                url: vars.fillCredibleSetTableUrl,
                data: vars,
                async: true
            });
            promise.done(
                function (data) {


                    var extractAllCredibleSetNames = function (drivingVariables){
                        var returnValues = [];
                        _.forEach(drivingVariables.variants, function (drivingVariable){
                            var previouslyEstablishedCredibleSetRecord = _.find(returnValues,function (oneCredibleSetRecord) {
                                return (oneCredibleSetRecord.credibleSetId===drivingVariable.details.extractedCREDIBLE_SET_ID);
                            })
                            if (previouslyEstablishedCredibleSetRecord === undefined){
                                var newCredibleSetRecord = {  credibleSetId:drivingVariable.details.extractedCREDIBLE_SET_ID,
                                                                            variantsInCredibleSet: [],
                                                                renderVariantsAsArray:function(){
                                    return "["+_.map(this.variantsInCredibleSet,function(variantId){
                                        return "\""+variantId+"\"";
                                    })+"]";}
                                };
                                returnValues.push(newCredibleSetRecord);
                                previouslyEstablishedCredibleSetRecord = newCredibleSetRecord;
                            }
                            previouslyEstablishedCredibleSetRecord.variantsInCredibleSet.push(drivingVariable.details.VAR_ID);
                        });
                        return returnValues;
                    }



                    //var assayIdList = $("select.variantIntersectionChoiceSelect").find(":selected").val();
                    var assayIdList = additionalParameters.assayIdList;

                    var drivingVariables = buildRenderData(data,additionalParameters);
                    var allCredibleSets = extractAllCredibleSetNames (drivingVariables);
                    if (Object.keys(allCredibleSets).length > 1){
                        $(".credibleSetChooserGoesHere").empty().append(
                            Mustache.render( $('#organizeCredibleSetChooserTemplate')[0].innerHTML,{allCredibleSets:allCredibleSets,
                                                                                                    atLeastOneCredibleSetExists: function(){
                                var credibleSetPresenceIndicator = [];
                                if (Object.keys(allCredibleSets).length > 1) {credibleSetPresenceIndicator.push(1)}
                                return credibleSetPresenceIndicator;
                            }})
                        );

                    }
                    $.data($('#dataHolderForCredibleSets')[0],'allRenderData',drivingVariables);
                    $.data($('#dataHolderForCredibleSets')[0],'assayIdList',assayIdList);
                    $.data($('#dataHolderForCredibleSets')[0],'additionalParameters',additionalParameters);
                    $.data($('#dataHolderForCredibleSets')[0],'dataVariants',data.variants);
                    buildTheCredibleSetHeatMap(drivingVariables,true);
                    // if (Object.keys(allCredibleSets).length > 1){
                    //     $($('.credibleSetChooserButton')[0]).click();
                    // }
                    $('#toggleVarianceTableLink').click();
                }
            );
            promise.fail(function( jqXHR, textStatus, errorThrown ) {
                console.log('error');
            });

        }

        return {
            fillRegionInfoTable: fillRegionInfoTable,
            specificCredibleSetSpecificDisplay: specificCredibleSetSpecificDisplay,
            getCurrentSequenceExtents:getCurrentSequenceExtents,
            setSampleGroupsWithCredibleSetNames:setSampleGroupsWithCredibleSetNames,
            getSampleGroupsWithCredibleSetNames:getSampleGroupsWithCredibleSetNames
        }

    })();



})();
