var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var assayExtremes = {"1":{minimum:127,maximum:9213115},
            "2":{minimum:83,maximum:854238}};
        var numberOfQuantiles =4;
        var precalculatedQuantileBoundaries = {
            "0":[0,0,0,0,0], // provide a default in case no tissues are chosen
            "1":[0,167.9,888.4,2649.9,9213115], // h3ks2ac
            "2":[0,207.8,389.6,1248.1,854238], // dnase
            "3":[0,0,0,0,0], // parker -- not sorted by value
            "4":[0,0,0,0,0]  // varshney -- not sorted by value
        }
        var DEFAULT_NUMBER_OF_VARIANTS = 10;
        var defaultTissueRegionOverlapMatcher = {'t2d':["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
            'stroke':["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
            'mi':["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
            'epilepsy':["8_Genic_enhancer","9_Active_enhancer_1","10_Active_enhancer_2","11_Weak_enhancer"],
            'ibd':["DNase"]};

        /***
         *  Choose from among all the tissues we get back from a regions search based on the user's display criteria
         * @param o
         * @returns {boolean}
         */
        var includeRecordBasedOnUserChoice = function(o) {
            console.log("not properly initialized");
            return true;
        };
        var developingTissueGrid = {};
        var sampleGroupsWithCredibleSetNames = [];
        var getSelectedValuesAndText = function() {
            var selectedElements = $('#credSetSelectorChoice option:selected');
            var selectedValuesAndText = [];
            _.forEach(selectedElements,function(oe){
                selectedValuesAndText.push({name:$(oe).val(),text:$(oe).text()});
            });
            return selectedValuesAndText;
        };
        var getDisplayValuesAndText = function() {
            var selectedElements = $('#credSetDisplayChoice option:selected');
            var selectedValuesAndText = [];
            _.forEach(selectedElements,function(oe){
                selectedValuesAndText.push({name:$(oe).val(),text:$(oe).text()});
            });
            return selectedValuesAndText;
        };
        var convertUserChoicesIntoAssayIds = function(selectedValuesAndText) {;
            var assayIds = [];
            _.forEach(selectedValuesAndText,function(oe){
                if (oe.name==='H3K27ac'){
                    assayIds.push(1);
                } else if (oe.name==='DNase'){
                    assayIds.push(2);
                } else {
                    if (!assayIds.includes(3)){
                        assayIds.push(3);
                    }
                }
            });
            return assayIds;
        };
        var getSelectorAssayIds = function() {
            return convertUserChoicesIntoAssayIds(getSelectedValuesAndText());
        };
        var getDisplayAssayIds = function() {
            return convertUserChoicesIntoAssayIds(getDisplayValuesAndText());
        };
        var getDefaultTissueRegionOverlapMatcher = function (portalType){
            return defaultTissueRegionOverlapMatcher[portalType];
        };
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
                                credibleSetInfoCode:data.credibleSetInfoCode,
                                const:{
                                    coding:[],
                                    spliceSite:[],
                                    utr:[],
                                    promoter:[],
                                    CTCFmotif:[],
                                    posteriorProbability: [],
                                    tfBindingMotif: [],
                                    posteriorProbabilityExists: function(){
                                        var posteriorProbabilityIndicator = [];
                                        if (Object.keys(this.posteriorProbability).length > 0) {posteriorProbabilityIndicator.push(1)}
                                        return posteriorProbabilityIndicator;
                                    },
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

                    if (typeof v.extractedPOSTERIOR_PROBABILITY !== 'undefined'){
                        if ($.isNumeric(v.extractedPOSTERIOR_PROBABILITY)) {
                            renderData.const.posteriorProbability.push({val:UTILS.realNumberFormatter(v.extractedPOSTERIOR_PROBABILITY)});
                        }
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
                    if (typeof v.MOTIF_NAME !== 'undefined') {
                        if (v.MOTIF_NAME === null) {
                            renderData.const.tfBindingMotif.push({val:'',descr:'absent'});
                        } else {
                            renderData.const.tfBindingMotif.push({val:v.MOTIF_NAME,descr:'present'});
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
                    tfBindingMotif:[],
                    posteriorProbability: [],
                    posteriorProbabilityExists: function(){
                        var posteriorProbabilityIndicator = [];
                        if (Object.keys(this.posteriorProbability).length > 0) {posteriorProbabilityIndicator.push(1)}
                        return posteriorProbabilityIndicator;
                    },                    pValue: []
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
                    var convertedVarId = mpgSoftware.locusZoom.convertVarIdToBroadFavoredForm(varId);
                    var indexToPick = extractedVariantIds.indexOf(convertedVarId);
                    if (indexToPick>-1){
                        arrayOfIndexesToInclude.push(extractedVariantIds.indexOf(convertedVarId));
                    }
                });
            }



            _.forEach(arrayOfIndexesToInclude, function (i){


                newRenderData.variants.push(oldRenderData.variants[i]);
                newRenderData.const.coding.push(oldRenderData.const.coding[i]);
                newRenderData.const.spliceSite.push(oldRenderData.const.spliceSite[i]);
                newRenderData.const.utr.push(oldRenderData.const.utr[i]);
                newRenderData.const.promoter.push(oldRenderData.const.promoter[i]);
                if (typeof oldRenderData.const.tfBindingMotif[i]!=='undefined') {// sometimes we don't have these
                    newRenderData.const.tfBindingMotif.push(oldRenderData.const.tfBindingMotif[i]);
                }
                newRenderData.const.CTCFmotif.push(oldRenderData.const.CTCFmotif[i]);
                if (typeof oldRenderData.const.posteriorProbability[i]!=='undefined'){// sometimes we don't have these
                    newRenderData.const.posteriorProbability.push(oldRenderData.const.posteriorProbability[i]);
                }
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
                        assayIdList:""+assayIdList
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

        var redisplayTheCredibleSetHeatMap = function(){
            var variantsToInclude =[];
            var headers = $('#overlapTable th');
            _.forEach(headers,function(o){
                var varid = $(o).attr('varid');
                if (typeof varid  !== 'undefined'){
                    variantsToInclude.push(varid);
                }
            })
            var allRenderData = $.data($('#dataHolderForCredibleSets')[0],'allRenderData');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            //if (assayIdList==='[1,2]') { assayIdList = '[1,2,3]' }
            $.data($('#dataHolderForCredibleSets')[0],'assayIdList',assayIdList);
            var filteredRenderData = filterRenderData(allRenderData,assayIdList,variantsToInclude);
            buildTheCredibleSetHeatMap(filteredRenderData,false);
        }


        var specificHeaderToBeActiveByVarId = function(varId){
            $('th.headersWithVarIds').removeClass('active');
            $("th.headersWithVarIds:contains('"+varId+"')").addClass('active')
        };

        var specificCredibleSetSpecificDisplay = function(currentButton,variantsToInclude){
            $('.credibleSetChooserButton').removeAttr('onclick'); // we will put this function back when the processing is complete
            $('.credibleSetChooserButton').removeClass('active');
            $('.credibleSetChooserButton').addClass('inactive');
            $(currentButton).removeClass('inactive');
            $(currentButton).addClass('active');
            var allRenderData = $.data($('#dataHolderForCredibleSets')[0],'allRenderData');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var filteredRenderData = filterRenderData(allRenderData,assayIdList,variantsToInclude);
            buildTheCredibleSetHeatMap(filteredRenderData,false);
        };
        var determineColorIndex = function (val,quantileArray){
            var index = 0;
            while (index<quantileArray.length&& val>=quantileArray[index].min){index++};
            return index-1;
        };
        var determineCategoricalColorIndex = function (elementName){
            var returnVal = 5;
            if (typeof elementName !== 'undefined'){
                if (elementName.indexOf("Active_TSS")>-1){
                    returnVal = 1;
                } else if (elementName.indexOf("Weak_TSS")>-1){
                    returnVal = 2;
                } else if (elementName.indexOf("Flanking_TSS")>-1){
                    returnVal = 3;
                } else if (elementName.indexOf("Strong_transcription")>-1){
                    returnVal = 5;
                } else if (elementName.indexOf("Weak_transcription")>-1){
                    returnVal = 6;
                } else if (elementName.indexOf("Genic_enhancer")>-1){
                    returnVal = 8;
                }else if (elementName.indexOf("Active_enhancer")>-1){
                    returnVal = 9;
                } else if (elementName.indexOf("Weak_enhancer")>-1){
                    returnVal = 11;
                }else if (elementName.indexOf("Bivalent/poised_TSS")>-1){
                    returnVal = 14;
                } else if (elementName.indexOf("Repressed_polycomb")>-1){
                    returnVal = 16;
                }else if (elementName.indexOf("Weak_repressed_polycomb")>-1){
                    returnVal = 17;
                } else if (elementName.indexOf("Quiescent/low_signal")>-1){
                    returnVal = 18;
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
                    quantileArray = createQuantilesArray(record.ASSAY_ID);
                    var elementName = record.source_trans;
                    if (record.ASSAY_ID === 3){
                        lineToAdd = ("<td class='tissueTable matchingRegion"+record.ASSAY_ID + "_"+determineCategoricalColorIndex(record.element)+" "+
                            elementName+"' data-toggle='tooltip' title='chromosome:"+ record.CHROM +
                            ", position:"+ positionString +", tissue:"+ record.source_trans +"'></td>");
                    } else {
                        lineToAdd = ("<td class='tissueTable matchingRegion"+record.ASSAY_ID + "_" +determineColorIndex(record.VALUE,quantileArray)+" "+
                            elementName+"' data-toggle='tooltip' title='chromosome:"+ record.CHROM +
                            ", position:"+ positionString +", tissue:"+ record.source_trans +", value:"+ UTILS.realNumberFormatter(record.VALUE) +"'></td>");
                    }
                } else {
                    lineToAdd = ("<td class='tissueTable "+elementName+"'></td>");

                }
            }
            return lineToAdd;
        };

        var createQuantilesArray = function(assayId){
            var boundariesForThisAssay = precalculatedQuantileBoundaries[assayId];
            var quantileArray = [];
            for ( var i = 0 ; i < numberOfQuantiles ; i++ ){
                quantileArray.push({min:boundariesForThisAssay[i],max:boundariesForThisAssay[i+1]});
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
        var filterTissueGrid = function(incomingTissueGrid,assayIdArray){
            var retVal = {};
            // convert assay id into a real array
            _.forEach(Object.keys(incomingTissueGrid),function(tissueKey){
                var variantsToKeep = {};
                _.forEach(Object.keys(incomingTissueGrid[tissueKey]),function(variantPos){
                    var variantRecord = incomingTissueGrid[tissueKey][variantPos];
                    if (assayIdArray.includes(variantRecord.ASSAY_ID)){
                        variantsToKeep[variantPos]=variantRecord;
                    }
                });
                if (Object.keys(variantsToKeep).length>0){
                    retVal[tissueKey] = variantsToKeep;
                }
            });
            return retVal;
        };
        var filterSecondaryTissueGrid = function(incomingTissueGrid,assayIdArray,primaryTissueObject){
            var retVal = {};
            // convert assay id into a real array
            _.forEach(Object.keys(primaryTissueObject),function(primaryTissueKey){
                // to be in the primary grid you must have at least one matching variant.  Take the first one to find it's assay id
                var primaryAssayId = primaryTissueObject[primaryTissueKey][Object.keys(primaryTissueObject[primaryTissueKey])[0]].ASSAY_ID
                var weHaveDataForThatTissue = incomingTissueGrid[primaryTissueKey];
                if (typeof weHaveDataForThatTissue !== 'undefined'){
                    var variantsToKeep = {};
                    _.forEach(Object.keys(weHaveDataForThatTissue),function(variantPos){
                        var variantRecord = weHaveDataForThatTissue[variantPos];
                        if ((assayIdArray.includes(variantRecord.ASSAY_ID))&&
                            (variantRecord.ASSAY_ID!==primaryAssayId)){ // we only want s subsidiary records, which must come from a different assay
                            variantsToKeep[variantPos]=variantRecord;
                        }
                    });
                    if (Object.keys(variantsToKeep).length>0){
                        retVal[primaryTissueKey] = variantsToKeep;
                    }
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
                return  (typeof bestVariantPerTissue !== 'undefined') ? bestVariantPerTissue.VALUE : 0;
            });

            return {
                sortedTissues: _.map(sortedArrayOfArrays, function(oneRec){
                    var assString = ""
                    var rec = oneRec[Object.keys(oneRec)[0]];
                    if (typeof rec !== 'undefined') {
                        assString = rec.source_trans;
                    }
                    return assString;
                }),
               // quantileArray: createStaticQuantileArray(assayId)
                quantileArray: createQuantilesArray(assayId)
            };
        };

        var colorMapper = function(elementName){
            var colorSpecification = '#ffffff';
            if (elementName==="1_Active_TSS"){
                colorSpecification = '#ff0000';
            } else if (elementName==="2_Weak_TSS"){
                colorSpecification = '#ff8c1a';
            } else if (elementName==="3_Flanking_TSS"){
                colorSpecification = '#ff8c1a';
            } else if (elementName==="5_Strong_transcription"){
                colorSpecification = '#00e600';
            } else if (elementName==="6_Weak_transcription"){
                colorSpecification = '#006400';
            } else if (elementName==="8_Genic_enhancer"){
                colorSpecification = '#c2e105';
            } else if (elementName==="9_Active_enhancer_1"){
                colorSpecification = '#ffc34d';
            } else if (elementName==="10_Active_enhancer_2"){
                colorSpecification = '#ffc34d';
            } else if (elementName==="11_Weak_enhancer"){
                colorSpecification = '#ffff00';
            } else if (elementName==="14_Bivalent/poised_TSS"){
                colorSpecification = '#994d00';
            } else if (elementName==="16_Repressed_polycomb"){
                colorSpecification = '#808080';
            } else if (elementName==="17_Weak_repressed_polycomb"){
                colorSpecification = '#c0c0c0';
            } else if (elementName==="18_Quiescent/low_signal"){
                colorSpecification = '#dddddd';
            }
            return colorSpecification;
        }
        var appendLegendInfo = function() {
            var selectedElements = _.unionBy(getSelectedValuesAndText(),getDisplayValuesAndText(), 'name');
            var chosenElementTypes = [];
            _.forEach(selectedElements,function(oe){
                if (oe.name==='DNase') {
                    chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name),dnase:1});
                } else if (oe.name==='H3K27ac') {
                    chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name),h3k27ac:1});
                } else {
                    chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name)});
                }
            });
            return chosenElementTypes;
        };
        var markHeaderAsCurrentlyDisplayed = function(varId){
            $('#overlapTable th.headersWithVarIds').removeClass('active');
            if (( typeof varId !== 'undefined') &&
                (varId.length>1)){
                var allHeaders = $('#overlapTable th.headersWithVarIds');
                _.forEach(allHeaders,function(o){
                    if ($(o).attr('varid')===varId){
                        $(o).addClass('active');
                    }
                });
            }

        };
        var removeAllCredSetHeaderPopUps  =  function () {
            var immedHeader = this;
            $('[data-toggle="popover"]').each(function() {
                if (this!==immedHeader){
                    $(this).popover('hide');
                }

            });
        };
        var removeAllCredSetHeaderPopUpsUnconditionally  =  function () {
            $('[data-toggle="popover"]').each(function() {
                    $(this).popover('hide');
            });

        };

        var buildTheCredibleSetHeatMap = function (drivingVariables,setDefaultButton){
            drivingVariables['chosenStatesForTissueDisplay']=appendLegendInfo();
            $(".credibleSetTableGoesHere").empty().append(
                Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
            );
          //  mpgSoftware.geneSignalSummaryMethods.updateCredibleSetTable(data, additionalParameters);
            var additionalParameters = $.data($('#dataHolderForCredibleSets')[0],'additionalParameters');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var allDataVariants = $.data($('#dataHolderForCredibleSets')[0],'dataVariants',allDataVariants);
            // var includeRecord  = function() {console.log(' seriously uninitialized');return true;};
            // setIncludeRecordBasedOnUserChoice(additionalData.assayIdList);
            // includeRecord = includeRecordBasedOnUserChoice;
            setDevelopingTissueGrid({});
            var assayIdArrays = _.union(getSelectorAssayIds(),getDisplayAssayIds()) ;
            var assayIdArrayAsString = "["+assayIdArrays.join(",")+"]";
            var promises = oneCallbackForEachVariant(allDataVariants,additionalParameters,setIncludeRecordBasedOnUserChoice(assayIdList),assayIdArrayAsString);

            $.when.apply($, promises).then(function(schemas) {
                var tissueGrid = getDevelopingTissueGrid();
                $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid);


                displayAParticularCredibleSet(tissueGrid, drivingVariables.variants, assayIdList,setDefaultButton );
                // do we have any credible set buttons?  If so then it is now safe to turn them on
                var credSetChoices = $('li.credibleSetChooserButton');
                _.forEach(credSetChoices,function(credSetButton){
                    var credSetButtonObj = $(credSetButton);
                    credSetButtonObj.attr('onclick',credSetButtonObj.attr('toBeOnClick'));
                });
                if (setDefaultButton){
                    $($('div.credibleSetNameHolder>ul.nav>li')[0]).click();
                }

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
            $('.credibleSetTableGoesHere th.niceHeadersThatAreLinks ').popover({
                html : true,
                title: function() {
                    var var_id = $(this).attr('chrom')+":"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"_"+$(this).attr('defeffa')+
                    '<div onclick="mpgSoftware.regionInfo.removeAllCredSetHeaderPopUps()" class="close">&times;</div>';
                        //'<div  class="close">&times;</div>'+
                        //'<a href="#" class="close" data-dismiss="alert">&times;</a>'+
                        //'<button type="button" id="close" class="close" onclick="function(){alert(6);'+
                        //'$(".credibleSetTableGoesHere th.niceHeadersThatAreLinks").popover("hide");)' +
                        //'">&times;</button>';

                    return var_id;
                },
                content: function() {
                    var retString = "";
                    retString +=
                        "<div class='credSetLine'><scan class='credSetPopUpTitle'>Chromosome:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('chrom')+"</scan>"+
                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<scan class='credSetPopUpTitle'>Position:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('position')+"</scan></div>"+
                        "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan>"+
                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<scan class='credSetPopUpTitle'>Effect Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defeffa')+"</scan></div>"+
                        "<div class='credSetLine'><span class='fakelink' onclick='mpgSoftware.locusZoom.replaceTissuesWithOverlappingEnhancersFromVarId(\""+
                        $(this).attr('chrom')+"_"+$(this).attr('position')+"_"+$(this).attr('defrefa')+"_"+$(this).attr('defeffa')+"\",\"#lz-lzCredSet\",\""+assayIdList+"\")' href='#'>"+
                        "Click to display tissues with overlapping regions below the LocusZoom plot</span></div>";
                    // if (additionalParameters.portalTypeString==='ibd'){
                    //     retString = "<div class='credSetLine'><scan class='credSetPopUpTitle'>Posterior probability:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('postprob')+"</scan></div>"+
                    //         "<div class='credSetLine'><scan class='credSetPopUpTitle'>Reference Allele:&nbsp;</scan><scan class='credSetPopUpValue'>"+$(this).attr('defrefa')+"</scan></div>"+
                    //         "<div class='credSetLine'><scan class='credSetPopUpTitle'>Click to see overlapping DNase active regions</scan></div>";
                    // }
                    return retString;
                },
                container: 'body',
                placement: 'bottom',
                trigger: 'focus click'
            }).on('show.bs.popover', removeAllCredSetHeaderPopUps );

            //.on("click", function(){
            //    $(this).parents(".popover").popover('hide');
            //});
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
                // The logic ultimately employed is this: primaryTissueGrid tells us which tissues to display.  subsidiaryTissueGrid holds any additional tissues that we will display,
                //  which assumes that that tissue is already a primary tissue.  If
                primaryTissueGrid = filterTissueGrid(tissueGrid,getSelectorAssayIds()); // DNase drives
                subsidiaryTissueGrid = filterSecondaryTissueGrid(tissueGrid,getDisplayAssayIds(),primaryTissueGrid);
            }

            var primaryTissueObject = extractValuesForTissueDisplay(primaryTissueGrid);
            var subsidiaryTissueObject = extractValuesForTissueDisplay(subsidiaryTissueGrid);


            var sortedVariants = dataVariants;
            var countOfTissues = primaryTissueObject.sortedTissues.length;
            var countOfSubsidiaryTissues = subsidiaryTissueObject.sortedTissues.length;
            _.forEach(primaryTissueObject.sortedTissues,function(tissueKey, index){
                var lineToAdd = "<tr>";
                if ( index === 0){
                    lineToAdd += "<td class='credSetOrgLabel' style='vertical-align: middle' rowspan="+(countOfTissues+countOfSubsidiaryTissues)+">tissue</td>"
                }
                lineToAdd += "<td>"+tissueKey+"</td>";
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
                        var lineToAdd = "<tr><td><span  class='subsidiaryClass'>("+tissueKey+")</span></td>";
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
        var setIncludeRecordBasedOnUserChoice = function(assayIdList){
            //if (assayIdList === '[1,2]') {
            if (true) {
                mpgSoftware.regionInfo.includeRecordBasedOnUserChoice = function(o) {
                    var selectedElements = getSelectedValuesAndText();
                    var chosenElementTypes = [];
                    var retval = false;
                    _.forEach(selectedElements,function(oe){

                        if ((o.ASSAY_ID===1)||(o.ASSAY_ID===2)){
                            retval = true;
                        } else {
                            chosenElementTypes.push(oe.name);
                        }

                        // if ((oe.name==="DNase")&&
                        //     (o.ASSAY_ID===2)){
                        //     retval = true;
                        // } else if ((oe.name==="H3K27ac")&&
                        //     (o.ASSAY_ID===1)){
                        //     retval = true;
                        // } else {
                        //     chosenElementTypes.push(oe.name);
                        // }
                    });
                    if (retval) {
                        return true;
                    } else {
                        return ((chosenElementTypes.indexOf(o.element)>-1));
                    }

                };
            }
            // else if (assayIdList === '[3]') {
            //     mpgSoftware.regionInfo.includeRecordBasedOnUserChoice = function(o) {
            //         console.log("[3] choice function");
            //         var selectedElements = $('#credSetSelectorChoice option:selected');
            //         var chosenElementTypes = [];
            //         _.forEach(selectedElements,function(oe){
            //             chosenElementTypes.push($(oe).val());
            //         });
            //         return ((chosenElementTypes.indexOf(o.element)>-1))
            //     };
            // }
            return mpgSoftware.regionInfo.includeRecordBasedOnUserChoice;
        };

        var fillRegionInfoTable = function(vars,additionalParameters) {
            setIncludeRecordBasedOnUserChoice(additionalParameters.assayIdList);
            var currentSequenceExtents = getCurrentSequenceExtents();
            if (!isNaN(currentSequenceExtents.start)){vars.start=currentSequenceExtents.start}
            if (!isNaN(currentSequenceExtents.end)){vars.end=currentSequenceExtents.end}
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
                    if (allCredibleSets.length > 0){

                        if (allCredibleSets[0].credibleSetId===""){
                            var oldTabName = $('a[href=#credibleSetTabHolder]').text();
                            $('a[href=#credibleSetTabHolder]').text("Strongest associations: " +oldTabName);
                        } else {
                            $(".credibleSetChooserGoesHere").empty().append(
                                Mustache.render( $('#organizeCredibleSetChooserTemplate')[0].innerHTML,{allCredibleSets:allCredibleSets,
                                    atLeastOneCredibleSetExists: function(){
                                        var credibleSetPresenceIndicator = [];
                                        if (Object.keys(allCredibleSets).length > 1) {credibleSetPresenceIndicator.push(1)}
                                        return credibleSetPresenceIndicator;
                                    }})
                            );
                            var oldTabName = $('a[href=#credibleSetTabHolder]').text();
                            $('a[href=#credibleSetTabHolder]').text("Credible sets: " +oldTabName);
                        }
                    } else {
                        var oldTabName = $('a[href=#credibleSetTabHolder]').text();
                        $('a[href=#credibleSetTabHolder]').text("Strongest associations: " +oldTabName);
                    }
                    $.data($('#dataHolderForCredibleSets')[0],'allRenderData',drivingVariables);
                    $.data($('#dataHolderForCredibleSets')[0],'assayIdList',assayIdList);
                    $.data($('#dataHolderForCredibleSets')[0],'additionalParameters',additionalParameters);
                    $.data($('#dataHolderForCredibleSets')[0],'dataVariants',data.variants);
                    currentSequenceExtents = getCurrentSequenceExtents();
                    var propertyMeaning = data.propertyName;
                    var positionBy;
                    var maximumNumberOfResults = -1;
                    if (propertyMeaning === 'POSTERIOR_PROBABILITY'){
                        positionBy = 2;
                    } else {
                        propertyMeaning = 'P_VALUE';
                        positionBy = 1;
                        maximumNumberOfResults = DEFAULT_NUMBER_OF_VARIANTS;
                    }
                    mpgSoftware.geneSignalSummaryMethods.lzOnCredSetTab(additionalParameters,{
                        positioningInformation:{
                            chromosome:additionalParameters.geneChromosome.substr(3),
                            startPosition:getCurrentSequenceExtents().start,
                            endPosition:getCurrentSequenceExtents().end
                        },
                        phenotypeName:data.phenotype,
                        pName:data.phenotypeReadable,
                        datasetName:data.dataset,
                        phenoPropertyName:propertyMeaning,//data.propertyName,
                        defaultTissuesDescriptions:[],
                        datasetReadableName:data.datasetReadable,
                        positionBy:positionBy,
                        sampleGroupsWithCredibleSetNames:[data.dataset],
                        maximumNumberOfResults:maximumNumberOfResults
                    });


                    buildTheCredibleSetHeatMap(drivingVariables,true);
                    // if (Object.keys(allCredibleSets).length > 1){
                    //     $($('.credibleSetChooserButton')[0]).click();
                    // }
                    $('#credSetSelectorChoice').multiselect({includeSelectAllOption: true,
                        allSelectedText: 'All Selected',
                        buttonWidth: '60%',onChange: function() {
                            console.log($('#credSetSelectorChoice').val());
                        }});
        //            $('#credSetSelectorChoice').multiselect('selectAllOption', false);
                    $('#credSetSelectorChoice').val(mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters.portalTypeString));
                    $('#credSetDisplayChoice').multiselect({includeSelectAllOption: true,
                        // allSelectedText: 'All Selected',
                        buttonWidth: '60%'});
               //     $('#credSetDisplayChoice').multiselect('selectAllOption', false);
                    $('#credSetDisplayChoice').val(mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters.portalTypeString));
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
            getSampleGroupsWithCredibleSetNames:getSampleGroupsWithCredibleSetNames,
            redisplayTheCredibleSetHeatMap:redisplayTheCredibleSetHeatMap,
            includeRecordBasedOnUserChoice:includeRecordBasedOnUserChoice,
            removeAllCredSetHeaderPopUps:removeAllCredSetHeaderPopUps,
            markHeaderAsCurrentlyDisplayed:markHeaderAsCurrentlyDisplayed,
            setIncludeRecordBasedOnUserChoice:setIncludeRecordBasedOnUserChoice,
            getDefaultTissueRegionOverlapMatcher:getDefaultTissueRegionOverlapMatcher,
            getSelectorAssayIds:getSelectorAssayIds,
            specificHeaderToBeActiveByVarId:specificHeaderToBeActiveByVarId
        }

    })();



})();
