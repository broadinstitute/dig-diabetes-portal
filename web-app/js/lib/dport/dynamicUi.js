var mpgSoftware = mpgSoftware || {};




mpgSoftware.dynamicUi = (function () {
    var loading = $('#rSpinner');
    var commonTable;
    var dyanamicUiVariables;

    var setDyanamicUiVariables = function(incomingDyanamicUiVariables){
        dyanamicUiVariables = incomingDyanamicUiVariables;
    };

    var getDyanamicUiVariables = function(){
        return dyanamicUiVariables;
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

            var recordToDisplay = {mods:[]};
            _.forEach(geneWithMods.mods,function(eachMod){
                recordToDisplay.mods.push({modName:eachMod})
            });
            returnObject.geneModTerms.push(recordToDisplay);

        });
        $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
            returnObject
        ));
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
            geneTissueEqtls:[],
            geneModTerms:[],
            genesPositionsExist:function(){
                return (this.genePositions.length>0)?[1]:[];
            },
            genesExist:function(){
                return (this.uniqueGenes.length>0)?[1]:[];
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
            geneNameArray:[],
            tissueNameArray:[],
            tissuesForEveryGene:[],
            genesForEveryTissue:[],
            modNameArray:[],
            mods:[]
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
    var resetAccumulatorObject =  function(additionalParameters,specificField){
        if ( typeof specificField !== 'undefined'){
            getAccumulatorObject()[specificField]=sharedAccumulatorObject(additionalParameters)[specificField]
        } else {
            $("#configurableUiTabStorage").data("dataHolder", sharedAccumulatorObject(additionalParameters));
        }
    }



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

            var recordToDisplay = {tissues:[]};
            _.forEach(eachGene.tissues,function(eachTissue){
                recordToDisplay.tissues.push({tissueName:eachTissue})
            });
            returnObject.uniqueEqtlGenes.push(recordToDisplay);
        });
        $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
            returnObject
        ));
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

        $("#dynamicTissueHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicTissueTable')[0].innerHTML,
            returnObject
        ));
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
                    };
                });
            }
        }
        // we have a list of all the genes in the range.  Let's remember that information.
        setAccumulatorObject("geneNameArray",returnObject.uniqueGenes);
        return returnObject;
    };
    var displayRefinedGenesInARange = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        $("#dynamicGeneHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicGeneTable')[0].innerHTML,
            objectContainingRetrievedRecords
        ));
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
            var numberOfElements =  data.data[0].length;
            for ( var variant = 0; variant < numberOfElements; variant++ ){
                var varId = data.data[varIdIndex][variant];
                var gene = data.data[geneIndex][variant];
                var phenotype = data.data[phenotypeIndex][variant];
                if (!returnObject.uniqueGenes.includes(gene)){
                    returnObject.uniqueGenes.push(gene);
                };
                if (!returnObject.uniquePhenotypes.includes(phenotype)){
                    returnObject.uniquePhenotypes.push(phenotype);
                };
                if (!returnObject.uniqueVarIds.includes(varId)){
                    returnObject.uniqueVarIds.push(varId);
                };
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
        _.forEach(objectContainingRetrievedRecords.uniqueVarIds,function(oneTissue) {
            $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+oneTissue+'</div>');
        });
    };
    var displayPhenotypeRecordsFromVariantQtlSearch = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();
        _.forEach(objectContainingRetrievedRecords.uniquePhenotypes,function(onePhenotype) {
            $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+onePhenotype+'</div>');
        });

    };

    var displayContext = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {
        var contextDescr = objectContainingRetrievedRecords;
        $(idForTheTargetDiv).empty().append(Mustache.render($('#contextDescriptionSection')[0].innerHTML,
            contextDescr
        ));
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

            collectionOfRemoteCallingParameters.displayRefinedContextFunction(   collectionOfRemoteCallingParameters.placeToDisplayData,
                                                                        objectContainingRetrievedRecords );

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
            ( typeof startingMaterials.displayRefinedContextFunction !== 'undefined') &&
            ( typeof startingMaterials.placeToDisplayData !== 'undefined') &&
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
            } else {
                console.log("Serious error: incorrect fields in startingMaterials = "+startingMaterials.name+".")
            };
        return returnValue;
    };



    var installDirectorButtonsOnTabs =  function ( additionalParameters) {
        /***
         * gene tab
         * @type {{directorButtons: *[]}}
         */
        var objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'genesWithinRangeButtonId', buttonName: 'proximity', description: 'present all genes overlapping  the specified region'},
                {buttonId: 'eQTL-dynamic-gene-go', buttonName: 'eQTL', description: 'present all genes overlapping  the specified region for which some eQTL relationship exists'},
                {buttonId: 'modAnnotationButtonId', buttonName: 'MOD', description: 'list mouse knockout annotations  for all genes overlapping the specified region'}]
        };
        $("#dynamicGeneHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * variant tab
         * @type {{directorButtons: {buttonId: string, buttonName: string, description: string}[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'getVariantsButtonId', buttonName: 'QTL', description: 'find all variants in the above range with QTL relationship with some phenotype'}]
        };
        $("#dynamicVariantHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * tissue tab
         * @type {{directorButtons: {buttonId: string, buttonName: string, description: string}[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'getTissuesFromEqtlButtonId', buttonName: 'eQTL', description: 'find all tissues for which eQTLs exist foraging in the specified range'}]
        };
        $("#dynamicTissueHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

        /***
         * phenotype tab
         * @type {{directorButtons: *[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [{buttonId: 'getPhenotypesFromQtlButtonId', buttonName: 'QTL', description: 'find all phenotypes for which QTLs exist in the above'}]
        };
        $("#dynamicPhenotypeHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));

    };







    var modifyScreenFields = function (data, additionalParameters) {

        $('#'+additionalParameters.generalizedInputId).typeahead({
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
        $('#'+additionalParameters.generalizedGoButtonId).on('click', function () {
            var somethingSymbol = $('#'+additionalParameters.generalizedInputId).val();
            somethingSymbol = somethingSymbol.replace(/\//g,"_"); // forward slash crashes app (even though it is the LZ standard variant format
            var geneInArray =[{name:somethingSymbol}];
            setAccumulatorObject("geneNameArray",geneInArray);
            if (somethingSymbol) {
                retrieveRefinedContext({ loopOverGenes:geneInArray,
                        gene:somethingSymbol,
                        processEachRecord:processRecordsUpdateContext,
                        retrieveDataUrl:additionalParameters.geneInfoAjaxUrl,
                        displayRefinedContextFunction:displayRangeContext,
                        placeToDisplayData:'#contextDescription'
                    },
                    additionalParameters)
            }
        });

        // pull back mouse annotations
        $('#modAnnotationButtonId').on('click', function () {
            resetAccumulatorObject(additionalParameters,"modNameArray");

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"modAnnotationButtonId",
                retrieveDataUrl:additionalParameters.retrieveModDataUrl,
                dataForCall:_.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}}),
                processEachRecord:processRecordsFromMod,
                displayRefinedContextFunction:displayRefinedModContext,
                placeToDisplayData: '#dynamicPhenotypeHolder div.dynamicUiHolder'
                }));

        });

        // perform an eQTL based lookup
        $('#eQTL-dynamic-gene-go').on('click', function () {

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"eQTL-dynamic-gene-go",
                retrieveDataUrl:additionalParameters.retrieveEqtlDataUrl,
                dataForCall:_.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}}),
                processEachRecord:processRecordsFromEqtls,
                displayRefinedContextFunction:displayTissuesPerGeneFromEqtl,
                placeToDisplayData: '#dynamicTissueHolder div.dynamicUiHolder'
            }));

        });


        // assign the correct response to the proximity range go button
        $('#genesWithinRangeButtonId').on('click', function () {

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"genesWithinRangeButtonId",
                retrieveDataUrl:additionalParameters.retrieveListOfGenesInARangeUrl,
                dataForCall:{
                    chromosome: getAccumulatorObject("chromosome"),
                    startPos: getAccumulatorObject("extentBegin"),
                    endPos: getAccumulatorObject("extentEnd")
                },
                processEachRecord:processRecordsFromProximitySearch,
                displayRefinedContextFunction:displayRefinedGenesInARange,
                placeToDisplayData: '#dynamicGeneHolder div.dynamicUiHolder'
            }));

        });


        $('#getVariantsButtonId').on('click', function () {

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"getVariantsButtonId",
                retrieveDataUrl:additionalParameters.retrieveVariantsWithQtlRelationshipsUrl,
                dataForCall:{
                    chromosome: getAccumulatorObject("chromosome"),
                    startPos: getAccumulatorObject("extentBegin"),
                    endPos: getAccumulatorObject("extentEnd")
                },
                processEachRecord:processRecordsFromVariantQtlSearch,
                displayRefinedContextFunction:displayVariantRecordsFromVariantQtlSearch,
                placeToDisplayData: '#dynamicVariantHolder div.dynamicUiHolder'
            }));

        });


        $('#getTissuesFromEqtlButtonId').on('click', function () {
            resetAccumulatorObject(additionalParameters,"tissueNameArray");

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"getTissuesFromEqtlButtonId",
                retrieveDataUrl:additionalParameters.retrieveEqtlDataUrl,
                dataForCall:_.map(getAccumulatorObject("geneNameArray"),function(o){return {gene:o.name}}),
                processEachRecord:processRecordsFromEqtls,
                displayRefinedContextFunction:displayGenesPerTissueFromEqtl,
                placeToDisplayData: '#dynamicTissueHolder div.dynamicUiHolder'
            }));

        });


        $('#getPhenotypesFromQtlButtonId').on('click', function () {

            retrieveRemotedContextInformation(buildRemoteContextArray ({
                name:"getTissuesFromEqtlButtonId",
                retrieveDataUrl:additionalParameters.retrieveVariantsWithQtlRelationshipsUrl,
                dataForCall:{
                    chromosome: getAccumulatorObject("chromosome"),
                    startPos: getAccumulatorObject("extentBegin"),
                    endPos: getAccumulatorObject("extentEnd")
                },
                processEachRecord:processRecordsFromVariantQtlSearch,
                displayRefinedContextFunction:displayPhenotypeRecordsFromVariantQtlSearch,
                placeToDisplayData: '#dynamicPhenotypeHolder div.dynamicUiHolder'
            }));

        });

        resetAccumulatorObject(additionalParameters);

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



// public routines are declared below
    return {
        installDirectorButtonsOnTabs:installDirectorButtonsOnTabs,
        modifyScreenFields:modifyScreenFields,
        adjustLowerExtent:adjustLowerExtent,
        adjustUpperExtent:adjustUpperExtent
    }

}());


