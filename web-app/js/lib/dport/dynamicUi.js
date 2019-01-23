var mpgSoftware = mpgSoftware || {};

/***
 * Rules:
 *   setAccumulatorObject should be done within processRecordXXX
 *   resetAccumulatorObject should be done within modifyScreenFields
 *
 *   challenge: sometimes one Ajax call must proceed another.  How to organize this in an elegant way?
 *      Each call might have dependencies in the accumulatorObject.
 *      Each call might set one or more fields in the accumulator object.
 *
 *
 * @type {{installDirectorButtonsOnTabs, modifyScreenFields, adjustLowerExtent, adjustUpperExtent}}
 */


mpgSoftware.dynamicUi = (function () {
    var loading = $('#rSpinner');
    var commonTable;
    var dyanamicUiVariables;
var clearBeforeStarting = false;

    var setDyanamicUiVariables = function(incomingDyanamicUiVariables){
        dyanamicUiVariables = incomingDyanamicUiVariables;
    };

    var getDyanamicUiVariables = function(){
        return dyanamicUiVariables;
    };



    var actionDefaultFollowUp =  function(actionId ) {
        var defaultFollowUp = {
            displayRefinedContextFunction : undefined,
            placeToDisplayData: undefined,
            actionId: undefined
        };
        switch(actionId){

            case "getTissuesFromProximityForLocusContext":
                defaultFollowUp.displayRefinedContextFunction =  displayRefinedGenesInARange;
                defaultFollowUp.placeToDisplayData =  '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getTissuesFromEqtlsForTissuesTable":
                defaultFollowUp.displayRefinedContextFunction =  displayGenesPerTissueFromEqtl;
                defaultFollowUp.placeToDisplayData =  '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getTissuesFromEqtlsForGenesTable":
                defaultFollowUp.displayRefinedContextFunction =  displayTissuesPerGeneFromEqtl;
                defaultFollowUp.placeToDisplayData =  '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getVariantsFromQtlForContextDescription":
                defaultFollowUp.displayRefinedContextFunction =  displayVariantRecordsFromVariantQtlSearch;
                defaultFollowUp.placeToDisplayData =  '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromQtlForPhenotypeTable":
                defaultFollowUp.displayRefinedContextFunction =  displayPhenotypeRecordsFromVariantQtlSearch;
                defaultFollowUp.placeToDisplayData =  '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromECaviarForPhenotypeTable":
                defaultFollowUp.displayRefinedContextFunction =  displayPhenotypesFromColocalization;
                defaultFollowUp.placeToDisplayData =  '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromECaviarForTissueTable":
                defaultFollowUp.displayRefinedContextFunction =  displayTissuesFromColocalization;
                defaultFollowUp.placeToDisplayData =  '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getRecordsFromECaviarForGeneTable":
                defaultFollowUp.displayRefinedContextFunction =  displayGenesFromColocalization;
                defaultFollowUp.placeToDisplayData =  '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getAnnotationsFromModForGenesTable":
                defaultFollowUp.displayRefinedContextFunction =  displayRefinedModContext;
                defaultFollowUp.placeToDisplayData =  '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "replaceGeneContext":
                defaultFollowUp.displayRefinedContextFunction =  displayRangeContext;
                defaultFollowUp.placeToDisplayData =  '#contextDescription';
                break;

            case "getTissuesFromAbcForGenesTable":
                defaultFollowUp.displayRefinedContextFunction =  displayGenesFromAbc;
                defaultFollowUp.placeToDisplayData =  '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getRecordsFromAbcForTissueTable":
                defaultFollowUp.displayRefinedContextFunction =  displayTissuesFromAbc;
                defaultFollowUp.placeToDisplayData =  '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getVariantsWeWillUseToBuildTheVariantTable":
                defaultFollowUp.displayRefinedContextFunction =  displayVariantsForAPhenotype;
                defaultFollowUp.placeToDisplayData =  '#dynamicVariantHolder div.dynamicUiHolder';

            default:
                break;
        }
        return defaultFollowUp;
    }





    var actionContainer =  function(actionId, followUp ){
        var additionalParameters = getDyanamicUiVariables();
        var displayFunction = ( typeof followUp.displayRefinedContextFunction !== 'undefined') ?  followUp.displayRefinedContextFunction : undefined;
        var displayLocation= ( typeof followUp.placeToDisplayData !== 'undefined') ?  followUp.placeToDisplayData : undefined;
        var nextActionId= ( typeof followUp.actionId !== 'undefined') ?  followUp.actionId : undefined;
        var functionToLaunchDataRetrieval;

        switch(actionId){

            case "getTissuesFromProximityForLocusContext":
                functionToLaunchDataRetrieval = function(){
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    retrieveRemotedContextInformation(buildRemoteContextArray ({
                        name:"getTissuesFromProximityForLocusContext",
                        retrieveDataUrl:additionalParameters.retrieveListOfGenesInARangeUrl,
                        dataForCall:{
                            chromosome: chromosome,
                            startPos: startPos,
                            endPos: endPos
                        },
                        processEachRecord:processRecordsFromProximitySearch,
                        displayRefinedContextFunction:displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId:nextActionId
                    }));
                };
                break;

            case "getTissuesFromEqtlsForTissuesTable":
                functionToLaunchDataRetrieval = function() {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getTissuesFromEqtlsForTissuesTable"});
                        actionToUndertake();
                    } else {
                        resetAccumulatorObject("tissueNameArray");
                        resetAccumulatorObject("tissuesForEveryGene");
                        resetAccumulatorObject("genesForEveryTissue");
                        //var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                        var geneNameArray = _.map(getAccumulatorObject("geneInfoArray"),function(o){return {gene:o.name}});
                        retrieveRemotedContextInformation(buildRemoteContextArray ({
                            name:"getTissuesFromEqtlsForTissuesTable",
                            retrieveDataUrl:additionalParameters.retrieveEqtlDataUrl,
                            dataForCall:geneNameArray,
                            processEachRecord:processRecordsFromEqtls,
                            displayRefinedContextFunction:displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId:nextActionId
                        }));
                    }
                }
                break;

            case "getTissuesFromEqtlsForGenesTable":
                functionToLaunchDataRetrieval = function(){
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getTissuesFromEqtlsForGenesTable"});
                        actionToUndertake();
                    } else {
                        resetAccumulatorObject("tissueNameArray");
                        resetAccumulatorObject("genesForEveryTissue");
                        resetAccumulatorObject("tissuesForEveryGene");
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                        retrieveRemotedContextInformation(buildRemoteContextArray ({
                            name:"getTissuesFromEqtlsForGenesTable",
                            retrieveDataUrl:additionalParameters.retrieveEqtlDataUrl,
                            dataForCall:geneNameArray,
                            processEachRecord:processRecordsFromEqtls,
                            displayRefinedContextFunction:displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId:nextActionId
                        }));
                    }
                };
                break;

            case "getVariantsFromQtlForContextDescription":
                functionToLaunchDataRetrieval = function() {
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    resetAccumulatorObject("phenotypesForEveryVariant");
                    resetAccumulatorObject("variantsForEveryPhenotype");
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getVariantsFromQtlForContextDescription",
                        retrieveDataUrl: additionalParameters.retrieveVariantsWithQtlRelationshipsUrl,
                        dataForCall: {
                            chromosome: chromosome,
                            startPos: startPos,
                            endPos: endPos
                        },
                        processEachRecord: processRecordsFromVariantQtlSearch,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));
                };
                break;

            case "getPhenotypesFromQtlForPhenotypeTable":
                functionToLaunchDataRetrieval = function(){
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    resetAccumulatorObject("phenotypesForEveryVariant");
                    resetAccumulatorObject("variantsForEveryPhenotype");
                    retrieveRemotedContextInformation(buildRemoteContextArray ({
                        name:"getPhenotypesFromQtlForPhenotypeTable",
                        retrieveDataUrl:additionalParameters.retrieveVariantsWithQtlRelationshipsUrl,
                        dataForCall:{
                            chromosome: chromosome,
                            startPos: startPos,
                            endPos: endPos
                        },
                        processEachRecord:processRecordsFromVariantQtlSearch,
                        displayRefinedContextFunction:displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId:nextActionId
                    }));
                };
                break;


            case "getPhenotypesFromECaviarForPhenotypeTable":
                functionToLaunchDataRetrieval = function(){
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                    retrieveRemotedContextInformation(buildRemoteContextArray ({
                        name:"getPhenotypesFromECaviarForPhenotypeTable",
                        retrieveDataUrl:additionalParameters.retrieveECaviarDataUrl,
                        dataForCall:geneNameArray,
                        processEachRecord:processRecordsFromColocalization,//TODO
                        displayRefinedContextFunction:displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId:nextActionId
                    }));
                };
                break;

            case "getPhenotypesFromECaviarForTissueTable":
                functionToLaunchDataRetrieval = function(){
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getPhenotypesFromECaviarForTissueTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                        retrieveRemotedContextInformation(buildRemoteContextArray ({
                            name:"getPhenotypesFromECaviarForPhenotypeTable",
                            retrieveDataUrl:additionalParameters.retrieveECaviarDataUrl,
                            dataForCall:geneNameArray,
                            processEachRecord:processRecordsFromColocalization,
                            displayRefinedContextFunction:displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId:nextActionId
                        }));

                    }
                };
                break;

            case "getRecordsFromECaviarForGeneTable":
                functionToLaunchDataRetrieval = function(){
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getRecordsFromECaviarForGeneTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                        retrieveRemotedContextInformation(buildRemoteContextArray ({
                            name:"getRecordsFromECaviarForGeneTable",
                            retrieveDataUrl:additionalParameters.retrieveECaviarDataUrl,
                            dataForCall:geneNameArray,
                            processEachRecord:processRecordsFromColocalization,
                            displayRefinedContextFunction:displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId:nextActionId
                        }));
                    }
                };
                break;


            case "getAnnotationsFromModForGenesTable":
                functionToLaunchDataRetrieval = function(){
                    resetAccumulatorObject("modNameArray");
                    var geneNameArray = _.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}});
                    retrieveRemotedContextInformation(buildRemoteContextArray ({
                        name:"getAnnotationsFromModForGenesTable",
                        retrieveDataUrl:additionalParameters.retrieveModDataUrl,
                        dataForCall:geneNameArray,
                        processEachRecord:processRecordsFromMod,
                        displayRefinedContextFunction:displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId:nextActionId
                    }));
                };
                break;

            case "replaceGeneContext":
                functionToLaunchDataRetrieval = function(){
                    var somethingSymbol = $('#inputBoxForDynamicContextId').val();
                    somethingSymbol = somethingSymbol.replace(/\//g,"_");
                    setAccumulatorObject("geneNameArray",[{name:somethingSymbol}]);
                    retrieveRemotedContextInformation(buildRemoteContextArray ({
                        name:"replaceGeneContext",
                        retrieveDataUrl:additionalParameters.geneInfoAjaxUrl,
                        dataForCall:{geneName:somethingSymbol},
                        processEachRecord:processRecordsUpdateContext,
                        displayRefinedContextFunction:displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId:nextActionId
                    }));
                };
                break;

            case "getTissuesFromAbcForGenesTable":
                functionToLaunchDataRetrieval = function(){
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getTissuesFromAbcForGenesTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        geneNameArray = _.map(getAccumulatorObject("geneInfoArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getTissuesFromAbcForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveAbcDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromAbc,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                 break;

            case "getRecordsFromAbcForTissueTable":
                functionToLaunchDataRetrieval = function(){
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId:"getRecordsFromAbcForTissueTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getTissuesFromAbcForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveAbcDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromAbc,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;

            case "getVariantsWeWillUseToBuildTheVariantTable":
                functionToLaunchDataRetrieval = function(){

                    var phenotype = $('li.chosenPhenotype').attr('id');
                    var chromosome = $('span.dynamicUiChromosome').text();
                    var startExtent = $('span.dynamicUiGeneExtentBegin').text();
                    var endExtent = $('span.dynamicUiGeneExtentBegin').text();
                    var dataNecessaryToRetrieveVariantsPerPhenotype;
                    if (( typeof phenotype === 'undefined') ||
                        (typeof chromosome === 'undefined') ||
                        (typeof startExtent === 'undefined') ||
                        (typeof endExtent === 'undefined') ){
                        alert(" missing a value when we want to collect variants for a phenotype");
                    }else{
                        dataNecessaryToRetrieveVariantsPerPhenotype = {
                            phenotype: phenotype,
                            geneToSummarize: "chr"+chromosome+ ":"+startExtent+":"+endExtent
                        }

                    }


                    retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getTissuesFromAbcForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveTopVariantsAcrossSgsUrl,
                            dataForCall: dataNecessaryToRetrieveVariantsPerPhenotype,
                            processEachRecord: processRecordsFromQtl,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));

                };
                break;


            default:
                break;
        }

        return functionToLaunchDataRetrieval;
    };


    /***
     *
     * @param data
     * @returns {{geneName: undefined, chromosome: undefined, extentBegin: undefined, extentEnd: undefined}}
     */
    var processRecordsUpdateContext = function (data){
        var returnObject = {geneName: undefined,
            chromosome : undefined,
            extentBegin : undefined,
            extentEnd : undefined,
        };
        if (( typeof data !== 'undefined')&&
            ( typeof data.geneInfo !== 'undefined')){
            returnObject.geneName = data.geneInfo.Gene_name;
            returnObject.chromosome = data.geneInfo.CHROM;
            returnObject.extentBegin = data.geneInfo.BEG-1;
            returnObject.extentEnd = data.geneInfo.END+1;
        }
        return returnObject;
    };
    var displayRangeContext = function(idForTheTargetDiv,objectContainingRetrievedRecords){
        $(idForTheTargetDiv).empty().append(Mustache.render($('#contextDescriptionSection')[0].innerHTML,
            objectContainingRetrievedRecords
        ));
        setAccumulatorObject( "extentBegin", objectContainingRetrievedRecords.extentBegin );
        setAccumulatorObject( "extentEnd", objectContainingRetrievedRecords.extentEnd );
        setAccumulatorObject( "chromosome", objectContainingRetrievedRecords.chromosome );
        setAccumulatorObject( "originalGeneName", objectContainingRetrievedRecords.geneName );

        addAdditionalResultsObject({rangeContext:{
                extentBegin:objectContainingRetrievedRecords.extentBegin,
                extentEnd:objectContainingRetrievedRecords.extentEnd,
                chromosome:objectContainingRetrievedRecords.chromosome,
                geneName:objectContainingRetrievedRecords.geneName
    }})
    }


    /***
     * Mod annotation search
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var processRecordsFromMod = function (data){
        var returnObject = {rawData:[],
            uniqueGenes:[],
            uniqueMods:[]};
        var originalGene = data.gene;
        if (data.records.length===0){
            // no mods.  add an empty record for this gene to the global structure
            var modNameArray =  getAccumulatorObject("modNameArray");
            modNameArray.push({geneName:originalGene,mods:[]});
            setAccumulatorObject("modNameArray",modNameArray);
            if (!returnObject.uniqueGenes.includes(originalGene)){
                returnObject.uniqueGenes.push(originalGene);
            };
        } else {
            // we have mods for this gene. First let's save them
            _.forEach(data.records,function(oneRec){
                if (!returnObject.uniqueGenes.includes(oneRec.Human_gene)){
                    returnObject.uniqueGenes.push(oneRec.Human_gene);
                };
                if (!returnObject.uniqueMods.includes(oneRec.Term)){
                    returnObject.uniqueMods.push(oneRec.Term);
                };
                returnObject.rawData.push(oneRec);
            });
            // now let's add them to our global structure.  First, find any record for this gene that we might already have
            var geneIndex = _.findIndex(getAccumulatorObject("modNameArray"),{geneName:originalGene});
            if (geneIndex<0){ // this is the only path we ever take, right
                var modNameArray =  getAccumulatorObject("modNameArray");
                modNameArray.push({geneName:originalGene,
                    mods:returnObject.uniqueMods});
                setAccumulatorObject("modNameArray",modNameArray);
            } else{ // we already know about this tissue, but have we seen this gene associated with it before?
                alert('this never happens, I think');
                var tissueRecord = getAccumulatorObject("modNameArray")[geneIndex];
                _.forEach(uniqueMods,function(oneMod){
                    if (!tissueRecord.mods.includes(oneMod)){
                        tissueRecord.mods.push(oneMod);
                    }
                });
            }
        }
        return returnObject;
    };
    var displayRefinedModContext = function (idForTheTargetDiv,objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(getAccumulatorObject("modNameArray"), function (geneWithMods) {
            returnObject.uniqueGenes.push({name:geneWithMods.geneName});

            var recordToDisplay = { mods:[],
                                    geneName: geneWithMods.geneName };
            _.forEach(geneWithMods.mods,function(eachMod){
                recordToDisplay.mods.push({modName:eachMod})
            });
            returnObject.geneModTerms.push(recordToDisplay);

        });

        addAdditionalResultsObject({refinedModContext:returnObject});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",'#dynamicGeneTable',returnObject,clearBeforeStarting);
        // $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
        //     returnObject
        // ));
    };

    /***
     * The object is passed into mustache and describes the display that will be presented to users
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueEqtlGenes: Array, genePositions: Array, uniqueTissues: Array, geneTissueEqtls: Array, geneModTerms: Array, genesPositionsExist: (function(): *), genesExist: (function(): *), tissuesExist: (function(): *), eqtlTissuesExist: (function(): *), eqtlGenesExist: (function(): *), geneModsExist: (function(): *)}}
     */
    var createNewDisplayReturnObject = function(){
        return {rawData:[],
            uniqueGenes:[],
            uniqueEqtlGenes:[],
            genePositions:[],
            uniqueTissues:[],
            uniquePhenotypes:[],
            uniqueVariants: [],
            geneTissueEqtls:[],
            variantPhenotypeQtl:[],
            phenotypeVariantQtl:[],
            geneModTerms:[],
            phenotypesByColocalization:[],
            genesByAbc:[],
            tissuesByAbc:[],
            variantsToAnnotate: [],
            genesPositionsExist:function(){
                return (this.genePositions.length>0)?[1]:[];
            },
            genesExist:function(){
                return (this.uniqueGenes.length>0)?[1]:[];
            },
            variantsExist:function(){
                return (this.uniqueVariants.length>0)?[1]:[];
            },
            phenotypesExist:function(){
                return (this.uniquePhenotypes.length>0)?[1]:[];
            },
            tissuesExist:function(){
                return (this.uniqueTissues.length>0)?[1]:[];
            },
            eqtlTissuesExist:function(){
                return (this.uniqueEqtlGenes.length>0)?[1]:[];
            },
            eqtlGenesExist:function(){
                return (this.geneTissueEqtls.length>0)?[1]:[];
            },
            geneModsExist:function(){
                return (this.geneModTerms.length>0)?[1]:[];
            },
            variantPhenotypesExist:function(){
                return (this.variantPhenotypeQtl.length>0)?[1]:[];
            },
            phenotypeVariantsExist:function(){
                return (this.phenotypeVariantQtl.length>0)?[1]:[];
            }

        };
    };

    /***
     * Default value of the shared accumulator object
     * @param additionalParameters
     * @returns {{extentBegin: (*|jQuery), extentEnd: (*|jQuery), chromosome: string, originalGeneName: *, geneNameArray: Array, tissueNameArray: Array, modNameArray: Array, mods: Array, contextDescr: {chromosome: string, extentBegin: (*|jQuery), extentEnd: (*|jQuery), moreContext: Array}}}
     */
    var sharedAccumulatorObject = function (additionalParameters){
        var chrom=(additionalParameters.geneChromosome.indexOf('chr')>-1)?
            additionalParameters.geneChromosome.substr(3):
            additionalParameters.geneChromosome;
        return {
            extentBegin:additionalParameters.geneExtentBegin,
            extentEnd:additionalParameters.geneExtentEnd,
            chromosome:chrom,
            originalGeneName:additionalParameters.geneName,
            rawQtlInfo:{},
            geneNameArray:[],
            tissueNameArray:[],
            tissuesForEveryGene:[],
            genesForEveryTissue:[],
            modNameArray:[],
            mods:[],
            phenotypesForEveryVariant:[],
            variantsForEveryPhenotype:[],
            rawColocalizationInfo:[],
            rawAbcInfo:[],
            geneInfoArray:[]
        };
    };

    /***
     * retrieve the accumulator object, pulling back a specified field if requested
     * @param chosenField
     * @returns {jQuery}
     */
    var getAccumulatorObject = function (chosenField){
        var returnValue = $("#configurableUiTabStorage").data("dataHolder");
        if ( typeof returnValue === 'undefined'){
            alert('Fatal error.  Malfunction is imminent. Missing accumulator object.');
            return;
        }
        if ( typeof chosenField !== 'undefined'){
            returnValue = returnValue[chosenField];
        }
        return returnValue
    };

    /***
     * store the accumulator object in the DOM
     * @param accumulatorObject
     * @returns {*}
     */
    var setAccumulatorObject = function (specificField, value){
        if ( typeof specificField === 'undefined'){
            alert("Serious error.  Attempted assignment of unspecified field.");
            return;
        }
        getAccumulatorObject()[specificField]=value;
        return getAccumulatorObject(specificField);
    };

    /***
     * Reset the chosen field in the accumulator object to its default value. If no field is specified then reset the entire
     * accumulator object to its default.
     */
    var resetAccumulatorObject =  function(specificField){
        var additionalParameters = getDyanamicUiVariables();
        var filledOutSharedAccumulatorObject = sharedAccumulatorObject(additionalParameters);
        if ( typeof specificField !== 'undefined'){
            if ( typeof filledOutSharedAccumulatorObject === 'undefined'){
                alert(" Unexpected absence of field '"+specificField+"' in shared accumulator object");
            }
            getAccumulatorObject()[specificField]=filledOutSharedAccumulatorObject[specificField]
        } else {
            $("#configurableUiTabStorage").data("dataHolder", filledOutSharedAccumulatorObject);
        }
    };


    var addAdditionalResultsObject =  function(returnObject) {
        var resultsArray = getAccumulatorObject("resultsArray");
        if (typeof resultsArray === 'undefined') {
            setAccumulatorObject("resultsArray", []);
            resultsArray = getAccumulatorObject("resultsArray");
        }
        resultsArray.push(returnObject);
    };


    var accumulatorObjectFieldEmpty = function(specificField) {
        var returnValue = true;
        var accumulatorObjectField = getAccumulatorObject(specificField);
        if (Array.isArray(accumulatorObjectField)){
            if (accumulatorObjectField.length>0){
                returnValue = false;
            }
        }
        return returnValue;
    };

    /***
     * Need to build an intermediate data structure. It'll be an object but looks like this:
     * headerNames: ['Header name 1','header name 2']
     * headerContents: [' HTML for a header',' HTML for a header']
     * headers: { name: 'index name of header',
     *              contents: 'display HTML for header' }
     * rowsToAdd:  [ { category: 'name for first column',
     *                 subcategory: 'name for second column',
     *                 columnCells:  [  {'Header name 1':' HTML for a cell'},
     *                                  {'header name 2':' HTML for a cell'} ]
     * @param idForTheTargetDiv
     * @param templateInfo
     * @param returnObject
     * @param clearBeforeStarting
     */
    var prepareToPresentToTheScreen = function(idForTheTargetDiv,templateInfo,returnObject,clearBeforeStarting) {
        if (clearBeforeStarting){
            $(idForTheTargetDiv).empty();
        }
        var intermediateDataStructure = {   headerNames: [],
                                            headerContents: [],
                                            headers: [],
                                            rowsToAdd: []     };

        // Mod data for the gene table
        if (returnObject.genesExist()){
            intermediateDataStructure.rowsToAdd.push ({ category: 'Annotation',
                                                        subcategory: 'MOD',
                                                        columnCells:  []});
            _.forEach(returnObject.uniqueGenes, function (uniqueGene){
                intermediateDataStructure.headerNames.push (uniqueGene.name);
                intermediateDataStructure.headerContents.push (Mustache.render($("#dynamicGeneTableHeader")[0].innerHTML,uniqueGene));
                intermediateDataStructure.headers.push({name:uniqueGene.name,
                                                   contents:Mustache.render($("#dynamicGeneTableHeader")[0].innerHTML,uniqueGene)} );
                intermediateDataStructure.rowsToAdd[0].columnCells.push ("");
            });

        }
        if (( typeof returnObject.geneModsExist !== 'undefined') && ( returnObject.geneModsExist())){

            _.forEach(returnObject.geneModTerms, function (recordsPerGene){
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames,recordsPerGene.geneName);
                if (indexOfColumn===-1){
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                }else {
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn]  = Mustache.render($("#dynamicGeneTableBody")[0].innerHTML,recordsPerGene);
                }
            });
            buildOrExtendDynamicTable("table.combinedGeneTableHolder",intermediateDataStructure);
        }

        //ABC data for the gene table
        if (( typeof returnObject.abcGenesExist !== 'undefined') && ( returnObject.abcGenesExist())){
            intermediateDataStructure.rowsToAdd.push ({ category: 'Annotation',
                subcategory: 'ABC',
                columnCells:  []});
            // set up the headers, and give us an empty row of column cells
            _.forEach(returnObject.genesByAbc, function (oneRecord){
                intermediateDataStructure.headerNames.push (oneRecord.geneName);
                intermediateDataStructure.headerContents.push (Mustache.render($("#dynamicAbcGeneTableHeader")[0].innerHTML,oneRecord));
                intermediateDataStructure.headers.push({name:oneRecord.geneName,
                    contents:Mustache.render($("#dynamicAbcGeneTableHeader")[0].innerHTML,oneRecord)} );
                intermediateDataStructure.rowsToAdd[0].columnCells.push ("");
            });

                // fill in all of the column cells
            _.forEach(returnObject.genesByAbc, function (recordsPerGene){
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames,recordsPerGene.geneName);
                if (indexOfColumn===-1){
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                }else {
                    recordsPerGene["numberOfTissues"] = recordsPerGene.source.length;
                    recordsPerGene["numberOfExperiments"] = recordsPerGene.experiment.length;
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn]  = Mustache.render($("#dynamicAbcGeneTableBody")[0].innerHTML,recordsPerGene);
                }
            });
            buildOrExtendDynamicTable("table.combinedGeneTableHolder",intermediateDataStructure);

        }

        //eQTL data for the gene table
        if (( typeof returnObject.eqtlTissuesExist !== 'undefined') && ( returnObject.eqtlTissuesExist())){
            intermediateDataStructure.rowsToAdd.push ({ category: 'Annotation',
                subcategory: 'eQTL',
                columnCells:  []});
            // set up the headers, and give us an empty row of column cells
            _.forEach(returnObject.uniqueEqtlGenes, function (oneRecord){
                intermediateDataStructure.headerNames.push (oneRecord.geneName);
                intermediateDataStructure.headerContents.push (Mustache.render($("#dynamicGeneTableEqtlHeader")[0].innerHTML,oneRecord));
                intermediateDataStructure.headers.push({name:oneRecord.geneName,
                    contents:Mustache.render($("#dynamicGeneTableEqtlHeader")[0].innerHTML,oneRecord)} );
                intermediateDataStructure.rowsToAdd[0].columnCells.push ("");
            });

            // fill in all of the column cells
            _.forEach(returnObject.uniqueEqtlGenes, function (recordsPerGene){
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames,recordsPerGene.geneName);
                if (indexOfColumn===-1){
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                }else {
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn]  = Mustache.render($("#dynamicGeneTableEqtlBody")[0].innerHTML,recordsPerGene);
                }
            });
            buildOrExtendDynamicTable("table.combinedGeneTableHolder",intermediateDataStructure);

        }


        var variantAnnotationAppearance = function(annotationName,recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,testToRun){
            var row = _.find(intermediateDataStructure.rowsToAdd,{'subcategory':annotationName});
            if ( typeof row === 'undefined'){
                intermediateDataStructure.rowsToAdd.push ({ category: 'annotation',
                    subcategory: annotationName,
                    columnCells:  _.times(numberOfVariants, "")});
                row = _.find(intermediateDataStructure.rowsToAdd,{'subcategory':annotationName});
            } else {
                var present = testToRun(recordsPerVariant)?[1]:[];
                row.columnCells[indexOfColumn] = Mustache.render($("#dynamicVariantCellAnnotations")[0].innerHTML,{"variantAnnotationIsPresent":present});
            }
        }






        // variants that we will want to annotate in the variant table
        if (( typeof returnObject.variantsToAnnotate !== 'undefined') && (!$.isEmptyObject(returnObject.variantsToAnnotate))){
            // set up the headers, and give us an empty row of column cells
            intermediateDataStructure.rowsToAdd.push ({ category: 'annotation',
                subcategory: '',
                columnCells:  []});
            _.forEach(returnObject.variantsToAnnotate.variants, function (oneRecord){
                if( typeof oneRecord !== 'undefined'){
                    intermediateDataStructure.headers.push({variantName:oneRecord.VAR_ID,
                        contents:Mustache.render($("#dynamicVariantHeader")[0].innerHTML,{variantName:oneRecord.VAR_ID})} );
                  //  intermediateDataStructure.columnCells.push ("");
                }
            });

            var numberOfVariants = returnObject.variantsToAnnotate.variants.length;
            // fill in all of the column cells covering each of our annotations
            if ( typeof returnObject.variantsToAnnotate.variants !== 'undefined'){
                _.forEach(returnObject.variantsToAnnotate.variants, function (recordsPerVariant){
                    var headerNames = _.map(intermediateDataStructure.headers, function (headerRecord){
                        return headerRecord.variantName
                    });
                    var indexOfColumn = _.indexOf(headerNames,recordsPerVariant.VAR_ID);
                    if (indexOfColumn===-1){
                        console.log("Did not find index of recordsPerVariant.VAR_ID.  Shouldn't we?")
                    }else {
                        _.forEach([ 'Coding',
                                    'Splice site',
                                    'UTR',
                                    'Promoter' ], function (eachAnnotation){
                            switch (eachAnnotation){
                                case 'Coding':
                                    variantAnnotationAppearance('Coding',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,function(v){return ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4))});
                                    break;
                                case 'Splice site':
                                    variantAnnotationAppearance('Splice site',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,function(v){return (v.Consequence.indexOf('splice')>-1)});
                                    break;
                                case 'UTR':
                                    variantAnnotationAppearance('UTR',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,function(v){return (v.Consequence.indexOf('UTR')>-1)});
                                    break;
                                case 'Promoter':
                                    variantAnnotationAppearance('Promoter',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,function(v){return (v.Consequence.indexOf('promoter')>-1)});
                                    break;
                                default: break;
                            }
                        });
                        //intermediateDataStructure.columnCells[indexOfColumn]  = Mustache.render($("#dynamicVariantBody")[0].innerHTML,recordsPerVariant);
                    }
                });

            }
            buildOrExtendDynamicTable("table.combinedVariantTableHolder",intermediateDataStructure);

        }


        $(idForTheTargetDiv).append(Mustache.render($(templateInfo)[0].innerHTML,
            returnObject
        ));
    }




    var processRecordsFromColocalization = function (data){
        // build up an object to describe this
        var returnObject = {rawData:[]
        };

        var rawColocalizationInfo = getAccumulatorObject('rawColocalizationInfo');

        _.forEach(data,function(oneRec){

            rawColocalizationInfo.push(oneRec);

        });

        return rawColocalizationInfo;
    };



    var processRecordsFromAbc = function (data){
        // build up an object to describe this
        var returnObject = {rawData:[]
        };

        var rawAbcInfo = getAccumulatorObject('rawAbcInfo');

        _.forEach(data,function(oneRec){

            rawAbcInfo.push(oneRec);

        });

        return rawAbcInfo;
    };



    var processRecordsFromQtl = function (data){
        // build up an object to describe this
        var returnObject = {rawData:[]
        };

        var rawQtlInfo = getAccumulatorObject('rawQtlInfo');
        var sampleGroupWithCredibleSetNames = (data.sampleGroupsWithCredibleSetNames.length>0)?data.sampleGroupsWithCredibleSetNames[0]:"";
        if (sampleGroupWithCredibleSetNames.length>0) {
                rawQtlInfo["credSetDataset"] = sampleGroupWithCredibleSetNames;
                rawQtlInfo["variants"] =_.filter(data.variants.variants,function(o){return o.dataset==="GWAS_IBDGenetics_eu_CrdSet_mdv80"});
        } else {
            rawQtlInfo["credSetDataset"] = sampleGroupWithCredibleSetNames;
            rawQtlInfo["variants"] =_.filter(data.variants.variants,function(o,cnt){return cnt<10});
        }


        return rawQtlInfo;
    };




    var retrieveExtents = function(geneName,defaultStart,defaultEnd){
        var returnValue = {regionStart:defaultStart,regionEnd:defaultEnd};
        var geneInfoArray = getAccumulatorObject("geneInfoArray");
        var geneInfoIndex = _.findIndex( geneInfoArray, { name:geneName } );
        if (geneInfoIndex >= 0) {
            returnValue.regionStart=geneInfoArray[geneInfoIndex].startPos;
            returnValue.regionEnd=geneInfoArray[geneInfoIndex].endPos;
        }
        return returnValue
    }




    var displayGenesFromAbc = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();

        // for each gene collect up the data we want to display
        _.forEach(_.groupBy(getAccumulatorObject("rawAbcInfo"),'GENE'),function(value,geneName){
            var geneObject = {geneName:geneName};
            geneObject['source'] = _.map(_.uniqBy(value,'SOURCE'),function(o){return o.SOURCE}).sort();
            geneObject['experiment'] = _.map(_.uniqBy(value,'EXPERIMENT'),function(o){return o.EXPERIMENT}).sort();
            geneObject['chrom'] = _.first(_.map(_.uniqBy(value,'CHROM'),function(o){return o.CHROM}).sort());
            var startPosRec = _.minBy(value,function(o){return o.START});
            geneObject['start_pos'] = (startPosRec)?startPosRec.START:0;
            var stopPosRec = _.maxBy(value,function(o){return o.STOP});
            geneObject['stop_pos'] = (stopPosRec)?stopPosRec.STOP:0;
            geneObject['abcTissuesVector'] = function(){
                return geneObject['source'];
            };
            geneObject['sourceByTissue'] = function(){
                return _.groupBy(value,'SOURCE');
            };
            var extents = retrieveExtents(geneName,startPosRec,stopPosRec);
            geneObject['regionStart'] = extents.regionStart;
            geneObject['regionEnd'] = extents.regionEnd;

            returnObject.genesByAbc.push(geneObject);

        });

        // now concoct a few functions that mustache can call
        returnObject['abcGenesExist'] = function(){
            return (this.genesByAbc.length>0)?[1]:[];
        };


        addAdditionalResultsObject({genesFromAbc:returnObject});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",'#dynamicAbcGeneTable',returnObject,clearBeforeStarting);
        // $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicAbcGeneTable')[0].innerHTML,
        //     returnObject
        // ));
        // and then store up some data that we will use when it's time to drill down
        _.forEach(returnObject.genesByAbc, function (value){
            $('#tissues_'+value.geneName).data('allUniqueTissues', value.abcTissuesVector());
            $('#tissues_'+value.geneName).data('sourceByTissue', value.sourceByTissue());
            $('#tissues_'+value.geneName).data('regionStart', value.start_pos);
            $('#tissues_'+value.geneName).data('regionEnd', value.stop_pos);
            $('#tissues_'+value.geneName).data('geneName', value.geneName);
        });



        $('div.openTissues').on('show.bs.collapse', function () {
            // the user wants to drill down into the tissues. Let's make them a graphic using the data we stored above
            var dataMatrix =
                _.map($(this).data("sourceByTissue"),
                    function(v,k){
                        var retVal = [];
                        _.forEach(v,function(oneRec){
                            retVal.push(oneRec);
                        });
                        return retVal ;
                    }
                );
            var geneInfoArray = getAccumulatorObject("geneInfoArray");
            var geneInfoIndex = _.findIndex( geneInfoArray, { name:$(this).data("geneName") } );
            var additionalParameters;
            if (geneInfoIndex < 0){
                additionalParameters = {regionStart:_.minBy(_.flatMap ($(this).data("sourceByTissue")),'START').START,
                    regionEnd:_.maxBy(_.flatMap ($(this).data("sourceByTissue")),'STOP').STOP,
                    stateColorBy:['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'),function(){return [1]})
                };
            } else {
                additionalParameters = {regionStart:geneInfoArray[geneInfoIndex].startPos,
                    regionEnd:geneInfoArray[geneInfoIndex].endPos,
                    stateColorBy:['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'),function(){return [1]})
                };
            }

            //  here comes that D3 graphic!
            buildMultiTissueDisplay(['Flanking TSS'],
                                    $(this).data('allUniqueTissues'),
                                    dataMatrix,
                                    additionalParameters,
                '#tooltip_'+$(this).attr('id'),
                '#graphic_'+$(this).attr('id'));

        });
    };


    var displayTissuesFromAbc = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawAbcInfo"),'SOURCE'),function(value,tissueName){
            var geneObject = {tissueName:tissueName};
            geneObject['gene'] = _.map(_.uniqBy(value,'GENE'),function(o){return o.GENE}).sort();
            geneObject['experiment'] = _.map(_.uniqBy(value,'EXPERIMENT'),function(o){return o.EXPERIMENT}).sort();
            var startPosRec = _.minBy(value,function(o){return o.START});
            geneObject['start_pos'] = (startPosRec)?startPosRec.START:0;
            var stopPosRec = _.maxBy(value,function(o){return o.STOP});
            geneObject['stop_pos'] = (stopPosRec)?stopPosRec.STOP:0;
            returnObject.tissuesByAbc.push(geneObject);

        });
        returnObject['abcTissuesExist'] = function(){
            return (this.tissuesByAbc.length>0)?[1]:[];
        };


        returnObject['numberOfGenes'] = function(){
            return (this.gene.length);
        };
        returnObject['numberOfExperiments'] = function(){
            return (this.experiment.length);
        };

        addAdditionalResultsObject({tissuesFromAbc:returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv,'#dynamicAbcTissueTable',returnObject,clearBeforeStarting);
        // $(idForTheTargetDiv).empty().append(Mustache.render($('#dynamicAbcTissueTable')[0].innerHTML,
        //     returnObject
        // ));
    };




    var displayPhenotypesFromColocalization = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"),'phenotype'),function(value,phenotypeName){
            var phenotypeObject = {phenotypeName:phenotypeName};
            phenotypeObject['tissues'] = _.map(_.uniqBy(value,'tissue'),function(o){return o.tissue}).sort();
            phenotypeObject['genes'] = _.map(_.uniqBy(value,'gene'),function(o){return o.gene}).sort();
            phenotypeObject['varId'] = _.map(_.uniqBy(value,'var_id'),function(o){return o.var_id}).sort();
            returnObject.phenotypesByColocalization.push(phenotypeObject);
            returnObject.uniquePhenotypes.push({phenotypeName:phenotypeName});
        });

        returnObject['phenotypeColocsExist'] = function(){
            return (this.phenotypesByColocalization.length>0)?[1]:[];
        };
        returnObject['numberOfTissues'] = function(){
            return (this.tissues.length);
        };
        returnObject['numberOfGenes'] = function(){
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function(){
            return (this.varId.length);
        };


        addAdditionalResultsObject({phenotypesFromColocalizatio:returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv,'#dynamicColocalizationPhenotypeTable',returnObject,clearBeforeStarting);
        // $("#dynamicPhenotypeHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicColocalizationPhenotypeTable')[0].innerHTML,
        //     returnObject
        // ));


    };




    var displayTissuesFromColocalization = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"),'tissue'),function(value,tissueName){
            var tissueObject = {tissueName:tissueName};
            tissueObject['phenotypes'] = _.map(_.uniqBy(value,'phenotype'),function(o){return o.phenotype}).sort();
            tissueObject['genes'] = _.map(_.uniqBy(value,'gene'),function(o){return o.gene}).sort();
            tissueObject['varId'] = _.map(_.uniqBy(value,'var_id'),function(o){return o.var_id}).sort();
             returnObject.phenotypesByColocalization.push(tissueObject);
            returnObject.uniqueTissues.push({tissueName:tissueName});
        });
        returnObject['colocsTissuesExist'] = function(){
            return (this.phenotypesByColocalization.length>0)?[1]:[];
        };

        returnObject['phenotypeColocsExist'] = function(){
            return (this.phenotypesByColocalization.length>0)?[1]:[];
        };
        returnObject['numberOfTissues'] = function(){
            return (this.tissues.length);
        };
        returnObject['numberOfPhenotypes'] = function(){
            return (this.phenotypes.length);
        };
        returnObject['numberOfGenes'] = function(){
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function(){
            return (this.varId.length);
        };

        addAdditionalResultsObject({tissuesFromColocalization:returnObject});
        prepareToPresentToTheScreen("#dynamicTissueHolder div.dynamicUiHolder",'#dynamicColocalizationTissueTable',returnObject,clearBeforeStarting);
        // $("#dynamicTissueHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicColocalizationTissueTable')[0].innerHTML,
        //     returnObject
        // ));


    };





    var displayGenesFromColocalization = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"),'common_name'),function(value,geneName){
            var geneObject = {geneName:geneName};
            geneObject['phenotypes'] = _.map(_.uniqBy(value,'phenotype'),function(o){return o.phenotype}).sort();
            geneObject['tissues'] = _.map(_.uniqBy(value,'tissue'),function(o){return o.tissue}).sort();
            geneObject['varId'] = _.map(_.uniqBy(value,'var_id'),function(o){return o.var_id}).sort();
            geneObject['colocTissuesVector'] = function(){
                return geneObject['tissue'];
            };
            geneObject['sourceByTissue'] = function(){
                return _.groupBy(value,'tissue');
            };
            var startPosRec = 0;
            var stopPosRec = 0;
            var extents = retrieveExtents(geneName,startPosRec,stopPosRec);
            geneObject['regionStart'] = extents.regionStart;
            geneObject['regionEnd'] = extents.regionEnd;

            returnObject.phenotypesByColocalization.push(geneObject);
        });
        returnObject['colocsExist'] = function(){
            return (this.phenotypesByColocalization.length>0)?[1]:[];
        };

        returnObject['phenotypeColocsExist'] = function(){
            return (this.phenotypesByColocalization.length>0)?[1]:[];
        };
        returnObject['numberOfTissues'] = function(){
            return (this.tissues.length);
        };
        returnObject['numberOfPhenotypes'] = function(){
            return (this.phenotypes.length);
        };
        returnObject['numberOfGenes'] = function(){
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function(){
            return (this.varId.length);
        };

        addAdditionalResultsObject({genesFromColocalization:returnObject});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",'#dynamicColocalizationGeneTable',returnObject,clearBeforeStarting);
        // $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicColocalizationGeneTable')[0].innerHTML,
        //     returnObject
        // ));

        _.forEach(returnObject.phenotypesByColocalization, function (value){
            $('#tissues_'+value.geneName).data('allUniqueTissues', value.colocTissuesVector());
            $('#tissues_'+value.geneName).data('sourceByTissue', value.sourceByTissue());
            $('#tissues_'+value.geneName).data('regionStart', value.start_pos);
            $('#tissues_'+value.geneName).data('regionEnd', value.stop_pos);
            $('#tissues_'+value.geneName).data('geneName', value.geneName);
        });



        $('div.openTissues').on('show.bs.collapse', function () {
            // the user wants to drill down into the tissues. Let's make them a graphic using the data we stored above
            var dataMatrix =
                _.map($(this).data("sourceByTissue"),
                    function(v,k){
                        var retVal = [];
                        _.forEach(v,function(oneRec){
                            retVal.push(oneRec);
                        });
                        return retVal ;
                    }
                );
            var geneInfoArray = getAccumulatorObject("geneInfoArray");
            var geneInfoIndex = _.findIndex( geneInfoArray, { name:$(this).data("geneName") } );
            var additionalParameters;
            if (geneInfoIndex < 0){
                additionalParameters = {regionStart:_.minBy(_.flatMap ($(this).data("sourceByTissue")),'START').START,
                    regionEnd:_.maxBy(_.flatMap ($(this).data("sourceByTissue")),'STOP').STOP,
                    stateColorBy:['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'),function(){return [1]})
                };
            } else {
                additionalParameters = {regionStart:geneInfoArray[geneInfoIndex].startPos,
                    regionEnd:geneInfoArray[geneInfoIndex].endPos,
                    stateColorBy:['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'),function(){return [1]})
                };
            }

            //  here comes that D3 graphic!
            buildMultiTissueDisplay(['Flanking TSS'],
                $(this).data('allUniqueTissues'),
                dataMatrix,
                additionalParameters,
                '#tooltip_'+$(this).attr('id'),
                '#graphic_'+$(this).attr('id'));

        });


    };






    /***
     * gene eQTL search
     * @param data
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueTissues: Array, chromosome: undefined, startPos: undefined, endPos: undefined}}
     */
    var processRecordsFromEqtls = function (data){
        // build up an object to describe this
        var returnObject = {rawData:[],
            uniqueGenes:[],
            uniqueTissues:[],
            chromosome:undefined,
            startPos:undefined,
            endPos:undefined
        };
        _.forEach(data,function(oneRec){
            returnObject.rawData.push(oneRec);
            if ( typeof returnObject.startPos === 'undefined'){
                returnObject.startPos = oneRec.start_position;
            } else if (returnObject.startPos > oneRec.start_position){
                returnObject.startPos = oneRec.start_position;
            }
            if ( typeof returnObject.endPos === 'undefined'){
                returnObject.endPos = oneRec.end_position;
            } else if (returnObject.endPos < oneRec.end_position){
                returnObject.endPos = oneRec.end_position;
            }
            if ( typeof returnObject.chromosome === 'undefined'){
                returnObject.chromosome = oneRec.chromosome;
            }
            if (!returnObject.uniqueGenes.includes(oneRec.gene)){
                returnObject.uniqueGenes.push(oneRec.gene);
            };
            if (!returnObject.uniqueTissues.includes(oneRec.tissue)){
                returnObject.uniqueTissues.push(oneRec.tissue);
            };

            var geneIndex = _.findIndex( getAccumulatorObject("tissuesForEveryGene"),{geneName:oneRec.gene} );
            if (geneIndex<0) {
                var accumulatorArray = getAccumulatorObject("tissuesForEveryGene");
                accumulatorArray.push({geneName: oneRec.gene, tissues: [oneRec.tissue]});
                setAccumulatorObject("tissuesForEveryGene", accumulatorArray);
            } else {
                var accumulatorElement = getAccumulatorObject("tissuesForEveryGene")[geneIndex];
                if (!accumulatorElement.tissues.includes(oneRec.tissue)) {
                    accumulatorElement.tissues.push(oneRec.tissue);
                }
            }

            var tissueIndex = _.findIndex( getAccumulatorObject("genesForEveryTissue"),{tissueName:oneRec.tissue} );
            if (tissueIndex<0) {
                var accumulatorArray = getAccumulatorObject("genesForEveryTissue");
                accumulatorArray.push({tissueName: oneRec.tissue, genes: [oneRec.gene]});
                setAccumulatorObject("genesForEveryTissue", accumulatorArray);
            } else {
                var accumulatorElement = getAccumulatorObject("genesForEveryTissue")[tissueIndex];
                if (!accumulatorElement.genes.includes(oneRec.gene)) {
                    accumulatorElement.genes.push(oneRec.gene);
                }
            }


        });

        return returnObject;
    };
    var displayTissuesPerGeneFromEqtl = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var returnObject = createNewDisplayReturnObject();
        _.forEach(getAccumulatorObject("tissuesForEveryGene"),function(eachGene){
            returnObject.uniqueGenes.push({name:eachGene.geneName});

            var recordToDisplay = {tissues:[],
                                    geneName:eachGene.geneName};
            _.forEach(eachGene.tissues,function(eachTissue){
                recordToDisplay.tissues.push({tissueName:eachTissue})
            });
            returnObject.uniqueEqtlGenes.push(recordToDisplay);
        });
        addAdditionalResultsObject({tissuesPerGeneFromEqtl:returnObject});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",'#dynamicGeneTable',returnObject,clearBeforeStarting);
        // $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
        //     returnObject
        // ));
    };
    var displayGenesPerTissueFromEqtl = function (idForTheTargetDiv,objectContainingRetrievedRecords){

        var returnObject = createNewDisplayReturnObject();
        _.forEach(getAccumulatorObject("genesForEveryTissue"),function(eachTissue){
            returnObject.uniqueTissues.push({name:eachTissue.tissueName});

            var recordToDisplay = {genes:[]};
            _.forEach(eachTissue.genes,function(eachGene){
                recordToDisplay.genes.push({geneName:eachGene})
            });
            if (!returnObject.geneTissueEqtls.includes(recordToDisplay)){
                returnObject.geneTissueEqtls.push(recordToDisplay);
            }

        });
        addAdditionalResultsObject({genesPerTissueFromEqtl:returnObject});
        prepareToPresentToTheScreen("#dynamicTissueHolder div.dynamicUiHolder",'#dynamicTissueTable',returnObject,clearBeforeStarting);
        // $("#dynamicTissueHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicTissueTable')[0].innerHTML,
        //     returnObject
        // ));
    };

    /***
     * Gene proximity search
     * @param data
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueTissues: Array}}
     */
    var processRecordsFromProximitySearch = function (data){
        var returnObject = {rawData:[],
            uniqueGenes:[],
            genePositions:[],
            uniqueTissues:[],
            genesPositionsExist:function(){
                return (this.genePositions.length>0)?[1]:[];
            },
            genesExist:function(){
                return (this.uniqueGenes.length>0)?[1]:[];
            }
        };
        var geneInfoArray = [];
        if (( typeof data !== 'undefined') &&
            ( data !== null ) &&
            (data.is_error === false ) &&
            ( typeof data.listOfGenes !== 'undefined') ){
            if (data.listOfGenes.length === 0){
                alert(' No genes in the specified region')
            } else {
                _.forEach(data.listOfGenes,function(geneRec){
                    returnObject.rawData.push(geneRec);
                    if (!returnObject.uniqueGenes.includes(geneRec.name2)){
                        returnObject.uniqueGenes.push({name:geneRec.name2});
                        returnObject.genePositions.push({name:geneRec.chromosome +":"+geneRec.addrStart +"-"+geneRec.addrEnd});
                        var chromosomeString = _.includes(geneRec.chromosome,"chr")?geneRec.chromosome.substr(3):geneRec.chromosome;
                        geneInfoArray.push({    chromosome:chromosomeString,
                                                startPos:geneRec.addrStart,
                                                endPos:geneRec.addrEnd,
                                                name:geneRec.name2,
                                                id:geneRec.id }
                        );
                    };
                });
            }
        }
        // we have a list of all the genes in the range.  Let's remember that information.
        setAccumulatorObject("geneNameArray",returnObject.uniqueGenes);
        setAccumulatorObject("geneInfoArray",geneInfoArray);
        return returnObject;
    };
    var displayRefinedGenesInARange = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();

        addAdditionalResultsObject({refinedGenesInARange:objectContainingRetrievedRecords});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",'#dynamicGeneTable',objectContainingRetrievedRecords,clearBeforeStarting);
        // $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
        //     objectContainingRetrievedRecords
        // ));
    };



    var processRecordsFromVariantQtlSearch = function (data) {
        var returnObject = {rawData:[],
            uniqueGenes:[],
            uniquePhenotypes:[],
            uniqueVarIds:[]
        };
        if ( ( typeof data !== 'undefined') &&
                ( typeof data.data !== 'undefined') &&
                ( typeof data.header !== 'undefined') &&
                ( data.header.length > 0 ) ) {
            var varIdIndex =  _.indexOf(data.header,'VAR_ID');
            var geneIndex =  _.indexOf(data.header,'GENE');
            var phenotypeIndex =  _.indexOf(data.header,'PHENOTYPE');
            var positionIndex =  _.indexOf(data.header,'POS');
            var numberOfElements =  data.data[0].length;
            for ( var variant = 0; variant < numberOfElements; variant++ ){
                var varId = data.data[varIdIndex][variant];
                var gene = data.data[geneIndex][variant];
                var phenotype = data.data[phenotypeIndex][variant];
                var position = data.data[positionIndex][variant];
                if (!returnObject.uniqueGenes.includes(gene)){
                    returnObject.uniqueGenes.push(gene);
                };
                if (!returnObject.uniquePhenotypes.includes(phenotype)){
                    returnObject.uniquePhenotypes.push(phenotype);
                };
                if (!returnObject.uniqueVarIds.includes(varId)){
                    returnObject.uniqueVarIds.push(varId);
                };

                var variantIndex = _.findIndex( getAccumulatorObject("phenotypesForEveryVariant"),{ variantName:varId } );
                if (variantIndex<0) {
                    var accumulatorArray = getAccumulatorObject("phenotypesForEveryVariant");
                    accumulatorArray.push({ variantName:varId,
                                            phenotypes: [phenotype],
                                            position: position });
                    setAccumulatorObject("phenotypesForEveryVariant", accumulatorArray);
                } else {
                    var accumulatorElement = getAccumulatorObject("phenotypesForEveryVariant")[variantIndex];
                    if (!accumulatorElement.phenotypes.includes(phenotype)) {
                        accumulatorElement.phenotypes.push(phenotype);
                    }
                }

                var phenotIndex = _.findIndex( getAccumulatorObject("variantsForEveryPhenotype"),{phenotypeName:phenotype} );
                if (phenotIndex<0) {
                    var accumulatorArray = getAccumulatorObject("variantsForEveryPhenotype");
                    accumulatorArray.push({phenotypeName:phenotype, variants: [varId]});
                    setAccumulatorObject("variantsForEveryPhenotype", accumulatorArray);
                } else {
                    var accumulatorElement = getAccumulatorObject("variantsForEveryPhenotype")[phenotIndex];
                    if (!accumulatorElement.variants.includes(phenotype)) {
                        accumulatorElement.variants.push(phenotype);
                    }
                }



                returnObject.rawData.push({varId:varId,gene:gene,phenotype:phenotype});
            }
        } else {
            alert('API call return to unexpected result. Is the KB fully functional?');
        }
        returnObject.uniqueGenes = returnObject.uniqueGenes.sort();
        returnObject.uniquePhenotypes = returnObject.uniquePhenotypes.sort();
        returnObject.uniqueVarIds = returnObject.uniqueVarIds.sort();
        return returnObject;
    };
    var displayVariantRecordsFromVariantQtlSearch = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();
        // _.forEach(objectContainingRetrievedRecords.uniqueVarIds,function(oneTissue) {
        //     $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+oneTissue+'</div>');
        // });

        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(getAccumulatorObject("phenotypesForEveryVariant"),['position']), function (variantWithPhenotypes) {
            returnObject.uniqueVariants.push({variantName:variantWithPhenotypes.variantName});

            var recordToDisplay = {phenotypes:[]};
            _.forEach(variantWithPhenotypes.phenotypes,function(eachPhenotype){
                recordToDisplay.phenotypes.push({phenotypeName:eachPhenotype})
            });
            returnObject.variantPhenotypeQtl.push(recordToDisplay);

        });
        addAdditionalResultsObject({variantRecordsFromVariantQtlSearch:returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv,'#dynamicPhenotypeTable',returnObject,clearBeforeStarting);
        // $(idForTheTargetDiv).empty().append(Mustache.render($('#dynamicPhenotypeTable')[0].innerHTML,
        //     returnObject
        // ));

    };
    var displayPhenotypeRecordsFromVariantQtlSearch = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();
        // _.forEach(objectContainingRetrievedRecords.uniquePhenotypes,function(onePhenotype) {
        //     $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+onePhenotype+'</div>');
        // });

        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(getAccumulatorObject("variantsForEveryPhenotype"),['phenotypeName']), function (phenotypesWithVariants) {
            returnObject.uniquePhenotypes.push({phenotypeName:phenotypesWithVariants.phenotypeName});

            var recordToDisplay = {variants:[]};
            _.forEach(phenotypesWithVariants.variants,function(eachVariant){
                recordToDisplay.variants.push({variantName:eachVariant})
            });
            returnObject.phenotypeVariantQtl.push(recordToDisplay);

        });
        addAdditionalResultsObject({phenotypeRecordsFromVariantQtlSearch:returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv,'#dynamicPhenotypeTable',returnObject,clearBeforeStarting);
        // $(idForTheTargetDiv).empty().append(Mustache.render($('#dynamicPhenotypeTable')[0].innerHTML,
        //     returnObject
        // ));

    };

    var displayContext = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        var contextDescr = objectContainingRetrievedRecords;
        // Do we actually use this routine?
        $(idForTheTargetDiv).empty().append(Mustache.render($('#contextDescriptionSection')[0].innerHTML,
            contextDescr
        ));
    };




    var displayVariantsForAPhenotype = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();

        var returnObject = createNewDisplayReturnObject();
        returnObject.variantsToAnnotate = objectContainingRetrievedRecords;

        addAdditionalResultsObject({variantRecordsForOnePhenotypeQtlSearch:returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv,'#dynamicVariantTable',returnObject,clearBeforeStarting);


    };




    var retrieveRemotedContextInformation=function(collectionOfRemoteCallingParameters){

        var objectContainingRetrievedRecords = [];
        var promiseArray = [];

        _.forEach(collectionOfRemoteCallingParameters.multiples,function(eachRemoteCallingParameter){
            promiseArray.push(
                $.ajax({
                    cache: false,
                    type: "post",
                    url: eachRemoteCallingParameter.retrieveDataUrl,
                    data: eachRemoteCallingParameter.dataForCall,
                    async: true
                }).done(function (data, textStatus, jqXHR) {

                    objectContainingRetrievedRecords = eachRemoteCallingParameter.processEachRecord( data );

                }).fail(function (jqXHR, textStatus, errorThrown) {
                    loading.hide();
                    core.errorReporter(jqXHR, errorThrown)
                })
            );
        });


        $.when.apply($, promiseArray).then(function(allCalls) {

            if (( typeof collectionOfRemoteCallingParameters.displayRefinedContextFunction !== 'undefined') &&
                ( collectionOfRemoteCallingParameters.displayRefinedContextFunction !== null ) ) {

                collectionOfRemoteCallingParameters.displayRefinedContextFunction(   collectionOfRemoteCallingParameters.placeToDisplayData,
                    objectContainingRetrievedRecords );

            } else if  ( typeof collectionOfRemoteCallingParameters.actionId !== 'undefined')  {

                var actionToUndertake = actionContainer( collectionOfRemoteCallingParameters.actionId, actionDefaultFollowUp(collectionOfRemoteCallingParameters.actionId) );
                actionToUndertake();

            } else {

                alert("we had no follow-up action.  That's okay, right?");

            }


        }, function(e) {
            alert("Ajax call failed");
        });

    };


    var buildRemoteContextArray = function(startingMaterials){
        var returnValue = {multiples:[]};
        if(( typeof startingMaterials !== 'undefined') &&
            ( typeof startingMaterials.retrieveDataUrl !== 'undefined') &&
            ( typeof startingMaterials.dataForCall !== 'undefined') &&
            ( typeof startingMaterials.processEachRecord !== 'undefined') &&
            //( typeof startingMaterials.displayRefinedContextFunction !== 'undefined') &&
            //( typeof startingMaterials.placeToDisplayData !== 'undefined') &&
            ( !Array.isArray(startingMaterials.displayRefinedContextFunction) ) &&
            ( !Array.isArray(startingMaterials.placeToDisplayData) ) ){
                var retrieveDataUrlMultiple = (Array.isArray(startingMaterials.retrieveDataUrl))?
                    startingMaterials.retrieveDataUrl:[startingMaterials.retrieveDataUrl];
                var dataForCallMultiple = (Array.isArray(startingMaterials.dataForCall))?
                    startingMaterials.dataForCall:[startingMaterials.dataForCall];
                var processEachRecordMultiple = (Array.isArray(startingMaterials.processEachRecord))?
                    startingMaterials.processEachRecord:[startingMaterials.processEachRecord];
                _.forEach(retrieveDataUrlMultiple,function(eachRetrieveDataUrl){
                    _.forEach(dataForCallMultiple,function(eachDataForCall){
                        _.forEach(processEachRecordMultiple,function(eachprocessEachRecord){
                            returnValue.multiples.push({ retrieveDataUrl:eachRetrieveDataUrl,
                                                        dataForCall: eachDataForCall,
                                                        processEachRecord:eachprocessEachRecord });
                        });
                    });
                });
                returnValue["displayRefinedContextFunction"] = startingMaterials.displayRefinedContextFunction;
                returnValue["placeToDisplayData"] = startingMaterials.placeToDisplayData;
                returnValue["actionId"] = startingMaterials.actionId;

        } else {
                console.log("Serious error: incorrect fields in startingMaterials = "+startingMaterials.name+".")
            };
        return returnValue;
    };



    var installDirectorButtonsOnTabs =  function ( additionalParameters) {
        /***
         * The area above the tabs with a button connected to an input box
         * @type {{directorButtons: *[]}}
         */
        var objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'topLevelContextOfTheDynamicUiButton', buttonName: 'Reset context',
                description: 'Change the locus under consideration',
                inputBoxId:'inputBoxForDynamicContextId', reference: 'none?' }]
        };
        $("#contextControllersInDynamicUi").empty().append(Mustache.render($('#contextControllerDescriptionSection')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * gene tab
         * @type {{directorButtons: *[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [
                {buttonId: 'getTissuesFromProximityForLocusContext', buttonName: 'proximity',
                    description: 'present all genes overlapping  the specified region',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder', reference: '#' },
                {buttonId: 'getTissuesFromEqtlsForGenesTable', buttonName: 'eQTL',
                    description: 'present all genes overlapping  the specified region for which some eQTL relationship exists',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'https://www.genome.gov/27543767/genotypetissue-expression-project-gtex'},
                {buttonId: 'modAnnotationButtonId', buttonName: 'MOD',
                    description: 'list mouse knockout annotations  for all genes overlapping the specified region',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'http://www.informatics.jax.org/phenotypes.shtml'},
                {buttonId: 'getTissuesFromAbcForGenesTable', buttonName: 'ABC',
                    description: 'get a list of regions associated with a gene via ABC test',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'http://science.sciencemag.org/content/354/6313/769'},
                {buttonId: 'getRecordsFromECaviarForGeneTable', buttonName: 'eCaviar',
                    description: 'find all genes for which co-localized variants exist',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'},
                {buttonId: 'retrieveMultipleRecordsTest', buttonName: 'multi',
                    description: 'combine multiple epigenetic record types',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'}]
        };
        $("#dynamicGeneHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * variant tab
         * @type {{directorButtons: {buttonId: string, buttonName: string, description: string}[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [
                {buttonId: 'getVariantsFromQtlForContextDescription', buttonName: 'QTL',
                    description: 'find all variants in the above range with QTL relationship with some phenotype',
                    outputBoxId:'#dynamicVariantHolder div.dynamicUiHolder',
                    reference: 'https://s3.amazonaws.com/broad-portal-resources/tutorials/Genetic_association_primer.pdf'},
                {buttonId: 'getVariantsFromQtlAndThenRetrieveEpigeneticData', buttonName: 'multi',
                    description: 'build a variant based table with a collection of epigenetic data',
                    outputBoxId:'#dynamicVariantHolder div.dynamicUiHolder',
                    reference: 'https://s3.amazonaws.com/broad-portal-resources/tutorials/Genetic_association_primer.pdf'}
            ]
        };
        $("#dynamicVariantHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * tissue tab
         * @type {{directorButtons: {buttonId: string, buttonName: string, description: string}[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [
                {buttonId: 'getTissuesFromEqtlsForTissuesTable', buttonName: 'eQTL',
                    description: 'find all tissues for which eQTLs exist foraging in the specified range',
                    outputBoxId:'#dynamicTissueHolder div.dynamicUiHolder',
                    reference: 'https://www.genome.gov/27543767/genotypetissue-expression-project-gtex'},
                {buttonId: 'getPhenotypesFromECaviarForTissueTable', buttonName: 'eCaviar',
                    description: 'find all tissues for which co-localized variants exist',
                    outputBoxId:'#dynamicTissueHolder div.dynamicUiHolder',
                    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'},
                {buttonId: 'getRecordsFromAbcForTissueTable', buttonName: 'ABC',
                    description: 'find all tissues identified in the ABC gene-enhancer screen',
                    outputBoxId:'#dynamicTissueHolder div.dynamicUiHolder',
                    reference: 'http://science.sciencemag.org/content/354/6313/769'}
                ]
        };
        $("#dynamicTissueHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * phenotype tab
         * @type {{directorButtons: *[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'getPhenotypesFromQtlForPhenotypeTable', buttonName: 'QTL',
                description: 'find all phenotypes for which QTLs exist in the above',
                outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                reference: 'https://s3.amazonaws.com/broad-portal-resources/tutorials/Genetic_association_primer.pdf'},
                {buttonId: 'getPhenotypesFromECaviarForPhenotypeTable', buttonName: 'eCAVIAR',
                    description: 'find all variants which co-localize with eQTLs',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'}]
        };
        $("#dynamicPhenotypeHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

    };





    var modifyScreenFields = function (data, additionalParameters) {

        setDyanamicUiVariables(additionalParameters);

        $('#inputBoxForDynamicContextId').typeahead({
            source: function (query, process) {
                $.get(additionalParameters.generalizedTypeaheadUrl, {query: query}, function (data) {
                    process(data, additionalParameters);
                })
            },
            afterSelect: function(selection) {
                //alert('not sure if we want a default behavior here?');;
            }
        });


        // manually set the range
        $('#topLevelContextOfTheDynamicUiButton').on('click', function () {

            var actionToUndertake = actionContainer("replaceGeneContext", actionDefaultFollowUp("replaceGeneContext"));
            actionToUndertake();
        });

        // pull back mouse annotations
        $('#modAnnotationButtonId').on('click', function () {
      //      resetAccumulatorObject("modNameArray");

            var actionToUndertake = actionContainer('getAnnotationsFromModForGenesTable', actionDefaultFollowUp("getAnnotationsFromModForGenesTable"));
            actionToUndertake();


        });

        // perform an eQTL based lookup
        $('#getTissuesFromEqtlsForGenesTable').on('click', function () {

            var actionToUndertake = actionContainer('getTissuesFromEqtlsForGenesTable', actionDefaultFollowUp("getTissuesFromEqtlsForGenesTable"));
            actionToUndertake();
        });



        $('#getTissuesFromAbcForGenesTable').on('click', function () {

            var actionToUndertake = actionContainer("getTissuesFromAbcForGenesTable", actionDefaultFollowUp("getTissuesFromAbcForGenesTable"));
            actionToUndertake();

        });



        // assign the correct response to the proximity range go button
        $('#getTissuesFromProximityForLocusContext').on('click', function () {

            var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", actionDefaultFollowUp("getTissuesFromProximityForLocusContext"));
            actionToUndertake();

        });


        $('#getVariantsFromQtlForContextDescription').on('click', function () {

            var actionToUndertake = actionContainer("getVariantsFromQtlForContextDescription", actionDefaultFollowUp("getVariantsFromQtlForContextDescription"));
            actionToUndertake();

        });


        $('#getTissuesFromEqtlsForTissuesTable').on('click', function () {

            var actionToUndertake = actionContainer("getTissuesFromEqtlsForTissuesTable", actionDefaultFollowUp("getTissuesFromEqtlsForTissuesTable"));
            actionToUndertake();

        });


        $('#getPhenotypesFromQtlForPhenotypeTable').on('click', function () {

            var actionToUndertake = actionContainer("getPhenotypesFromQtlForPhenotypeTable", actionDefaultFollowUp("getPhenotypesFromQtlForPhenotypeTable"));
            actionToUndertake();

        });



        $('#getPhenotypesFromECaviarForPhenotypeTable').on('click', function () {

            var actionToUndertake = actionContainer("getPhenotypesFromECaviarForPhenotypeTable", actionDefaultFollowUp("getPhenotypesFromECaviarForPhenotypeTable"));
            actionToUndertake();

        });

        $('#getPhenotypesFromECaviarForTissueTable').on('click', function () {
            var actionToUndertake = actionContainer("getPhenotypesFromECaviarForTissueTable", actionDefaultFollowUp("getPhenotypesFromECaviarForTissueTable"));
            actionToUndertake();
        });



        $('#getRecordsFromECaviarForGeneTable').on('click', function () {
            var actionToUndertake = actionContainer("getRecordsFromECaviarForGeneTable", actionDefaultFollowUp("getRecordsFromECaviarForGeneTable"));
            actionToUndertake();
        });



        $('#getRecordsFromAbcForTissueTable').on('click', function () {
            var actionToUndertake = actionContainer("getRecordsFromAbcForTissueTable", actionDefaultFollowUp("getRecordsFromAbcForTissueTable"));
            actionToUndertake();
        });


        $('#retrieveMultipleRecordsTest').on('click', function () {
            var arrayOfRoutinesToUndertake = [];

            arrayOfRoutinesToUndertake.push( actionContainer('getTissuesFromEqtlsForGenesTable',
                actionDefaultFollowUp("getTissuesFromEqtlsForGenesTable")));

            arrayOfRoutinesToUndertake.push( actionContainer('getAnnotationsFromModForGenesTable',
                actionDefaultFollowUp("getAnnotationsFromModForGenesTable")));

            arrayOfRoutinesToUndertake.push( actionContainer("getTissuesFromAbcForGenesTable",
                actionDefaultFollowUp("getTissuesFromAbcForGenesTable")));

            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});


        });


        $('#getVariantsFromQtlAndThenRetrieveEpigeneticData').on('click', function () {
            var arrayOfRoutinesToUndertake = [];

            arrayOfRoutinesToUndertake.push( actionContainer('getVariantsWeWillUseToBuildTheVariantTable',
                actionDefaultFollowUp("getVariantsWeWillUseToBuildTheVariantTable")));

            arrayOfRoutinesToUndertake.push( actionContainer('getTissuesFromEqtlsForGenesTable',
                actionDefaultFollowUp("getTissuesFromEqtlsForGenesTable")));

            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});


        });




        resetAccumulatorObject();

        displayContext('#contextDescription',getAccumulatorObject());

    };



    var adjustExtentHolders = function(storageField,spanClass,basesToShift){
        var extentBegin = parseInt( getAccumulatorObject(storageField) );
        if ((extentBegin+basesToShift)>0){
            extentBegin += basesToShift;
        } else {
            extentBegin = 0;
        }
        setAccumulatorObject(storageField,extentBegin);
        $(spanClass).html(""+extentBegin);
        resetAccumulatorObject("geneNameArray");
        resetAccumulatorObject("geneInfoArray");
        resetAccumulatorObject("tissueNameArray");
    };

    var adjustLowerExtent = function(basesToShift){
        if (basesToShift>0){
            if ( ( parseInt(getAccumulatorObject("extentBegin") )+basesToShift ) > //
                 ( parseInt(getAccumulatorObject("extentEnd") ) ) ){
                return;
            }
        }
        adjustExtentHolders("extentBegin","span.dynamicUiGeneExtentBegin",basesToShift);
    };

    var adjustUpperExtent = function(basesToShift){
        if (basesToShift<0){
            if ( ( parseInt(getAccumulatorObject("extentEnd") )+basesToShift ) < //
                 ( parseInt(getAccumulatorObject("extentBegin") ) ) ){
                return;
            }
        }
        adjustExtentHolders("extentEnd","span.dynamicUiGeneExtentEnd",basesToShift);
    };


    var buildMultiTissueDisplay  = function(     allUniqueElementNames,
                                                allUniqueTissueNames,
                                                dataMatrix,
                                                additionalParams,
                                                 tooltipLocation,
                                                cssSelector ){
        var correlationMatrix = dataMatrix;
        var xlabels = additionalParams.stateColorBy;
        var ylabels = allUniqueTissueNames;
        var margin = {top: 50, right: 50, bottom: 100, left: 250},
            width = 750 - margin.left - margin.right,
            height = 800 - margin.top - margin.bottom;
        var varsImpacter = baget.varsImpacter()
            .height(height)
            .width(width)
            .margin(margin)
            .renderCellText(1)
            .xlabelsData(xlabels)
            .ylabelsData(ylabels)
            .startColor('#ffffff')
            .endColor('#3498db')
            .endRegion(additionalParams.regionEnd)
            .startRegion(additionalParams.regionStart)
            .xAxisLabel('genomic position')
            .mappingInfo(additionalParams.mappingInformation)
            .colorByValue(1)
            .tooltipLocation(tooltipLocation)
            .dataHanger(cssSelector, correlationMatrix);
        d3.select(cssSelector).call(varsImpacter.render);
    };







    var buildOrExtendDynamicTable = function (whereTheTableGoes,intermediateStructure) {
        if (( typeof intermediateStructure !== 'undefined') &&
            ( typeof intermediateStructure.headers !== 'undefined') &&
            (intermediateStructure.headers.length > 0)){
            var datatable;
            if ( ! $.fn.DataTable.isDataTable( whereTheTableGoes ) ){
                var headerDescriber = {
                    dom: '<"#gaitButtons"B><"#gaitVariantTableLength"l>rtip',
                    "buttons": [
                        {extend: "copy", text: "Copy all to clipboard"},
                        {extend: "csv", text: "Copy all to csv"},
                        {extend: "pdf", text: "Copy all to pdf"}
                    ],
                    "aLengthMenu": [
                        [10, 50, -1],
                        [10, 50, "All"]
                    ],
                    "bDestroy": true,
                    "bAutoWidth": false,
                    "columnDefs": []
                };
                _.forEach(intermediateStructure.headers, function (header,count){
                    headerDescriber.columnDefs.push({"title":header.contents,
                        "targets": count,
                        "name":header.name});
                });
                 datatable = $(whereTheTableGoes).DataTable( headerDescriber );
            } else {
                datatable =  $(whereTheTableGoes).dataTable();
            }

            var rowDescriber = [];
            _.forEach(intermediateStructure.rowsToAdd, function (row) {
                _.forEach(row.columnCells, function (val, key) {
                    rowDescriber.push(val);
                })
                $(whereTheTableGoes).dataTable().fnAddData(rowDescriber);
            });


        }
    };






        var addToCombinedTable = function (variantAndDsAjaxUrl, variantInfoUrl,
                                       whereTheTableGoes) {
        // var proposedVariant = $('#proposedVariant').val();
        // var metadata = getStoredSampleMetadata();
        var rememberVariantInfoUrl = variantInfoUrl;
        // if (proposedVariant.length < 1) {
        //     proposedVariant = $('#proposedMultiVariant').val();
        // }
        // var allVariants = proposedVariant.split(",");
        // if (allVariants.length < 2) {
        //     allVariants = proposedVariant.split('\n');
        // }
        var datatable = $(whereTheTableGoes).DataTable();
        var deferreds = [];
        var unrecognizedVariants = [];
        var duplicateVariants = [];
        // var datasetFilter = $('#datasetFilter').val();
        // var dataSet = metadata.conversion[datasetFilter];
        _.forEach(allVariants, function (oneVariantRaw) {
            var oneVariant = oneVariantRaw.trim();
            if (oneVariant.length > 0) {
                var oneCall = function (curVariant, unrecognized, duplicate) {
                    var d = $.Deferred();
                    var promise = $.ajax({
                        cache: false,
                        type: "get",
                        url: ( variantAndDsAjaxUrl + "?varid=" + curVariant + "&dataSet=" + dataSet),
                        async: true
                    });
                    promise.done(
                        function (data) {
                            if ((typeof data !== 'undefined') &&
                                (data) &&
                                (data.variant) &&
                                (!(data.variant.is_error))) {
                                if (data.variant.numRecords > 0) {
                                    var args = _.flatten([{}, data.variant.variants[0]]);
                                    var variantObject = _.merge.apply(_, args);
                                    var mac = '';
                                    var macObject = variantObject['MAC'];
                                    if (typeof macObject !== 'undefined') {
                                        _.forEach(macObject, function (v, k) {
                                            mac = v;
                                        })
                                    }
                                    if (_.findIndex(datatable.rows().data(), function (oneRow) {
                                        return oneRow[0] === variantObject.VAR_ID;
                                    }) > -1) {
                                        duplicate.push(curVariant);
                                    } else {
                                        datatable.row.add([variantObject.VAR_ID,
                                            '<a href="' + rememberVariantInfoUrl + '/' + variantObject.VAR_ID + '" class="boldItlink">' +
                                            variantObject.CHROM + ':' + variantObject.POS + '</a>',
                                            variantObject.DBSNP_ID,
                                            variantObject.CHROM,
                                            variantObject.POS,
                                            mac,
                                            variantObject.PolyPhen_PRED,
                                            variantObject.SIFT_PRED,
                                            variantObject.Protein_change,
                                            variantObject.Consequence
                                        ]).draw(false);
                                    }

                                } else {
                                    unrecognized.push(curVariant);
                                }

                            }
                            d.resolve(data);
                        }
                    );
                    promise.fail(d.reject);
                    return d.promise();
                };
                deferreds.push(oneCall(oneVariant, unrecognizedVariants, duplicateVariants));
            }
        });
        $.when.apply($, deferreds).then(function () {
            $('#rSpinner').hide();
            var reportError = "";
            if (unrecognizedVariants.length > 0) {
                if (unrecognizedVariants.length > 1) {
                    reportError += ('The following variants were unrecognized: ' + unrecognizedVariants.join(", "));
                } else {
                    reportError += ('Variant ' + unrecognizedVariants[0] + ' unrecognized.');
                }
            }
            if (duplicateVariants.length > 0) {
                if (reportError.length > 0) {
                    reportError += '\n\n';
                }
                if (duplicateVariants.length > 1) {
                    reportError += ('The following variants were already in the table: ' + duplicateVariants.join(", "));
                } else {
                    reportError += ('Variant ' + duplicateVariants[0] + ' already in the table.');
                }
            }
            if (reportError.length > 0) {
                alert(reportError);
            }
        });
    };




// public routines are declared below
    return {
        installDirectorButtonsOnTabs: installDirectorButtonsOnTabs,
        modifyScreenFields: modifyScreenFields,
        adjustLowerExtent: adjustLowerExtent,
        adjustUpperExtent: adjustUpperExtent
    }
}());


