var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var assayInformation = {};

        var storeAssayInformation = function (incomingAssayInformation) {
            assayInformation = incomingAssayInformation;
        };
        var getAssayMetadata = function () {
            if (typeof assayInformation === 'undefined') {
                console.log ("Assay metadata appears to be absent. Page failure imminent.");
            }
            return assayInformation;
        };
        var getAssayInformation = function () {
            return getAssayMetadata ().assays;
        };
        var getTissueInformation = function () {
            return getAssayMetadata ().tissues;
        };
        var getAnnotationInformation = function () {
            return getAssayMetadata ().annotations;
        };

        var initializeRegionInfoModule = function (drivingVariables){
            var promise = $.ajax({
                cache: false,
                type: "post",
                url: drivingVariables.availableAssayIdsJsonUrl,
                data: {},
                async: true
            });
            promise.done(
                function (data) {
                    storeAssayInformation (data);
                });
            promise.fail(
                function (){
                    console.log ("We were unable to obtain the assay info metadata. The credible set tab will fail soon");
                }
            );
        };

        var retrieveDesiredAssay = function (assayId){
            var returnValue = {};
            var desiredAssay = _.findIndex(getAssayInformation (),{'assayID':assayId});
            if (desiredAssay === -1){
                console.log ("Caller requested assay ID =" + assayId+ ", for which we have no record. The credible set tab will fail soon");
            }else {
                returnValue = getAssayInformation () [desiredAssay];
            }
            return returnValue;
        };


        var retrieveQuantileBoundaries = function (assayId){
            return retrieveDesiredAssay (assayId).quantile;
        };



        var DEFAULT_NUMBER_OF_VARIANTS = 10;

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
        var convertUserChoicesIntoAssayIds = function(selectedValuesAndText) {
            var assayIds = [];
            var assayInformation = getAssayInformation();
            _.forEach(selectedValuesAndText,function(oe){
                var elementForAssay = _.find (assayInformation, function (o){return (_.findIndex (o.selectionOptions,function (p){return p.value===oe.name})>-1)});
                if (typeof elementForAssay !== 'undefined') {
                    assayIds.push(elementForAssay.assayID);
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
        var getDefaultTissueRegionOverlapMatcher = function (additionalParameters,displayNumber){
            if (displayNumber === 0){
                return additionalParameters.tissueRegionOverlapMatcher ;
            } else if (displayNumber === 1){
                return  additionalParameters.tissueRegionOverlapDisplayMatcher
            }
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
        };

        var insertAnnotation = function (renderData, fieldId, valueToInsert,relatedFieldExists){
            var mapTableCellClasses = function (metadataRecord){
                var returnValue = {
                                    rowName: metadataRecord.name
                                    };
                if (fieldId === 'coding'){
                    returnValue ['annotationSection']= {
                        sectionName: metadataRecord.group,
                        primaryRowClass:'credcellpval',
                        secondaryRowClass:'credSetOrgLabel',
                        rowsPerSection: _.filter (getAnnotationInformation (), {'group':metadataRecord.group}).length
                    };
                    returnValue ['rowClass'] = 'credSetConstLabel';
                } else if (fieldId === 'spliceSite'){
                    returnValue ['rowClass'] = 'credSetConstLabel';
                } else if (fieldId === 'utr'){
                    returnValue ['rowClass'] = 'credSetConstLabel';
                } else if (fieldId === 'promoter'){
                    returnValue ['rowClass'] = 'credSetConstLabel';
                } else if (fieldId === 'tfBindingMotif'){
                    returnValue ['rowClass'] = 'credcellpval credSetConstLabel';
                }else if (fieldId === 'posteriorProbability'){
                    returnValue ['annotationSection']= {
                        sectionName: metadataRecord.group,
                        primaryRowClass:'credcellpval',
                        secondaryRowClass:'credSetOrgLabel',
                        rowsPerSection: _.filter (getAnnotationInformation (), {'group':metadataRecord.group}).length
                    };
                    returnValue ['rowClass'] = 'credSetConstLabel';
                }else if (fieldId === 'pValue'){
                    if (!relatedFieldExists){
                        returnValue ['annotationSection']= {
                            sectionName: metadataRecord.group,
                            primaryRowClass:'credcellpval',
                            secondaryRowClass:'credSetOrgLabel',
                            rowsPerSection: 1
                        };
                    }
                    returnValue ['rowClass'] = 'credcellpval credSetConstLabel';
                }
                return returnValue;
            };
            var metadataRecord;
            var recordType;
            var recordIndex = _.findIndex (renderData.annotation, function(o){return o.value===fieldId});
            if (recordIndex === -1){
                var metadataIndex = _.findIndex(getAnnotationInformation(),function (o){return o.value===fieldId});
                if (metadataIndex === -1){
                    console.log('missing annotation metadata record');
                } else {
                    metadataRecord = getAnnotationInformation()[metadataIndex];
                    recordType = metadataRecord.type;
                    var annotationRecord = {annotationSection:[],
                        rowName: metadataRecord.name,
                        value:metadataRecord.value,
                        sort_order: metadataRecord.sort_order,
                        type:  recordType,
                        annotationRecord:[]
                    };
                    var displaySpecifications = mapTableCellClasses (metadataRecord);
                    if (typeof displaySpecifications.annotationSection !== 'undefined'){
                        annotationRecord.annotationSection.push(displaySpecifications.annotationSection);
                    }
                    annotationRecord['rowClass'] = displaySpecifications.rowClass;
                    renderData.annotation.push(annotationRecord);

                    recordIndex = _.findIndex (renderData.annotation, function(o){return o.value===fieldId});
                    if (recordIndex === -1){
                        console.log(' unexpected inconsistency');
                        return;
                    }

                }
            }
            recordType = renderData.annotation[recordIndex].type;
            if (recordType === "BINARY"){
                var classToInsert = 'absent';
                if (valueToInsert){
                    classToInsert = 'present';
                }
                renderData.annotation[recordIndex].annotationRecord.push({val:'',descr:classToInsert});
            } else if (recordType === "COMPOUND"){
                renderData.annotation[recordIndex].annotationRecord.push(valueToInsert);
            } else if (recordType === "REAL") {
                renderData.annotation[recordIndex].annotationRecord.push({val:UTILS.realNumberFormatter(valueToInsert,1)});
            }
            return renderData;
        };




        var buildRenderDataForGenes = function (data,additionalParameters){
            var renderData = {  variants: [],
                credibleSetInfoCode:data.credibleSetInfoCode,
                const:{
                },
                annotation:[],

                cellTypeSpecs: [
                ]};
            if (typeof data !== 'undefined'){
                var eachColumn = [];
                _.forEach(data.data, function (gene){
                    var geneRecord = {};
                    var allVariants = _.flatten([{}, gene.annotations.variants]);
                    var flattendVariants = _.map(allVariants,function(o){return  _.merge.apply(_,o)});
                    var minimumPValue = 1;
                    var minimumPosteriorPValue = 1;
                    var variants = [];
                    var codingVariants = [];
                    var spliceSiteVariants = [];
                    var utrVariants = [];
                    var tfBindingVariants = [];
                    var promoterVariants = [];
                    _.forEach(flattendVariants.sort(function (a, b) {return a.POS - b.POS;}), function (v){ // need to aggregate variance into something meaningful for the gene
                        _.forEach(v.P_VALUE, function (csvalue){
                            _.forEach(csvalue,function (currentPValue){
                                if (currentPValue<minimumPValue){
                                    minimumPValue=currentPValue;
                                }

                            })
                        });
                        _.forEach(v.POSTERIOR_PROBABILITY, function (csvalue){
                            _.forEach(csvalue,function (currentPValue){
                                if (currentPValue<minimumPosteriorPValue){
                                    minimumPosteriorPValue=currentPValue;
                                }

                            })
                        });
                        if (typeof v.VAR_ID !== 'undefined') {
                            variants.push({name:v.VAR_ID, details:v, assayIdList: additionalParameters.assayIdList});
                        }
                        if (typeof v.MOST_DEL_SCORE !== 'undefined') {
                            if ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4)){
                                codingVariants.push (v.VAR_ID);
                            }
                        }
                        if (typeof v.Consequence !== 'undefined'){
                            if (v.Consequence.indexOf('splice')>-1){
                                spliceSiteVariants.push (v.VAR_ID);
                            }
                            if (v.Consequence.indexOf('utr')>-1){
                                utrVariants.push (v.VAR_ID);
                            }
                            if (v.Consequence.indexOf('promoter')>-1){
                                promoterVariants.push (v.VAR_ID);
                            }
                        }
                        if (typeof v.MOTIF_NAME !== 'undefined') {
                            tfBindingVariants.push((v.MOTIF_NAME === null) ?
                                {val:'',descr:'absent'}:
                                {val:v.MOTIF_NAME,descr:'present'});
                        }

                    });
                    insertAnnotation(renderData,'coding', codingVariants.length>0, false );
                    insertAnnotation(renderData,'spliceSite', (spliceSiteVariants.length>0), false );
                    insertAnnotation(renderData,'utr', (utrVariants.length>0), false );
                    insertAnnotation(renderData,'promoter', (promoterVariants.length>0), false );
                    insertAnnotation(renderData,'tfBindingMotif', (tfBindingVariants.length>0), false );
                    var posteriorProbabilitiesExist = false;
                    if (minimumPosteriorPValue<1) {
                        posteriorProbabilitiesExist = true;
                        insertAnnotation(renderData,'posteriorProbability',minimumPosteriorPValue, false);

                    }
                    if (minimumPValue<1) {
                        insertAnnotation(renderData,'pValue',minimumPValue,posteriorProbabilitiesExist);
                    }
                    geneRecord['addrStart'] = gene.addrStart;
                    geneRecord['addrEnd'] = gene.addrEnd;
                    geneRecord['chromosome'] = gene.chromosome;
                    geneRecord['name'] = gene.name1;
                    eachColumn.push(geneRecord);
                });
            }
            renderData['columns'] = eachColumn;

            return renderData;
        };







        var buildRenderData = function (data,additionalParameters){
            var renderData = {  variants: [],
                                credibleSetInfoCode:data.credibleSetInfoCode,
                                const:{
                                },
                                annotation:[],

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

                    if (typeof v.VAR_ID !== 'undefined') {
                        renderData.variants.push({name:v.VAR_ID, details:v, assayIdList: additionalParameters.assayIdList});
                    }
                    if (typeof v.MOST_DEL_SCORE !== 'undefined') {
                        insertAnnotation(renderData,'coding', ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4)), false );
                    }
                    if (typeof v.Consequence !== 'undefined'){
                        insertAnnotation(renderData,'spliceSite', (v.Consequence.indexOf('splice')>-1), false );
                        insertAnnotation(renderData,'utr', (v.Consequence.indexOf('UTR')>-1), false );
                        insertAnnotation(renderData,'promoter', (v.Consequence.indexOf('promoter')>-1), false );
                    }
                    if (typeof v.MOTIF_NAME !== 'undefined') {
                        insertAnnotation(renderData,'tfBindingMotif', (v.MOTIF_NAME === null) ?
                            {val:'',descr:'absent'}:
                            {val:v.MOTIF_NAME,descr:'present'}, false );
                    }
                    var posteriorProbabilitiesExist = false;
                    if ((typeof v.extractedPOSTERIOR_PROBABILITY !== 'undefined') &&
                        ($.isNumeric(v.extractedPOSTERIOR_PROBABILITY))) {
                            posteriorProbabilitiesExist = true;
                            insertAnnotation(renderData,'posteriorProbability',v.extractedPOSTERIOR_PROBABILITY, false);

                    }
                    if ((typeof v.extractedP_VALUE !== 'undefined')&&
                        ($.isNumeric(v.extractedP_VALUE))) {
                        insertAnnotation(renderData,'pValue',v.extractedP_VALUE,posteriorProbabilitiesExist);
                    }

                });
            }

            return renderData;
        };

        var filterRenderData = function (oldRenderData,assayIdList,variantsToInclude){
            var newRenderData = {  variants: [],
                const:{
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

            newRenderData.annotation = [];
            _.forEach(oldRenderData.annotation,function (val,ind){
                var newAnnotation = {};
                newAnnotation["annotationRecord"] = [];
                newAnnotation["annotationSection"] = [];
                if (oldRenderData.annotation[ind].annotationSection.length>0) {
                    newAnnotation["annotationSection"].push (oldRenderData.annotation[ind].annotationSection[0]);
                }
                newAnnotation["rowClass"] = oldRenderData.annotation[ind].rowClass;
                newAnnotation["rowName"] = oldRenderData.annotation[ind].rowName;
                newAnnotation["sort_order"] = oldRenderData.annotation[ind].sort_order;
                newAnnotation["type"] = oldRenderData.annotation[ind].type;
                newAnnotation["value"] = oldRenderData.annotation[ind].value;
                _.forEach(arrayOfIndexesToInclude, function (i) {
                    newAnnotation.annotationRecord.push(oldRenderData.annotation[ind].annotationRecord[i]);
                });
                newRenderData.annotation.push (newAnnotation);
            });
            _.forEach(arrayOfIndexesToInclude, function (i) {
                 newRenderData.variants.push(oldRenderData.variants[i]);
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
                                var assaySpecificTissueDesignation = record.source_trans + "_"+record.ANNOTATION;
                                if (includeRecord(record)){
                                    if(typeof tissueGrid[assaySpecificTissueDesignation] === 'undefined') {
                                        tissueGrid[assaySpecificTissueDesignation] = {};
                                    }
                                    var tissueRow = tissueGrid[assaySpecificTissueDesignation];
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



        var oneCallbackForEachGene = function(genes,
                                                 additionalData,
                                                 includeRecord,
                                                 assayIdList){
            var promiseArray = [];
            _.forEach(genes,function (gene){
                var chromosome = (gene.chromosome.indexOf('chr')>-1)?gene.chromosome.substr(3):gene.chromosome;
                promiseArray.push(
                    $.ajax({
                        cache: false,
                        type: "post",
                        url: additionalData.retrieveFunctionalDataAjaxUrl,
                        data: {
                            chromosome: chromosome,
                            startPos: ""+gene.addrStart,
                            endPos: ""+gene.addrEnd,
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
                                var assaySpecificTissueDesignation = record.source_trans + "_"+record.ANNOTATION;
                                if (includeRecord(record)){
                                    if(typeof tissueGrid[assaySpecificTissueDesignation] === 'undefined') {
                                        tissueGrid[assaySpecificTissueDesignation] = {};
                                    }
                                    var tissueRow = tissueGrid[assaySpecificTissueDesignation];
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

        // let's return an array of elements which we can eventually feed to mustache
        var writeOneCellOfTheHeatMap = function(tissueGrid,tissueKey,quantileArray,variantRec){
            var lineToAdd ="";
            var arrayToBuild = [];
            if ((typeof variantRec !== 'undefined')&&
                (typeof variantRec.details !== 'undefined')&&
                (typeof variantRec.details.POS !== 'undefined')){
                var positionString = ""+variantRec.details.POS;
                var record = tissueGrid[tissueKey][positionString];
                var worthIncluding = false;
                if ((typeof record !== 'undefined') && (typeof record.source_trans !== 'undefined') && (record.source_trans !== null)){
                    quantileArray = createQuantilesArray(record.ANNOTATION);
                    var elementName = record.source_trans;
                    var provideDefaultForAssayId = (typeof record.ANNOTATION === 'undefined') ? 3 : record.ANNOTATION;
                    if  (provideDefaultForAssayId === 3){
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineCategoricalColorIndex(record.ELEMENT)),
                                        title:('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans ),
                                        annotation:record.ANNOTATION, experiment:record.EXPERIMENT, gene:record.GENE, value:record.VALUE,
                                        tissue:record.source_trans});
                    } else if ((provideDefaultForAssayId === 1) || (provideDefaultForAssayId === 2)){
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineColorIndex(record.VALUE,quantileArray)),
                            title:('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans+', value:'+ UTILS.realNumberFormatter(record.VALUE) ),
                            annotation:record.ANNOTATION, experiment:record.EXPERIMENT, gene:record.GENE, value:record.VALUE,
                            tissue:record.source_trans});
                    }
                    else {
                        var displayableContent = '';
                        if (record.GENE!==null){displayableContent = record.GENE};
                        if ((record.ELEMENT!==null) && (displayableContent.length===0)){displayableContent = record.ELEMENT};
                        if ((record.EXPERIMENT!==null) && (displayableContent.length===0)){displayableContent = record.EXPERIMENT};
                        var allInfo = [];
                        allInfo.push('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans);
                        if (record.VALUE!==null){allInfo.push( 'value:'+ UTILS.realNumberFormatter(record.VALUE))};
                        if (record.EXPERIMENT!==null){allInfo.push( 'experiment:'+ record.EXPERIMENT)};
                        if (record.GENE!==null){allInfo.push( 'gene:'+ record.GENE)};
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineColorIndex(record.VALUE,quantileArray)),
                            title:allInfo.join(",<br/>"),
                            annotation:record.ANNOTATION, experiment:record.EXPERIMENT, gene:record.GENE, value:record.VALUE,
                            tissue:record.source_trans,displayableContent:displayableContent});
                    }
                } else {
                    arrayToBuild.push({annotation:0});
                }
            }
            //return lineToAdd;
            return arrayToBuild[0];
        };


        var writeOneCellOfTheGeneBasedHeatMap = function(tissueGrid,tissueKey,quantileArray,variantRec,recordsToAggregate){
            var lineToAdd ="";
            var arrayToBuild = [];
            if ((typeof variantRec !== 'undefined')&&
                (typeof variantRec.addrStart !== 'undefined')){
                var positionString = ""+variantRec.addrStart;
                var record = tissueGrid[tissueKey][positionString];
                var worthIncluding = false;
                if ((typeof record !== 'undefined') && (typeof record.source_trans !== 'undefined') && (record.source_trans !== null)){
                    quantileArray = createQuantilesArray(record.ANNOTATION);
                    var elementName = record.source_trans;
                    var provideDefaultForAssayId = (typeof record.ANNOTATION === 'undefined') ? 3 : record.ANNOTATION;
                    if  (provideDefaultForAssayId === 3){
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineCategoricalColorIndex(record.ELEMENT)),
                            title:('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans ),
                            annotation:record.ANNOTATION, experiment:record.EXPERIMENT, gene:record.GENE, value:record.VALUE,
                            tissue:record.source_trans});
                    } else if ((provideDefaultForAssayId === 1) || (provideDefaultForAssayId === 2)){
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineColorIndex(record.VALUE,quantileArray)),
                            title:('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans+', value:'+ UTILS.realNumberFormatter(record.VALUE) ),
                            annotation:record.ANNOTATION, experiment:record.EXPERIMENT, gene:record.GENE, value:record.VALUE,
                            tissue:record.source_trans});
                    }
                    else {
                        var listOfElementsToDisplayInACell = '';
                        var listOfElementsValues = [];
                        var valueArray = _.map(recordsToAggregate,function(v,k){return v;});
                        var uniqueRecords = _.uniqWith(valueArray,function(x,y){return (x.EXPERIMENT===y.EXPERIMENT&&x.ELEMENT===y.ELEMENT&&x.SOURCE===y.SOURCE)});
                        _.forEach(uniqueRecords, function (recordValue){
                            listOfElementsValues.push (recordValue);
                        });
                        var uniqueRecordsByExperiment = _.uniqWith(valueArray,function(x,y){return (x.EXPERIMENT===y.EXPERIMENT)});
                        if (uniqueRecordsByExperiment.length > 1){
                            _.forEach(uniqueRecords, function (recordValue){
                                listOfElementsValues.push (recordValue);
                            });
                        } else if (uniqueRecordsByExperiment.length > 0) {
                            listOfElementsToDisplayInACell+=uniqueRecordsByExperiment[0].EXPERIMENT;
                            if (uniqueRecords.length>1) {
                                listOfElementsToDisplayInACell += '(';
                            } else {
                                listOfElementsToDisplayInACell += ' ';
                            }
                            _.forEach(uniqueRecords, function (recordValue){
                                listOfElementsValues.push (recordValue);
                                if (recordValue.ELEMENT!==null){
                                    listOfElementsToDisplayInACell += recordValue.ELEMENT;
                                }
                                // if (recordValue.SOURCE!=='NA'){
                                //     listOfElementsToDisplayInACell += ','+recordValue.SOURCE;
                                // }
                            });
                            if (uniqueRecords.length>1) {
                                listOfElementsToDisplayInACell += ')';
                            }



                        }
                        var uniqueRecordsByElement = _.uniqWith(valueArray,function(x,y){return (x.ELEMENT===y.ELEMENT)});

                        // listOfElementsToDisplayInACell += recordValue.EXPERIMENT;
                        // if (recordValue.ELEMENT!==null){
                        //     listOfElementsToDisplayInACell += ','+recordValue.ELEMENT;
                        // }
                        // if (recordValue.SOURCE!=='NA'){
                        //     listOfElementsToDisplayInACell += ','+recordValue.SOURCE;
                        // }
                        var displayableContent = '';
                        if (record.GENE!==null){displayableContent = record.GENE};
                        if ((record.ELEMENT!==null) && (displayableContent.length===0)){displayableContent = record.ELEMENT};
                        if ((record.EXPERIMENT!==null) && (displayableContent.length===0)){displayableContent = record.EXPERIMENT};
                        var allInfo = [];
                        allInfo.push('chromosome:'+ record.CHROM +', position:'+ positionString +', tissue:'+ record.source_trans);
                        if (record.VALUE!==null){allInfo.push( 'value:'+ UTILS.realNumberFormatter(record.VALUE))};
                        if (record.EXPERIMENT!==null){allInfo.push( 'experiment:'+ record.EXPERIMENT)};
                        if (record.GENE!==null){allInfo.push( 'gene:'+ record.GENE)};
                        arrayToBuild.push({matchingRegion:('matchingRegion'+provideDefaultForAssayId +'_'+determineColorIndex(record.VALUE,quantileArray)),
                            title:allInfo.join(",<br/>"),
                            annotation:record.ANNOTATION,
                            experiment:record.EXPERIMENT,
                            gene:record.GENE,
                            value:record.VALUE,
                            tissue:record.source_trans,
                            displayableContent:listOfElementsToDisplayInACell});
                    }
                } else {
                    arrayToBuild.push({annotation:0});
                }
            }
            //return lineToAdd;
            return arrayToBuild[0];
        };





        var createQuantilesArray = function(assayId){
            // let's make assay ID==3 the default
            if ((typeof assayId === 'undefined') ) { assayId = 3;}
            var boundariesForThisAssay = retrieveQuantileBoundaries(assayId);
            var quantileArray = [];
            for ( var i = 0 ; i < boundariesForThisAssay.length ; i++ ){
                quantileArray.push({min:boundariesForThisAssay[i],max:boundariesForThisAssay[i+1]});
            }
            return quantileArray;
        };

        var filterTissueGrid = function(incomingTissueGrid,assayIdArray){
            var retVal = {};
            // convert assay id into a real array
            _.forEach(Object.keys(incomingTissueGrid),function(tissueKey){
                var variantsToKeep = {};
                _.forEach(Object.keys(incomingTissueGrid[tissueKey]),function(variantPos){
                    var variantRecord = incomingTissueGrid[tissueKey][variantPos];
                    if (((typeof variantRecord.ANNOTATION === 'undefined') ) || (assayIdArray.includes(variantRecord.ANNOTATION))){
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
                var primaryAssayId = primaryTissueObject[primaryTissueKey][Object.keys(primaryTissueObject[primaryTissueKey])[0]].ANNOTATION
                var weHaveDataForThatTissue = incomingTissueGrid[primaryTissueKey];
                if (typeof weHaveDataForThatTissue !== 'undefined'){
                    var variantsToKeep = {};
                    _.forEach(Object.keys(weHaveDataForThatTissue),function(variantPos){
                        var variantRecord = weHaveDataForThatTissue[variantPos];
                        if ((assayIdArray.includes(variantRecord.ANNOTATION))&&
                            (variantRecord.ANNOTATION!==primaryAssayId)){ // we only want s subsidiary records, which must come from a different assay
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
                    assayId = singleVariant.ANNOTATION;
                    everySingleValue.push(oneValue);
                    return oneValue;
                })[0];
                return  (typeof bestVariantPerTissue !== 'undefined') ? bestVariantPerTissue.VALUE : 0;
            });

            return {
                sortedTissues: _.map(sortedArrayOfArrays, function(oneRec){
                    var assString = ""
                    var rec = oneRec[Object.keys(oneRec)[0]];
                    var assaySpecificTissueName = rec.source_trans + "_"+rec.ANNOTATION;
                    if (typeof rec !== 'undefined') {
                        assString = assaySpecificTissueName;
                    }
                    return assString;
                }),
                tissueGrid: tissueGrid,
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
            var assayInformation = getAssayInformation();
            _.forEach(selectedElements,function(oe){
                var elementForAssay = _.find (assayInformation, function (o){return (_.findIndex (o.selectionOptions,function (p){return p.value===oe.name})>-1)});
                if (typeof elementForAssay !== 'undefined') {
                    var chosenElementType = {name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name)};
                    chosenElementType [elementForAssay.name] = 1
                    chosenElementTypes.push(chosenElementType);
                }
                // if (oe.name==='DNase') {
                //     chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name),dnase:1});
                // } else if (oe.name==='H3K27ac') {
                //     chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name),h3k27ac:1});
                // } else if (oe.name==='UCSD') {
                //     chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name),tfbf:1});
                // } else {
                //     chosenElementTypes.push({name:oe.name,descr:oe.text,colorCode:colorMapper (oe.name)});
                // }
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


        var buildTheGeneHeatMap = function (drivingVariables,setDefaultButton){
            drivingVariables['chosenStatesForTissueDisplay']=appendLegendInfo();
            $(".credibleSetTableGoesHere").empty().append(
                Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
            );
            var additionalParameters = $.data($('#dataHolderForCredibleSets')[0],'additionalParameters');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');

            setDevelopingTissueGrid({});
            var assayIdArrays = _.union(getSelectorAssayIds(),getDisplayAssayIds()) ;
            var assayIdArrayAsString = "["+assayIdArrays.join(",")+"]";
            var promises = oneCallbackForEachGene(drivingVariables.columns, additionalParameters,setIncludeRecordBasedOnUserChoice(assayIdList),assayIdArrayAsString);

            $.when.apply($, promises).then(function(schemas) {
                var tissueGrid = getDevelopingTissueGrid();

                //  we need to remember some of these data
                $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid);
                $.data($('#dataHolderForCredibleSets')[0],'sortedVariants',drivingVariables.variants);

                var uniqueAssayIds = _.uniq(getSelectorAssayIds());
                if (uniqueAssayIds.length===1){
                    displayAParticularCredibleSet(tissueGrid, drivingVariables.variants, setDefaultButton,uniqueAssayIds[0] );
                } else {
                    _.forEach(uniqueAssayIds, function (assayId){
                        displayAggregatedGenesPerAssayId(tissueGrid, drivingVariables.columns, [assayId], setDefaultButton );
                       // displayAggregatedDataPerAssayId(tissueGrid, drivingVariables.variants, [assayId], setDefaultButton );
                    });
                }


                // do we have any credible set buttons?  If so then it is now safe to turn them on
                var credSetChoices = $('li.credibleSetChooserButton');
                _.forEach(credSetChoices,function(credSetButton){
                    var credSetButtonObj = $(credSetButton);
                    credSetButtonObj.attr('onclick',credSetButtonObj.attr('toBeOnClick'));
                });
                if (setDefaultButton){
                    $($('div.credibleSetNameHolder>ul.nav>li')[0]).click();
                }
                $('[data-toggle="popover"]').popover({
                    animation: true,
                    html: true,
                    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                });
                $(".pop-top").popover({placement: 'top'});
                $(".pop-right").popover({placement: 'right'});
                $(".pop-bottom").popover({placement: 'bottom'});
                $(".pop-left").popover({placement: 'left'});
                $(".pop-auto").popover({placement: 'auto'})

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
                    return retString;
                },
                container: 'body',
                placement: 'bottom',
                trigger: 'focus click'
            }).on('show.bs.popover', removeAllCredSetHeaderPopUps );

        };










        var buildTheCredibleSetHeatMap = function (drivingVariables,setDefaultButton){
            drivingVariables['chosenStatesForTissueDisplay']=appendLegendInfo();
            $(".credibleSetTableGoesHere").empty().append(
                Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
            );
            var additionalParameters = $.data($('#dataHolderForCredibleSets')[0],'additionalParameters');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var allDataVariants = $.data($('#dataHolderForCredibleSets')[0],'dataVariants',allDataVariants);
            setDevelopingTissueGrid({});
            var assayIdArrays = _.union(getSelectorAssayIds(),getDisplayAssayIds()) ;
            var assayIdArrayAsString = "["+assayIdArrays.join(",")+"]";
            var promises = oneCallbackForEachVariant(allDataVariants,additionalParameters,setIncludeRecordBasedOnUserChoice(assayIdList),assayIdArrayAsString);

            $.when.apply($, promises).then(function(schemas) {
                var tissueGrid = getDevelopingTissueGrid();

                //  we need to remember some of these data
                $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid);
                $.data($('#dataHolderForCredibleSets')[0],'sortedVariants',drivingVariables.variants);

                var uniqueAssayIds = _.uniq(getSelectorAssayIds());
                if (uniqueAssayIds.length===1){
                    displayAParticularCredibleSet(tissueGrid, drivingVariables.variants, setDefaultButton,uniqueAssayIds[0] );
                } else {
                    _.forEach(uniqueAssayIds, function (assayId){
                        //displayAParticularCredibleSetPerAssayId (tissueGrid, drivingVariables.variants, [assayId], setDefaultButton );
                        displayAggregatedDataPerAssayId(tissueGrid, drivingVariables.variants, [assayId], setDefaultButton );
                    });
                }


                // do we have any credible set buttons?  If so then it is now safe to turn them on
                var credSetChoices = $('li.credibleSetChooserButton');
                _.forEach(credSetChoices,function(credSetButton){
                    var credSetButtonObj = $(credSetButton);
                    credSetButtonObj.attr('onclick',credSetButtonObj.attr('toBeOnClick'));
                });
                if (setDefaultButton){
                    $($('div.credibleSetNameHolder>ul.nav>li')[0]).click();
                }
                $('[data-toggle="popover"]').popover({
                    animation: true,
                    html: true,
                    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                });
                $(".pop-top").popover({placement: 'top'});
                $(".pop-right").popover({placement: 'right'});
                $(".pop-bottom").popover({placement: 'bottom'});
                $(".pop-left").popover({placement: 'left'});
                $(".pop-auto").popover({placement: 'auto'})

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





        var buildANearbyGeneHeatMap = function (drivingVariables,setDefaultButton){
            drivingVariables['chosenStatesForTissueDisplay']=appendLegendInfo();
            $(".credibleSetTableGoesHere").empty().append(
                Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
            );
            var additionalParameters = $.data($('#dataHolderForCredibleSets')[0],'additionalParameters');
            var assayIdList = $.data($('#dataHolderForCredibleSets')[0],'assayIdList');
            var allDataVariants = $.data($('#dataHolderForCredibleSets')[0],'dataVariants',allDataVariants);
            setDevelopingTissueGrid({});
            var assayIdArrays = _.union(getSelectorAssayIds(),getDisplayAssayIds()) ;
            var assayIdArrayAsString = "["+assayIdArrays.join(",")+"]";
            //var promises = oneCallbackForEachVariant(allDataVariants,additionalParameters,setIncludeRecordBasedOnUserChoice(assayIdList),assayIdArrayAsString);
            var promises = oneCallbackForEachGene(allDataVariants,additionalParameters,setIncludeRecordBasedOnUserChoice(assayIdList),assayIdArrayAsString);

            $.when.apply($, promises).then(function(schemas) {
                var tissueGrid = getDevelopingTissueGrid();

                //  we need to remember some of these data
                $.data($('#dataHolderForCredibleSets')[0],'tissueGrid',tissueGrid);
                $.data($('#dataHolderForCredibleSets')[0],'sortedVariants',drivingVariables.variants);

                var uniqueAssayIds = _.uniq(getSelectorAssayIds());
                if (uniqueAssayIds.length===1){
                    displayAParticularCredibleSet(tissueGrid, drivingVariables.variants, setDefaultButton,uniqueAssayIds[0] );
                } else {
                    _.forEach(uniqueAssayIds, function (assayId){
                        //displayAParticularCredibleSetPerAssayId (tissueGrid, drivingVariables.variants, [assayId], setDefaultButton );
                        displayAggregatedDataPerAssayId(tissueGrid, drivingVariables.variants, [assayId], setDefaultButton );
                    });
                }


                // do we have any credible set buttons?  If so then it is now safe to turn them on
                var credSetChoices = $('li.credibleSetChooserButton');
                _.forEach(credSetChoices,function(credSetButton){
                    var credSetButtonObj = $(credSetButton);
                    credSetButtonObj.attr('onclick',credSetButtonObj.attr('toBeOnClick'));
                });
                if (setDefaultButton){
                    $($('div.credibleSetNameHolder>ul.nav>li')[0]).click();
                }
                $('[data-toggle="popover"]').popover({
                    animation: true,
                    html: true,
                    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                });
                $(".pop-top").popover({placement: 'top'});
                $(".pop-right").popover({placement: 'right'});
                $(".pop-bottom").popover({placement: 'bottom'});
                $(".pop-left").popover({placement: 'left'});
                $(".pop-auto").popover({placement: 'auto'})

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





        //  Generate a mustache-ready data structure which holds everything that will go into the tissue specific portion of the
        //   heat map.
        var generateDataStructureForTissueSpecificHeatMap = function(primaryTissueObject, subsidiaryTissueObject, sortedVariants, annotationId ){
            var tissueSpecificHeatMapDataStructure = { tissueSpecificRow: [] };
            _.forEach(primaryTissueObject.sortedTissues,function(tissueKey, index){
                var rowDataStructure = {    rowSpan:0,
                                            createSpanningCell: function () {return (this.rowSpan > 0);}
                };
                if ( index === 0){
                    rowDataStructure.rowSpan = primaryTissueObject.sortedTissues.length+subsidiaryTissueObject.sortedTissues.length;
                }
                rowDataStructure.tissueName = tissueKey.replace(/_\d+/g,'');
                rowDataStructure.tissueDescriptionClass = 'credSetTissueLabel';
                rowDataStructure.cellsPerLine = [];
                rowDataStructure.annotationId = annotationId;
                _.forEach(sortedVariants,function(variantRec){
                    rowDataStructure.cellsPerLine.push(writeOneCellOfTheHeatMap(primaryTissueObject.tissueGrid,tissueKey,primaryTissueObject.quantileArray,variantRec));
                });
                var drivingTissueRecordExists = false;
                if (rowDataStructure.cellsPerLine.length > 0){
                    if (!(((Object.keys(subsidiaryTissueObject.tissueGrid).length>0))&&(typeof subsidiaryTissueObject.tissueGrid[tissueKey] !== 'undefined'))){
                        rowDataStructure.rowDecoration  = 'border-bottom: solid 2px #bbb';
                    }
                    tissueSpecificHeatMapDataStructure.tissueSpecificRow.push (rowDataStructure);
                    drivingTissueRecordExists = true;
                }

                var followUpRowDataStructure = {    rowSpan:0,
                                                    createSpanningCell: function () {return (this.rowSpan > 0)}};
                // do we want to add a follow up lines?
                if (drivingTissueRecordExists&&(Object.keys(subsidiaryTissueObject.tissueGrid).length>0)){
                    if (typeof subsidiaryTissueObject.tissueGrid[tissueKey] !== 'undefined') {
                        followUpRowDataStructure.rowDecoration = 'border-bottom: solid 2px #bbb';
                        followUpRowDataStructure.tissueDescriptionClass = 'subsidiaryClass';
                        followUpRowDataStructure.tissueName = "("+tissueKey.replace(/_\d+/g,'')+")";
                        followUpRowDataStructure.cellsPerLine = [];
                        followUpRowDataStructure.annotationId = annotationId;
                        _.forEach(sortedVariants,function(variantRec){
                            followUpRowDataStructure.cellsPerLine.push (writeOneCellOfTheHeatMap(subsidiaryTissueObject.tissueGrid,tissueKey,subsidiaryTissueObject.quantileArray,variantRec));
                        });
                        tissueSpecificHeatMapDataStructure.tissueSpecificRow.push (followUpRowDataStructure);
                    }
                }


            });

        return tissueSpecificHeatMapDataStructure;

        };




        // the algorithm which aggregates the information across regions within a single tissue for a single assay
        // must be defined below
        var generateDataStructureForGeneBasedTissueSpecificHeatMap = function (primaryTissueObject, subsidiaryTissueObject, sortedGenes, annotationId){
            var tissueSpecificHeatMapDataStructure = { tissueSpecificRow: [] };
            _.forEach(primaryTissueObject.sortedTissues,function(tissueKey, index){
                var rowDataStructure = {    rowSpan:0,
                    createSpanningCell: function () {return (this.rowSpan > 0);}
                };
                if ( index === 0){
                    rowDataStructure.rowSpan = primaryTissueObject.sortedTissues.length+subsidiaryTissueObject.sortedTissues.length;
                }
                rowDataStructure.tissueName = tissueKey.replace(/_\d+/g,'');
                rowDataStructure.tissueDescriptionClass = 'credSetTissueLabel';
                rowDataStructure.cellsPerLine = [];
                rowDataStructure.annotationId = annotationId;
                _.forEach(sortedGenes,function(variantRec){
                    rowDataStructure.cellsPerLine.push(writeOneCellOfTheGeneBasedHeatMap(   primaryTissueObject.tissueGrid,
                                                                                            tissueKey,
                                                                                            primaryTissueObject.quantileArray,
                                                                                            variantRec,
                                                                                            primaryTissueObject.tissueGrid[tissueKey] ));
                });
                var drivingTissueRecordExists = false;
                if (rowDataStructure.cellsPerLine.length > 0){
                    if (!(((Object.keys(subsidiaryTissueObject.tissueGrid).length>0))&&(typeof subsidiaryTissueObject.tissueGrid[tissueKey] !== 'undefined'))){
                        rowDataStructure.rowDecoration  = 'border-bottom: solid 2px #bbb';
                    }
                    tissueSpecificHeatMapDataStructure.tissueSpecificRow.push (rowDataStructure);
                    drivingTissueRecordExists = true;
                }

                var followUpRowDataStructure = {    rowSpan:0,
                    createSpanningCell: function () {return (this.rowSpan > 0)}};
                // do we want to add a follow up lines?
                if (drivingTissueRecordExists&&(Object.keys(subsidiaryTissueObject.tissueGrid).length>0)){
                    if (typeof subsidiaryTissueObject.tissueGrid[tissueKey] !== 'undefined') {
                        followUpRowDataStructure.rowDecoration = 'border-bottom: solid 2px #bbb';
                        followUpRowDataStructure.tissueDescriptionClass = 'subsidiaryClass';
                        followUpRowDataStructure.tissueName = "("+tissueKey.replace(/_\d+/g,'')+")";
                        followUpRowDataStructure.cellsPerLine = [];
                        followUpRowDataStructure.annotationId = annotationId;
                        _.forEach(sortedVariants,function(variantRec){
                            followUpRowDataStructure.cellsPerLine.push (writeOneCellOfTheGeneBasedHeatMap(  subsidiaryTissueObject.tissueGrid,
                                                                                                            tissueKey,
                                                                                                            subsidiaryTissueObject.quantileArray,
                                                                                                            sortedGenes,
                                                                                                            primaryTissueObject.tissueGrid[tissueKey] ));
                        });
                        tissueSpecificHeatMapDataStructure.tissueSpecificRow.push (followUpRowDataStructure);
                    }
                }


            });

            return tissueSpecificHeatMapDataStructure;

        };





        //   At this point we have built a grid of all the tissues, and we have a sorted list of all the variants, and now we need to go through
        //   and map from tissues to variants and come up with something we can display as a heat map.
        var displayAParticularCredibleSet = function(tissueGrid, dataVariants, setDefaultButton, annotationId ){

            // In some cases we may have one primary tissue grid that drives the display, and a subsidiary tissue grid that is displayed only if
            // the primary tissue is displayed
            var primaryTissueGrid = {};
            var subsidiaryTissueGrid = {};

            // The logic ultimately employed is this: primaryTissueGrid tells us which tissues to display.  subsidiaryTissueGrid holds any additional tissues that we will display,
            //  which assumes that that tissue is already a primary tissue.
            primaryTissueGrid = filterTissueGrid(tissueGrid,getSelectorAssayIds());
            subsidiaryTissueGrid = filterSecondaryTissueGrid(tissueGrid,
                _.difference(getDisplayAssayIds(),getSelectorAssayIds()),primaryTissueGrid);


            var primaryTissueObject = extractValuesForTissueDisplay(primaryTissueGrid);
            var subsidiaryTissueObject = extractValuesForTissueDisplay(subsidiaryTissueGrid);

            var tissueSpecificDataStructure = generateDataStructureForTissueSpecificHeatMap(primaryTissueObject, subsidiaryTissueObject, dataVariants, annotationId );

            $('.credibleSetTableGoesHere tr:last').parent().append(
                Mustache.render( $('#credibleSetHeatMapTemplate')[0].innerHTML,tissueSpecificDataStructure));

            if (setDefaultButton){
                if ($('.credibleSetChooserButton').length > 1){
                    $($('.credibleSetChooserButton')[0]).click();
                }
            }


        };
        var displayTissuesForAnnotation = function (annotationId){
            $('tr.tissueHider_'+annotationId).show();
            $('button.tissueHide_'+annotationId).show();
            $('button.tissueDisplay_'+annotationId).hide();
        };
        var hideTissuesForAnnotation = function (annotationId){
            $('tr.tissueHider_'+annotationId).hide();
            $('button.tissueHide_'+annotationId).hide();
            $('button.tissueDisplay_'+annotationId).show();
        };

        var aggregateAcrossTissues = function (renderData,assayName,annotationId){
            var assayName = retrieveDesiredAssay (annotationId).name;
            var aggregatedRenderData = {assaySpecificRow:[]};
            var aggregatedRow = {assayName:assayName,expandTissues:'disable'};
            var aggregatedCells = [];
            var finalAggregation = [];
            _.forEach(renderData.tissueSpecificRow, function(row, index){
                if (index === 0) {
                    aggregatedRow ['annotationId'] = annotationId;
                    aggregatedRow ['rowDecoration'] = row['rowDecoration'];
                    aggregatedRow ['rowSpan'] = 1;
                    aggregatedRow ['tissueDescriptionClass'] = row['tissueDescriptionClass'];
                    if (row.cellsPerLine.length>0){
                        aggregatedRow ['expandTissues'] = '';
                    }


                    _.forEach(row.cellsPerLine, function (singleCell,i){
                        if ((aggregatedRow ['assayName'] === assayName)  && (singleCell.annotation!==0)){
                            aggregatedRow ['assayName'] = retrieveDesiredAssay (singleCell.annotation).name;
                        }
                        aggregatedCells.push([singleCell]);
                    });
                } else {
                    _.forEach(row.cellsPerLine, function (singleCell,i){
                        aggregatedCells[i].push(singleCell);
                    });
                }
            });
            _.forEach(aggregatedCells, function(arrayOfCells){
                var objectHolder = {};
                var tissueCount = 0;
                var allObjects = [];
                var allGenes = [];
                var allTissues = [];
                var uniqueGenes = [];
                var uniqueTissues = [];
                _.forEach(arrayOfCells, function (cell){
                    if(cell.annotation !== 0){
                        tissueCount++;
                        allObjects.push (cell);
                         if((typeof cell.gene !== 'undefined')&&(cell.gene!==null)&&(cell.gene!=='')) {
                             allGenes.push(cell.gene);
                         }
                        if((typeof cell.tissue !== 'undefined')&&(cell.tissue!==null)&&(cell.tissue!=='')) {
                            allTissues.push(cell.tissue);
                        }
                        objectHolder = {matchingRegion:'informationIsPresent',
                            title:cell.title};
                        uniqueGenes = _.uniq(allGenes);
                        uniqueTissues = _.uniq(allTissues);
                        if (uniqueGenes.length>0){
                            var geneTitle = 'Gene';
                            if (uniqueGenes.length>1){geneTitle+='s'};
                            objectHolder ['genes'] = '<span style="text-decoration: underline">'+geneTitle+'</span><br/>'+uniqueGenes.join(',<br/>');
                        }
                        if (uniqueTissues.length>0){
                            var tissueTitle = 'Tissue';
                            if (uniqueTissues.length>1){tissueTitle+='s'};
                            objectHolder ['tissues'] = '<span style="text-decoration: underline">'+tissueTitle+'</span><br/>'+uniqueTissues.join(',<br/>');
                        }

                    }
                });
                if ((uniqueGenes.length>0)&&(uniqueTissues.length>0)){
                    objectHolder['countDivider'] = '\r';
                }

                if (uniqueGenes.length>0){
                    objectHolder['geneCount'] = "G:"+uniqueGenes.length;
                }
                if (tissueCount>0) {
                    objectHolder['tissueCount'] = "T:"+uniqueTissues.length;
                }
                finalAggregation.push(objectHolder);
            });
            aggregatedRenderData.cellsPerLine = finalAggregation;
            aggregatedRenderData.assaySpecificRow = aggregatedRow;
            return aggregatedRenderData;
        };


        var displayAggregatedDataPerAssayId = function(tissueGrid, sortedVariants, assayIdArray, setDefaultButton ){

            var subsidiaryTissueGrid = {tissueGrid:[],sortedTissues:[]};
            var primaryTissueGrid = filterTissueGrid(tissueGrid,assayIdArray);

            var primaryTissueObject = extractValuesForTissueDisplay(primaryTissueGrid);

            var tissueSpecificDataStructure = generateDataStructureForTissueSpecificHeatMap(primaryTissueObject, subsidiaryTissueGrid, sortedVariants, assayIdArray[0] );
            var aggregatedAcrossTissue = aggregateAcrossTissues(tissueSpecificDataStructure,'assayname',assayIdArray[0]);


            $('.credibleSetTableGoesHere tr:last').parent().append(
                Mustache.render( $('#heatMapAggregatedAcrossTissueTemplate')[0].innerHTML,aggregatedAcrossTissue));
            $('.credibleSetTableGoesHere tr:last').parent().append(
                Mustache.render( $('#credibleSetHeatMapTemplate')[0].innerHTML,tissueSpecificDataStructure));
            $('tr.tissueHider_'+assayIdArray[0]).hide();

            if (setDefaultButton){
                if ($('.credibleSetChooserButton').length > 1){
                    $($('.credibleSetChooserButton')[0]).click();
                }
            }


        };

        var displayAggregatedGenesPerAssayId = function(tissueGrid, sortedGenes, assayIdArray, setDefaultButton ){

            var subsidiaryTissueGrid = {tissueGrid:[],sortedTissues:[]};
            var primaryTissueGrid = filterTissueGrid(tissueGrid,assayIdArray);

            var primaryTissueObject = extractValuesForTissueDisplay(primaryTissueGrid);

            var tissueSpecificDataStructure = generateDataStructureForGeneBasedTissueSpecificHeatMap(primaryTissueObject, subsidiaryTissueGrid, sortedGenes, assayIdArray[0] );
            var aggregatedAcrossTissue = aggregateAcrossTissues(tissueSpecificDataStructure,'assayname',assayIdArray[0]);


            $('.credibleSetTableGoesHere tr:last').parent().append(
                Mustache.render( $('#heatMapAggregatedAcrossTissueTemplate')[0].innerHTML,aggregatedAcrossTissue));
            $('.credibleSetTableGoesHere tr:last').parent().append(
                Mustache.render( $('#credibleSetHeatMapTemplate')[0].innerHTML,tissueSpecificDataStructure));
            $('tr.tissueHider_'+assayIdArray[0]).hide();

            if (setDefaultButton){
                if ($('.credibleSetChooserButton').length > 1){
                    $($('.credibleSetChooserButton')[0]).click();
                }
            }


        };




        var setIncludeRecordBasedOnUserChoice = function(assayIdList){

            mpgSoftware.regionInfo.includeRecordBasedOnUserChoice = function(o) {
                var selectedElements = getSelectedValuesAndText();
                var assayInformation = getAssayInformation();
                var chosenElementTypes = [];
                var retval = false;
                _.forEach(selectedElements,function(oe){
                    var assay = _.find(assayInformation,{'assayID':o.ANNOTATION});
                    if (typeof assay === 'undefined') {
                        retval = false;
                    } else {
                        if (assay.selectionOptions.length>1){// it's a categorical type
                            chosenElementTypes.push(oe.name);
                        } else { // it's not categorical
                            retval = true;
                        }
                    }
                });
                if (retval) {
                    return true;
                } else {
                    return ((chosenElementTypes.indexOf(o.ELEMENT)>-1));
                }

            };

            return mpgSoftware.regionInfo.includeRecordBasedOnUserChoice;
        };

        var fillRegionInfoTable = function(vars,additionalParameters) {
            setIncludeRecordBasedOnUserChoice(additionalParameters.assayIdList);
            var currentSequenceExtents = getCurrentSequenceExtents();
            var geneTablePresentation = false;
            var urlForDataRecall = vars.fillCredibleSetTableUrl;
            if ((typeof vars.geneTable !== 'undefined')  &&
                (vars.geneTable)){
                urlForDataRecall = vars.fillGeneComparisonTableUrl;
                geneTablePresentation = true;
            }
            if (!isNaN(currentSequenceExtents.start)){vars.start=currentSequenceExtents.start}
            if (!isNaN(currentSequenceExtents.end)){vars.end=currentSequenceExtents.end}
            var promise = $.ajax({
                cache: false,
                type: "post",
                url: urlForDataRecall,
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
                    var drivingVariables;
                    if (geneTablePresentation){
                        drivingVariables = buildRenderDataForGenes(data,additionalParameters);
                    } else {
                        drivingVariables = buildRenderData(data,additionalParameters);
                    }
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

                    // What we need is a listing of all of the variants inside each credible set which we can pass to LZ
                    var variantToCredSetMap = _.map(drivingVariables.variants,function(v,k){return {"VAR_ID":v.details.VAR_ID,
                        "CREDIBLE_SET_ID":( (typeof v.details.CREDIBLE_SET_ID === 'undefined')?'none':v.details.CREDIBLE_SET_ID)}});
                    var credSetToVariants = {};
                    _.forEach(variantToCredSetMap,function(objWithIdAndCredSet){
                        var credSetId;
                        if ($.type(objWithIdAndCredSet.CREDIBLE_SET_ID)==="string"){
                            credSetId = objWithIdAndCredSet.CREDIBLE_SET_ID;
                        } else {
                            _.forEach(objWithIdAndCredSet.CREDIBLE_SET_ID,function(credSetVal,credSetKey){
                                _.forEach(credSetVal,function(credSetName,phenotypeName){
                                    credSetId = credSetName;
                                });
                            });
                        }
                        if ( typeof credSetToVariants[credSetId] === 'undefined'){
                            credSetToVariants[credSetId] = [objWithIdAndCredSet.VAR_ID];
                        } else {
                            credSetToVariants[credSetId].push(objWithIdAndCredSet.VAR_ID);
                        }
                    });
                    var sortedByKey = [];
                    _.forEach(Object.keys(credSetToVariants).sort(), function(key) {
                        sortedByKey.push({"credSetName":key,"varIds":credSetToVariants[key]});
                    });


                    var chromosome = (additionalParameters.geneChromosome.length>3)?additionalParameters.geneChromosome.substr(3):additionalParameters.geneChromosome;
                    mpgSoftware.geneSignalSummaryMethods.lzOnCredSetTab(additionalParameters,{
                        positioningInformation:{
                            chromosome:chromosome,
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
                        maximumNumberOfResults:maximumNumberOfResults,
                        credSetToVariants:sortedByKey
                    });

                    if (geneTablePresentation){
                        buildTheGeneHeatMap(drivingVariables,true);
                    } else {
                        buildTheCredibleSetHeatMap(drivingVariables,true);
                    }


                    $('#credSetSelectorChoice').multiselect({includeSelectAllOption: true,
                        allSelectedText: 'All Selected',
                        buttonWidth: '60%',onChange: function() {
                            console.log($('#credSetSelectorChoice').val());
                        }});
                    $('#credSetSelectorChoice').val(mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters,0));
                    $('#credSetDisplayChoice').multiselect({includeSelectAllOption: true,
                        buttonWidth: '60%'});
                    $('#credSetDisplayChoice').val(mpgSoftware.regionInfo.getDefaultTissueRegionOverlapMatcher(additionalParameters,1));
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
            specificHeaderToBeActiveByVarId:specificHeaderToBeActiveByVarId,
            initializeRegionInfoModule:initializeRegionInfoModule,
            retrieveDesiredAssay:retrieveDesiredAssay,
            displayTissuesForAnnotation: displayTissuesForAnnotation,
            hideTissuesForAnnotation: hideTissuesForAnnotation

    }

    })();



})();
