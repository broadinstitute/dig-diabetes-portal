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
        var returnArray = [];
        _.forEach(data,function(oneRec){
            if (!returnArray.includes(oneRec.Term)){
                returnArray.push(oneRec.Term);
            };
        });
        return returnArray;
    };

    var processRecordsFromEqtls = function (data){
        var returnArray = [];
        _.forEach(data,function(oneRec){
            returnArray.push(oneRec);
        });
        return returnArray;
    };

    var displayRefinedModContext = function (idForTheTargetDiv,arrayOfRetrievedRecords){
        var selectorForIidForTheTargetDiv = '#' + idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(_.uniq(arrayOfRetrievedRecords)),function(onePhenotypeName) {
            $(selectorForIidForTheTargetDiv).append(onePhenotypeName);
        });
    };

    var displayRefinedEqtlContext = function (idForTheTargetDiv,arrayOfRetrievedRecords){
        var selectorForIidForTheTargetDiv = '#' + idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(arrayOfRetrievedRecords,function(onePhenotypeName) {
            $(selectorForIidForTheTargetDiv).append(onePhenotypeName.tissue+'\n');
        });
    };




    var retrieveRefinedContext=function(inParms,additionalParameters){
        var promiseArray = [];
        var rememberInParmsGene = inParms.gene;
        var rememberProcessEachRecord = inParms.processEachRecord;
        var rememberRetrieveDataUrl = inParms.retrieveDataUrl;
        var rememberDisplayRefinedContextFunction =  inParms.displayRefinedContextFunction;
        var rememberPhenoHolder = additionalParameters.phenoHolder;
        var arrayOfRetrievedRecords = [];
        promiseArray.push(
            $.ajax({
                cache: false,
                type: "post",
                url: rememberRetrieveDataUrl,
                data: { gene: rememberInParmsGene },
                async: true
            }).done(function (data, textStatus, jqXHR) {

                arrayOfRetrievedRecords = rememberProcessEachRecord( data );

            }).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                core.errorReporter(jqXHR, errorThrown)
            })
        );
        $.when.apply($, promiseArray).then(function(allCalls) {

            rememberDisplayRefinedContextFunction( rememberPhenoHolder, arrayOfRetrievedRecords );

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


