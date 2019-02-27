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

(function( factory ){
    if ( typeof define === 'function' && define.amd ) {
        // AMD
        define( ['jquery', 'datatables.net'], function ( $ ) {
            return factory( $, window, document );
        } );
    }
    else if ( typeof exports === 'object' ) {
        // CommonJS
        module.exports = function (root, $) {
            if ( ! root ) {
                root = window;
            }

            if ( ! $ || ! $.fn.dataTable ) {
                $ = require('datatables.net')(root, $).$;
            }

            return factory( $, root, root.document );
        };
    }
    else {
        // Browser
        factory( jQuery, window, document );
    }
}(function( $, window, document, undefined ) {
    'use strict';

// Unique value allowing multiple absolute ordering use cases on a single page.
    var _unique = 0;

// Function to encapsulate code that is common to both the string and number
// ordering plug-ins.
    var _setup = function ( values ) {
        if ( ! $.isArray( values ) ) {
            values = [ values ];
        }

        var o = {
            name: 'absoluteOrder'+(_unique++),
            alwaysTop: {},
            alwaysBottom: {}
        };

        // In order to provide performance, the symbols that are to be looked for
        // are stored as parameter keys in an object, allowing O(1) lookup, rather
        // than O(n) if it were in an array.
        for ( var i=0, ien=values.length ; i<ien ; i++ ) {
            var conf = values[i];

            if ( typeof conf === 'string' ) {
                o.alwaysTop[ conf ] = true;
            }
            else if ( conf.position === undefined || conf.position === 'top' ) {
                o.alwaysTop[ conf.value ] = true;
            }
            else {
                o.alwaysBottom[ conf.value ] = true;
            }
        }

        // Ascending ordering method
        o.asc = function ( a, b, isNumber ) {
            if ( o.alwaysTop[ a ] && o.alwaysTop[ b ] ) {
                return 0;
            }
            else if ( o.alwaysBottom[ a ] && o.alwaysBottom[ b ] ) {
                return 0;
            }
            else if ( o.alwaysTop[ a ] || o.alwaysBottom[ b ] ) {
                return -1;
            }
            else if ( o.alwaysBottom[ a ] || o.alwaysTop[ b ] ) {
                return 1;
            }

            if ( isNumber ) {
                // Cast as a number if required
                if ( typeof a === 'string' ) {
                    a = a.replace(/[^\d\-\.]/g, '') * 1;
                }
                if ( typeof b === 'string' ) {
                    b = b.replace(/[^\d\-\.]/g, '') * 1;
                }
            }

            return ((a < b) ? -1 : ((a > b) ? 1 : 0));
        };

        // Descending ordering method
        o.desc = function ( a, b, isNumber ) {
            if ( o.alwaysTop[ a ] && o.alwaysTop[ b ] ) {
                return 0;
            }
            else if ( o.alwaysBottom[ a ] && o.alwaysBottom[ b ] ) {
                return 0;
            }
            else if ( o.alwaysTop[ a ] || o.alwaysBottom[ b ] ) {
                return -1;
            }
            else if ( o.alwaysBottom[ a ] || o.alwaysTop[ b ] ) {
                return 1;
            }

            if ( isNumber ) {
                if ( typeof a === 'string' ) {
                    a = a.replace(/[^\d\-\.]/g, '') * 1;
                }
                if ( typeof b === 'string' ) {
                    b = b.replace(/[^\d\-\.]/g, '') * 1;
                }
            }

            return ((a < b) ? 1 : ((a > b) ? -1 : 0));
        };

        return o;
    };

// String based ordering
    $.fn.dataTable.absoluteOrder = function ( values ) {
        var conf = _setup( values );

        $.fn.dataTable.ext.type.order[ conf.name+'-asc' ] = conf.asc;
        $.fn.dataTable.ext.type.order[ conf.name+'-desc' ] = conf.desc;

        // Return the name of the sorting plug-in that was created so it can be used
        // with the `columns.type` parameter. There is no auto-detection here.
        return conf.name;
    };

// Number based ordering - strips out everything but the number information
    $.fn.dataTable.absoluteOrderNumber = function ( values ) {
        var conf = _setup( values );

        $.fn.dataTable.ext.type.order[ conf.name+'-asc' ] = function ( a, b ) {
            return conf.asc( a, b, true );
        };
        $.fn.dataTable.ext.type.order[ conf.name+'-desc' ] = function ( a, b ) {
            return conf.desc( a, b, true );
        };

        return conf.name;
    };


}));



