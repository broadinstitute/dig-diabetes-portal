var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var developingTissueGrid = {};
        var getDevelopingTissueGrid = function (){
            return developingTissueGrid;
        };
        var setDevelopingTissueGrid = function (myDevelopingTissueGrid){
            developingTissueGrid = myDevelopingTissueGrid;
        };

        var buildRenderData = function (data,additionalParameters){
            var renderData = {  variants: [],
                                const:{
                                    coding:[],
                                    spliceSite:[],
                                    utr:[],
                                    promoter:[],
                                    CTCFmotif:[]
                                },
                                cellTypeSpecs: [
                                    // {name:'Aorta',
                                    // DHS:[],
                                    // K27:[]}
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

        var fillRegionInfoTable = function(vars,additionalParameters) {

            var promise = $.ajax({
                cache: false,
                type: "post",
                url: vars.fillCredibleSetTableUrl,
                data: vars,
                async: true
            });
            promise.done(
                function (data) {
                    var createQuantilesArray = function(everySingleValue){
                        var everySingleValueSorted = everySingleValue.sort(function(a,b){return a-b});
                        var maximumValue = everySingleValueSorted[everySingleValueSorted.length-1];
                        var minimumValue = everySingleValueSorted[0];
                        var quantileArray = [];
                        var numberOfQuantiles =5;
                        var widthOfOneQuintile = (maximumValue-minimumValue)/numberOfQuantiles;
                        for ( var i = 0 ; i < numberOfQuantiles ; i++ ){
                            quantileArray.push({min:minimumValue+(widthOfOneQuintile*i),max:minimumValue+(widthOfOneQuintile*(i+1))});
                        }
                        return quantileArray;
                    }
                    var determineColorIndex = function (val,quantileArray){
                        var index = 0;
                        while (index<quantileArray.length&& val>quantileArray[index].min){index++};
                        return index;
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
                            } else if (elementName.indexOf("Weak_TSS")>-1){
                                returnVal = 1;
                            } else if (elementName.indexOf("Active_TSS")>-1){
                                returnVal = 0;
                            }
                        }
                        return returnVal;
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
                    }
                    var writeOneLineOfTheHeatMap = function(tissueGrid,tissueKey,quantileArray,variantRec){
                        var lineToAdd ="";
                        if (typeof variantRec.POS !== 'undefined'){
                            var positionString = ""+variantRec.POS;
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
                    var extractValuesForTissueDisplay = function (tissueGrid){
                        var sortableTissueArray = [];
                        _.forEach(Object.keys(tissueGrid),function(tissueKey){
                            sortableTissueArray.push(tissueGrid[tissueKey]);
                        });
                        var everySingleValue = [];
                        var sortedArrayOfArrays = _.sortBy(sortableTissueArray, function(objArray){
                            var bestVariantPerTissue = _.sortBy(objArray, function(singleVariant){
                                var oneValue = singleVariant.VALUE;
                                everySingleValue.push(oneValue);
                                return oneValue;
                            })[0];
                            return bestVariantPerTissue.VALUE
                        });
                        return {
                            sortedTissues: _.map(sortedArrayOfArrays, function(oneRec){return oneRec[Object.keys(oneRec)[0]].source_trans}),
                            quantileArray: createQuantilesArray(everySingleValue)
                        };


                    };
                    var extractAllCredibleSetNames = function (drivingVariables){
                        var returnValues = [];
                        _.forEach(drivingVariables.variants, function (drivingVariable){
                            var previouslyEstablishedCredibleSetRecord = _.find(returnValues,function (oneCredibleSetRecord) {
                                return (oneCredibleSetRecord.credibleSetId===drivingVariable.details.extractedCREDIBLE_SET_ID);
                            })
                            if (previouslyEstablishedCredibleSetRecord === undefined){
                                var newCredibleSetRecord = {  credibleSetId:drivingVariable.details.extractedCREDIBLE_SET_ID,
                                                                            variantsInCredibleSet: []  };
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
                    //return;
                    $(".credibleSetTableGoesHere").empty().append(
                        Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
                    );
                    mpgSoftware.geneSignalSummaryMethods.updateCredibleSetTable(data, additionalParameters);
                    var includeRecord  = function() {return true;};
                    if (assayIdList=='[3]') {
                        includeRecord = function(o) {return ((o.element.indexOf('nhancer')>-1)||(o.element.indexOf('TSS')>-1))};
                    }
                    var promises = oneCallbackForEachVariant(data.variants,additionalParameters,includeRecord);

                    $.when.apply($, promises).then(function(schemas) {
                        console.log("DONE with "+getDevelopingTissueGrid(), this, schemas);
                        var tissueGrid = getDevelopingTissueGrid();
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


                        var allVariants = _.flatten([{}, data.variants]);
                        var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                        var sortedVariants = flattendVariants.sort(function (a, b) {return a.POS - b.POS;});

                        _.forEach(primaryTissueObject.sortedTissues,function(tissueKey){
                            var lineToAdd = "<tr><td></td><td>"+tissueKey+"</td>";
                            _.forEach(sortedVariants,function(variantRec){
                                    lineToAdd+=writeOneLineOfTheHeatMap(primaryTissueGrid,tissueKey,primaryTissueObject.quantileArray,variantRec)
                            });
                            lineToAdd += '</tr>';
                            $('.credibleSetTableGoesHere tr:last').parent().append(lineToAdd);

                            // do we want to add a follow up lines?
                            if (Object.keys(subsidiaryTissueGrid).length>0){
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

                        setDevelopingTissueGrid({});
                    }, function(e) {
                        console.log("My ajax failed");
                    });
                    $('#toggleVarianceTableLink').click();
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
                }
            );
            promise.fail(function( jqXHR, textStatus, errorThrown ) {
                console.log('error');
            });

        }

        return { fillRegionInfoTable: fillRegionInfoTable}

    })();



})();
