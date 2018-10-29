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

    var processRecordsFromMod = function (data){
        var returnObject = {rawData:[],
            uniqueGenes:[],
            uniqueTissues:[]};
        _.forEach(data,function(oneRec){
            if (!returnObject.uniqueTissues.includes(oneRec)){
                returnObject.uniqueTissues.push(oneRec);
            };
            returnObject.rawData.push(oneRec);
        });
        return returnObject;
    };

    var processRecordsFromEqtls = function (data){
        var returnObject = {rawData:[],
                            uniqueGenes:[],
                            uniqueTissues:[]};
        _.forEach(data,function(oneRec){
            returnObject.rawData.push(oneRec);
            if (!returnObject.uniqueGenes.includes(oneRec.gene)){
                returnObject.uniqueGenes.push(oneRec.gene);
            };
            if (!returnObject.uniqueTissues.includes(oneRec.tissue)){
                returnObject.uniqueTissues.push(oneRec.tissue);
            };
        });
        return returnObject;
    };

    var displayRefinedModContext = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var selectorForIidForTheTargetDiv = '#' + idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(_.uniq(objectContainingRetrievedRecords.rawData)),function(onePhenotypeName) {
            $(selectorForIidForTheTargetDiv).append(onePhenotypeName.Term+'\n');
        });
    };

    var displayRefinedEqtlContext = function (idForTheTargetDiv,objectContainingRetrievedRecords){
        var selectorForIidForTheTargetDiv = '#' + idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(objectContainingRetrievedRecords.uniqueTissues,function(oneTissue) {
            $(selectorForIidForTheTargetDiv).append(oneTissue+'\n');
        });
    };




    var retrieveRefinedContext=function(inParms,additionalParameters){
        var promiseArray = [];
        var rememberInParmsGene = inParms.gene;
        var rememberProcessEachRecord = inParms.processEachRecord;
        var rememberRetrieveDataUrl = inParms.retrieveDataUrl;
        var rememberDisplayRefinedContextFunction =  inParms.displayRefinedContextFunction;
        var rememberPhenoHolder = additionalParameters.phenoHolder;
        var objectContainingRetrievedRecords = [];
        promiseArray.push(
            $.ajax({
                cache: false,
                type: "post",
                url: rememberRetrieveDataUrl,
                data: { gene: rememberInParmsGene },
                async: true
            }).done(function (data, textStatus, jqXHR) {

                objectContainingRetrievedRecords = rememberProcessEachRecord( data );// HEY -- I should return an object
                // with useful summary information, and not just an array of strings. I started in
                // processRecordsFromEqtls, but the MODS data is still handled the old way.

            }).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                core.errorReporter(jqXHR, errorThrown)
            })
        );
        $.when.apply($, promiseArray).then(function(allCalls) {

            rememberDisplayRefinedContextFunction( rememberPhenoHolder, objectContainingRetrievedRecords );

        }, function(e) {
            console.log("Ajax call failed");
        });

    };




    var modifyScreenFields = function (data, additionalParameters) {
        var updateDynamicUiInResponseToButtonClick = function(item, additionalParameters) {
            retrieveRefinedContext(item, additionalParameters);
        };
        $('#'+additionalParameters.generalizedInputId).typeahead({
            source: function (query, process) {
                $.get(additionalParameters.generalizedTypeaheadUrl, {query: query}, function (data) {
                    process(data, additionalParameters);
                })
            },
            afterSelect: function(selection) {
                updateDynamicUiInResponseToButtonClick({gene:selection,
                        processEachRecord:processRecordsFromMod,
                        retrieveDataUrl:additionalParameters.retrieveModDataUrl,
                        displayRefinedContextFunction:displayRefinedModContext},
                    additionalParameters);
            }
        });

        // assign the correct response to the MOD go button
        $('#'+additionalParameters.generalizedGoButtonId).on('click', function () {
            var somethingSymbol = $('#'+additionalParameters.generalizedInputId).val();
            somethingSymbol = somethingSymbol.replace(/\//g,"_"); // forward slash crashes app (even though it is the LZ standard variant format
            if (somethingSymbol) {
                updateDynamicUiInResponseToButtonClick({   gene:somethingSymbol,
                        processEachRecord:processRecordsFromMod,
                        retrieveDataUrl:additionalParameters.retrieveModDataUrl,
                        displayRefinedContextFunction:displayRefinedModContext
                    },
                    additionalParameters)
            }
        });

        // assign the correct response to the eQTL go button
        $('#'+additionalParameters.eQTLGoButtonId).on('click', function () {
            var somethingSymbol = $('#'+additionalParameters.generalizedInputId).val();
            somethingSymbol = somethingSymbol.replace(/\//g,"_"); // forward slash crashes app (even though it is the LZ standard variant format
            if (somethingSymbol) {
                updateDynamicUiInResponseToButtonClick({   gene:somethingSymbol,
                        processEachRecord:processRecordsFromEqtls,
                        retrieveDataUrl:additionalParameters.retrieveEqtlDataUrl,
                        displayRefinedContextFunction:displayRefinedEqtlContext},
                    additionalParameters)
            }
        });

    };


// public routines are declared below
    return {
        modifyScreenFields:modifyScreenFields
    }

}());