mpgSoftware.dynamicUi = (function () {
    var loading = $('#rSpinner');
    var commonTable;
    var dyanamicUiVariables;
    var clearBeforeStarting = false;

    var setDyanamicUiVariables = function (incomingDyanamicUiVariables) {
        dyanamicUiVariables = incomingDyanamicUiVariables;
    };

    var getDyanamicUiVariables = function () {
        return dyanamicUiVariables;
    };


    var actionDefaultFollowUp = function (actionId) {
        var defaultFollowUp = {
            displayRefinedContextFunction: undefined,
            placeToDisplayData: undefined,
            actionId: undefined
        };
        switch (actionId) {

            case "getTissuesFromProximityForLocusContext":
                defaultFollowUp.displayRefinedContextFunction = displayRefinedGenesInARange;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getTissuesFromEqtlsForTissuesTable":
                defaultFollowUp.displayRefinedContextFunction = displayGenesPerTissueFromEqtl;
                defaultFollowUp.placeToDisplayData = '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getTissuesFromEqtlsForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = displayTissuesPerGeneFromEqtl;
                defaultFollowUp.placeToDisplayData = '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getVariantsFromQtlForContextDescription":
                defaultFollowUp.displayRefinedContextFunction = displayVariantRecordsFromVariantQtlSearch;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromQtlForPhenotypeTable":
                defaultFollowUp.displayRefinedContextFunction = displayPhenotypeRecordsFromVariantQtlSearch;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromECaviarForPhenotypeTable":
                defaultFollowUp.displayRefinedContextFunction = displayPhenotypesFromColocalization;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getPhenotypesFromECaviarForTissueTable":
                defaultFollowUp.displayRefinedContextFunction = displayTissuesFromColocalization;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getRecordsFromECaviarForGeneTable":
                defaultFollowUp.displayRefinedContextFunction = displayGenesFromColocalization;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getAnnotationsFromModForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = displayRefinedModContext;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "replaceGeneContext":
                defaultFollowUp.displayRefinedContextFunction = displayRangeContext;
                defaultFollowUp.placeToDisplayData = '#contextDescription';
                break;

            case "getTissuesFromAbcForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = displayGenesFromAbc;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getGeneAssociationsForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = displayGenePhenotypeAssociations;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;
            case "getInformationFromDepictForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = displayGenesFromDepict;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;


            case "getRecordsFromAbcForTissueTable":
                defaultFollowUp.displayRefinedContextFunction = displayTissuesFromAbc;
                defaultFollowUp.placeToDisplayData = '#dynamicTissueHolder div.dynamicUiHolder';
                break;

            case "getVariantsWeWillUseToBuildTheVariantTable":
                defaultFollowUp.displayRefinedContextFunction = displayVariantsForAPhenotype;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            case "getEqtlsGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = displayEqtlsGivenVariantList;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            case "getABCGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = displayAbcGivenVariantList;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            case "getDnaseGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = displayDnaseGivenVariantList;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;
            case "getH3k27acGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = displayH3k27acGivenVariantList;
                defaultFollowUp.placeToDisplayData = '#dynamicVariantHolder div.dynamicUiHolder';
                break;

            default:
                break;
        }
        return defaultFollowUp;
    }


    var actionContainer = function (actionId, followUp) {
        var additionalParameters = getDyanamicUiVariables();
        var displayFunction = ( typeof followUp.displayRefinedContextFunction !== 'undefined') ? followUp.displayRefinedContextFunction : undefined;
        var displayLocation = ( typeof followUp.placeToDisplayData !== 'undefined') ? followUp.placeToDisplayData : undefined;
        var nextActionId = ( typeof followUp.actionId !== 'undefined') ? followUp.actionId : undefined;

        var functionToLaunchDataRetrieval;

        switch (actionId) {

            case "getTissuesFromProximityForLocusContext":
                functionToLaunchDataRetrieval = function () {
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getTissuesFromProximityForLocusContext",
                        retrieveDataUrl: additionalParameters.retrieveListOfGenesInARangeUrl,
                        dataForCall: {
                            chromosome: chromosome,
                            startPos: startPos,
                            endPos: endPos
                        },
                        processEachRecord: processRecordsFromProximitySearch,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));
                };
                break;

            case "getTissuesFromEqtlsForTissuesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getTissuesFromEqtlsForTissuesTable"});
                        actionToUndertake();
                    } else {
                        resetAccumulatorObject("tissueNameArray");
                        resetAccumulatorObject("tissuesForEveryGene");
                        resetAccumulatorObject("genesForEveryTissue");
                        var geneNameArray = _.map(getAccumulatorObject("geneInfoArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getTissuesFromEqtlsForTissuesTable",
                            retrieveDataUrl: additionalParameters.retrieveEqtlDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromEqtls,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                }
                break;

            case "getTissuesFromEqtlsForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getTissuesFromEqtlsForGenesTable"});
                        actionToUndertake();
                    } else {
                        resetAccumulatorObject("tissueNameArray");
                        resetAccumulatorObject("genesForEveryTissue");
                        resetAccumulatorObject("tissuesForEveryGene");
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getTissuesFromEqtlsForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveEqtlDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromEqtls,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;

            case "getGeneAssociationsForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getGeneAssociationsForGenesTable"});
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype
                            }
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getGeneAssociationsForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveGeneLevelAssociationsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processGeneAssociationRecords,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;
            case "getVariantsFromQtlForContextDescription":
                functionToLaunchDataRetrieval = function () {
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
                functionToLaunchDataRetrieval = function () {
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    resetAccumulatorObject("phenotypesForEveryVariant");
                    resetAccumulatorObject("variantsForEveryPhenotype");
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getPhenotypesFromQtlForPhenotypeTable",
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


            case "getPhenotypesFromECaviarForPhenotypeTable":
                functionToLaunchDataRetrieval = function () {
                    var chromosome = getAccumulatorObject("chromosome");
                    var startPos = getAccumulatorObject("extentBegin");
                    var endPos = getAccumulatorObject("extentEnd");
                    var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                        return {gene: o.name}
                    });
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getPhenotypesFromECaviarForPhenotypeTable",
                        retrieveDataUrl: additionalParameters.retrieveECaviarDataUrl,
                        dataForCall: geneNameArray,
                        processEachRecord: processRecordsFromColocalization,//TODO
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));
                };
                break;

            case "getPhenotypesFromECaviarForTissueTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getPhenotypesFromECaviarForTissueTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getPhenotypesFromECaviarForPhenotypeTable",
                            retrieveDataUrl: additionalParameters.retrieveECaviarDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromColocalization,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));

                    }
                };
                break;

            case "getRecordsFromECaviarForGeneTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getRecordsFromECaviarForGeneTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getRecordsFromECaviarForGeneTable",
                            retrieveDataUrl: additionalParameters.retrieveECaviarDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: processRecordsFromColocalization,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;


            case "getAnnotationsFromModForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    resetAccumulatorObject("modNameArray");
                    var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                        return {gene: o.name}
                    });
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getAnnotationsFromModForGenesTable",
                        retrieveDataUrl: additionalParameters.retrieveModDataUrl,
                        dataForCall: geneNameArray,
                        processEachRecord: processRecordsFromMod,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));
                };
                break;

            case "replaceGeneContext":
                functionToLaunchDataRetrieval = function () {
                    var somethingSymbol = $('#inputBoxForDynamicContextId').val();
                    somethingSymbol = somethingSymbol.replace(/\//g, "_");
                    setAccumulatorObject("geneNameArray", [{name: somethingSymbol}]);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "replaceGeneContext",
                        retrieveDataUrl: additionalParameters.geneInfoAjaxUrl,
                        dataForCall: {geneName: somethingSymbol},
                        processEachRecord: processRecordsUpdateContext,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));
                };
                break;

            case "getTissuesFromAbcForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getTissuesFromAbcForGenesTable"});
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
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getRecordsFromAbcForTissueTable"});
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getRecordsFromAbcForTissueTable",
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
                functionToLaunchDataRetrieval = function () {

                    var phenotype = $('li.chosenPhenotype').attr('id');
                    var chromosome = $('span.dynamicUiChromosome').text();
                    var startExtent = $('span.dynamicUiGeneExtentBegin').text();
                    var endExtent = $('span.dynamicUiGeneExtentEnd').text();
                    var dataNecessaryToRetrieveVariantsPerPhenotype;
                    if (( typeof phenotype === 'undefined') ||
                        (typeof chromosome === 'undefined') ||
                        (typeof startExtent === 'undefined') ||
                        (typeof endExtent === 'undefined')) {
                        alert(" missing a value when we want to collect variants for a phenotype");
                    } else {
                        dataNecessaryToRetrieveVariantsPerPhenotype = {
                            phenotype: phenotype,
                            geneToSummarize: "chr" + chromosome + ":" + startExtent + "-" + endExtent
                        }

                    }


                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getVariantsWeWillUseToBuildTheVariantTable",
                        retrieveDataUrl: additionalParameters.retrieveTopVariantsAcrossSgsUrl,
                        dataForCall: dataNecessaryToRetrieveVariantsPerPhenotype,
                        processEachRecord: processRecordsFromQtl,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId
                    }));

                };
                break;

            case "getEqtlsGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("variantNameArray")) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable", {actionId: "getEqtlsGivenVariantList"});
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject("variantNameArray").length > 0) {
                            variantsAsJson = "[\"" + getAccumulatorObject("variantNameArray").join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getEqtlsGivenVariantList",
                            retrieveDataUrl: additionalParameters.retrieveEqtlDataWithVariantsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processEqtlRecordsFromVariantBasedRequest,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;
            case "getABCGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("variantNameArray")) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable", {actionId: "getABCGivenVariantList"});
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject("variantNameArray").length > 0) {
                            variantsAsJson = "[\"" + getAccumulatorObject("variantNameArray").join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getABCGivenVariantList",
                            retrieveDataUrl: additionalParameters.retrieveAbcDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processAbcRecordsFromVariantBasedRequest,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;
            case "getInformationFromDepictForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneNameArray")) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext", {actionId: "getInformationFromDepictForGenesTable"});
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneNameArray"), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype
                            }
                        });

                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getInformationFromDepictForGenesTable",
                            retrieveDataUrl: additionalParameters.retrieveDepictDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processRecordsFromDepict,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;
            case "getDnaseGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("variantNameArray")) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable", {actionId: "getDnaseGivenVariantList"});
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject("variantNameArray").length > 0) {
                            variantsAsJson = "[\"" + getAccumulatorObject("variantNameArray").join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getDnaseGivenVariantList",
                            retrieveDataUrl: additionalParameters.retrieveDnaseDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processDnaseRecordsFromVariantBasedRequest,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
                };
                break;
            case "getH3k27acGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("variantNameArray")) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable", {actionId: "getH3k27acGivenVariantList"});
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject("variantNameArray").length > 0) {
                            variantsAsJson = "[\"" + getAccumulatorObject("variantNameArray").join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: "getH3k27acGivenVariantList",
                            retrieveDataUrl: additionalParameters.retrieveH3k27acDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: processH3k27acRecordsFromVariantBasedRequest,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId
                        }));
                    }
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
    var processRecordsUpdateContext = function (data) {
        var returnObject = {
            geneName: undefined,
            chromosome: undefined,
            extentBegin: undefined,
            extentEnd: undefined,
        };
        if (( typeof data !== 'undefined') &&
            ( typeof data.geneInfo !== 'undefined')) {
            returnObject.geneName = data.geneInfo.Gene_name;
            returnObject.chromosome = data.geneInfo.CHROM;
            returnObject.extentBegin = data.geneInfo.BEG - 1;
            returnObject.extentEnd = data.geneInfo.END + 1;
        }
        return returnObject;
    };
    var displayRangeContext = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty().append(Mustache.render($('#contextDescriptionSection')[0].innerHTML,
            objectContainingRetrievedRecords
        ));
        setAccumulatorObject("extentBegin", objectContainingRetrievedRecords.extentBegin);
        setAccumulatorObject("extentEnd", objectContainingRetrievedRecords.extentEnd);
        setAccumulatorObject("chromosome", objectContainingRetrievedRecords.chromosome);
        setAccumulatorObject("originalGeneName", objectContainingRetrievedRecords.geneName);

        addAdditionalResultsObject({
            rangeContext: {
                extentBegin: objectContainingRetrievedRecords.extentBegin,
                extentEnd: objectContainingRetrievedRecords.extentEnd,
                chromosome: objectContainingRetrievedRecords.chromosome,
                geneName: objectContainingRetrievedRecords.geneName
            }
        })
    }


    /***
     * Mod annotation search
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var processRecordsFromMod = function (data) {
        var returnObject = {
            rawData: [],
            uniqueGenes: [],
            uniqueMods: []
        };
        var originalGene = data.gene;
        if (data.records.length === 0) {
            // no mods.  add an empty record for this gene to the global structure
            var modNameArray = getAccumulatorObject("modNameArray");
            modNameArray.push({geneName: originalGene, mods: []});
            setAccumulatorObject("modNameArray", modNameArray);
            if (!returnObject.uniqueGenes.includes(originalGene)) {
                returnObject.uniqueGenes.push(originalGene);
            }
            ;
        } else {
            // we have mods for this gene. First let's save them
            _.forEach(data.records, function (oneRec) {
                if (!returnObject.uniqueGenes.includes(oneRec.Human_gene)) {
                    returnObject.uniqueGenes.push(oneRec.Human_gene);
                }
                ;
                if (!returnObject.uniqueMods.includes(oneRec.Term)) {
                    returnObject.uniqueMods.push(oneRec.Term);
                }
                ;
                returnObject.rawData.push(oneRec);
            });
            // now let's add them to our global structure.  First, find any record for this gene that we might already have
            var geneIndex = _.findIndex(getAccumulatorObject("modNameArray"), {geneName: originalGene});
            if (geneIndex < 0) { // this is the only path we ever take, right
                var modNameArray = getAccumulatorObject("modNameArray");
                modNameArray.push({
                    geneName: originalGene,
                    mods: returnObject.uniqueMods
                });
                setAccumulatorObject("modNameArray", modNameArray);
            } else { // we already know about this tissue, but have we seen this gene associated with it before?
                alert('this never happens, I think');
                var tissueRecord = getAccumulatorObject("modNameArray")[geneIndex];
                _.forEach(uniqueMods, function (oneMod) {
                    if (!tissueRecord.mods.includes(oneMod)) {
                        tissueRecord.mods.push(oneMod);
                    }
                });
            }
        }
        return returnObject;
    };
    var displayRefinedModContext = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(getAccumulatorObject("modNameArray"), function (geneWithMods) {
            returnObject.uniqueGenes.push({name: geneWithMods.geneName});

            var recordToDisplay = {
                mods: [],
                geneName: geneWithMods.geneName
            };
            _.forEach(geneWithMods.mods, function (eachMod) {
                recordToDisplay.mods.push({modName: eachMod})
            });
            returnObject.geneModTerms.push(recordToDisplay);

        });

        addAdditionalResultsObject({refinedModContext: returnObject});
        var intermediateDataStructure = new IntermediateDataStructure();

        // Mod data for the gene table
        if (returnObject.genesExist()) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                subcategory: 'MOD',
                columnCells: []
            });
            _.forEach(returnObject.uniqueGenes, function (uniqueGene) {
                intermediateDataStructure.headerNames.push(uniqueGene.name);
                intermediateDataStructure.headerContents.push(Mustache.render($("#dynamicGeneTableHeader")[0].innerHTML, uniqueGene));
                intermediateDataStructure.headers.push({
                    name: uniqueGene.name,
                    contents: Mustache.render($("#dynamicGeneTableHeader")[0].innerHTML, uniqueGene)
                });
                intermediateDataStructure.rowsToAdd[0].columnCells.push("");
            });

        }
        if (( typeof returnObject.geneModsExist !== 'undefined') && ( returnObject.geneModsExist())) {

            _.forEach(returnObject.geneModTerms, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames, recordsPerGene.geneName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = Mustache.render($("#dynamicGeneTableBody")[0].innerHTML, recordsPerGene);
                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicGeneTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');

    };

    /***
     * The object is passed into mustache and describes the display that will be presented to users
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueEqtlGenes: Array, genePositions: Array, uniqueTissues: Array, geneTissueEqtls: Array, geneModTerms: Array, genesPositionsExist: (function(): *), genesExist: (function(): *), tissuesExist: (function(): *), eqtlTissuesExist: (function(): *), eqtlGenesExist: (function(): *), geneModsExist: (function(): *)}}
     */
    var createNewDisplayReturnObject = function () {
        return {
            rawData: [],
            uniqueGenes: [],
            uniqueEqtlGenes: [],
            genePositions: [],
            uniqueTissues: [],
            uniquePhenotypes: [],
            uniqueVariants: [],
            geneTissueEqtls: [],
            variantPhenotypeQtl: [],
            phenotypeVariantQtl: [],
            geneModTerms: [],
            phenotypesByColocalization: [],
            genesByAbc: [],
            genesByDepict: [],
            tissuesByAbc: [],
            geneAssociations: [],
            variantsToAnnotate: [],
            genesPositionsExist: function () {
                return (this.genePositions.length > 0) ? [1] : [];
            },
            genesExist: function () {
                return (this.uniqueGenes.length > 0) ? [1] : [];
            },
            variantsExist: function () {
                return (this.uniqueVariants.length > 0) ? [1] : [];
            },
            phenotypesExist: function () {
                return (this.uniquePhenotypes.length > 0) ? [1] : [];
            },
            tissuesExist: function () {
                return (this.uniqueTissues.length > 0) ? [1] : [];
            },
            eqtlTissuesExist: function () {
                return (this.uniqueEqtlGenes.length > 0) ? [1] : [];
            },
            eqtlGenesExist: function () {
                return (this.geneTissueEqtls.length > 0) ? [1] : [];
            },
            geneModsExist: function () {
                return (this.geneModTerms.length > 0) ? [1] : [];
            },
            variantPhenotypesExist: function () {
                return (this.variantPhenotypeQtl.length > 0) ? [1] : [];
            },
            phenotypeVariantsExist: function () {
                return (this.phenotypeVariantQtl.length > 0) ? [1] : [];
            }

        };
    };

    /***
     * Default constructor of the shared accumulator object
     * @param additionalParameters
     * @returns {{extentBegin: (*|jQuery), extentEnd: (*|jQuery), chromosome: string, originalGeneName: *, geneNameArray: Array, tissueNameArray: Array, modNameArray: Array, mods: Array, contextDescr: {chromosome: string, extentBegin: (*|jQuery), extentEnd: (*|jQuery), moreContext: Array}}}
     */
    var AccumulatorObject = function (additionalParameters) {
        var chrom = (additionalParameters.geneChromosome.indexOf('chr') > -1) ?
            additionalParameters.geneChromosome.substr(3) :
            additionalParameters.geneChromosome;
        return {
            extentBegin: additionalParameters.geneExtentBegin,
            extentEnd: additionalParameters.geneExtentEnd,
            chromosome: chrom,
            originalGeneName: additionalParameters.geneName
        };
    };

    /***
     * retrieve the accumulator object, pulling back a specified field if requested
     * @param chosenField
     * @returns {jQuery}
     */
    var getAccumulatorObject = function (chosenField) {
        var accumulatorObject = $("#configurableUiTabStorage").data("dataHolder");
        var returnValue;
        if (typeof accumulatorObject === 'undefined') {
            alert('Fatal error.  Malfunction is imminent. Missing accumulator object.');
            return;
        }
        if (typeof chosenField !== 'undefined') {
            returnValue = accumulatorObject[chosenField];
            if (typeof returnValue === 'undefined') {
                // if someone requests a field that doesn't exist then let's presume that they are going to
                //  want an array. Create one, add it to the accumulator object, and then give them a pointer to it
                accumulatorObject[chosenField] = new Array();
                returnValue = accumulatorObject[chosenField];
            }
        } else {
            returnValue = accumulatorObject;
        }

        return returnValue
    };

    /***
     * store the accumulator object in the DOM
     * @param accumulatorObject
     * @returns {*}
     */
    var setAccumulatorObject = function (specificField, value) {
        if (typeof specificField === 'undefined') {
            alert("Serious error.  Attempted assignment of unspecified field.");
            return;
        }
        var accumulatorObject = getAccumulatorObject();
        accumulatorObject[specificField] = value;
        return getAccumulatorObject(specificField);
    };

    /***
     * Reset the chosen field in the accumulator object to its default value. If no field is specified then reset the entire
     * accumulator object to its default.
     */
    var resetAccumulatorObject = function (specificField) {
        var additionalParameters = getDyanamicUiVariables();
        var filledOutSharedAccumulatorObject = new AccumulatorObject(additionalParameters);
        if (typeof specificField !== 'undefined') {
            if (typeof filledOutSharedAccumulatorObject === 'undefined') {
                alert(" Unexpected absence of field '" + specificField + "' in shared accumulator object");
            }
            setAccumulatorObject(specificField, []);
        } else {
            $("#configurableUiTabStorage").data("dataHolder", filledOutSharedAccumulatorObject);
        }
    };


    var addAdditionalResultsObject = function (returnObject) {
        var resultsArray = getAccumulatorObject("resultsArray");
        if (typeof resultsArray === 'undefined') {
            setAccumulatorObject("resultsArray", []);
            resultsArray = getAccumulatorObject("resultsArray");
        }
        resultsArray.push(returnObject);
    };


    var accumulatorObjectFieldEmpty = function (specificField) {
        var returnValue = true;
        var accumulatorObjectField = getAccumulatorObject(specificField);
        if (Array.isArray(accumulatorObjectField)) {
            if (accumulatorObjectField.length > 0) {
                returnValue = false;
            }
        }
        return returnValue;
    };

    function IntermediateDataStructure() {
        this.headerNames = [];
        this.headerContents = [];
        this.headers = [];
        this.rowsToAdd = [];
        this.tableToUpdate = "";
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
    var prepareToPresentToTheScreen = function (idForTheTargetDiv,
                                                templateInfo,
                                                returnObject,
                                                clearBeforeStarting,
                                                intermediateDataStructure,
                                                storeRecords,
                                                typeOfRecord) {
        if (clearBeforeStarting) {
            $(idForTheTargetDiv).empty();
        }

        if (typeof intermediateDataStructure !== 'undefined') {

            buildOrExtendDynamicTable(intermediateDataStructure.tableToUpdate,
                intermediateDataStructure,
                storeRecords,
                typeOfRecord);

        } else {

            $(idForTheTargetDiv).append(Mustache.render($(templateInfo)[0].innerHTML,
                returnObject
            ));

        }


    }



    var processGeneAssociationRecords = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: []
        };

        var rawGeneAssociationRecords = getAccumulatorObject('rawGeneAssociationRecords');

        if ( ( typeof data !== 'undefined') &&
             (  data.is_error !== true ) &&
             (  data.numRecords > 0 ) &&
             ( typeof data.variants !== 'undefined' ) )

            var geneRecord = {};
            _.forEach(data.variants[0], function (oneRec) {
                _.forEach(oneRec, function(sampleRecord,tissue){
                    if (tissue==='GENE') {
                        geneRecord['gene'] = sampleRecord;
                        geneRecord['tissues'] = [];
                    } else {
                        _.forEach(sampleRecord, function (phenotypeRecord, dataset) {
                            _.forEach(phenotypeRecord, function (number, phenotypeString) {
                                console.log("phenotypeString=" + phenotypeString + ", number, " + number);
                                if (number !== null) {
                                    geneRecord['tissues'].push({tissue: tissue, value: number});

                                }
                            })
                        });
                    }
                });
            });
        if (typeof geneRecord.gene !== 'undefined'){
            rawGeneAssociationRecords.push(geneRecord);
        }

        return rawGeneAssociationRecords;

    };






    var processRecordsFromColocalization = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: []
        };

        var rawColocalizationInfo = getAccumulatorObject('rawColocalizationInfo');

        _.forEach(data, function (oneRec) {

            rawColocalizationInfo.push(oneRec);

        });

        return rawColocalizationInfo;
    };


    var processRecordsFromAbc = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: []
        };

        var rawAbcInfo = getAccumulatorObject('rawAbcInfo');

        _.forEach(data, function (oneRec) {

            rawAbcInfo.push(oneRec);

        });

        return rawAbcInfo;
    };


    var processRecordsFromDepict = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: []
        };

        var rawAbcInfo = getAccumulatorObject('rawDepictInfo');

        _.forEach(data, function (oneRec) {

            rawAbcInfo.push(oneRec);

        });

        return rawAbcInfo;
    };


    var processRecordsFromQtl = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: []
        };

        var rawQtlInfo = getAccumulatorObject('rawQtlInfo');
        var sampleGroupWithCredibleSetNames = (data.sampleGroupsWithCredibleSetNames.length > 0) ? data.sampleGroupsWithCredibleSetNames[0] : "";
        if (sampleGroupWithCredibleSetNames.length > 0) {
            rawQtlInfo["credSetDataset"] = sampleGroupWithCredibleSetNames;
            rawQtlInfo["variants"] = _.filter(data.variants.variants, function (o) {
                return o.dataset === "GWAS_IBDGenetics_eu_CrdSet_mdv80"
            });
        } else {
            rawQtlInfo["credSetDataset"] = sampleGroupWithCredibleSetNames;
            rawQtlInfo["variants"] = _.filter(data.variants.variants, function (o, cnt) {
                return cnt < 10
            });
        }


        return rawQtlInfo;
    };


    var retrieveExtents = function (geneName, defaultStart, defaultEnd) {
        var returnValue = {regionStart: defaultStart, regionEnd: defaultEnd};
        var geneInfoArray = getAccumulatorObject("geneInfoArray");
        var geneInfoIndex = _.findIndex(geneInfoArray, {name: geneName});
        if (geneInfoIndex >= 0) {
            returnValue.regionStart = geneInfoArray[geneInfoIndex].startPos;
            returnValue.regionEnd = geneInfoArray[geneInfoIndex].endPos;
        }
        return returnValue
    }


    var displayGenesFromAbc = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        // for each gene collect up the data we want to display
        _.forEach(_.groupBy(getAccumulatorObject("rawAbcInfo"), 'GENE'), function (value, geneName) {
            var geneObject = {geneName: geneName};
            geneObject['source'] = _.map(_.uniqBy(value, 'SOURCE'), function (o) {
                return o.SOURCE
            }).sort();
            geneObject['experiment'] = _.map(_.uniqBy(value, 'EXPERIMENT'), function (o) {
                return o.EXPERIMENT
            }).sort();
            geneObject['chrom'] = _.first(_.map(_.uniqBy(value, 'CHROM'), function (o) {
                return o.CHROM
            }).sort());
            var startPosRec = _.minBy(value, function (o) {
                return o.START
            });
            geneObject['start_pos'] = (startPosRec) ? startPosRec.START : 0;
            var stopPosRec = _.maxBy(value, function (o) {
                return o.STOP
            });
            geneObject['stop_pos'] = (stopPosRec) ? stopPosRec.STOP : 0;
            geneObject['abcTissuesVector'] = function () {
                return geneObject['source'];
            };
            geneObject['sourceByTissue'] = function () {
                return _.groupBy(value, 'SOURCE');
            };
            var extents = retrieveExtents(geneName, startPosRec, stopPosRec);
            geneObject['regionStart'] = extents.regionStart;
            geneObject['regionEnd'] = extents.regionEnd;

            returnObject.genesByAbc.push(geneObject);

        });

        // now concoct a few functions that mustache can call
        returnObject['abcGenesExist'] = function () {
            return (this.genesByAbc.length > 0) ? [1] : [];
        };


        addAdditionalResultsObject({genesFromAbc: returnObject});


        var intermediateDataStructure = new IntermediateDataStructure();

        if (( typeof returnObject.abcGenesExist !== 'undefined') && ( returnObject.abcGenesExist())) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                displayCategory: 'Annotation',
                subcategory: 'ABC',
                displaySubcategory: 'ABC',
                columnCells: []
            });

            // set up the headers, and give us an empty row of column cells
            var headerNames = [];
            if (accumulatorObjectFieldEmpty("geneNameArray")) {
                console.log("We always have to have a record of the current gene names in ABC display. We have a problem.");
            } else {
                headerNames  = _.map(getAccumulatorObject("geneNameArray"),'name');
                _.forEach(getAccumulatorObject("geneNameArray"), function (oneRecord) {
                    intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell("",
                        Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML), "header of some sort"));
                });
            }


            // set up the headers, and give us an empty row of column cells


            // fill in all of the column cells
            _.forEach(returnObject.genesByAbc, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(headerNames, recordsPerGene.geneName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {

                    if ((recordsPerGene.source.length === 0) &&
                        (recordsPerGene.experiment.length === 0)) {
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.geneName,
                            Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML),"not sure this is ever used?");
                    } else {
                        recordsPerGene["numberOfTissues"] = recordsPerGene.source.length;
                        recordsPerGene["numberOfExperiments"] = recordsPerGene.experiment.length;
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.geneName,
                            Mustache.render($("#dynamicAbcGeneTableBody")[0].innerHTML, recordsPerGene),"tissue specific");
                    }

                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicAbcGeneTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');


        _.forEach(returnObject.genesByAbc, function (value) {
            $('#tissues_' + value.geneName).data('allUniqueTissues', value.abcTissuesVector());
            $('#tissues_' + value.geneName).data('sourceByTissue', value.sourceByTissue());
            $('#tissues_' + value.geneName).data('regionStart', value.start_pos);
            $('#tissues_' + value.geneName).data('regionEnd', value.stop_pos);
            $('#tissues_' + value.geneName).data('geneName', value.geneName);
        });


        $('div.openTissues').on('show.bs.collapse', function () {
            // the user wants to drill down into the tissues. Let's make them a graphic using the data we stored above
            var dataMatrix =
                _.map($(this).data("sourceByTissue"),
                    function (v, k) {
                        var retVal = [];
                        _.forEach(v, function (oneRec) {
                            retVal.push(oneRec);
                        });
                        return retVal;
                    }
                );
            var geneInfoArray = getAccumulatorObject("geneInfoArray");
            var geneInfoIndex = _.findIndex(geneInfoArray, {name: $(this).data("geneName")});
            var additionalParameters;
            if (geneInfoIndex < 0) {
                additionalParameters = {
                    regionStart: _.minBy(_.flatMap($(this).data("sourceByTissue")), 'START').START,
                    regionEnd: _.maxBy(_.flatMap($(this).data("sourceByTissue")), 'STOP').STOP,
                    stateColorBy: ['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'), function () {
                        return [1]
                    })
                };
            } else {
                additionalParameters = {
                    regionStart: geneInfoArray[geneInfoIndex].startPos,
                    regionEnd: geneInfoArray[geneInfoIndex].endPos,
                    stateColorBy: ['Flanking TSS'],
                    mappingInformation: _.map($(this).data('allUniqueTissues'), function () {
                        return [1]
                    })
                };
            }

            //  here comes that D3 graphic!
            buildMultiTissueDisplay(['Flanking TSS'],
                $(this).data('allUniqueTissues'),
                dataMatrix,
                additionalParameters,
                '#tooltip_' + $(this).attr('id'),
                '#graphic_' + $(this).attr('id'));

        });
    };


    var displayGenesFromDepict = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        // for each gene collect up the data we want to display
        _.forEach(_.groupBy(getAccumulatorObject("rawDepictInfo"), 'gene'), function (value, geneName) {
            var geneObject = {geneName: geneName};
            geneObject['chrom'] = _.first(_.map(_.uniqBy(value, 'region_chr'), function (o) {
                return o.region_chr
            }).sort());
            var startPosRec = _.minBy(value, function (o) {
                return o.region_start
            });
            geneObject['start_pos'] = (startPosRec) ? startPosRec.region_start : 0;
            var stopPosRec = _.maxBy(value, function (o) {
                return o.region_end
            });
            geneObject['stop_pos'] = (stopPosRec) ? stopPosRec.region_end : 0;
            //geneObject['recordByDataSet'] = function(){
            //    return _.groupBy(value,'dataset');
            //};
            var recordsByDataSet = [];
            _.forEach(_.groupBy(value, 'dataset'), function (recValue, datasetName) {
                var myRecValue = recValue[0];
                myRecValue["formattedPValue"] = UTILS.realNumberFormatter(myRecValue["pvalue"]);
                recordsByDataSet.push(myRecValue);
            });

            geneObject['recordByDataSet'] = recordsByDataSet;
            returnObject.genesByDepict.push(geneObject);

        });

        addAdditionalResultsObject({genesFromAbc: returnObject});

        var intermediateDataStructure = new IntermediateDataStructure();

        if (( typeof returnObject.genesByDepict !== 'undefined') && ( returnObject.genesByDepict.length > 0)) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                displayCategory: 'Annotation',
                subcategory: 'Depict',
                displaySubcategory: 'Depict',
                columnCells: []
            });

            // set up the headers, and give us an empty row of column cells
            var headerNames = [];
            if (accumulatorObjectFieldEmpty("geneNameArray")) {
                console.log("We always have to have a record of the current gene names in depict display. We have a problem.");
            } else {
                headerNames  = _.map(getAccumulatorObject("geneNameArray"),'name');
                _.forEach(getAccumulatorObject("geneNameArray"), function (oneRecord) {
                    intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                        Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML),"header"));
                });
            }


            // set up the headers, and give us an empty row of column cells


            // fill in all of the column cells
            _.forEach(returnObject.genesByDepict, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(headerNames, recordsPerGene.geneName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {
                    if ((recordsPerGene.recordByDataSet.length === 0)) {
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.geneName,
                            Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML), "tissue specific");
                    } else {
                        recordsPerGene["numberOfRecords"] = recordsPerGene.recordByDataSet.length;
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.geneName,
                            Mustache.render($("#depictGeneTableBody")[0].innerHTML, recordsPerGene),"tissue specific");
                    }

                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicAbcGeneTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');

        _.forEach(returnObject.genesByAbc, function (value) {
            $('#tissues_' + value.geneName).data('allUniqueTissues', value.abcTissuesVector());
            $('#tissues_' + value.geneName).data('sourceByTissue', value.sourceByTissue());
            $('#tissues_' + value.geneName).data('regionStart', value.start_pos);
            $('#tissues_' + value.geneName).data('regionEnd', value.stop_pos);
            $('#tissues_' + value.geneName).data('geneName', value.geneName);
        });

    };






    var displayGenePhenotypeAssociations = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        // for each gene collect up the data we want to display
        _.forEach(getAccumulatorObject("rawGeneAssociationRecords"), function (value) {

            returnObject.geneAssociations.push(value);

        });

        var intermediateDataStructure = new IntermediateDataStructure();

        if (( typeof returnObject.geneAssociations !== 'undefined') && ( returnObject.geneAssociations.length > 0)) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                displayCategory: 'Annotation',
                subcategory: 'MetaXcan',
                displaySubcategory: 'MetaXcan',
                columnCells: []
            });

            // set up the headers, and give us an empty row of column cells
            var headerNames = [];
            if (accumulatorObjectFieldEmpty("geneNameArray")) {
                console.log("We always have to have a record of the current gene names in depict display. We have a problem.");
            } else {
                headerNames  = _.map(getAccumulatorObject("geneNameArray"),'name');
                _.forEach(getAccumulatorObject("geneNameArray"), function (oneRecord) {
                    intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                        Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML),"header"));
                });
            }


            // set up the headers, and give us an empty row of column cells


            // fill in all of the column cells
            _.forEach(returnObject.geneAssociations, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(headerNames, recordsPerGene.gene);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {
                    if ((recordsPerGene.tissues.length === 0)) {
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.gene,
                            Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML), "tissue specific");
                    } else {
                        recordsPerGene["numberOfRecords"] = recordsPerGene.tissues.length;
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.gene,
                            Mustache.render($("#geneAssociationTableBody")[0].innerHTML, recordsPerGene),"tissue specific");
                    }

                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicAbcGeneTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');

        //_.forEach(returnObject.genesByAbc, function (value) {
        //    $('#tissues_' + value.geneName).data('allUniqueTissues', value.abcTissuesVector());
        //    $('#tissues_' + value.geneName).data('sourceByTissue', value.sourceByTissue());
        //    $('#tissues_' + value.geneName).data('regionStart', value.start_pos);
        //    $('#tissues_' + value.geneName).data('regionEnd', value.stop_pos);
        //    $('#tissues_' + value.geneName).data('geneName', value.geneName);
        //});

    };







    var displayTissuesFromAbc = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawAbcInfo"), 'SOURCE'), function (value, tissueName) {
            var geneObject = {tissueName: tissueName};
            geneObject['gene'] = _.map(_.uniqBy(value, 'GENE'), function (o) {
                return o.GENE
            }).sort();
            geneObject['experiment'] = _.map(_.uniqBy(value, 'EXPERIMENT'), function (o) {
                return o.EXPERIMENT
            }).sort();
            var startPosRec = _.minBy(value, function (o) {
                return o.START
            });
            geneObject['start_pos'] = (startPosRec) ? startPosRec.START : 0;
            var stopPosRec = _.maxBy(value, function (o) {
                return o.STOP
            });
            geneObject['stop_pos'] = (stopPosRec) ? stopPosRec.STOP : 0;
            returnObject.tissuesByAbc.push(geneObject);

        });
        returnObject['abcTissuesExist'] = function () {
            return (this.tissuesByAbc.length > 0) ? [1] : [];
        };


        returnObject['numberOfGenes'] = function () {
            return (this.gene.length);
        };
        returnObject['numberOfExperiments'] = function () {
            return (this.experiment.length);
        };

        addAdditionalResultsObject({tissuesFromAbc: returnObject});

        var intermediateDataStructure = new IntermediateDataStructure();

        if (( typeof returnObject.abcGenesExist !== 'undefined') && ( returnObject.abcGenesExist())) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                displayCategory: 'Annotation',
                subcategory: 'ABC',
                displaySubcategory: 'ABC',
                columnCells: []
            });
            // set up the headers, and give us an empty row of column cells
            _.forEach(returnObject.genesByAbc, function (oneRecord) {
                intermediateDataStructure.headerNames.push(oneRecord.geneName);
                intermediateDataStructure.headerContents.push(Mustache.render($("#dynamicAbcGeneTableHeader")[0].innerHTML, oneRecord));
                intermediateDataStructure.headers.push({
                    name: oneRecord.geneName,
                    contents: Mustache.render($("#dynamicAbcGeneTableHeader")[0].innerHTML, oneRecord)
                });
                intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell("ABC", ""));
            });

            // fill in all of the column cells
            _.forEach(returnObject.genesByAbc, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames, recordsPerGene.geneName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {
                    recordsPerGene["numberOfTissues"] = recordsPerGene.source.length;
                    recordsPerGene["numberOfExperiments"] = recordsPerGene.experiment.length;
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell("",
                        Mustache.render($("#dynamicAbcGeneTableBody")[0].innerHTML, recordsPerGene));
                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";

        }


        prepareToPresentToTheScreen(idForTheTargetDiv, '#dynamicAbcTissueTable', returnObject, clearBeforeStarting, intermediateDataStructure);
        // $(idForTheTargetDiv).empty().append(Mustache.render($('#dynamicAbcTissueTable')[0].innerHTML,
        //     returnObject
        // ));
    };


    var displayPhenotypesFromColocalization = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"), 'phenotype'), function (value, phenotypeName) {
            var phenotypeObject = {phenotypeName: phenotypeName};
            phenotypeObject['tissues'] = _.map(_.uniqBy(value, 'tissue'), function (o) {
                return o.tissue
            }).sort();
            phenotypeObject['genes'] = _.map(_.uniqBy(value, 'gene'), function (o) {
                return o.gene
            }).sort();
            phenotypeObject['varId'] = _.map(_.uniqBy(value, 'var_id'), function (o) {
                return o.var_id
            }).sort();
            returnObject.phenotypesByColocalization.push(phenotypeObject);
            returnObject.uniquePhenotypes.push({phenotypeName: phenotypeName});
        });

        returnObject['phenotypeColocsExist'] = function () {
            return (this.phenotypesByColocalization.length > 0) ? [1] : [];
        };
        returnObject['numberOfTissues'] = function () {
            return (this.tissues.length);
        };
        returnObject['numberOfGenes'] = function () {
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function () {
            return (this.varId.length);
        };


        addAdditionalResultsObject({phenotypesFromColocalizatio: returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv, '#dynamicColocalizationPhenotypeTable', returnObject, clearBeforeStarting);
        // $("#dynamicPhenotypeHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicColocalizationPhenotypeTable')[0].innerHTML,
        //     returnObject
        // ));


    };


    var displayTissuesFromColocalization = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"), 'tissue'), function (value, tissueName) {
            var tissueObject = {tissueName: tissueName};
            tissueObject['phenotypes'] = _.map(_.uniqBy(value, 'phenotype'), function (o) {
                return o.phenotype
            }).sort();
            tissueObject['genes'] = _.map(_.uniqBy(value, 'gene'), function (o) {
                return o.gene
            }).sort();
            tissueObject['varId'] = _.map(_.uniqBy(value, 'var_id'), function (o) {
                return o.var_id
            }).sort();
            returnObject.phenotypesByColocalization.push(tissueObject);
            returnObject.uniqueTissues.push({tissueName: tissueName});
        });
        returnObject['colocsTissuesExist'] = function () {
            return (this.phenotypesByColocalization.length > 0) ? [1] : [];
        };

        returnObject['phenotypeColocsExist'] = function () {
            return (this.phenotypesByColocalization.length > 0) ? [1] : [];
        };
        returnObject['numberOfTissues'] = function () {
            return (this.tissues.length);
        };
        returnObject['numberOfPhenotypes'] = function () {
            return (this.phenotypes.length);
        };
        returnObject['numberOfGenes'] = function () {
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function () {
            return (this.varId.length);
        };

        addAdditionalResultsObject({tissuesFromColocalization: returnObject});
        prepareToPresentToTheScreen("#dynamicTissueHolder div.dynamicUiHolder", '#dynamicColocalizationTissueTable', returnObject, clearBeforeStarting);
        // $("#dynamicTissueHolder div.dynamicUiHolder").empty().append(Mustache.render($('#dynamicColocalizationTissueTable')[0].innerHTML,
        //     returnObject
        // ));


    };


    var displayGenesFromColocalization = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();

        _.forEach(_.groupBy(getAccumulatorObject("rawColocalizationInfo"), 'common_name'), function (value, geneName) {
            var geneObject = {geneName: geneName};
            geneObject['phenotypes'] = _.map(_.uniqBy(value, 'phenotype'), function (o) {
                return o.phenotype
            }).sort();
            geneObject['tissues'] = _.map(_.uniqBy(value, 'tissue'), function (o) {
                return o.tissue
            }).sort();
            geneObject['varId'] = _.map(_.uniqBy(value, 'var_id'), function (o) {
                return o.var_id
            }).sort();
            geneObject['colocTissuesVector'] = function () {
                return geneObject['tissue'];
            };
            geneObject['sourceByTissue'] = function () {
                return _.groupBy(value, 'tissue');
            };
            var startPosRec = 0;
            var stopPosRec = 0;
            var extents = retrieveExtents(geneName, startPosRec, stopPosRec);
            geneObject['regionStart'] = extents.regionStart;
            geneObject['regionEnd'] = extents.regionEnd;

            returnObject.phenotypesByColocalization.push(geneObject);
        });
        returnObject['colocsExist'] = function () {
            return (this.phenotypesByColocalization.length > 0) ? [1] : [];
        };

        returnObject['phenotypeColocsExist'] = function () {
            return (this.phenotypesByColocalization.length > 0) ? [1] : [];
        };
        returnObject['numberOfTissues'] = function () {
            return (this.tissues.length);
        };
        returnObject['numberOfPhenotypes'] = function () {
            return (this.phenotypes.length);
        };
        returnObject['numberOfGenes'] = function () {
            return (this.genes.length);
        };
        returnObject['numberOfVariants'] = function () {
            return (this.varId.length);
        };

        addAdditionalResultsObject({genesFromColocalization: returnObject});
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder", '#dynamicColocalizationGeneTable', returnObject, clearBeforeStarting);


        _.forEach(returnObject.phenotypesByColocalization, function (value) {
            $('#tissues_' + value.geneName).data('allUniqueTissues', value.colocTissuesVector());
            $('#tissues_' + value.geneName).data('sourceByTissue', value.sourceByTissue());
            $('#tissues_' + value.geneName).data('regionStart', value.start_pos);
            $('#tissues_' + value.geneName).data('regionEnd', value.stop_pos);
            $('#tissues_' + value.geneName).data('geneName', value.geneName);
        });


    };


    var processEqtlRecordsFromVariantBasedRequest = function (data) {

        var tempHolder = []
        // basic data aggregation
        _.forEach(data, function (oneRec) {
            var existingRecord = _.find(tempHolder, {variant: oneRec.var_id});
            if (typeof existingRecord === 'undefined') {
                tempHolder.push({
                    variant: oneRec.var_id,
                    genes: [],
                    uniqueGeneNames: [],
                    tissues: [],
                    uniqueTissueNames: []
                });
                existingRecord = _.find(tempHolder, {variant: oneRec.var_id});
            }
            var existingGeneRecord = _.find(existingRecord.genes, {geneName: oneRec.gene, tissueName: oneRec.tissue});
            if (typeof existingGeneRecord === 'undefined') {
                existingRecord.genes.push({
                    geneName: oneRec.gene,
                    value: oneRec.value,
                    tissueName: oneRec.tissue
                });
                ;
            } else {
                console.log('should I be worried? EQTL record matches gene (' + oneRec.gene + ') tissue (' + oneRec.tissue + ') for variant=' + oneRec.var_id + '.');
            }
            var existingTissueRecord = _.find(existingRecord.tissues, {
                geneName: oneRec.gene,
                tissueName: oneRec.tissue
            });
            if (typeof existingTissueRecord === 'undefined') {
                existingRecord.tissues.push({
                    geneName: oneRec.gene,
                    value: oneRec.value,
                    tissueName: oneRec.tissue
                });
                ;
            } else {
                console.log('should I be worried? EQTL record matches gene (' + oneRec.gene + ') tissue (' + oneRec.tissue + ') for variant=' + oneRec.var_id + '.');
            }

        });
        // extract a few summaries
        var uniqueVariants = _.map(tempHolder, function (o) {
            return o.variant
        });
        var existingRecord;
        _.forEach(uniqueVariants, function (varId) {
            existingRecord = _.find(tempHolder, {variant: varId});
            existingRecord.uniqueGeneNames = _.uniq(_.map(existingRecord.genes, function (o) {
                return o.geneName
            }));
            existingRecord.uniqueTissueNames = _.uniq(_.map(existingRecord.tissues, function (o) {
                return o.tissueName
            }));
        });
        setAccumulatorObject("eqtlsAggregatedPerVariant", tempHolder);
        return {};
    };


    var processAbcRecordsFromVariantBasedRequest = function (data) {

        var tempHolder = []
        // basic data aggregation
        _.forEach(data, function (oneRec) {
            var existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            if (typeof existingRecord === 'undefined') {
                tempHolder.push({
                    variant: oneRec.VAR_ID,
                    genes: [],
                    uniqueGeneNames: [],
                    tissues: [],
                    uniqueTissueNames: []
                });
                existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            }
            var existingGeneRecord = _.find(existingRecord.genes, {geneName: oneRec.GENE, tissueName: oneRec.SOURCE});
            if (typeof existingGeneRecord === 'undefined') {
                existingRecord.genes.push({
                    geneName: oneRec.GENE,
                    value: oneRec.VALUE,
                    tissueName: oneRec.SOURCE
                });
                ;
            } else {
                console.log('should I be worried? EQTL record matches gene (' + oneRec.GENE + ') tissue (' + oneRec.SOURCE + ') for variant=' + oneRec.var_id + '.');
            }
            var existingTissueRecord = _.find(existingRecord.tissues, {
                geneName: oneRec.GENE,
                tissueName: oneRec.SOURCE
            });
            if (typeof existingTissueRecord === 'undefined') {
                existingRecord.tissues.push({
                    geneName: oneRec.GENE,
                    value: oneRec.VALUE,
                    tissueName: oneRec.SOURCE
                });
                ;
            } else {
                console.log('should I be worried? ABC record matches gene (' + oneRec.GENE + ') tissue (' + oneRec.SOURCE + ') for variant=' + oneRec.var_id + '.');
            }

        });
        // extract a few summaries
        var uniqueVariants = _.map(tempHolder, function (o) {
            return o.variant
        });
        var existingRecord;
        _.forEach(uniqueVariants, function (varId) {
            existingRecord = _.find(tempHolder, {variant: varId});
            existingRecord.uniqueGeneNames = _.uniq(_.map(existingRecord.genes, function (o) {
                return o.geneName
            }));
            existingRecord.uniqueTissueNames = _.uniq(_.map(existingRecord.tissues, function (o) {
                return o.tissueName
            }));
        });
        setAccumulatorObject("abcAggregatedPerVariant", tempHolder);
        return {};
    };


    var processDnaseRecordsFromVariantBasedRequest = function (data) {

        var tempHolder = [];
        var quantileArray = mpgSoftware.regionInfo.createQuantilesArray(1);
        // basic data aggregation
        _.forEach(data, function (oneRec) {
            var existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            if (typeof existingRecord === 'undefined') {
                tempHolder.push({
                    variant: oneRec.VAR_ID,
                    tissues: [],
                    uniqueTissueNames: [],
                    maximumValue: undefined
                });
                existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            }
            var existingTissueRecord = _.find(existingRecord.tissues, {tissueName: oneRec.SOURCE});
            if (typeof existingTissueRecord === 'undefined') {
                existingRecord.tissues.push({
                    value: UTILS.realNumberFormatter("" + oneRec.VALUE),
                    tissueName: oneRec.SOURCE,
                    quantileIndicator: 'matchingRegion2_' + mpgSoftware.regionInfo.determineColorIndex(oneRec.VALUE, quantileArray)
                });
            } else {
                console.log('should I be worried? Dnase record matches tissue (' + oneRec.SOURCE + ') for variant=' + oneRec.VAR_ID + '.');
            }

        });
        // extract a few summaries
        var uniqueVariants = _.map(tempHolder, function (o) {
            return o.variant
        });
        var existingRecord;
        _.forEach(uniqueVariants, function (varId) {
            existingRecord = _.find(tempHolder, {variant: varId});
            existingRecord.uniqueTissueNames = _.uniq(_.map(existingRecord.tissues, function (o) {
                return o.tissueName
            }));
        });
        setAccumulatorObject("dnaseAggregatedPerVariant", tempHolder);
        return {};
    };


    var processH3k27acRecordsFromVariantBasedRequest = function (data) {

        var tempHolder = [];
        var quantileArray = mpgSoftware.regionInfo.createQuantilesArray(2);
        // basic data aggregation
        _.forEach(data, function (oneRec) {
            var existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            if (typeof existingRecord === 'undefined') {
                tempHolder.push({
                    variant: oneRec.VAR_ID,
                    tissues: [],
                    uniqueTissueNames: [],
                    maximumValue: undefined
                });
                existingRecord = _.find(tempHolder, {variant: oneRec.VAR_ID});
            }
            var existingTissueRecord = _.find(existingRecord.tissues, {tissueName: oneRec.SOURCE});
            if (typeof existingTissueRecord === 'undefined') {
                existingRecord.tissues.push({
                    value: UTILS.realNumberFormatter("" + oneRec.VALUE),
                    tissueName: oneRec.SOURCE,
                    quantileIndicator: 'matchingRegion1_' + mpgSoftware.regionInfo.determineColorIndex(oneRec.VALUE, quantileArray)
                });
                ;
            } else {
                console.log('should I be worried? H3k27ac record matches tissue (' + oneRec.SOURCE + ') for variant=' + oneRec.VAR_ID + '.');
            }

        });
        // extract a few summaries
        var uniqueVariants = _.map(tempHolder, function (o) {
            return o.variant
        });
        var existingRecord;
        _.forEach(uniqueVariants, function (varId) {
            existingRecord = _.find(tempHolder, {variant: varId});
            existingRecord.uniqueTissueNames = _.uniq(_.map(existingRecord.tissues, function (o) {
                return o.tissueName
            }));
        });
        setAccumulatorObject("h3k27acAggregatedPerVariant", tempHolder);
        return {};
    };




    /***
     * gene eQTL search
     * @param data
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueTissues: Array, chromosome: undefined, startPos: undefined, endPos: undefined}}
     */
    var processRecordsFromEqtls = function (data) {
        // build up an object to describe this
        var returnObject = {
            rawData: [],
            uniqueGenes: [],
            uniqueTissues: [],
            chromosome: undefined,
            startPos: undefined,
            endPos: undefined
        };
        _.forEach(data, function (oneRec) {
            returnObject.rawData.push(oneRec);
            if (typeof returnObject.startPos === 'undefined') {
                returnObject.startPos = oneRec.start_position;
            } else if (returnObject.startPos > oneRec.start_position) {
                returnObject.startPos = oneRec.start_position;
            }
            if (typeof returnObject.endPos === 'undefined') {
                returnObject.endPos = oneRec.end_position;
            } else if (returnObject.endPos < oneRec.end_position) {
                returnObject.endPos = oneRec.end_position;
            }
            if (typeof returnObject.chromosome === 'undefined') {
                returnObject.chromosome = oneRec.chromosome;
            }
            if (!returnObject.uniqueGenes.includes(oneRec.gene)) {
                returnObject.uniqueGenes.push(oneRec.gene);
            }
            ;
            if (!returnObject.uniqueTissues.includes(oneRec.tissue)) {
                returnObject.uniqueTissues.push(oneRec.tissue);
            }
            ;

            var geneIndex = _.findIndex(getAccumulatorObject("tissuesForEveryGene"), {geneName: oneRec.gene});
            if (geneIndex < 0) {
                var accumulatorArray = getAccumulatorObject("tissuesForEveryGene");
                accumulatorArray.push({geneName: oneRec.gene, tissues: [oneRec.tissue]});
                setAccumulatorObject("tissuesForEveryGene", accumulatorArray);
            } else {
                var accumulatorElement = getAccumulatorObject("tissuesForEveryGene")[geneIndex];
                if (!accumulatorElement.tissues.includes(oneRec.tissue)) {
                    accumulatorElement.tissues.push(oneRec.tissue);
                }
            }

            var tissueIndex = _.findIndex(getAccumulatorObject("genesForEveryTissue"), {tissueName: oneRec.tissue});
            if (tissueIndex < 0) {
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





    var displayTissuesPerGeneFromEqtl = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var returnObject = createNewDisplayReturnObject();
        _.forEach(getAccumulatorObject("tissuesForEveryGene"), function (eachGene) {
            returnObject.uniqueGenes.push({name: eachGene.geneName});

            var recordToDisplay = {
                tissues: [],
                numberOfTissues: eachGene.tissues.length,
                geneName: eachGene.geneName
            };
            _.forEach(eachGene.tissues, function (eachTissue) {
                recordToDisplay.tissues.push({tissueName: eachTissue})
            });
            returnObject.uniqueEqtlGenes.push(recordToDisplay);
        });
        addAdditionalResultsObject({tissuesPerGeneFromEqtl: returnObject});

        var intermediateDataStructure = new IntermediateDataStructure();
        if (( typeof returnObject.eqtlTissuesExist !== 'undefined') && ( returnObject.eqtlTissuesExist())) {
            intermediateDataStructure.rowsToAdd.push({
                category: 'Annotation',
                displayCategory: 'Annotation',
                subcategory: 'eQTL',
                displaySubcategory: 'eQTL',
                columnCells: []
            });
             //set up the headers, and give us an empty row of column cells
            var headerNames = [];
            if (accumulatorObjectFieldEmpty("geneNameArray")) {
                console.log("We always have to have a record of the current gene names in eqtl display. We have a problem.");
            } else {
                headerNames  = _.map(getAccumulatorObject("geneNameArray"),'name');
                _.forEach(getAccumulatorObject("geneNameArray"), function (oneRecord) {
                    intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell('eQTL',
                        Mustache.render($("#dynamicGeneTableEmptyRecord")[0].innerHTML),'eQTL for genes'));
                });
            }

            // fill in all of the column cells
            _.forEach(returnObject.uniqueEqtlGenes, function (recordsPerGene) {
                var indexOfColumn = _.indexOf(headerNames, recordsPerGene.geneName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerGene.geneName.  Shouldn't we?")
                } else {
                    intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell('eQTL',
                        Mustache.render($("#dynamicGeneTableEqtlSummaryBody")[0].innerHTML, recordsPerGene),'tisseRecord');
                }
            });
            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";


        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicGeneTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');
    };
    var displayGenesPerTissueFromEqtl = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        var returnObject = createNewDisplayReturnObject();
        _.forEach(getAccumulatorObject("genesForEveryTissue"), function (eachTissue) {
            returnObject.uniqueTissues.push({name: eachTissue.tissueName});

            var recordToDisplay = {genes: []};
            _.forEach(eachTissue.genes, function (eachGene) {
                recordToDisplay.genes.push({geneName: eachGene})
            });
            if (!returnObject.geneTissueEqtls.includes(recordToDisplay)) {
                returnObject.geneTissueEqtls.push(recordToDisplay);
            }

        });
        addAdditionalResultsObject({genesPerTissueFromEqtl: returnObject});
        prepareToPresentToTheScreen("#dynamicTissueHolder div.dynamicUiHolder",
            '#dynamicTissueTable',
            returnObject,
            clearBeforeStarting, null,
            true,
            'geneTableGeneHeaders');

    };

    /***
     * Gene proximity search
     * @param data
     * @returns {{rawData: Array, uniqueGenes: Array, uniqueTissues: Array}}
     */
    var processRecordsFromProximitySearch = function (data) {
        var returnObject = {
            rawData: [],
            uniqueGenes: [],
            genePositions: [],
            uniqueTissues: [],
            genesPositionsExist: function () {
                return (this.genePositions.length > 0) ? [1] : [];
            },
            genesExist: function () {
                return (this.uniqueGenes.length > 0) ? [1] : [];
            }
        };
        var geneInfoArray = [];
        if (( typeof data !== 'undefined') &&
            ( data !== null ) &&
            (data.is_error === false ) &&
            ( typeof data.listOfGenes !== 'undefined')) {
            if (data.listOfGenes.length === 0) {
                alert(' No genes in the specified region')
            } else {
                _.forEach(data.listOfGenes, function (geneRec) {
                    returnObject.rawData.push(geneRec);
                    if (!returnObject.uniqueGenes.includes(geneRec.name2)) {
                        returnObject.uniqueGenes.push({name: geneRec.name2});
                        returnObject.genePositions.push({name: geneRec.chromosome + ":" + geneRec.addrStart + "-" + geneRec.addrEnd});
                        var chromosomeString = _.includes(geneRec.chromosome, "chr") ? geneRec.chromosome.substr(3) : geneRec.chromosome;
                        geneInfoArray.push({
                                chromosome: chromosomeString,
                                startPos: geneRec.addrStart,
                                endPos: geneRec.addrEnd,
                                name: geneRec.name2,
                                id: geneRec.id
                            }
                        );
                    }
                    ;
                });
            }
        }
        // we have a list of all the genes in the range.  Let's remember that information.
        setAccumulatorObject("geneNameArray", returnObject.uniqueGenes);
        setAccumulatorObject("geneInfoArray", geneInfoArray);
        return returnObject;
    };
    var displayRefinedGenesInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();

        addAdditionalResultsObject({refinedGenesInARange: objectContainingRetrievedRecords});


        var intermediateDataStructure = new IntermediateDataStructure();

        if (typeof objectContainingRetrievedRecords.rawData !== 'undefined') {
            // set up the headers, and give us an empty row of column cells
            _.forEach(objectContainingRetrievedRecords.rawData, function (oneRecord,index) {
                intermediateDataStructure.headerNames.push(oneRecord.name1);
                intermediateDataStructure.headerContents.push(Mustache.render($("#dynamicGeneTableHeaderV2")[0].innerHTML, oneRecord));
                intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord.name1,
                    Mustache.render($("#dynamicGeneTableHeaderV2")[0].innerHTML, oneRecord),"geneHeader columnNumber_"+(index+2)+" asc "));
            });

            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicGeneTable',
            objectContainingRetrievedRecords,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders');

    };


    var processRecordsFromVariantQtlSearch = function (data) {
        var returnObject = {
            rawData: [],
            uniqueGenes: [],
            uniquePhenotypes: [],
            uniqueVarIds: []
        };
        if (( typeof data !== 'undefined') &&
            ( typeof data.data !== 'undefined') &&
            ( typeof data.header !== 'undefined') &&
            ( data.header.length > 0 )) {
            var varIdIndex = _.indexOf(data.header, 'VAR_ID');
            var geneIndex = _.indexOf(data.header, 'GENE');
            var phenotypeIndex = _.indexOf(data.header, 'PHENOTYPE');
            var positionIndex = _.indexOf(data.header, 'POS');
            var numberOfElements = data.data[0].length;
            for (var variant = 0; variant < numberOfElements; variant++) {
                var varId = data.data[varIdIndex][variant];
                var gene = data.data[geneIndex][variant];
                var phenotype = data.data[phenotypeIndex][variant];
                var position = data.data[positionIndex][variant];
                if (!returnObject.uniqueGenes.includes(gene)) {
                    returnObject.uniqueGenes.push(gene);
                }
                ;
                if (!returnObject.uniquePhenotypes.includes(phenotype)) {
                    returnObject.uniquePhenotypes.push(phenotype);
                }
                ;
                if (!returnObject.uniqueVarIds.includes(varId)) {
                    returnObject.uniqueVarIds.push(varId);
                }
                ;

                var variantIndex = _.findIndex(getAccumulatorObject("phenotypesForEveryVariant"), {variantName: varId});
                if (variantIndex < 0) {
                    var accumulatorArray = getAccumulatorObject("phenotypesForEveryVariant");
                    accumulatorArray.push({
                        variantName: varId,
                        phenotypes: [phenotype],
                        position: position
                    });
                    setAccumulatorObject("phenotypesForEveryVariant", accumulatorArray);
                } else {
                    var accumulatorElement = getAccumulatorObject("phenotypesForEveryVariant")[variantIndex];
                    if (!accumulatorElement.phenotypes.includes(phenotype)) {
                        accumulatorElement.phenotypes.push(phenotype);
                    }
                }

                var phenotIndex = _.findIndex(getAccumulatorObject("variantsForEveryPhenotype"), {phenotypeName: phenotype});
                if (phenotIndex < 0) {
                    var accumulatorArray = getAccumulatorObject("variantsForEveryPhenotype");
                    accumulatorArray.push({phenotypeName: phenotype, variants: [varId]});
                    setAccumulatorObject("variantsForEveryPhenotype", accumulatorArray);
                } else {
                    var accumulatorElement = getAccumulatorObject("variantsForEveryPhenotype")[phenotIndex];
                    if (!accumulatorElement.variants.includes(phenotype)) {
                        accumulatorElement.variants.push(phenotype);
                    }
                }


                returnObject.rawData.push({varId: varId, gene: gene, phenotype: phenotype});
            }
        } else {
            alert('API call return to unexpected result. Is the KB fully functional?');
        }
        returnObject.uniqueGenes = returnObject.uniqueGenes.sort();
        returnObject.uniquePhenotypes = returnObject.uniquePhenotypes.sort();
        returnObject.uniqueVarIds = returnObject.uniqueVarIds.sort();
        return returnObject;
    };
    var displayVariantRecordsFromVariantQtlSearch = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();
        // _.forEach(objectContainingRetrievedRecords.uniqueVarIds,function(oneTissue) {
        //     $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+oneTissue+'</div>');
        // });

        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(getAccumulatorObject("phenotypesForEveryVariant"), ['position']), function (variantWithPhenotypes) {
            returnObject.uniqueVariants.push({variantName: variantWithPhenotypes.variantName});

            var recordToDisplay = {phenotypes: []};
            _.forEach(variantWithPhenotypes.phenotypes, function (eachPhenotype) {
                recordToDisplay.phenotypes.push({phenotypeName: eachPhenotype})
            });
            returnObject.variantPhenotypeQtl.push(recordToDisplay);

        });
        addAdditionalResultsObject({variantRecordsFromVariantQtlSearch: returnObject});


        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#dynamicPhenotypeTable',
            returnObject,
            clearBeforeStarting, null,
            true,
            'variantTableVariantHeaders');


    };
    var displayPhenotypeRecordsFromVariantQtlSearch = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        $(idForTheTargetDiv).empty();
        // _.forEach(objectContainingRetrievedRecords.uniquePhenotypes,function(onePhenotype) {
        //     $(idForTheTargetDiv).append('<div class="resultElementPerLine">'+onePhenotype+'</div>');
        // });

        var returnObject = createNewDisplayReturnObject();
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        _.forEach(_.sortBy(getAccumulatorObject("variantsForEveryPhenotype"), ['phenotypeName']), function (phenotypesWithVariants) {
            returnObject.uniquePhenotypes.push({phenotypeName: phenotypesWithVariants.phenotypeName});

            var recordToDisplay = {variants: []};
            _.forEach(phenotypesWithVariants.variants, function (eachVariant) {
                recordToDisplay.variants.push({variantName: eachVariant})
            });
            returnObject.phenotypeVariantQtl.push(recordToDisplay);

        });
        addAdditionalResultsObject({phenotypeRecordsFromVariantQtlSearch: returnObject});
        prepareToPresentToTheScreen(idForTheTargetDiv, '#dynamicPhenotypeTable', returnObject, clearBeforeStarting);
        // $(idForTheTargetDiv).empty().append(Mustache.render($('#dynamicPhenotypeTable')[0].innerHTML,
        //     returnObject
        // ));

    };

    var displayContext = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        var contextDescr = objectContainingRetrievedRecords;
        // Do we actually use this routine?
        $(idForTheTargetDiv).empty().append(Mustache.render($('#contextDescriptionSection')[0].innerHTML,
            contextDescr
        ));
    };


    /***
     * constructor we need when inverting an array to figure out what which sells we need to display
     * @param useGenes
     * @param useTissues
     * @param usePhenotypes
     * @returns {{}}
     * @constructor
     */
    var InversionArray = function (useGenes,useTissues,usePhenotypes){
        var returnObject = {};
        if (useGenes){
            returnObject['genes'] = [];
        }
        if (useTissues){
            returnObject['tissues'] = [];
        }
        if (usePhenotypes){
            returnObject['phenotypes'] = [];
        }
        return returnObject;
    };



    var displayEqtlsGivenVariantList = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        displayVariantDataWithHiddenTissuesAndSummaryLines(idForTheTargetDiv,"eqtlsAggregatedPerVariant",'eQTL','eQTL',
            "noRecordTemplate","undefinedTissueRecord","#dynamicEqtlVariantTableBody",
            "#dynamicEqtlVariantTableBodySummaryRecord", "table.combinedVariantTableHolder",'variantTableVariantHeaders',
            undefined, 0.05,
        true, true);


    };

    var displayAbcGivenVariantList = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        displayVariantDataWithHiddenTissuesAndSummaryLines(idForTheTargetDiv,"abcAggregatedPerVariant",'ABC','ABC',
            "noRecordTemplate","undefinedTissueRecord","#dynamicEqtlVariantTableBody",
            "#dynamicEqtlVariantTableBodySummaryRecord", "table.combinedVariantTableHolder",'variantTableVariantHeaders',
            undefined, undefined,
        true, true);

    }


    var displayDnaseGivenVariantList = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        displayVariantDataWithHiddenTissuesAndSummaryLines(idForTheTargetDiv,"dnaseAggregatedPerVariant",'DNase','DNase',
            "noRecordTemplate","undefinedTissueRecord","#dynamicDnaseVariantTableBody",
            "#dynamicDnaseVariantTableBodySummaryRecord", "table.combinedVariantTableHolder",'variantTableVariantHeaders',
            undefined, undefined,
        false, true);
    };


    var displayH3k27acGivenVariantList = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        displayVariantDataWithHiddenTissuesAndSummaryLines(idForTheTargetDiv,"h3k27acAggregatedPerVariant",'H3k27ac','H3k27ac',
            "noRecordTemplate","undefinedTissueRecord","#dynamicH3k27acVariantTableBody",
            "#dynamicH3k27acVariantTableBodySummaryRecord", "table.combinedVariantTableHolder",'variantTableVariantHeaders',
            undefined, undefined,
        false, true);
    };


    /***
     * This complicated routine serves as a general-purpose display IF:
     *      we are considering a variant based table
     *      Results are to be separated by tissue, but aggregated by Gene
     * The challenge we try to address here is that we have a long linear list of records, and we need to
     * convert that list into an array where each cell contains only data that is relevant to its
     * specific row and column.  Furthermore we may wish to filter out some records based on their
     * numerical value
     *
     * @param idForTheTargetDiv
     * @param nameOfAccumulatorObject
     * @param category
     * @param displayCategory
     * @param noRecordTemplate
     * @param undefinedTissueRecord
     * @param cellBodyRecord
     * @param cellBodySummaryRecord
     * @param tableToUpdate
     * @param typeOfTable
     * @param minimumValue
     * @param maximumValue
     * @param matchOnGene
     * @param matchOnTissue
     */
    var displayVariantDataWithHiddenTissuesAndSummaryLines = function(  idForTheTargetDiv,nameOfAccumulatorObject,category,displayCategory,
                                                                        noRecordTemplate,undefinedTissueRecord,cellBodyRecord,
                                                                        cellBodySummaryRecord,tableToUpdate, typeOfTable,
                                                                        minimumValue,maximumValue,
                                                                        matchOnGene,matchOnTissue){
        var returnObject = createNewDisplayReturnObject();

        var intermediateDataStructure = new IntermediateDataStructure();
        var recordsAggregatedPerVariant = getAccumulatorObject(nameOfAccumulatorObject);
        if (( typeof recordsAggregatedPerVariant !== 'undefined') && ( recordsAggregatedPerVariant.length > 0)) {

            // fill in all of the column cells
            var variantNameArray = getAccumulatorObject("variantNameArray");
            var allArraysOfTissueNames = _.map(recordsAggregatedPerVariant, function (o) {
                return o.uniqueTissueNames
            });
            var everyTissueToDisplay = _.uniq(_.flatten(_.union(allArraysOfTissueNames))).sort();
            _.forEach(everyTissueToDisplay, function (aTissue) {
                var tissueRow = {
                    category: category,
                    displayCategory: displayCategory,
                    subcategory: "tissueRecord "+aTissue+" "+category,
                    displaySubcategory: aTissue,
                    columnCells: [],
                    sortField: "summary "+category+"x"
                };
                var dataWorthDisplayingExists = false;
                _.forEach(variantNameArray, function (aVariant, indexOfColumn) {
                    var recordsPerVariant = _.find(recordsAggregatedPerVariant, {variant: aVariant});
                    if (typeof  recordsPerVariant === 'undefined') {
                        tissueRow.columnCells[indexOfColumn] = new IntermediateStructureDataCell(aTissue,
                            "<div class='noDataHere" + tissueRow.category + "' sortField=0></div>", "tissueRecord");
                    } else {
                        var perTissuePerVariant = _.merge(_.filter(recordsPerVariant.tissues, {tissueName: aTissue}), {category: tissueRow.category});
                        if ((typeof perTissuePerVariant === 'undefined')||
                            ((typeof minimumValue !== 'undefined')&&(perTissuePerVariant[0].value<minimumValue))||
                            ((typeof maximumValue !== 'undefined')&&(perTissuePerVariant[0].value>maximumValue))){
                            tissueRow.columnCells[indexOfColumn] = new IntermediateStructureDataCell(aTissue,
                                "<div class='noDataHere " + tissueRow.category + "' sortField=0></div>", "tissueRecord");
                        } else {
                            tissueRow.columnCells[indexOfColumn] = new IntermediateStructureDataCell(aTissue,
                                Mustache.render($(cellBodyRecord)[0].innerHTML, perTissuePerVariant), "tissueRecord");
                            dataWorthDisplayingExists = true;
                        }
                    }

                });
                if (dataWorthDisplayingExists){
                    intermediateDataStructure.rowsToAdd.push(tissueRow);
                }

            });

            // I might need to create a summary line
            if (intermediateDataStructure.rowsToAdd.length > 0) {
                var invertedArray = [];
                var rememberCategoryFromOneLine = "none";
                _.map(intermediateDataStructure.rowsToAdd, function (oneRow) {
                    if (invertedArray.length === 0) {
                        invertedArray = new Array(oneRow.columnCells.length);
                        rememberCategoryFromOneLine = oneRow.category;
                    }
                    _.forEach(oneRow.columnCells, function (cell, index) {
                        var domVersionOfCell = $(cell.content);
                        if (domVersionOfCell.hasClass("variantRecordExists")) {
                            if (typeof invertedArray[index] === 'undefined') {
                                invertedArray[index] = new InversionArray(matchOnGene,matchOnTissue,false);
                            }
                            var geneName = domVersionOfCell.attr('geneName');
                            if ((matchOnGene) && (!invertedArray[index].genes.includes(geneName))) {
                                invertedArray[index].genes.push(geneName);
                            }
                            if ((matchOnTissue) && (!invertedArray[index].tissues.includes(oneRow.subcategory))) {
                                invertedArray[index].tissues.push(oneRow.subcategory);
                            }
                        }
                    });
                });
                var summaryRow = {
                    displayCategory: '<button type="button" class="btn btn-info shower ' + rememberCategoryFromOneLine + '" ' +
                    'onclick="mpgSoftware.dynamicUi.displayTissuesForAnnotation(\'' + rememberCategoryFromOneLine + '\',\''+nameOfAccumulatorObject+'\',\''+tableToUpdate+'\')">display tissues</button>' +
                    '<button type="button" class="btn btn-info hider ' + rememberCategoryFromOneLine + '" ' +
                    'onclick="mpgSoftware.dynamicUi.hideTissuesForAnnotation(\'' + rememberCategoryFromOneLine + '\',\''+nameOfAccumulatorObject+'\',\''+tableToUpdate+'\')"  style="display: none">hide tissues</button>',
                    category: rememberCategoryFromOneLine,
                    sortField: "summary "+rememberCategoryFromOneLine,
                    subcategory: rememberCategoryFromOneLine,
                    displaySubcategory: rememberCategoryFromOneLine,
                    columnCells: []
                };
                _.forEach(invertedArray, function (summaryColumn, index) {
                    if (typeof summaryColumn === 'undefined') {
                        summaryRow.columnCells.push(new IntermediateStructureDataCell(rememberCategoryFromOneLine,
                            Mustache.render($('#emptySummaryVariantAnnotationRecord')[0].innerHTML), "zzzsummary"));
                    } else {

                        if (summaryColumn.tissues.length === 0) {
                            summaryRow.columnCells.push(new IntermediateStructureDataCell(rememberCategoryFromOneLine,
                                Mustache.render($('#emptySummaryVariantAnnotationRecord')[0].innerHTML), "zzzsummary"));
                        } else {
                            var argumentForMustache = {category: rememberCategoryFromOneLine};
                            if (matchOnGene){
                                argumentForMustache["geneNumber"]=  summaryColumn.genes.length;
                            }
                            if (matchOnTissue){
                                argumentForMustache["tissueNumber"]=  summaryColumn.tissues.length;
                            }
                            summaryRow.columnCells.push(new IntermediateStructureDataCell(rememberCategoryFromOneLine,
                                Mustache.render($(cellBodySummaryRecord)[0].innerHTML, argumentForMustache
                                ), "zzzsummary")
                            );
                        }

                    }
                });
                intermediateDataStructure.rowsToAdd.push(summaryRow);
            }

            intermediateDataStructure.tableToUpdate = tableToUpdate;
        }

        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#unused',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            typeOfTable);
    }



    var displayVariantsForAPhenotype = function  (idForTheTargetDiv,objectContainingRetrievedRecords) {

        var variantAnnotationAppearance = function(annotationName,recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                                   testToRun,category){
            var row = _.find(intermediateDataStructure.rowsToAdd,{'subcategory':annotationName});
            if ( typeof row === 'undefined'){
                intermediateDataStructure.rowsToAdd.push ({ category: category,
                    displayCategory:category,
                    subcategory: annotationName,
                    displaySubcategory: annotationName,
                    columnCells:  _.times(numberOfVariants, "")});
                row = _.find(intermediateDataStructure.rowsToAdd,{'subcategory':annotationName});
            }
            if (category ==='annotation'){
                var present = testToRun(recordsPerVariant)?[1]:[];
                row.columnCells[indexOfColumn] = new IntermediateStructureDataCell(annotationName,
                    Mustache.render($("#dynamicVariantCellAssociations")[0].innerHTML,{"variantAnnotationIsPresent":present}),category);
            }else if (category ==='association'){
                var valueToDisplay = testToRun(recordsPerVariant);
                row.columnCells[indexOfColumn] = new IntermediateStructureDataCell(annotationName,
                        Mustache.render($("#dynamicVariantCellAssociations")[0].innerHTML,{"valueToDisplay":valueToDisplay}),category);
            }

        };

        $(idForTheTargetDiv).empty();

        var returnObject = createNewDisplayReturnObject();
        returnObject.variantsToAnnotate = objectContainingRetrievedRecords;

        addAdditionalResultsObject({variantRecordsForOnePhenotypeQtlSearch:returnObject});







        var intermediateDataStructure = new IntermediateDataStructure();
        // variants that we will want to annotate in the variant table
        if (( typeof returnObject.variantsToAnnotate !== 'undefined') && (!$.isEmptyObject(returnObject.variantsToAnnotate))){
            // set up the headers, and give us an empty row of column cells
            _.forEach(returnObject.variantsToAnnotate.variants, function (oneRecord, index){
                if( typeof oneRecord !== 'undefined'){
                    intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord.VAR_ID,
                        Mustache.render($("#dynamicVariantHeader")[0].innerHTML,{variantName:oneRecord.VAR_ID, index: index+2}),"variantHeader") );
                    //  intermediateDataStructure.columnCells.push ("");
                }
            });
            setAccumulatorObject("variantNameArray", _.map(intermediateDataStructure.headers, function (headerRec){return headerRec.title}));
            intermediateDataStructure.rowsToAdd = [];
            var numberOfVariants = returnObject.variantsToAnnotate.variants.length;
            // fill in all of the column cells covering each of our annotations
            if ( typeof returnObject.variantsToAnnotate.variants !== 'undefined'){
                _.forEach(returnObject.variantsToAnnotate.variants, function (recordsPerVariant){
                    var headerNames = _.map(intermediateDataStructure.headers, function (headerRecord){
                        return headerRecord.title
                    });
                    var indexOfColumn = _.indexOf(headerNames,recordsPerVariant.VAR_ID);
                    if (indexOfColumn===-1){
                        console.log("Did not find index of recordsPerVariant.VAR_ID.  Shouldn't we?")
                    }else {
                        _.forEach([ 'Coding',
                            'Splice site',
                            'UTR',
                            'Promoter',
                            'P-value'], function (eachAnnotation){
                            switch (eachAnnotation){
                                case 'Coding':
                                    variantAnnotationAppearance('Coding',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                        function(v){return ((v.MOST_DEL_SCORE > 0)&&(v.MOST_DEL_SCORE < 4))},'annotation');
                                    break;
                                case 'Splice site':
                                    variantAnnotationAppearance('Splice_site',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                        function(v){return (v.Consequence.indexOf('splice')>-1)},'annotation');
                                    break;
                                case 'UTR':
                                    variantAnnotationAppearance('UTR',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                        function(v){return (v.Consequence.indexOf('UTR')>-1)},'annotation');
                                    break;
                                case 'Promoter':
                                    variantAnnotationAppearance('Promoter',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                        function(v){return (v.Consequence.indexOf('promoter')>-1)},'annotation');
                                    break;
                                case 'P-value':
                                    variantAnnotationAppearance('P-value',recordsPerVariant,indexOfColumn,intermediateDataStructure,numberOfVariants,
                                        function(v){return UTILS.realNumberFormatter(""+v.P_VALUE)},'association');
                                    break;
                                default: break;
                            }
                        });
                    }
                });

            }
            intermediateDataStructure.tableToUpdate = "table.combinedVariantTableHolder";

        }









        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#dynamicVariantTable',
            returnObject,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'variantTableVariantHeaders');

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
                //{buttonId: 'getTissuesFromProximityForLocusContext', buttonName: 'proximity',
                //    description: 'present all genes overlapping  the specified region',
                //    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder', reference: '#' },
                //{buttonId: 'getTissuesFromEqtlsForGenesTable', buttonName: 'eQTL',
                //    description: 'present all genes overlapping  the specified region for which some eQTL relationship exists',
                //    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                //    reference: 'https://www.genome.gov/27543767/genotypetissue-expression-project-gtex'},
                //{buttonId: 'modAnnotationButtonId', buttonName: 'MOD',
                //    description: 'list mouse knockout annotations  for all genes overlapping the specified region',
                //    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                //    reference: 'http://www.informatics.jax.org/phenotypes.shtml'},
                //{buttonId: 'getTissuesFromAbcForGenesTable', buttonName: 'ABC',
                //    description: 'get a list of regions associated with a gene via ABC test',
                //    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                //    reference: 'http://science.sciencemag.org/content/354/6313/769'},
                //{buttonId: 'getRecordsFromECaviarForGeneTable', buttonName: 'eCaviar',
                //    description: 'find all genes for which co-localized variants exist',
                //    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                //    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'},
                {buttonId: 'retrieveMultipleRecordsTest', buttonName: 'multi',
                    description: 'combine multiple epigenetic record types',
                    outputBoxId:'#dynamicGeneHolder div.dynamicUiHolder',
                    reference: 'https://www.ncbi.nlm.nih.gov/pubmed/27866706'}
            ]
        };
        $("#dynamicGeneHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));
        //$("#dynamicGeneHolder div.directorButtonHolder").style('display','none');

        /***
         * variant tab
         * @type {{directorButtons: {buttonId: string, buttonName: string, description: string}[]}}
         */
        objectDescribingDirectorButtons = {
            directorButtons: [
                {buttonId: 'getVariantsFromQtlAndThenRetrieveEpigeneticData', buttonName: 'multi',
                    description: 'build a variant based table with a collection of epigenetic data',
                    outputBoxId:'#dynamicVariantHolder div.dynamicUiHolder',
                    reference: 'https://s3.amazonaws.com/broad-portal-resources/tutorials/Genetic_association_primer.pdf'}
            ]
        };
        $("#dynamicVariantHolder div.directorButtonHolder").empty().append(Mustache.render($('#templateForDirectorButtonsOnATab')[0].innerHTML,
            objectDescribingDirectorButtons
        ));
        //$("#dynamicVariantHolder div.directorButtonHolder").style('display','none');

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

            resetAccumulatorObject("geneNameArray");
            resetAccumulatorObject("geneInfoArray");
//
            resetAccumulatorObject("tissuesForEveryGene");
            resetAccumulatorObject("genesForEveryTissue");
//
            resetAccumulatorObject("rawDepictInfo");
//
            resetAccumulatorObject("abcAggregatedPerVariant");
            resetAccumulatorObject("sharedTable_table.combinedGeneTableHolder");


            destroySharedTable('table.combinedGeneTableHolder');

            arrayOfRoutinesToUndertake.push( actionContainer("getTissuesFromProximityForLocusContext",
                actionDefaultFollowUp("getTissuesFromProximityForLocusContext")));


            arrayOfRoutinesToUndertake.push( actionContainer('getTissuesFromEqtlsForGenesTable',
                actionDefaultFollowUp("getTissuesFromEqtlsForGenesTable")));

            arrayOfRoutinesToUndertake.push( actionContainer('getGeneAssociationsForGenesTable',
                actionDefaultFollowUp("getGeneAssociationsForGenesTable")));

            arrayOfRoutinesToUndertake.push( actionContainer('getInformationFromDepictForGenesTable',
                actionDefaultFollowUp("getInformationFromDepictForGenesTable")));

            //////// arrayOfRoutinesToUndertake.push( actionContainer('getAnnotationsFromModForGenesTable',
            ////////     actionDefaultFollowUp("getAnnotationsFromModForGenesTable")));

            arrayOfRoutinesToUndertake.push( actionContainer("getTissuesFromAbcForGenesTable",
                actionDefaultFollowUp("getTissuesFromAbcForGenesTable")));

            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});


        });



        $('#getVariantsFromQtlAndThenRetrieveEpigeneticData').on('click', function () {

            resetAccumulatorObject("sharedTable_table.combinedVariantTableHolder");
            destroySharedTable('table.combinedVariantTableHolder');
            var arrayOfRoutinesToUndertake = [];

            arrayOfRoutinesToUndertake.push( actionContainer('getVariantsWeWillUseToBuildTheVariantTable',
                actionDefaultFollowUp("getVariantsWeWillUseToBuildTheVariantTable")));

            arrayOfRoutinesToUndertake.push( actionContainer('getEqtlsGivenVariantList',
                actionDefaultFollowUp("getEqtlsGivenVariantList")));


            arrayOfRoutinesToUndertake.push( actionContainer('getABCGivenVariantList',
                actionDefaultFollowUp("getABCGivenVariantList")));

            arrayOfRoutinesToUndertake.push( actionContainer('getDnaseGivenVariantList',
                actionDefaultFollowUp("getDnaseGivenVariantList")));

            arrayOfRoutinesToUndertake.push( actionContainer('getH3k27acGivenVariantList',
                actionDefaultFollowUp("getH3k27acGivenVariantList")));


            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});


        });




        resetAccumulatorObject();


        displayContext('#contextDescription',getAccumulatorObject());

        $('#retrieveMultipleRecordsTest').click();
        $('#getVariantsFromQtlAndThenRetrieveEpigeneticData').click();

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


    /***
     * Default constructor of the SharedTableObject
     * @param additionalParameters
     * @returns {{extentBegin: (*|jQuery), extentEnd: (*|jQuery), chromosome: string, originalGeneName: *, geneNameArray: Array, tissueNameArray: Array, modNameArray: Array, mods: Array, contextDescr: {chromosome: string, extentBegin: (*|jQuery), extentEnd: (*|jQuery), moreContext: Array}}}
     */
    var SharedTableObject = function (annotation,numberOfColumn,numberOfRows){
        return {
            originalForm: annotation,
            currentForm: annotation,
            numberOfColumns: numberOfColumn,
            numberOfRows: numberOfRows,
            dataCells: new Array()
        };
    };
    var SharedTableDataCell = function (title,content,annotation, ascensionNumber){
        return {
            title: title,
            content: content,
            annotation: annotation,
            ascensionNumber:ascensionNumber
        };
    };
    var IntermediateStructureDataCell = function (name,content, annotation){
        return {
            title: name,
            content: content,
            annotation:  annotation
        };
    };


    var storeCellInMemoryRepresentationOfSharedTable = function (   whichTable,
                                                                    cell,
                                                                    annotation,
                                                                    rowIndex,
                                                                    columnIndex,
                                                                    numberOfColumns ){
        var indexInOneDimensionalArray = (rowIndex*numberOfColumns)+columnIndex;
        var sharedTable = getAccumulatorObject("sharedTable_"+whichTable);
        if (($.isArray(sharedTable)) && (sharedTable.length === 0)){
            // data structure is empty.  Let us give it the correct form, and then store it
            sharedTable = new SharedTableObject(annotation,numberOfColumns,rowIndex);
            setAccumulatorObject("sharedTable_"+whichTable,sharedTable);
        }
        if (indexInOneDimensionalArray > sharedTable.length){
            // we must be on a new row. We know that rows are added sequentially
            sharedTable.dataCells.push.apply(sharedTable.dataCells, new Array(numberOfColumns));
        }
        sharedTable.dataCells [indexInOneDimensionalArray] = new SharedTableDataCell(   cell.title,
                                                                                        cell.content,
                                                                                        cell.annotation,
                                                                                        indexInOneDimensionalArray );
    }



        var generalPurposeSort  = function(a, b, direction, currentSort ){

            switch (currentSort){
                case 'geneMethods':
                    var textA = $(a).attr('sortField').toUpperCase();
                    var textB = $(b).attr('sortField').toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                case 'variantAnnotationCategory':
                case 'methods':
                    var textA = $(a).attr('sortField').toUpperCase();
                    var textB = $(b).attr('sortField').toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                case 'H3k27ac':
                case 'DNase':
                case 'ABC':
                case 'eQTL':
                case 'variantHeader':
                    var x = parseInt($(a).attr('sortField'));
                    var y = parseInt($(b).attr('sortField'));
                    if ( (-1===x) && (-1===y) ) {
                        return 0;
                    }
                    else if (-1===x) {
                        if (direction==='asc') {
                            return -1;
                        } else {
                            return 1;
                        }
                    }else if (-1===y)
                    {
                        if (direction==='asc') {
                            return 1;
                        } else {
                            return -1;
                        }
                    }
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                case 'Promoter':
                case 'Splice_site':
                case 'UTR':
                case 'Coding':
                    var x = parseInt($(a).attr('sortField'));
                    var y = parseInt($(b).attr('sortField'));
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'P-value':
                    var x = parseFloat($(a).attr('sortField'));
                    var y = parseFloat($(b).attr('sortField'));
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'eQTL':
                case 'Depict':
                case 'ABC':
                    var x = parseInt($(a).attr('sortField'));
                    if (isNaN(x)){
                        x = parseInt($(a).attr('subSortField'));
                    }
                    var y = parseInt($(b).attr('sortField'));
                    if (isNaN(y)){
                        y = parseInt($(b).attr('subSortField'));
                    }
                    if ( (-1===x) && (-1===y) ) {
                        return 0;
                    }
                    else if (-1===x) {
                        if (direction==='asc') {
                            return -1;
                        } else {
                            return 1;
                        }
                    }else if (-1===y)
                    {
                        if (direction==='asc') {
                            return 1;
                        } else {
                            return -1;
                        }
                    }
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'geneHeader':
                    var x = parseInt($(a).attr('sortField'));
                    if (isNaN(x)){
                        x = parseInt($(a).attr('subSortField'));
                    }
                    var y = parseInt($(b).attr('sortField'));
                    if (isNaN(y)){
                        y = parseInt($(b).attr('subSortField'));
                    }
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'straightAlphabetic':
                    var textA = a.trim().toUpperCase();
                    var textB = b.trim().toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                case 'straightAlphabeticWithSpacesOnTop':
                    var textA = a.trim().toUpperCase();
                    var textAEmpty = (textA.length===0);
                    var textB = b.trim().toUpperCase();
                    var textBEmpty = (textB.length===0);
                    if ( textAEmpty && textBEmpty ) {
                        return 0;
                    }
                    else if ( textAEmpty ) {
                        if (direction==='asc') {
                            return -1;
                        } else {
                            return 1;
                        }
                    }else if ( textBEmpty )
                    {
                        if (direction==='asc') {
                            return 1;
                        } else {
                            return -1;
                        }
                    }
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                default:
                    break;
            }
            var x = UTILS.extractAnchorTextAsInteger(a);
            var y = UTILS.extractAnchorTextAsInteger(b);
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        }



        jQuery.fn.dataTableExt.oSort['generalSort-asc'] = function (a, b ) {
            var currentSortRequest = getAccumulatorObject("currentSortRequest");
            return generalPurposeSort(a,b,'asc',currentSortRequest.currentSort);
        };

        jQuery.fn.dataTableExt.oSort['generalSort-desc'] = function (a, b) {
            var currentSortRequest = getAccumulatorObject("currentSortRequest");
            if (currentSortRequest.currentSort === "variantAnnotationCategory"){
                return generalPurposeSort(a,b,'desc',currentSortRequest.currentSort);
            } else {
                return generalPurposeSort(b,a,'desc',currentSortRequest.currentSort);
            }
        };








    /***
     * Initiate the jQuery data table and build its headers. This routine expects objects
     * inside each element of the array which will have
     * {contents:'whatever HTML you want to display in a cell',
     *  name:'a string which every cell can reference to figure out which column it belongs in'}
     *
     *  If the length is zero then don't make a table.
     *
     *  Return a pointer to the data table
     *
     * @param headerArray
     */
    var buildHeadersForTable = function (   whereTheTableGoes,
                                            headers,// object with title, content, and ascensionNumber (and annotation?)
                                            storeHeadersInDataStructure,
                                            typeOfHeader,
                                            prependColumns,
                                            additionalDetailsForHeaders ){
        if (( typeof headers !== 'undefined') &&
            (headers.length > 0)){
            var datatable;
            if ( ! $.fn.DataTable.isDataTable( whereTheTableGoes ) ) {
                var headerDescriber = {
                    //dom: '<"#gaitButtons"B><"#gaitVariantTableLength"l>rtip',
                    dom: '<"top">rt<"bottom"iplB>',
                    "buttons": [
                        {extend: "copy", text: "Copy all to clipboard"},
                        {extend: "csv", text: "Copy all to csv"},
                        {extend: "pdf", text: "Copy all to pdf"}
                    ],
                    "aLengthMenu": [
                        [100, 500, -1],
                        [100, 500, "All"]
                    ],
                    "bDestroy": true,
                    "bAutoWidth": false,
                    "columnDefs": []
                };
                var addedColumns = [];
                if (prependColumns){ // we may wish to add in some columns based on metadata about a row.
                                     //  Definitely we don't if we are transposing, however, since we've already built that material
                    var sortability = [];
                    switch(typeOfHeader){
                        case 'geneTableGeneHeaders':
                            addedColumns.push(new IntermediateStructureDataCell('farLeftCorner','','geneFarLeftCorner columnNumber_0'));
                            sortability.push(false);
                            addedColumns.push(new IntermediateStructureDataCell('b','','geneMethods columnNumber_1'));
                            sortability.push(true);
                            break;
                        case 'variantTableVariantHeaders':
                            addedColumns.push(new IntermediateStructureDataCell('farLeftCorner','','variantAnnotationCategory columnNumber_0'));
                            sortability.push(true);
                            addedColumns.push(new IntermediateStructureDataCell('b','','methods columnNumber_1'));
                            sortability.push(true);
                            break;
                        case 'variantTableAnnotationHeaders':
                        case 'geneTableAnnotationHeaders':
                        default:
                            break;
                    }
                    _.forEach(addedColumns, function (column, index){
                        var contentOfHeader = column.content;
                        headerDescriber.columnDefs.push({
                            "title": contentOfHeader,
                            "targets": (sortability[index])?[index]:'nosort',
                            "name": column.title,
                            "className": column.annotation,
                            "sortable": sortability[index],
                            "type": "generalSort"
                        });
                    });

                }



                var numberOfAddedColumns = addedColumns.length;
                 _.forEach(headers, function (header, count) {
                     var classesToPromote = [];
                     // first let us extract any classes that we need to promote to the header
                     if (header.content.length>0){
                         var classList = $(header.content).attr("class").split(/\s+/);
                         var currentSortRequestObject = {};
                         _.forEach(classList, function (oneClass){
                             var columnNumber = "columnNumber_";
                             var sortOrderDesignation = "sorting_";
                             if ( oneClass.substr(0,columnNumber.length) === columnNumber ){
                                 classesToPromote.push (oneClass);
                             }
                             if ( oneClass.substr(0,sortOrderDesignation.length) === sortOrderDesignation ){
                                 classesToPromote.push (oneClass);
                             }
                         });
                     }
                     var contentOfHeader = header.content;
                     if ((typeOfHeader === 'variantTableAnnotationHeaders')&&
                         (additionalDetailsForHeaders.length > 0)){
                         contentOfHeader += additionalDetailsForHeaders[count].content;
                     }
                     var noSorting = (((count+numberOfAddedColumns)===0)&&(typeOfHeader==='geneTableGeneHeaders'));
                      headerDescriber.columnDefs.push({
                        "title": contentOfHeader,
                        "targets": noSorting?'nosort':[count+numberOfAddedColumns],
                        "name": header.title,
                        "className": header.annotation+" "+classesToPromote.join(" "),
                        "sortable": !noSorting,
                        "type": "generalSort"
                    });
                     addedColumns.push(new IntermediateStructureDataCell(header.title,header.content,header.annotation));
                });

                datatable = $(whereTheTableGoes).DataTable(headerDescriber);


                $(whereTheTableGoes+' th').unbind('click.DT');

                //create your own click handler for the header

                $(whereTheTableGoes+' th').click(function(e) {
                    var classList = $(this).attr("class").split(/\s+/);
                    var columnNumberValue = -1;
                    var sortOrder =  'asc';
                    var currentSortRequestObject = {};
                    _.forEach(classList, function (oneClass){
                        var columnNumber = "columnNumber_";
                        var sortOrderDesignation = "sorting_";
                        if ( oneClass.substr(0,columnNumber.length) === columnNumber ){
                            columnNumberValue =   parseInt(oneClass.substr(columnNumber.length));
                        }
                        if ( oneClass.substr(0,sortOrderDesignation.length) === sortOrderDesignation ){
                            sortOrder =   oneClass.substr(sortOrderDesignation.length);
                        }
                        switch (oneClass){
                            case 'eQTL':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'Depict':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'ABC':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'geneHeader':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'geneFarLeftCorner':
                                currentSortRequestObject = {
                                    'currentSort':'straightAlphabeticWithSpacesOnTop',
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'geneMethods':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedGeneTableHolder'
                                };
                                break;
                            case 'methods':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;

                            case 'variantTableVarHeader':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'variantHeader':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'variantAnnotationCategory':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'Coding':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'Splice_site':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'UTR':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'Promoter':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'P-value':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'H3k27ac':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'DNase':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'ABC':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;
                            case 'eQTL':
                                currentSortRequestObject = {
                                    'currentSort':oneClass,
                                    'table':'table.combinedVariantTableHolder'
                                };
                                break;

                            default:
                                break;
                        }
                    });
                    var actualColumnIndex = columnNumberValue;
                    currentSortRequestObject['sortOrder'] = (sortOrder === 'asc')?'desc':'asc';
                    currentSortRequestObject['columnNumberValue'] = actualColumnIndex;
                    var setOfColumnsToSort = [];
                    if ((typeOfHeader === "variantTableVariantHeaders")&&
                        ( currentSortRequestObject.currentSort !== "variantAnnotationCategory")){
                        setOfColumnsToSort.push([0,'asc']);
                    }
                    setOfColumnsToSort.push([ currentSortRequestObject.columnNumberValue, currentSortRequestObject.sortOrder ]);
                    setAccumulatorObject("currentSortRequest", currentSortRequestObject );

                    datatable
                        .order( setOfColumnsToSort )
                       // .order( [ currentSortRequestObject.columnNumberValue, currentSortRequestObject.sortOrder ] )
                        .draw();
                });


                if (storeHeadersInDataStructure){
                    // do we need to store these headers?
                    var numberOfHeaders = datatable.table().columns().length;
                    _.forEach(datatable.table().columns().header(),function(o,columnIndex){
                        var domElement = $(o);
                        var headerName = domElement.text().trim();
                        storeCellInMemoryRepresentationOfSharedTable(whereTheTableGoes,
                            addedColumns[columnIndex],
                            typeOfHeader,
                            0,
                            columnIndex,
                            headerDescriber.columnDefs.length );
                    });
                }
            }
        }
        return $(whereTheTableGoes).dataTable();

    };


    var refineTableRecords = function (datatable,headerType,adjustVisibilityCategories,headerSpecific){
        if( typeof datatable === 'undefined'){
            console.log(" ERROR: failed to receive a valid datatable parameter");
        } else if (( typeof datatable.DataTable() === 'undefined') ||
            ( typeof datatable.DataTable().columns() === 'undefined') ||
            ( typeof datatable.DataTable().columns().header() === 'undefined') ) {
            console.log(" ERROR: invalid parameter in refineTableRecords");
        } else {
            switch(headerType){
                case 'geneTableGeneHeaders':
                  break;
                case 'variantTableVariantHeaders':
                    if (headerSpecific) {
                        _.forEach(datatable.DataTable().columns().header(),function(o,columnIndex){ //  make nice headers out of VAR_IDs
                            var domElement = $(o);
                            var headerName = domElement.text().trim();
                            if ((headerName.length >  5) &&
                                (headerName.split('_').length === 4)){
                                var partsOfId = headerName.split('_');
                                domElement.addClass("niceHeadersThatAreLinks");
                                domElement.addClass("headersWithVarIds");
                                domElement.attr("defrefa",partsOfId[2]);
                                domElement.attr("defeffa",partsOfId[3]);
                                domElement.attr("chrom",partsOfId[0]);
                                domElement.attr("position",partsOfId[1]);
                                domElement.attr("varid",partsOfId[0]+":"+partsOfId[1]+"_"+
                                    partsOfId[2]+"/"+partsOfId[3]);
                                domElement.attr("data-toggle","popover");
                            }


                        });
                    } else { // adjust the coloration of selected squares
                        if (( typeof adjustVisibilityCategories !== 'undefined') &&
                            (adjustVisibilityCategories.length > 0)){
                            if (adjustVisibilityCategories[0] === "H3k27ac"){
                                for( var i = 0 ; i < 5 ; i++ ){
                                    $('td:has(div.tissueTable.matchingRegion1_'+i+')').addClass('tissueTable matchingRegion1_'+i);
                                }
                            } else if (adjustVisibilityCategories[0] === "DNase"){
                                for( var i = 0 ; i < 5 ; i++ ){
                                    $('td:has(div.tissueTable.matchingRegion2_'+i+')').addClass('tissueTable matchingRegion2_'+i);
                                }
                            }
                            _.forEach(adjustVisibilityCategories,function(adjustVisibilityCategory){
                                if (($.isArray(adjustVisibilityCategory))&&(adjustVisibilityCategory.length>0)){
                                    var elementsToHide = $('div.noDataHere.'+adjustVisibilityCategory);
                                    if (elementsToHide.length>0){
                                        elementsToHide.parent().parent().hide();
                                    }
                                    elementsToHide = $('div.variantRecordExists.'+adjustVisibilityCategory);
                                    if (elementsToHide.length>0){
                                        elementsToHide.parent().parent().hide();
                                    }
                                }

                            });
                            _.forEach($('div.tissueRecord'),function(oneRecord){
                                $(oneRecord).parent().parent().hide();
                            });

                        }

                    }
                    break;
                case 'variantTableAnnotationHeaders':
                    if (headerSpecific) {
                        ;
                    } else { // turn off the visibility of tissue specific
                        var tissueColumnsToHide = $('th.tissueRecord');
                        _.forEach(tissueColumnsToHide,function(oneColumn){
                            var classListForColumn = $(oneColumn).attr("class").split(/\s+/);
                            if (_.includes(classListForColumn,'tissueRecord')){
                                var buildSelector = 'th.'+classListForColumn.join('.');
                                datatable.DataTable().column(buildSelector).visible(false);
                            }

                        });
                    }

                     break;

                default:
                    break;
            }
        }
    }




    var addContentToTable = function (  whereTheTableGoes,
                                        rowsToAdd,
                                        storeRecordsInDataStructure,
                                        typeOfRecord,
                                        prependColumns){
        var rememberCategories = [];
        _.forEach(rowsToAdd, function (row,newRowCount) {
            if ( !_.includes (rememberCategories,row.category)) {
                rememberCategories.push(row.category);
            } else if ( !_.includes (rememberCategories,row.subcategory)) {
                rememberCategories.push(row.subcategory);
            }

            var numberOfExistingRows = $(whereTheTableGoes+" tr").length;
            if (numberOfExistingRows === 2){ // special case.  When the table is first created a fake row is added by jquery datatable.  Ignore it
                                             //   for the purposes of building our in memory representation of the table.
                if ($(whereTheTableGoes+" tr.odd td").hasClass("dataTables_empty")){
                    numberOfExistingRows = 1;
                }
            }
            var sharedTable = getAccumulatorObject("sharedTable_"+whereTheTableGoes);
            var numberOfColumns  = sharedTable.numberOfColumns;
            var rowDescriber = [];
            var numberOfColumnsAdded = 0;
            if (prependColumns){
                switch (typeOfRecord) {
                    case 'geneTableGeneHeaders':
                        rowDescriber.push( new IntermediateStructureDataCell(row.category,
                            "<div class='"+row.subcategory+" columnNumber_"+numberOfExistingRows+" geneRow'>"+row.displayCategory+"</div>" ,
                            row.subcategory)) ;
                        rowDescriber.push( new IntermediateStructureDataCell(row.subcategory,
                            "<div class='subcategory' sortField='"+row.displaySubcategory+"' subSortField='-1'>"+row.displaySubcategory+"</div>" ,
                            "insertedColumn2"));
                        numberOfColumnsAdded += rowDescriber.length;
                        break;
                    case 'variantTableVariantHeaders':
                        var primarySortField =  ( typeof row.sortField === 'undefined') ? row.category : row.sortField;
                        rowDescriber.push( new IntermediateStructureDataCell(row.category,
                                               "<div class='"+row.subcategory+" columnNumber_"+numberOfExistingRows+" variantRow' sortField='"+primarySortField+"'>"+
                                                row.displayCategory+"</div>" ,
                                                row.subcategory)) ;
                        rowDescriber.push( new IntermediateStructureDataCell(row.subcategory,
                                                "<div class='subcategory columnNumber_"+numberOfExistingRows+" variantRow' sortField='"+row.subcategory+"'>"+
                                                row.displaySubcategory+"</div>" ,
                                                "insertedColumn2"));
                        numberOfColumnsAdded += rowDescriber.length;
                        break;
                    case 'geneTableAnnotationHeaders':
                        break;
                    default:
                        break;
                }

                _.forEach(rowDescriber, function(oneRow,columnIndex){
                    if (storeRecordsInDataStructure) {
                        storeCellInMemoryRepresentationOfSharedTable(whereTheTableGoes,
                            oneRow,
                            'content',
                            numberOfExistingRows,
                            columnIndex,
                            numberOfColumns);
                    }
                });



            }
            _.forEach(rowDescriber, function(oneRow,columnIndex){
                if ( !_.includes (rememberCategories,oneRow.title)) {
                    rememberCategories.push(oneRow.title);
                }
            });


            _.forEach(row.columnCells, function (val, index) {
                rowDescriber.push(val);
                if (storeRecordsInDataStructure){
                    storeCellInMemoryRepresentationOfSharedTable(whereTheTableGoes,
                        val,
                        'content',
                        numberOfExistingRows,
                        index + numberOfColumnsAdded,
                        numberOfColumns);
                }
            });
            $(whereTheTableGoes).dataTable().fnAddData(_.map(rowDescriber,function(o){return o.content}));
        });
        return rememberCategories;
    }




    var buildOrExtendDynamicTable = function (whereTheTableGoes,intermediateStructure,
                                              storeRecords,typeOfRecord) {
        var datatable;

        if (( typeof intermediateStructure !== 'undefined') &&
            ( typeof intermediateStructure.headers !== 'undefined') &&
            (intermediateStructure.headers.length > 0)){
                datatable = buildHeadersForTable(whereTheTableGoes,intermediateStructure.headers,
                    storeRecords,typeOfRecord, true, []);
                refineTableRecords(datatable,typeOfRecord,[], true);
        }


        if (( typeof intermediateStructure.rowsToAdd !== 'undefined') &&
            (intermediateStructure.rowsToAdd.length > 0)){
            datatable =  $(whereTheTableGoes).dataTable();
            var rememberCategories = addContentToTable(whereTheTableGoes,intermediateStructure.rowsToAdd,
                                                    storeRecords,typeOfRecord, true);
            refineTableRecords(datatable,typeOfRecord,rememberCategories, false);
        }


    };


 var formConversionOfATranspose = function (originalForm){
     var currentForm = "";
     switch (originalForm){
         case 'geneTableGeneHeaders':
             currentForm = 'geneTableAnnotationHeaders';
             break;
         case 'variantTableVariantHeaders':
             currentForm = 'variantTableAnnotationHeaders';
             break;
         case 'geneTableAnnotationHeaders':
             currentForm = 'geneTableGeneHeaders';
             break;
         case 'variantTableAnnotationHeaders':
             currentForm = 'variantTableVariantHeaders';
             break;
         default:
             console.log("CRITICAL ERROR: unrecognized table form = "+ originalForm +"." );

     }
     return currentForm;
 }



 var transposeThisTable   = function (whereTheTableGoes) {
     destroySharedTable(whereTheTableGoes);

     var sharedTable = getAccumulatorObject("sharedTable_"+whereTheTableGoes);

     if (( typeof sharedTable !== 'undefined') &&
         ( typeof sharedTable.dataCells !== 'undefined') &&
         (sharedTable.dataCells.length > 0)){
         var numberOfColumns= sharedTable.numberOfColumns;
         if ((sharedTable.dataCells.length % numberOfColumns) !== 0){
             console.log(" CRITICAL ERROR in TRANSPOSITION.  Consistency check (sharedTable.dataCells.length % numberOfColumns) === 0) has failed.")
         }
         var numberOfRows= sharedTable.dataCells.length/numberOfColumns;
         var arrayIndex = 0;
         var transposedTableDescription = {};
         sharedTable.currentForm = formConversionOfATranspose(sharedTable.currentForm);
         if (sharedTable.currentForm !== sharedTable.originalForm){// need to transpose the data
             transposedTableDescription = {
                 numberOfColumns: numberOfRows,
                 numberOfRows: numberOfColumns,
                 dataCells: new Array()
             }

             for ( var i = 0 ; i < transposedTableDescription.numberOfRows ; i++ ){
                 for ( var j = 0 ; j < transposedTableDescription.numberOfColumns ; j++ ){
                     transposedTableDescription.dataCells[arrayIndex++]=sharedTable.dataCells[(j*transposedTableDescription.numberOfRows)+i];
                 }
             }

         } else { // we're going back to the original form of the table
             transposedTableDescription = {
                 numberOfColumns:  numberOfColumns,
                 numberOfRows: numberOfRows,
                 dataCells: new Array()
             };

             for ( var i = 0 ; i < transposedTableDescription.numberOfRows ; i++ ){
                 for ( var j = 0 ; j < transposedTableDescription.numberOfColumns ; j++ ){
                     transposedTableDescription.dataCells[arrayIndex]=sharedTable.dataCells[arrayIndex];
                     arrayIndex++;
                 }
             }

         }

         var additionalDetailsForHeaders = [];
         var currentLocationInArray = 0;
         var headers = _.slice(transposedTableDescription.dataCells,currentLocationInArray,transposedTableDescription.numberOfColumns);
         currentLocationInArray +=  transposedTableDescription.numberOfColumns;
         if (sharedTable.currentForm === 'variantTableAnnotationHeaders'){
             additionalDetailsForHeaders = _.slice( transposedTableDescription.dataCells,currentLocationInArray,
                                                    (currentLocationInArray+transposedTableDescription.numberOfColumns));
             currentLocationInArray += transposedTableDescription.numberOfColumns;
         }
         var datatable = buildHeadersForTable(whereTheTableGoes, headers,false,
             sharedTable.currentForm, false, additionalDetailsForHeaders);
         refineTableRecords(datatable,sharedTable.currentForm,[],true);

         // build the body
         var rowsToAdd = [];
         var content = _.slice(transposedTableDescription.dataCells,currentLocationInArray);

         var contentSize = content.length;
         _.forEach(content, function(datacell,index){
             var modulus = index%transposedTableDescription.numberOfColumns;
             if (modulus===0){
                 rowsToAdd.push({category:datacell.title,columnCells:new Array()});
             }
             var lastRow  = rowsToAdd[rowsToAdd.length-1];
             return lastRow.columnCells.push(datacell);
         });
         datatable =  $(whereTheTableGoes).dataTable();
         var rememberCategories = addContentToTable(whereTheTableGoes,rowsToAdd,false,sharedTable.currentForm, false);
         refineTableRecords(datatable,sharedTable.currentForm,rememberCategories,false);



     }



 };



var  dataTableZoomSet =    function (TGWRAPPER,TGZOOM) {

        $(TGWRAPPER).find(".dataTables_wrapper").removeClass("dk-zoom-0 dk-zoom-1 dk-zoom-2 dk-zoom-3").addClass("dk-zoom-"+TGZOOM);

}


var destroySharedTable = function (whereTheTableGoes) {
    if ( $.fn.DataTable.isDataTable( whereTheTableGoes ) ) {
        var datatable = $(whereTheTableGoes).dataTable();
        datatable.fnDestroy(false);
        $(whereTheTableGoes).empty()
    }
}


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

    var displayTissuesForAnnotation = function (annotationId,nameOfAccumulatorObject,tableToUpdate){
        var recordsAggregatedPerVariant = getAccumulatorObject("sharedTable_"+tableToUpdate);
        if (recordsAggregatedPerVariant.currentForm==="variantTableVariantHeaders"){
            $('div.noDataHere.'+annotationId).parent().parent().show();
            $('div.variantRecordExists.'+annotationId).parent().parent().show();
        } else {
            var dataTable = $(tableToUpdate).DataTable();
            var tissueColumnsToDisplay = [];
            var totalNumberOfColumns = $(tableToUpdate).DataTable().columns()[0].length;
            for ( var i = 0 ; i < totalNumberOfColumns ; i++ ){
                var classListForColumn = $($(tableToUpdate).DataTable().columns(i).header()[0]).attr('class').split(/\s+/);
                if (_.includes(classListForColumn,annotationId)){
                    var buildSelector = 'th.'+classListForColumn.join('.');
                    dataTable.column(buildSelector).visible(true);
                }

            }
        }
        $('button.shower.'+annotationId).hide();
        $('button.hider.'+annotationId).show();

    };
    var hideTissuesForAnnotation = function (annotationId,nameOfAccumulatorObject,tableToUpdate){
        var recordsAggregatedPerVariant = getAccumulatorObject("sharedTable_"+tableToUpdate);
        if (recordsAggregatedPerVariant.currentForm==="variantTableVariantHeaders") {
            $('div.noDataHere.' + annotationId).parent().parent().hide();
            $('div.variantRecordExists.' + annotationId).parent().parent().hide();
        } else {
            var dataTable = $(tableToUpdate).DataTable();
            var tissueColumnsToHide = $('th.tissueRecord.'+annotationId);
            _.forEach(tissueColumnsToHide,function(oneColumn){
                var classListForColumn = $(oneColumn).attr("class").split(/\s+/);
                if (_.includes(classListForColumn,'tissueRecord')){
                    var buildSelector = 'th.'+classListForColumn.join('.');
                    dataTable.column(buildSelector).visible(false);
                }
            });

    }


        $('button.shower.'+annotationId).show();
        $('button.hider.'+annotationId).hide();
    };


    //_.forEach(tissueColumnsToHide,function(oneColumn){
    //    var classListForColumn = $(oneColumn).attr("class").split(/\s+/);
    //    if (_.includes(classListForColumn,'tissueRecord')){
    //        var buildSelector = 'th.'+classListForColumn.join('.');
    //        datatable.DataTable().column(buildSelector).visible(false);
    //    }
    //
    //});



// public routines are declared below
    return {
        transposeThisTable:transposeThisTable,
        dataTableZoomSet:dataTableZoomSet,
        displayTissuesForAnnotation:displayTissuesForAnnotation,
        hideTissuesForAnnotation:hideTissuesForAnnotation,
        installDirectorButtonsOnTabs: installDirectorButtonsOnTabs,
        modifyScreenFields: modifyScreenFields,
        adjustLowerExtent: adjustLowerExtent,
        adjustUpperExtent: adjustUpperExtent
    }
}());


