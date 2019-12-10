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


var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = (function () {
    var loading = $('#rSpinner');
    var nameOfDomToStoreAccumulatorInformation;
    var dyanamicUiVariables;
    let currentSortRequest = "";
    var clearBeforeStarting = false;
    var deferredObject;

    var CELL_COLORING_BLUISH_TOP = '#1240FE';
    var CELL_COLORING_BLUISH_TOP_MINUS1 = '#3D63FF';
    var CELL_COLORING_BLUISH_TOP_MINUS2 = '#6482FE';
    var CELL_COLORING_BLUISH_TOP_MINUS3 = '#91A6FE';
    var CELL_COLORING_BLUISH_TOP_MINUS4 = '#CCD6FE';
    var CELL_COLORING_BLUISH_BOTTOM = '#eeeeee';

    var CELL_COLORING_REDDISH_TOP = '#FE2F06';
    var CELL_COLORING_REDDISH_TOP_MINUS1 = '#FE5E3D';
    var CELL_COLORING_REDDISH_TOP_MINUS2 = '#FE8870';
    var CELL_COLORING_REDDISH_TOP_MINUS3 = '#FFAC9C';
    var CELL_COLORING_REDDISH_TOP_MINUS4 = '#FFCEC4';
    var CELL_COLORING_REDDISH_BOTTOM = '#eeeeee';

    var CELL_COLORING_UNUSED = '#FFFFFF';






    /***
     * Constructor for the object which will be passed to addContent and addHeader routines.  Effectively we are
     * taking the information we received from the 'processor' routine, and, in the course of the 'display' routine,
     * and putting that information in a form that we can actually display.
     *
     * @returns {{headerNames: Array, headerContents: Array, headers: Array, rowsToAdd: Array, tableToUpdate: string}}
     * @constructor
     */
    var IntermediateDataStructure = function() {
        return {
            headerNames : [],
            headerContents:[],
            headers : [],
            rowsToAdd:[],
            tableToUpdate : ""
        }
    };


    /***
     * Default constructor of the shared accumulator object
     * @param additionalParameters
     * @returns {{extentBegin: (*|jQuery), extentEnd: (*|jQuery), chromosome: string, originalGeneName: *, geneNameArray: Array, tissueNameArray: Array, modNameArray: Array, mods: Array, contextDescr: {chromosome: string, extentBegin: (*|jQuery), extentEnd: (*|jQuery), moreContext: Array}}}
     */
    var AccumulatorObject = function (additionalParameters) {
        var returnObject = additionalParameters;
        if (( typeof additionalParameters.geneChromosome !== 'undefined') &&
            ( typeof additionalParameters.geneExtentBegin !== 'undefined') &&
            ( typeof additionalParameters.geneExtentEnd !== 'undefined') &&
            ( typeof additionalParameters.geneName !== 'undefined') ){
            var chrom = (additionalParameters.geneChromosome.indexOf('chr') > -1) ?
                additionalParameters.geneChromosome.substr(3) :
                additionalParameters.geneChromosome;
            returnObject['extentBegin'] = additionalParameters.geneExtentBegin;
            returnObject['extentEnd'] = additionalParameters.geneExtentEnd;
            returnObject['chromosome'] = chrom;
            returnObject['originalGeneName'] = additionalParameters.geneName;
        }
        return returnObject;
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
            mostRecentHeaders : [],
            dataCells: new Array(),
            staticDataExclusions: [], // an array of objects containing data to be excluded.  Form={groupNumber:0,excludedColumns:[3,4,5]}
            matrix: new mpgSoftware.matrixMath.Matrix(new Array(),0,0),
            assignDataToMatrix: function(cell,rowIndex,
                                          columnIndex,
                                          numberOfColumns,
                                          indexInOneDimensionalArray){
                var indexInOneDimensionalArray = (rowIndex*numberOfColumns)+columnIndex;
                this.matrix.numberOfColumns = numberOfColumns;
                this.matrix.dataArray[indexInOneDimensionalArray] = new SharedTableDataCell(    null ,
                    cell ,
                    null ,
                    indexInOneDimensionalArray,
                    null
                );
                this.matrix.numberOfRows =  Math.floor(this.matrix.dataArray.length/this.matrix.numberOfColumns);
            },
            removeColumnExclusionGroup:function(groupNumber) {
                _.remove(this.staticDataExclusions, function (o) {
                    return o.groupNumber === groupNumber
                });
            },
            addColumnExclusionGroup:function(groupNumber,
                                             groupName,
                                             columnsToExclude) {
                _.remove(this.staticDataExclusions, function (o) {
                    return o.groupNumber === groupNumber
                });
                this.staticDataExclusions.push({groupNumber: groupNumber, groupName:groupName, excludedColumns: columnsToExclude});
            },
            getAllColumnsToExclude:function() {
                var returnValue = [];
                _.forEach(this.staticDataExclusions, function (o){
                    _.forEach(o.excludedColumns, function (p){
                        returnValue.push(p);
                    });
                });
                return returnValue;
            },
            getAllCompressedGroups:function() {
                return _.map(this.staticDataExclusions, function(oneRecord){
                    var expansionPossible = (oneRecord.excludedColumns.length>0);
                    return {groupName:oneRecord.groupName,
                        expansionPossible:expansionPossible}
                });
            }


        };
    };

    SharedTableObject.prototype.assignDataToMatrix = function(rowIndex,
                                                              columnIndex,
                                                              numberOfColumns,
                                                              indexInOneDimensionalArray){
        var indexInOneDimensionalArray = (rowIndex*numberOfColumns)+columnIndex;
        this.matrix.dataArray[indexInOneDimensionalArray] = new SharedTableDataCell(    null ,
             null ,
             null ,
            indexInOneDimensionalArray,
             null
        );
        this.matrix.numberOfRows =  Math.floor(this.matrix.dataArray.length/this.matrix.numberOfColumns);
    };



    /***
     * Add the Ascension number to a day to cell in memory so that we can look it up later
     *
     * @param title
     * @param renderData
     * @param annotation
     * @param ascensionNumber
     * @param dataAnnotationTypeCode
     * @returns {*}
     * @constructor
     */
    var SharedTableDataCell = function (title,renderData,annotation, ascensionNumber, dataAnnotationTypeCode){
        renderData["ascensionNumber"] = ascensionNumber;
        return renderData;
    };

    /***
     *
     * @param name
     * @param renderData
     * @param annotation
     * @param dataAnnotationTypeCode
     * @returns {{dataAnnotationTypeCode: *, renderData: *, title: *, annotation: *}}
     * @constructor
     */
    var IntermediateStructureDataCell = function (name,renderData, annotation, dataAnnotationTypeCode){
        return {
            title: name,
            renderData:renderData,
            annotation:  annotation,
            dataAnnotationTypeCode:dataAnnotationTypeCode
        };
    };





    var getDatatypeInformation = function( dataTypeCode, baseDomElement) {
        var returnValue = {};
        const dataAnnotationTypes = getAccumulatorObject('dataAnnotationTypes',baseDomElement)
        var index = _.findIndex( dataAnnotationTypes, { 'code' : dataTypeCode } );
        if ( index === -1 ) {
            alert(' ERROR: fielding request for dataTypeCode='+dataTypeCode+', which does not exist.')
        } else {
            returnValue = { index: index,
                            dataAnnotation: dataAnnotationTypes[index] };
        }
        return returnValue;
    }



    var setCurrentSortRequest = function (incomingCurrentSortRequest) {
        currentSortRequest = incomingCurrentSortRequest;
    };

    var getCurrentSortRequest = function () {
        return currentSortRequest;
    };


    var actionDefaultFollowUp = function (actionId) {
        var defaultFollowUp = {
            displayRefinedContextFunction: undefined,
            placeToDisplayData: undefined,
            actionId: undefined
        };
        switch (actionId) {

            case "getTissuesFromProximityForLocusContext":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.geneHeaders.displayRefinedGenesInARange;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getFullFromEffectorGeneListTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.fullEffectorGeneTable.displayFullEffectorGeneTable;
                defaultFollowUp.placeToDisplayData = '#mainEffectorDiv div.mainEffectorDiv';
                break;

            case "getRecordsFromECaviarForGeneTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.eCaviar.displayGenesFromECaviar;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getRecordsFromColocForGeneTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.coloc.displayGenesFromColoc;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getAnnotationsFromModForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.mouseKnockout.displayRefinedModContext;
                defaultFollowUp.placeToDisplayData = '#dynamicPhenotypeHolder div.dynamicUiHolder';
                break;

            case "getGeneAssociationsForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.metaXcan.displayGenePhenotypeAssociations;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getSkatGeneAssociationsForGeneTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.geneBurdenSkat.displayGeneSkatAssociationsForGeneTable;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getFirthGeneAssociationsForGeneTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.geneBurdenFirth.displayGeneFirthAssociationsForGeneTable;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getInformationFromDepictForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.depictGenePvalue.displayGenesFromDepict;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getDepictGeneSetForGenesTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.depictGeneSets.displayGeneSetFromDepict;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getInformationFromDepictForTissueTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.depictTissues.displayTissueInformationFromDepict;
                defaultFollowUp.placeToDisplayData = '#mainTissueDiv table.tissueTableHolder';
                break;

            case "getInformationFromEffectorGeneListTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.effectorGene.displayGenesFromEffectorGene;
                defaultFollowUp.placeToDisplayData = '#dynamicGeneHolder div.dynamicUiHolder';
                break;

            case "getInformationFromGregorForTissueTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.gregorTissueTable.displayGregorDataForTissueTable;
                defaultFollowUp.placeToDisplayData = '#mainTissueDiv table.tissueTableHolder';
                break;

            case "getInformationFromLdsrForTissueTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.ldsrTissueTable.displayLdsrDataForTissueTable;
                defaultFollowUp.placeToDisplayData = '#mainTissueDiv table.tissueTableHolder';
                break;

            case "getVariantsWeWillUseToBuildTheVariantTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.variantTableHeaders.displayRefinedVariantsInARange;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;

            case "getABCGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.abcVariantTable.displayTissueInformationFromAbc;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "getCoaccessibilityGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.coaccessibilityVariantTable.displayTissueInformationFromCoaccess;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;

            case "getAtacseqGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.atacSeqVariantTable.displayTissueInformationFromDnase;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "getDnaseGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.dnaseVariantTable.displayTissueInformationFromDnase;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "getTfMotifGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.tfMotifVariantTable.displayTissueInformationFromTfMotif;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;

            case "getH3k27acGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.h3k27acVariantTable.displayTissueInformationFromH3k27ac;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "getChromStateGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.chromStateVariantTable.displayTissueInformationFromChromState;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "getTfbsGivenVariantList":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.tfbsVariantTable.displayTissueInformationFromTfbs;
                defaultFollowUp.placeToDisplayData = '#mainVariantDiv table.variantTableHolder';
                break;
            case "gregorSubTable":
                defaultFollowUp.displayRefinedContextFunction = mpgSoftware.dynamicUi.gregorSubTableVariantTable.displayGregorSubTable;
                defaultFollowUp.placeToDisplayData = '#gregorSubTableDiv table.gregorSubTable';
                break;
            default:
                break;
        }

        return defaultFollowUp;
    }




    var actionContainer = function (actionId, followUp, baseDomElement) {
        var additionalParameters = getAccumulatorObject(undefined,baseDomElement);
        var dataAnnotationType =_.find(additionalParameters.dataAnnotationTypes,{internalIdentifierString:actionId});
        var displayFunction = ( typeof followUp.displayRefinedContextFunction !== 'undefined') ? followUp.displayRefinedContextFunction : undefined;
        var displayLocation = ( typeof followUp.placeToDisplayData !== 'undefined') ? followUp.placeToDisplayData : undefined;
        var nextActionId = ( typeof followUp.actionId !== 'undefined') ? followUp.actionId : undefined;

        var functionToLaunchDataRetrieval;

        switch (actionId) {

            case "doesNotHaveAnIndependentFunction":
                functionToLaunchDataRetrieval = function () {}
                break;

            case "getInformationFromDepictForTissueTable":
                functionToLaunchDataRetrieval = function () {
                    var phenotype = getAccumulatorObject("preferredPhenotype", baseDomElement);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        retrieveDataUrl: additionalParameters.retrieveDepictTissueDataUrl,
                        dataForCall: {
                            phenotype: phenotype
                        },
                        processEachRecord: mpgSoftware.dynamicUi.depictTissues.processRecordsFromDepictTissues,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:'depictTissueArray',
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;



            case "getInformationFromGregorForTissueTable":
                functionToLaunchDataRetrieval = function () {
                    var phenotype = getAccumulatorObject("preferredPhenotype", baseDomElement);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        retrieveDataUrl: additionalParameters.retrieveGregorDataUrl,
                        dataForCall: {
                            phenotype: phenotype
                        },
                        processEachRecord: mpgSoftware.dynamicUi.gregorTissueTable.processGregorDataForTissueTable,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:'gregorTissueArray',
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;

            case "getInformationFromLdsrForTissueTable":
                functionToLaunchDataRetrieval = function () {
                    var phenotype = getAccumulatorObject("preferredPhenotype", baseDomElement);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        retrieveDataUrl: additionalParameters.retrieveLdsrDataUrl,
                        dataForCall: {
                            phenotype: phenotype
                        },
                        processEachRecord: mpgSoftware.dynamicUi.ldsrTissueTable.processLdsrDataForTissueTable,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:'ldsrTissueArray',
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;

            case "getTissuesFromProximityForLocusContext":
                functionToLaunchDataRetrieval = function () {
                    var chromosome = getAccumulatorObject("chromosome", baseDomElement);
                    var startPos = getAccumulatorObject("extentBegin", baseDomElement);
                    var endPos = getAccumulatorObject("extentEnd", baseDomElement);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: "getTissuesFromProximityForLocusContext",
                        retrieveDataUrl: additionalParameters.retrieveListOfGenesInARangeUrl,
                        dataForCall: {
                            chromosome: chromosome,
                            startPos: startPos,
                            endPos: endPos
                        },
                        processEachRecord: mpgSoftware.dynamicUi.geneHeaders.processRecordsFromProximitySearch,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:'geneInfoArray',
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;

            case "getFullFromEffectorGeneListTable":
                functionToLaunchDataRetrieval = function () {
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        retrieveDataUrl: additionalParameters.retrieveEffectorGeneInformationUrl,
                        dataForCall: {},
                        processEachRecord: mpgSoftware.dynamicUi.fullEffectorGeneTable.processRecordsFromFullEffectorGeneTable,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:'fullEffectorGeneTable',
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;

            case "getGeneAssociationsForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId:actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype,
                                propertyNames: "[\"P_VALUE\"]"
                            }
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveGeneLevelAssociationsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.metaXcan.processMetaXcanRecords,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawGeneAssociationRecords',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getSkatGeneAssociationsForGeneTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype,
                                propertyNames: "[\"P_VALUE\"]",
                                preferredSampleGroup: "ExSeq_52k"
                            }
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveGeneLevelAssociationsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.geneBurdenSkat.processGeneSkatAssociationRecords,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawGeneSkatRecords',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;


            case "getFirthGeneAssociationsForGeneTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId},
                            baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype,
                                propertyNames: "[\"P_VALUE\"]",
                                preferredSampleGroup: "ExSeq_52k"
                            }
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveGeneLevelAssociationsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.geneBurdenFirth.processGeneFirthAssociationRecords,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawGeneFirthRecords',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;


            case "getInformationFromEffectorGeneListTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                geneList: "[\""+o.name+"\"]",
                                phenotype: phenotype,
                                propertyNames: "[\"P_VALUE\"]"
                            }
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveEffectorGeneInformationUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.effectorGene.processRecordsFromEffectorGene,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawEffectorGeneRecords',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getRecordsFromECaviarForGeneTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var geneNameArray = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {gene: o.name,
                                phenotype:phenotype}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveECaviarDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: mpgSoftware.dynamicUi.eCaviar.processRecordsFromECaviar,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawColocalizationInfo',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getRecordsFromColocForGeneTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var geneNameArray = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {gene: o.name,
                                phenotype:phenotype}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveColocDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: mpgSoftware.dynamicUi.coloc.processRecordsFromColoc,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawColoInfo',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;


            case "getAnnotationsFromModForGenesTable":
                functionToLaunchDataRetrieval = function () {

                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var geneNameArray = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {gene: o.name}
                        });
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveModDataUrl,
                            dataForCall: geneNameArray,
                            processEachRecord: mpgSoftware.dynamicUi.mouseKnockout.processRecordsFromMod,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'modNameArray',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getVariantsWeWillUseToBuildTheVariantTable":
                functionToLaunchDataRetrieval = function () {

                    var phenotype = getAccumulatorObject("phenotype", baseDomElement);
                    var chromosome = getAccumulatorObject("chromosome", baseDomElement);
                    var startExtent = getAccumulatorObject("extentBegin", baseDomElement);//.replace(/,/g,""); // killing replace part to have it work with v2f
                    var endExtent = getAccumulatorObject("extentEnd", baseDomElement);//.replace(/,/g,""); // killing replace part to have it work with v2f
                    var sharedTable = getSharedTable(displayLocation, baseDomElement);
                    sharedTable['currentFormVariation'] = 2;

                    if (chromosome.startsWith("chr")){
                        chromosome =  chromosome.substring(3)
                    }
                    $('input#chromosomeInput').val(chromosome);
                    $('input#startExtentInput').val(startExtent);
                    $('input#endExtentInput').val(endExtent);
                    $('select.phenotypePicker').val(phenotype);
                    $('#annotationSelectorChoice').empty().multiselect('refresh');
                    $('#annotationSelectorChoice').multiselect('rebuild');

                    var dataNecessaryToRetrieveVariantsPerPhenotype;
                    if (( typeof phenotype === 'undefined') ||
                        (typeof chromosome === 'undefined') ||
                        (typeof startExtent === 'undefined') ||
                        (typeof endExtent === 'undefined')) {
                        alert(" missing a value when we want to collect variants for a phenotype");
                    } else {
                        dataNecessaryToRetrieveVariantsPerPhenotype = {
                            phenotype: phenotype,
                            geneToSummarize: "chr" + chromosome + ":" + startExtent + "-" + endExtent,
                            chromosome: chromosome,
                            startPos: startExtent,
                            start: startExtent,
                            endPos: endExtent,
                            end: endExtent,
                            gene:"",
                            dataSet:"",
                            dataType:"static",
                            propertyName:"POSTERIOR_PROBABILITY",
                            limit: "50",
                            findCredSetByOverlap: "1"
                        }

                    }


                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        //retrieveDataUrl: additionalParameters.getVariantsForRangeAjaxUrl,
                        //retrieveDataUrl: additionalParameters.retrieveTopVariantsAcrossSgsUrl,
                        //retrieveDataUrl: additionalParameters.retrieveOnlyTopVariantsAcrossSgsUrl,
                        retrieveDataUrl: additionalParameters.fillCredibleSetTableUrl,
                        dataForCall: dataNecessaryToRetrieveVariantsPerPhenotype,
                        processEachRecord: mpgSoftware.dynamicUi.variantTableHeaders.processRecordsFromProximitySearch,
                        displayRefinedContextFunction: displayFunction,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:dataAnnotationType.nameOfAccumulatorField,
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));

                };
                break;

            case "getABCGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length===0){return;}
                            var variantNameArray = _.map(dataVector, function(variantRec){return variantRec.var_id;});
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveAbcDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.abcVariantTable.processRecordsFromAbc,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:dataAnnotationType.nameOfAccumulatorField,
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;
            case "getCoaccessibilityGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";

                            var dataForCall = {variants: variantsAsJson, methodToRetrieve: 'cicero'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveAnyTypeRegionData,
                                dataForCall: dataForCall,
                                processEachRecord: mpgSoftware.dynamicUi.coaccessibilityVariantTable.processRecordsFromCoaccess,
                                displayRefinedContextFunction: displayFunction,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };
                break;
            case "getInformationFromDepictForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype
                            }
                        });

                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveDepictDataUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.depictGenePvalue.processRecordsFromDepictGenePvalue,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'rawDepictInfo',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getDepictGeneSetForGenesTable":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty("geneInfoArray", baseDomElement)) {
                        var actionToUndertake = actionContainer("getTissuesFromProximityForLocusContext",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var phenotype = $('li.chosenPhenotype').attr('id');
                        var dataForCall = _.map(getAccumulatorObject("geneInfoArray", baseDomElement), function (o) {
                            return {
                                gene: o.name,
                                phenotype: phenotype
                            }
                        });

                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveDepictGeneSetUrl,
                            dataForCall: dataForCall,
                            processEachRecord: mpgSoftware.dynamicUi.depictGeneSets.processRecordsFromDepictGeneSet,
                            displayRefinedContextFunction: displayFunction,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:'depictGeneSetInfo',
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
                        }));
                    }
                };
                break;

            case "getAtacseqGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
                            var dataForCall = {variants: variantsAsJson, method: 'MACS'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveVariantAnnotationsUrl,
                                dataForCall: dataForCall,
                                processEachRecord: dataAnnotationType.processEachRecord,
                                displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };
                break;

            case "getDnaseGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";

                            var dataForCall = {variants: variantsAsJson, annotationToRetrieve: 'DNASE'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveAnyTypeRegionData,
                                dataForCall: dataForCall,
                                processEachRecord: dataAnnotationType.processEachRecord,
                                displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };
                break;

            case "getTfMotifGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
                            var dataForCall = {variants: variantsAsJson, method: 'TFMOTIF'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveTfMotifUrl,
                                dataForCall: dataForCall,
                                processEachRecord: dataAnnotationType.processEachRecord,
                                displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };
                break;

            case "getTfbsGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
                            var dataForCall = {variants: variantsAsJson, method: 'SPP'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveVariantAnnotationsUrl,
                                dataForCall: dataForCall,
                                processEachRecord: dataAnnotationType.processEachRecord,
                                displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };
                break;

            case "gregorSubTable":
                functionToLaunchDataRetrieval = function () {
                    var phenotype = getAccumulatorObject("phenotype", baseDomElement);
                    destroySharedTable(displayLocation);
                    retrieveRemotedContextInformation(buildRemoteContextArray({
                        name: actionId,
                        retrieveDataUrl: additionalParameters.retrieveGregorDataUrl,
                        dataForCall: {
                            phenotype: phenotype
                        },
                        processEachRecord: dataAnnotationType.processEachRecord,
                        displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                        placeToDisplayData: displayLocation,
                        actionId: nextActionId,
                        nameOfAccumulatorField:dataAnnotationType.nameOfAccumulatorField,
                        code:dataAnnotationType.code,
                        nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                        baseDomElement:baseDomElement
                    }));
                };
                break;

            case "getH3k27acGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            if (dataVector.length === 0) {
                                return;
                            }
                            var variantNameArray = _.map(dataVector, function (variantRec) {
                                return variantRec.var_id;
                            });
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";

                            var dataForCall = {variants: variantsAsJson, annotationToRetrieve: 'H3K27AC'};
                            retrieveRemotedContextInformation(buildRemoteContextArray({
                                name: actionId,
                                retrieveDataUrl: additionalParameters.retrieveAnyTypeRegionData,
                                dataForCall: dataForCall,
                                processEachRecord: dataAnnotationType.processEachRecord,
                                displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                                placeToDisplayData: displayLocation,
                                actionId: nextActionId,
                                nameOfAccumulatorField: dataAnnotationType.nameOfAccumulatorField,
                                code: dataAnnotationType.code,
                                nameOfAccumulatorFieldWithIndex: dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                                baseDomElement:baseDomElement
                            }));
                        }
                    }
                };

                break;

            case "getChromStateGivenVariantList":
                functionToLaunchDataRetrieval = function () {
                    if (accumulatorObjectFieldEmpty(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)) {
                        var actionToUndertake = actionContainer("getVariantsWeWillUseToBuildTheVariantTable",
                            {actionId: actionId}, baseDomElement);
                        actionToUndertake();
                    } else {
                        var variantsAsJson = "[]";
                        if (getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement).length > 0) {
                            const dataVector = getAccumulatorObject(dataAnnotationType.nameOfAccumulatorFieldWithIndex, baseDomElement)[0].data;
                            var variantNameArray = _.map(dataVector, function(variantRec){return variantRec.var_id;});
                            variantsAsJson = "[\"" + variantNameArray.join("\",\"") + "\"]";
                        }
                        var dataForCall = {variants: variantsAsJson, method:'ChromHMM', limit:2000};
                        retrieveRemotedContextInformation(buildRemoteContextArray({
                            name: actionId,
                            retrieveDataUrl: additionalParameters.retrieveVariantAnnotationsUrl,
                            dataForCall: dataForCall,
                            processEachRecord: dataAnnotationType.processEachRecord,
                            displayRefinedContextFunction: dataAnnotationType.displayEverythingFromThisCall,
                            placeToDisplayData: displayLocation,
                            actionId: nextActionId,
                            nameOfAccumulatorField:dataAnnotationType.nameOfAccumulatorField,
                            code:dataAnnotationType.code,
                            nameOfAccumulatorFieldWithIndex:dataAnnotationType.nameOfAccumulatorFieldWithIndex,
                            baseDomElement:baseDomElement
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



    var addRowHolderToIntermediateDataStructure = function (dataAnnotationTypeCode,intermediateDataStructure,rowTag,baseDomElement){
        var displayDetails = getDatatypeInformation(dataAnnotationTypeCode, baseDomElement );
        intermediateDataStructure.rowsToAdd.push({
            code: displayDetails.dataAnnotation.code,
            category: displayDetails.dataAnnotation.category,
            displayCategory: displayDetails.dataAnnotation.displayCategory,
            subcategory: displayDetails.dataAnnotation.subcategory,
            displaySubcategory: displayDetails.dataAnnotation.displaySubcategory,
            columnCells: [],
            rowTag:rowTag
        });
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
     * retrieve the accumulator object, pulling back a specified field if requested
     * @param chosenField
     * @returns {jQuery}
     */
    var getAccumulatorObject = function (chosenField,nameOfBase) {
        var accumulatorObject = $(nameOfBase).data("dataHolder");
        var returnValue;
        if (typeof accumulatorObject === 'undefined') {
            alert('Fatal error.  Malfunction is imminent. Missing accumulator object.');
            return;
        }
        if (typeof chosenField !== 'undefined') {
            returnValue = accumulatorObject[chosenField];

            if (typeof returnValue === 'undefined') {
                // if someone requests a field that doesn't exist then as a default we can give them an array.  If we
                //  get a request for something that we recognize, we can also provide something more specific.
                switch (chosenField){ // we can provide defaults for some accumulator objects
                    case "currentSortRequest":
                        accumulatorObject[chosenField] = {
                            columnNumberValue: 1,
                            currentSort: "geneMethods",
                            sortOrder: "asc",
                            table: "table.combinedGeneTableHolder"
                        };
                        break;
                    default:
                        accumulatorObject[chosenField] = new Array();
                        break;
                }
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
    var setAccumulatorObject = function (specificField, value, baseDomElement) {
        if (typeof specificField === 'undefined') {
            alert("Serious error.  Attempted assignment of unspecified field.");
            return;
        }
        var accumulatorObject = getAccumulatorObject(undefined,baseDomElement);
        accumulatorObject[specificField] = value;
        return getAccumulatorObject(specificField,baseDomElement);
    };

    /***
     * Reset the chosen field in the accumulator object to its default value. If no field is specified then reset the entire
     * accumulator object to its default.
     */
    var resetAccumulatorObject = function (specificField, baseDomElement) {
        var additionalParameters = getAccumulatorObject(undefined,baseDomElement);
        var filledOutSharedAccumulatorObject = new AccumulatorObject(additionalParameters);
        if (typeof specificField !== 'undefined') {
            if (typeof filledOutSharedAccumulatorObject === 'undefined') {
                alert(" Unexpected absence of field '" + specificField + "' in shared accumulator object");
            }
            setAccumulatorObject(specificField, [], baseDomElement);
        } else {
            alert('initialization failure: null value of specificField in resetAccumulatorObject');
            // if ( typeof nameOfDomToStoreAccumulatorInformation === 'undefined'){
            //     alert(' initialization failure: the variable nameOfDomToStoreAccumulatorInformation needs to have a value');
            // } else {
            //     if ( typeof baseDomElement === 'undefined') {
            //         alert('initialization failure: null value of baseDomElement')
            //     } else {
            //         $(baseDomElement).data("dataHolder", filledOutSharedAccumulatorObject);
            //     }
            //
            // }

        }
    };
    var initializeAccumulatorObject = function (baseDomElement, dynamicUiVariables) {
        var filledOutSharedAccumulatorObject = new AccumulatorObject(dynamicUiVariables);
        if (typeof baseDomElement !== 'undefined') {
            if (typeof dynamicUiVariables === 'undefined') {
                alert(" Unexpected undefined value in dynamicUiVariables in initializeAccumulatorObject");
            } else {
                $(baseDomElement).data("dataHolder",filledOutSharedAccumulatorObject);
                //setAccumulatorObject('dynamicUiVariables', filledOutSharedAccumulatorObject, baseDomElement);
            }
        } else {
            alert('initialization failure: null value of baseDomElement in initializeAccumulatorObject');
        }
    };


    var addAdditionalResultsObject = function (returnObject, baseDomElement) {
        var resultsArray = getAccumulatorObject("resultsArray", baseDomElement);
        if (typeof resultsArray === 'undefined') {
            setAccumulatorObject("resultsArray", [], baseDomElement);
            resultsArray = getAccumulatorObject("resultsArray", baseDomElement);
        }
        resultsArray.push(returnObject);
    };


    var accumulatorObjectFieldEmpty = function (specificField, baseDomElement) {
        var returnValue = true;
        var accumulatorObjectField = getAccumulatorObject(specificField, baseDomElement);
        if (Array.isArray(accumulatorObjectField)) {
            if (accumulatorObjectField.length > 0) {
                returnValue = false;
            }
        }
        return returnValue;
    };
    var accumulatorObjectSubFieldEmpty = function (specificField,subField, baseDomElement) {
        var returnValue = true;
        var accumulatorObjectField = getAccumulatorObject(specificField, baseDomElement);
        if ( typeof subField === 'undefined'){
            alert("subfield record should not be empty. Data problem?")
        } else {

            if ((Array.isArray(accumulatorObjectField)) &&
                (accumulatorObjectField.length>0)){
                const singleElement = accumulatorObjectField[0];
                if (Array.isArray(singleElement[subField])) {
                    if (singleElement[subField].length > 0) {
                        returnValue = false;
                    }
                }

            }
        }
         return returnValue;
    };


    // convenience function for a very common retrieval
    const getSharedTable = function (idForTheTargetDiv, baseDomElement) {
        return getAccumulatorObject("sharedTable_"+idForTheTargetDiv, baseDomElement);
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
                                                baseDomElement,
                                                clearBeforeStarting,
                                                intermediateDataStructure,
                                                storeRecords,
                                                typeOfRecord,
                                                prependRecords,
                                                blankRowsAreAcceptable ) {
        if (clearBeforeStarting) {
            $(idForTheTargetDiv).empty();
        }

        if (typeof intermediateDataStructure !== 'undefined') {

            buildOrExtendDynamicTable(intermediateDataStructure.tableToUpdate,
                intermediateDataStructure,
                storeRecords,
                typeOfRecord,
                prependRecords,
                blankRowsAreAcceptable,
                baseDomElement);

        } else {

            alert('we never take this path anymore, right?');
            // $(idForTheTargetDiv).append(Mustache.render($(templateInfo)[0].innerHTML,
            //     returnObject
            // ));

        }


    }






    var retrieveExtents = function (geneName, defaultStart, defaultEnd) {
        alert('is retrieveExtents actually used anymore?');
        var returnValue = {regionStart: defaultStart, regionEnd: defaultEnd};
        var geneInfoArray = getAccumulatorObject("geneInfoArray");
        var geneInfoIndex = _.findIndex(geneInfoArray, {name: geneName});
        if (geneInfoIndex >= 0) {
            returnValue.regionStart = geneInfoArray[geneInfoIndex].startPos;
            returnValue.regionEnd = geneInfoArray[geneInfoIndex].endPos;
        }
        return returnValue
    }




    var buildRegionGraphic = function (placeForGraphic,placeForTooltip,divWithData) {
        // the user wants to drill down into the tissues. Let's make them a graphic using the data we stored above
        var dataMatrix =
            _.map($(divWithData).data("sourceByTissue"),
                function (v, k) {
                    var retVal = [];
                    _.forEach(v, function (oneRec) {
                        retVal.push(oneRec);
                    });
                    return retVal;
                }
            );
        var geneInfoArray = getAccumulatorObject("geneInfoArray",'#configurableUiTabStorage');
        var geneInfoIndex = _.findIndex(geneInfoArray, {name: $(divWithData).data("geneName")});
        var additionalParameters;
        if (geneInfoIndex < 0) {
            additionalParameters = {
                regionStart: _.minBy(_.flatMap($(divWithData).data("sourceByTissue")), 'START').START,
                regionEnd: _.maxBy(_.flatMap($(divWithData).data("sourceByTissue")), 'STOP').STOP,
                stateColorBy: ['Flanking TSS'],
                mappingInformation: _.map($(divWithData).data('allUniqueTissues'), function () {
                    return [1]
                })
            };
        } else {
            additionalParameters = {
                regionStart: geneInfoArray[geneInfoIndex].startPos,
                regionEnd: geneInfoArray[geneInfoIndex].endPos,
                stateColorBy: ['Flanking TSS'],
                mappingInformation: _.map($(divWithData).data('allUniqueTissues'), function () {
                    return [1]
                })
            };
        }

        //  here comes that D3 graphic!
        $(placeForTooltip).empty();
        $(placeForGraphic).empty();
        buildMultiTissueDisplay(['Flanking TSS'],
            _.map($(divWithData).data('allUniqueTissues'),'tissueName'),
            dataMatrix,
            additionalParameters,
            placeForTooltip,
            placeForGraphic);

    };












    var translateATissueName = function(tissueTranslations,tissueKey){
        var returnValue = tissueKey;
        if ( typeof  tissueTranslations !== 'undefined') {
            var translatedTissueName = tissueTranslations[tissueKey];
            if ( typeof  translatedTissueName !== 'undefined'){
                returnValue = translatedTissueName;
            }
        }
        return returnValue
    }



    var displayHeaderForGeneTable = function (idForTheTargetDiv, // which table are we adding to
                                              callingParameters,
                                        // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                        // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                        preferredSummaryKey, // we may wish to pull out one record for summary purposes
                                        mapSortAndFilterFunction,
                                        placeDataIntoRenderForm ) { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        const dataAnnotationTypeCode = callingParameters.code;
        const nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var objectContainingRetrievedRecords = getAccumulatorObject(nameOfAccumulatorField,callingParameters.baseDomElement);

        var intermediateDataStructure = new IntermediateDataStructure();

        if (typeof objectContainingRetrievedRecords !== 'undefined') {
            // set up the headers, and give us an empty row of column cells
            _.forEach(objectContainingRetrievedRecords, function (oneRecord,index) {
                intermediateDataStructure.headerNames.push(oneRecord.name);
                intermediateDataStructure.headerContents.push(Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, oneRecord));
                intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord.name,
                    Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, oneRecord),"geneHeader asc ",'LIT'));
            });

            intermediateDataStructure.tableToUpdate = "table.combinedGeneTableHolder";
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicGeneTable',
            callingParameters.baseDomElement,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders',
            true,
            false );
    };


    /***
     * This display function is trickier than the others for two reasons:
     *   1) we don't know the list of tissues we are seeking to display upfront.  Instead, we are
     *   adding new tissues each time we run a computational technique, and expanding the display to include them.
     *   2) we have this funky trick in which we update the list in response to changes made by
     *   the user interactively selecting which annotations we are going to use for Gregor data.
     *
     * @param idForTheTargetDiv
     * @param dataAnnotationTypeCode
     * @param nameOfAccumulatorField
     * @param insertAnyHeaderRecords
     * @param mapSortAndFilterFunction
     * @param placeDataIntoRenderForm
     * @param createSingleGregorCell
     */
    var displayTissueTable = function (idForTheTargetDiv, // which table are we adding to
                                                    callingParameters,
                                                    // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                                    // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                                    insertAnyHeaderRecords, // we may wish to pull out one record for summary purposes
                                                    mapSortAndFilterFunction,
                                                    placeDataIntoRenderForm,
                                                    createSingleGregorCell) { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        const dataAnnotationTypeCode = callingParameters.code;
        const nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        var displayAnnotationPicker = function(holderString,annotationPickerString,annotationArray){
            if (( typeof annotationArray !== 'undefined') &&
                (annotationArray.length > 0)){
                $(holderString).show();

                var annotationsToActivate = _.map(annotationArray, function (annotationName){
                    return {name:annotationName,
                            value:annotationName,
                            selected:false}
                });

                // First let's See if there is already a table, and if so what has been checked, since we'd like to try to retain those choices
                var selectedElements = $(annotationPickerString+' option:selected');
                var selectedValues = [];
                _.forEach(selectedElements,function(oe){
                    selectedValues.push($(oe).val());
                });
                if (selectedValues.length>0) {
                    // there were previous selections. Let's try to retain them
                    _.forEach(annotationsToActivate, function (oneRecord) {
                        oneRecord['selected'] = _.includes(selectedValues, oneRecord.value);
                    });
                }
                if ((selectedElements.length>0)||
                    (_.filter(annotationsToActivate,['selected',true]).length===0)){
                    // No selected elements exist in any existing list, OR the previous matching trick gave us no selections.  In either case
                    // let's provide a default and pick all the elements that contain the word 'enhancer'
                    _.forEach(annotationsToActivate,function(oneRecord){
                        oneRecord['selected'] = oneRecord.value.includes('nhancer');
                    });
                }
                var annotationArray = _.map(_.filter(annotationsToActivate,['selected',true]),function(o){return o.value});
                setAccumulatorObject('tissueTableChosenAnnotations', annotationArray, callingParameters.baseDomElement);  //save this for easy recall later

                // now for the UI work.  Wipe out anything in the multi-select, and fill it back up again
                $(annotationPickerString).empty();
                $(annotationPickerString).multiselect({includeSelectAllOption: false,
                    buttonWidth: '60%',onChange: function() {
                        console.log($('#annotationPicker').val());
                    }});
                _.forEach(_.orderBy(annotationsToActivate,['name'],['asc']), function(annotationToActivate) {
                    $(annotationPickerString).append($('<option>', {
                        value: annotationToActivate.value,
                        text : annotationToActivate.name ,
                     selected: annotationToActivate.selected}))
                });


                $('#annotationPicker').multiselect('rebuild');
            } else {
                $(holderString).hide();
            }
        };



        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var intermediateDataStructure = new IntermediateDataStructure();

        // for each gene collect up the data we want to display
        var incomingData = getAccumulatorObject(nameOfAccumulatorField,callingParameters.baseDomElement);

        // get the tissues that are already in place.  I'm planning to transpose this table before
        //  I display it
        var tissuesAlreadyInTheTable = getArrayOfRowHeaders(idForTheTargetDiv,callingParameters.baseDomElement);

        var returnObject={headers:[], content:[]};
        if (( typeof incomingData !== 'undefined') &&
            ( incomingData.length > 0)) {
            returnObject = incomingData[0];
        }
        var sortedHeaderObjects = [];

        if ( typeof returnObject.header.annotations !== 'undefined'){
            var filterModalContent = '<div id="filter_modal" style="display: none"><div class="closer-wrapper" style="text-align: center;">Filter GREGOR annotations\
                <span style="float:right; font-size: 12px; color: #888;" onclick="mpgSoftware.dynamicUi.displayAnnotationFilter(event,this);" class="glyphicon glyphicon-remove" aria-hidden="true"></span></div>\
                <div class="content-wrapper" style="width: auto; height:auto; width: 400px; min-height: 300px;">\
                <div class="annotationPickerHolder col-md-7" style="display: none">\
                <label for="annotationPicker">Add/remove annotations</label>\
                <select id="annotationPicker" class="annotationPicker"  multiple="multiple" \
                onchange="mpgSoftware.tissueTable.refreshTableForAnnotations(this)">\
                </select>\
                </div></div></div>';
            $("body").append(filterModalContent);
            var filterModalLeft = ($(window).width() - $("#filter_modal").width())/2;
            var filterModalTop = ($(window).height() - $("#filter_modal").height())/2;
            $("#filter_modal").css({"top":filterModalTop,"left":filterModalLeft});
            displayAnnotationPicker('div.annotationPickerHolder','#annotationPicker',returnObject.header.annotations);
        }


        var sharedTable = getAccumulatorObject("sharedTable_"+idForTheTargetDiv,callingParameters.baseDomElement);
        var rowsToInsert = [];
        var combinedSortedHeaders = [];
        if (sharedTable.numberOfColumns === 0) {
            if (returnObject.contents.length===0){
                return;
            }
            // we have no existing data that we need to merge. Set the number of columns to whatever we just processed
            sortedHeaderObjects = insertAnyHeaderRecords(returnObject,tissuesAlreadyInTheTable,dataAnnotationType,intermediateDataStructure,returnObject);
            intermediateDataStructure["headerNames"] = sortedHeaderObjects;
            sharedTable["numberOfColumns"] = sortedHeaderObjects.length+1;
            setAccumulatorObject("rememberHeadersInTissueTable", sortedHeaderObjects, callingParameters.baseDomElement);

        } else {
            if (returnObject.contents.length===0){
                return;  // we have no data to present. Abandon ship on adding this row
            }
            // we need to merge new data into the old data.  get our new data inputted in an array.
            if (( typeof returnObject.header !== 'undefined' ) &&
                ( typeof returnObject.header.tissues !== 'undefined' )) {
                sortedHeaderObjects = returnObject.header.tissues.sort();
            }

            combinedSortedHeaders = _.union(getAccumulatorObject("rememberHeadersInTissueTable",callingParameters.baseDomElement),sortedHeaderObjects).sort();
            // let's retrieve all of the old data from the table.
            var cellData;
            if (sharedTable.currentForm === 'tissueTableTissueHeaders'){
                cellData = retrieveSortedDataForTable(idForTheTargetDiv,callingParameters.baseDomElement);
            } else { // must be tissueTableMethodHeaders
                cellData = retrieveTransposedDataForThisTable(idForTheTargetDiv,callingParameters.baseDomElement);
            }
            var existingData =cellData;
            var numberOfRows = existingData.dataArray.length / existingData.numberOfColumns;
            var currentLocationInArray = existingData.numberOfColumns; // start at the end of the headers
            _.each(_.range(1,numberOfRows),function(index) { // start at 1, since the first rowhouse only headers
                rowsToInsert.push(_.slice(existingData.dataArray,
                    currentLocationInArray,
                    (currentLocationInArray+existingData.numberOfColumns)));
                currentLocationInArray += existingData.numberOfColumns;
                if (index===1){
                    mpgSoftware.dynamicUi.addRowHolderToIntermediateDataStructure(  dataAnnotationTypeCode,
                                                                                    intermediateDataStructure,
                                                                                    'noRowTag',
                                                                                    callingParameters.baseDomElement);
                }
            });
            // now we create a new headers, and then place them in the intermediate structure
            var initialLinearIndex = 1; // we are remaking the table, so start the count just past the row label
            intermediateDataStructure["headerNames"] = combinedSortedHeaders;
            setAccumulatorObject("rememberHeadersInTissueTable", combinedSortedHeaders, callingParameters.baseDomElement);
                returnObject.headers = _.map(intermediateDataStructure.headerNames, function(tissue){
                return Mustache.render($('#'+dataAnnotationType.dataAnnotation.headerWriter)[0].innerHTML,
                    {   tissueName: tissue,
                        initialLinearIndex:initialLinearIndex++
                    }
                )
            });

            _.forEach(returnObject.headers, function (oneRecord) {
                intermediateDataStructure.headers.push(new mpgSoftware.dynamicUi.IntermediateStructureDataCell(oneRecord,
                    oneRecord, "tissueHeader", 'LIT'));
            });
        }

        //  now proceed to process the data we received in this particular call.  We will add back in all of the old rows
        //  after we're done with this step
        if (intermediateDataStructure.headerNames.length > 0){
            // we may have fewer records than headers, so let's assign a blank record to every cell, and then we can fill in the ones we have data for
            _.each(_.range(0,intermediateDataStructure.headerNames.length),function(indexOfColumn) {
                intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(intermediateDataStructure.headerNames[indexOfColumn],
                    {initialLinearIndex:initialLinearIndex++}, "tissue specific",'EMC');
            });
            var objectsGroupedByTissue = _.groupBy(returnObject.contents,'tissue');
            _.forEach(objectsGroupedByTissue, function (recordsPerTissue, tissueName) {
                var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames, tissueName);
                if (indexOfColumn === -1) {
                    console.log("Did not find index of recordsPerTissue.tissue.  Shouldn't we?")
                } else {
                    var tissueTranslations = recordsPerTissue["TISSUE_TRANSLATIONS"];
                    var tissueRecords = mapSortAndFilterFunction (recordsPerTissue,tissueTranslations);
                    if ((tissueRecords.length === 0)) {
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(tissueName,
                            {}, "tissue specific",'EMC');
                    } else {
                         // if no translations are provided, it is fine to leave this value as undefined
                        var recordsCellPresentationString = Mustache.render($('#'+dataAnnotationType.dataAnnotation.numberRecordsCellPresentationStringWriter)[0].innerHTML, {
                            numberRecords:tissueRecords.length
                        });
                        var valuesForDisplay = createSingleGregorCell(recordsPerTissue,dataAnnotationType,
                            getAccumulatorObject('tissueTableChosenAnnotations',callingParameters.baseDomElement));
                        var renderData = placeDataIntoRenderForm(  valuesForDisplay.tissuesFilteredByAnnotation,
                            tissueRecords,
                            recordsCellPresentationString,
                            valuesForDisplay.significanceCellPresentationString,
                            dataAnnotationTypeCode,
                            valuesForDisplay.significanceValue,
                            tissueName );

                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(valuesForDisplay.significanceValue,
                            renderData,"tissue specific",dataAnnotationTypeCode );
                    }

                }
            });

            intermediateDataStructure.tableToUpdate = idForTheTargetDiv;
        }
        // now it is time two add any rows we had previously stored into the intermediate structure.  If we are going to
        //  add additional rows in this context we must delete the old table.
        if (rowsToInsert.length>0){
            destroySharedTable(idForTheTargetDiv);
            resetAccumulatorObject("sharedTable_"+idForTheTargetDiv,callingParameters.baseDomElement);
        }
        _.forEach(rowsToInsert,function(oneRow){

            var dataAnnotationTypeCode="";
            var rowsWithData = _.filter(oneRow,function(o){return (typeof o.renderData.dataAnnotationTypeCode !== 'undefined')});
            if (rowsWithData.length>0){
                dataAnnotationTypeCode = rowsWithData[0].renderData.dataAnnotationTypeCode;
            }
            addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                                                    intermediateDataStructure,
                                                    'noRowTag',
                                                    callingParameters.baseDomElement);

            // first initialize the row with blank cells
            var currentRow = intermediateDataStructure.rowsToAdd.length-1;
            _.each(_.range(0,intermediateDataStructure.headerNames.length),function(indexOfColumn) {
                intermediateDataStructure.rowsToAdd[currentRow].columnCells.push(new IntermediateStructureDataCell(intermediateDataStructure.headerNames[indexOfColumn],
                    {initialLinearIndex:initialLinearIndex++,tissueName:intermediateDataStructure.headerNames[indexOfColumn]}, "tissue specific",'EMC'));
            });
            _.forEach(oneRow, function(oneElement){
                switch(oneElement.dataAnnotationTypeCode){
                    case 'LIT':// these are row labels
                        // These are added by the buildHeader and addContent routines
                        break;
                    case 'EMC':// these are row labels
                        // These are empty cells, and what we have by default anyway
                        break;
                    default:
                        var indexOfColumn = _.findIndex(intermediateDataStructure.headerNames,function(o){ return o===oneElement.renderData.tissueName});
                        if (indexOfColumn === -1){
                            var errorMessage=( typeof oneElement.renderData.tissueName === 'undefined')?"unknown":oneElement.renderData.tissueName;
                            console.log('no index for '+errorMessage+'?')
                        } else if ( typeof oneElement.dataAnnotationTypeCode !== 'undefined'){
                            oneElement.renderData.initialLinearIndex = "initialLinearIndex_-1";  // Force a reset of the index
                            intermediateDataStructure.rowsToAdd[currentRow].columnCells[indexOfColumn] =
                                new IntermediateStructureDataCell(  oneElement.title,
                                    oneElement.renderData,
                                    oneElement.annotation,
                                    oneElement.dataAnnotationTypeCode);
                        }
                        break;

                }

            });
        });




        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#not used',
            callingParameters.baseDomElement,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'tissueTableTissueHeaders',
            true,
            false );

        transposeThisTable(idForTheTargetDiv,callingParameters.baseDomElement);

    };





    var displayForFullEffectorGeneTable = function (idForTheTargetDiv, // which table are we adding to
                                        callingParameters,
                                        // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                        // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                        insertAnyHeaderRecords, // we may wish to pull out one record for summary purposes
                                        mapSortAndFilterFunction,
                                        placeContentRowsIntoIntermediateObject ) { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        const nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        const dataAnnotationTypeCode = callingParameters.code;
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var intermediateDataStructure = new IntermediateDataStructure();
        var additionalParameters = getAccumulatorObject(undefined, callingParameters.baseDomElement);
        // for each gene collect up the data we want to display
        var incomingData = getAccumulatorObject(nameOfAccumulatorField, callingParameters.baseDomElement);
        var returnObject={headers:[], content:{}};
        if (( typeof incomingData !== 'undefined') &&
            ( incomingData.length > 0)) {
             returnObject = incomingData[0];
        }
        var sortedHeaderObjects = insertAnyHeaderRecords(incomingData,dataAnnotationType,intermediateDataStructure,returnObject,callingParameters.baseDomElement);
        var initialLinearIndex = sortedHeaderObjects.length;

        if (returnObject.headers.length > 0){
            placeContentRowsIntoIntermediateObject(returnObject,dataAnnotationType,intermediateDataStructure,initialLinearIndex,callingParameters.baseDomElement);
            intermediateDataStructure.tableToUpdate = additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory;
        }

        // Set the default exclusions.  We need to do this because we have to find every column in the table, but we don't want
        // to display every column.  Instead we exclude some of them unless a user specifically requests that a column be expanded.

        // var sharedTable = new SharedTableObject( 'fegtAnnotationHeaders',sortedHeaderObjects.length,0);
        //setAccumulatorObject("sharedTable_"+additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,sharedTable);
        //var sharedTable = getSharedTable(idForTheTargetDiv);
        var sharedTable = getSharedTable(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
            callingParameters.baseDomElement);
        sharedTable.numberOfColumns = sortedHeaderObjects.length;
        var deleter = {};
        _.forEach(sortedHeaderObjects, function (o,index){
            if (o.withinGroupNum === 0){
                if (!$.isEmptyObject(deleter)){
                    sharedTable.addColumnExclusionGroup(deleter.groupNumber,deleter.groupName,deleter.columnIndexes);
                }
                deleter['groupNumber'] = o.groupNum;
                deleter['groupName'] = o.groupKey;
                deleter['columnIndexes'] = [];
            } else {
                deleter.columnIndexes.push(index);
            }
        });
        if (!$.isEmptyObject(deleter)){
            sharedTable.addColumnExclusionGroup(deleter.groupNumber,deleter.groupName,deleter.columnIndexes);
        }

        prepareToPresentToTheScreen(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
            '#dynamicAbcGeneTable',
            callingParameters.baseDomElement,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'fegtAnnotationHeaders',
            false,
            false );



    };







    var displayForGeneTable = function (idForTheTargetDiv, // which table are we adding to
                                        callingParameters,
                                        // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                        // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                        preferredSummaryKey, // we may wish to pull out one record for summary purposes
                                        mapSortAndFilterFunction,
                                        placeDataIntoRenderForm ) { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        const dataAnnotationTypeCode = callingParameters.code;
        const nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode, callingParameters.baseDomElement);
        var returnObject = createNewDisplayReturnObject();
        var intermediateDataStructure = new IntermediateDataStructure();

        // for each gene collect up the data we want to display
        returnObject.geneAssociations = getAccumulatorObject(nameOfAccumulatorField, callingParameters.baseDomElement);

        // do we have any data at all?  If we do, then make a row
        if (( typeof returnObject.geneAssociations !== 'undefined') && ( returnObject.geneAssociations.length > 0)) {
            addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                                                    intermediateDataStructure,
                                                    'noRowTag',
                                                    callingParameters.baseDomElement);

            // set up the headers, even though we know we won't use them. Is this step necessary?
            var headerNames = [];
            if (accumulatorObjectFieldEmpty("geneInfoArray",callingParameters.baseDomElement)) {
                console.log("We always have to have a record of the current gene names in depict display. We have a problem.");
            } else {
                headerNames  = _.map(getAccumulatorObject("geneInfoArray", callingParameters.baseDomElement),'name');
                _.forEach(getAccumulatorObject("geneInfoArray", callingParameters.baseDomElement), function (oneRecord) {
                    intermediateDataStructure.rowsToAdd[0].columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                        {},"header",'EMC'));
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
                            {}, "tissue specific",'EMC');
                    } else {
                        var tissueTranslations = recordsPerGene["TISSUE_TRANSLATIONS"]; // if no translations are provided, it is fine to leave this value as undefined
                        var tissueRecords = mapSortAndFilterFunction (recordsPerGene.tissues,tissueTranslations);

                        var recordsCellPresentationString = Mustache.render($('#'+dataAnnotationType.dataAnnotation.numberRecordsCellPresentationStringWriter)[0].innerHTML, {
                            numberRecords:tissueRecords.length
                        });
                        var significanceCellPresentationString = "0";
                        var significanceValue = 0;
                        if (( typeof tissueRecords !== 'undefined')&&
                            (tissueRecords.length>0)){
                            var mostSignificantRecord;
                            if (( typeof preferredSummaryKey !== 'undefined') && (preferredSummaryKey.length>0)){ // we have a key telling us which record to pick
                                mostSignificantRecord=_.find(tissueRecords,function(t){return t.tissue.includes(preferredSummaryKey)});
                            }else{// no specific key, but we have sorted the keys in ascending order by value, so we can just pick the first one
                                mostSignificantRecord=tissueRecords[0];
                             }
                            significanceValue = mostSignificantRecord.value;
                            significanceCellPresentationString = Mustache.render($('#'+dataAnnotationType.dataAnnotation.significanceCellPresentationStringWriter)[0].innerHTML,
                                {significanceValue:significanceValue,
                                    significanceValueAsString:UTILS.realNumberFormatter(""+significanceValue),
                                    recordDescription:translateATissueName(tissueTranslations,mostSignificantRecord.tissue),
                                    numberRecords:tissueRecords.length});

                        }
                        //  this is the information we carry around each cell and that we will later use to display it
                        var renderData = placeDataIntoRenderForm(   tissueRecords,
                                                                    recordsCellPresentationString,
                                                                    significanceCellPresentationString,
                                                                    dataAnnotationTypeCode,
                                                                    significanceValue,
                                                                    recordsPerGene.gene );
                        recordsPerGene["numberOfRecords"] = recordsPerGene.tissues.length;//not sure if this is used
                        intermediateDataStructure.rowsToAdd[0].columnCells[indexOfColumn] = new IntermediateStructureDataCell(recordsPerGene.gene,
                            renderData,"tissue specific",dataAnnotationTypeCode );
                    }

                }
            });
            intermediateDataStructure.tableToUpdate = idForTheTargetDiv;
        }


        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicAbcGeneTable',
            callingParameters.baseDomElement,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'geneTableGeneHeaders',
            true,
            false );



    };


    /***
     *  Create and display one or more rows for the variant table.  'Methods' with multiple 'annotations'
     *  will lead to multiple rows, that can then be displayed directly in a variant x annotation grid.
     *  Additionally, build a variant x tissue data structure ( in an IntermediateDataStructure ), and
     *  we can display it later if someone wants to see it.  Even though we will have only one
     *  IntermediateDataStructure to hold all the tissues, store it in an array.  Meanwhile, we
     *  will also store the multiple IntermediateDataStructure's to hold each of the 'method', so that
     *  we can re-create
     *
     * @param idForTheTargetDiv
     * @param dataAnnotationTypeCode
     * @param nameOfAccumulatorField
     * @param nameOfAccumulatorFieldWithIndex
     * @param mapSortAndFilterFunction
     * @param placeDataIntoRenderForm
     */
    var displayForVariantTable = function ( idForTheTargetDiv, // which table are we adding to
                                            callingParameters,
                                            mapSortAndFilterFunction,
                                            variantTableAnnotationDominant,
                                            variantTableTissueDominant) { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        let dataAnnotationTypeCode = callingParameters.code;
        let nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        let nameOfAccumulatorFieldWithIndex = callingParameters.nameOfAccumulatorFieldWithIndex;
        let baseDomElement = callingParameters.baseDomElement;
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var intermediateDataStructure = new IntermediateDataStructure();
        var sharedTable = getSharedTable(idForTheTargetDiv,baseDomElement);
        var arrayOfDataToDisplay = getAccumulatorObject(nameOfAccumulatorField,baseDomElement);
        let prepend = true;
        console.log("displayForVariantTable:dataAnnotationTypeCode="+dataAnnotationTypeCode+".");




        // do we have any data at all?  If we do, then make a row
        let dataVector;
        let accumulatorFieldWithIndex;
        if (( typeof arrayOfDataToDisplay !== 'undefined') &&
            ( arrayOfDataToDisplay.length > 0) ) {
            // set up the headers, even though we know we won't use them. Is this step necessary?
            var headerNames = [];
            if (accumulatorObjectSubFieldEmpty(dataAnnotationType.dataAnnotation.nameOfAccumulatorFieldWithIndex,
                "data",
                baseDomElement)) {
                console.log("We should have a list of variants, otherwise we shouldn't be here. We have a problem.");
            } else {
                accumulatorFieldWithIndex = getAccumulatorObject(dataAnnotationType.dataAnnotation.nameOfAccumulatorFieldWithIndex,
                    baseDomElement);
                // Here are the two additional accumulators if they don't exist already
                // one for the variant x tissue display
                if (typeof accumulatorFieldWithIndex[0].header['tissueDisplay'] === 'undefined') {
                    accumulatorFieldWithIndex[0].header['tissueDisplay'] = new IntermediateDataStructure();
                }
                // and one for the variant x annotation display
                if (typeof accumulatorFieldWithIndex[0].header['annotationDisplay'] === 'undefined') {
                    accumulatorFieldWithIndex[0].header['annotationDisplay'] = new IntermediateDataStructure();
                }
                dataVector = accumulatorFieldWithIndex[0].data;
                headerNames = _.map(dataVector, function(o){
                    return o['name'].split(",")[0];
                });

            }


            // Create a grid of data cells with one annotation per row.  Sometimes we have more than one annotation per method,
            //  in which case this section might generate multiple rows.  Whatever happens, however, we add our rose to the bottom of the grid.
            var numberOfExistingRows = $(idForTheTargetDiv).dataTable().DataTable().rows()[0].length + 1;
            var numberOfColumns = sharedTable.numberOfColumns;
            if (typeof arrayOfDataToDisplay[0].data.groupByAnnotation !== 'undefined') {
                prepend = false;
                const currentMethod = arrayOfDataToDisplay[0].data.currentMethod;
                const currentAnnotation = arrayOfDataToDisplay[0].data.currentAnnotation[0];
                let annotationOptions = [];
                let tissueOptions = [];
                let addedRows = 0;
                // create a row for each epigenetic annotation even if it's empty
                if (arrayOfDataToDisplay[0].data.groupByAnnotation.length === 0) {
                    addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                                                            intermediateDataStructure,
                                                            'noRowTag',
                                                            callingParameters.baseDomElement );
                    let rowWeAreAddingTo = _.last(intermediateDataStructure.rowsToAdd);
                    rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(currentMethod,
                        Mustache.render($('#' + dataAnnotationType.dataAnnotation.drillDownCategoryWriter)[0].innerHTML,
                            {indexInOneDimensionalArray: ((numberOfExistingRows + addedRows) * numberOfColumns)}),
                        dataAnnotationType.dataAnnotation.subcategory + " header", 'LIT'));
                    rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(currentMethod,
                        Mustache.render($('#' + dataAnnotationType.dataAnnotation.drillDownSubCategoryWriter)[0].innerHTML,
                            {
                                methodName: currentMethod,
                                annotationName: currentAnnotation,
                                indexInOneDimensionalArray: (((numberOfExistingRows + addedRows) * numberOfColumns) + 1),
                                isBlank: "isBlank"
                            }),
                        dataAnnotationType.dataAnnotation.subcategory + " header", 'LIT'));
                    _.forEach(dataVector, function (oneRecord) {
                        rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                            {otherClasses: "methodName_" + currentMethod+" annotationName_"+currentAnnotation},
                            "header", 'EMP'));
                    });

                } else { // we have real data
                    _.forEach(arrayOfDataToDisplay[0].data.groupByAnnotation, function (recordsForAnnotation) {
                        annotationOptions.push({
                            name: recordsForAnnotation.name,
                            value: recordsForAnnotation.name + "_" + currentMethod
                        });
                        const annotation = recordsForAnnotation.name;
                        addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                                                                intermediateDataStructure,
                                                                'noRowTag',
                                                                callingParameters.baseDomElement );
                        let rowWeAreAddingTo = _.last(intermediateDataStructure.rowsToAdd);
                        rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(annotation,
                            Mustache.render($('#' + dataAnnotationType.dataAnnotation.drillDownCategoryWriter)[0].innerHTML,
                                {indexInOneDimensionalArray: ((numberOfExistingRows + addedRows) * numberOfColumns)}),
                            dataAnnotationType.dataAnnotation.subcategory + " header", 'LIT'));
                        let alternateAnnotation = annotation;
                        switch (annotation) {
                            case "MACS":
                                alternateAnnotation = "AccessibleChromatin"
                                break;
                            default:
                                break;
                        }
                        let isBlank = "";
                        if ((typeof recordsForAnnotation.arrayOfRecords === 'undefined') ||
                            (recordsForAnnotation.arrayOfRecords.length === 0)) {
                            isBlank = "isBlank";
                        }
                        rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(annotation,
                            Mustache.render($('#' + dataAnnotationType.dataAnnotation.drillDownSubCategoryWriter)[0].innerHTML,
                                {
                                    methodName: currentMethod,
                                    annotationName: alternateAnnotation,
                                    indexInOneDimensionalArray: (((numberOfExistingRows + addedRows) * numberOfColumns) + 1),
                                    isBlank: isBlank
                                }),
                            dataAnnotationType.dataAnnotation.subcategory, 'LIT'));
                        _.forEach(dataVector, function (oneRecord) {
                            rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                                {otherClasses: "methodName_" + currentMethod + " annotationName_" + annotation}, "discoDownAndCheckOutTheShow", 'EMP'));
                        });
                        // fill in all of the column cells
                        _.forEach(recordsForAnnotation.arrayOfRecords, function (oneRecord) {
                            var indexOfColumn = _.indexOf(headerNames, oneRecord.name);
                            if (indexOfColumn === -1) {
                                console.log("Did not find index of epigenetic var_id==" + oneRecord.name + ".  Shouldn't we?")
                            } else {
                                var renderData = variantTableAnnotationDominant(oneRecord.arrayOfRecords,
                                    "", "",
                                    dataAnnotationTypeCode,
                                    0.5,
                                    oneRecord.name);
                                _.last(intermediateDataStructure.rowsToAdd).columnCells[indexOfColumn + 2] = new IntermediateStructureDataCell(oneRecord.name,
                                    renderData, "tissue specific", dataAnnotationTypeCode);

                            }
                        });
                        addedRows++;
                    });
                }

                // create a grid of cells in which we have one row for each tissue.  This is a little trickier then adding rows on a per annotation basis,
                //  since we will sometimes come across records that need to be added to a tissue for which we've already created a row.
                const tissueIntermediateDataStructure = accumulatorFieldWithIndex[0].header['tissueDisplay'];
                numberOfExistingRows = tissueIntermediateDataStructure.rowsToAdd.length+6;
                addedRows = 0;
                if (arrayOfDataToDisplay[0].data.groupByTissue.length > 0) {
                    { // we have data.  Step through each tissue.
                        _.forEach(arrayOfDataToDisplay[0].data.groupByTissue, function (recordsForTissue) {
                            tissueOptions.push({
                                name: recordsForTissue.name,
                                value: recordsForTissue.safeTissueId
                            });
                            const tissueName = recordsForTissue.name;
                            const tissue_name = recordsForTissue.tissue_name;
                            const safeTissueId = recordsForTissue.safeTissueId;


                            // Either retrieve an existing row for this tissue, or else create a new one

                            let rowWeAreAddingTo = _.find(tissueIntermediateDataStructure.rowsToAdd, {'rowTag': tissueName});
                            if (typeof rowWeAreAddingTo === 'undefined') { // we have never seen this tissue before. Add a new row.
                                addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                                                                        tissueIntermediateDataStructure,
                                                                        tissueName,
                                                                        callingParameters.baseDomElement );
                                rowWeAreAddingTo = _.last(tissueIntermediateDataStructure.rowsToAdd);
                                rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(tissueName,
                                    Mustache.render($('#' + dataAnnotationType.dataAnnotation.tissueCategoryWriter)[0].innerHTML
                                                ,{indexInOneDimensionalArray:""}
                                        ),
                                    dataAnnotationType.dataAnnotation.subcategory + " header", 'LIT'));

                                //headerNames = _.map(dataVector, 'name');

                                let isBlank = "";
                                if ((typeof recordsForTissue.arrayOfRecords === 'undefined') ||
                                    (recordsForTissue.arrayOfRecords.length === 0)) {
                                    isBlank = "isBlank";
                                }
                                rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(tissueName,
                                    Mustache.render($('#' + dataAnnotationType.dataAnnotation.tissueSubCategoryWriter)[0].innerHTML,
                                        {
                                            tissueName: tissueName,
                                            method: currentMethod,
                                            annotation: currentAnnotation,
                                            indexInOneDimensionalArray: '',
                                            //indexInOneDimensionalArray: (((numberOfExistingRows + addedRows) * numberOfColumns) + 1),
                                            isBlank: isBlank,
                                            tissue_name: tissue_name,
                                            safeTissueId: safeTissueId
                                        }),
                                    dataAnnotationType.dataAnnotation.subcategory, 'LIT'));
                                _.forEach(dataVector, function (oneRecord) {
                                    rowWeAreAddingTo.columnCells.push(new IntermediateStructureDataCell(oneRecord.name,
                                        {otherClasses: "methodName_" + currentMethod + " annotationName_" + currentAnnotation+"  tissueId_"+safeTissueId}, "emptyRecord", 'EMP'));
                                });
                            } else {
                                console.log("We recognize this row")
                            }
                            // fill in all of the column cells
                            if (recordsForTissue.arrayOfRecords.length>dataVector.length+2){
                                console.log("recordsForTissue.arrayOfRecords.length="+recordsForTissue.arrayOfRecords.length+".")
                            }
                            _.forEach(recordsForTissue.arrayOfRecords, function (oneRecord) {
                                var indexOfColumn = _.indexOf(headerNames, oneRecord.name);
                                if (indexOfColumn === -1) {
                                    console.log("Did not find index of tissue epigenetic var_id===" + oneRecord.name + ".  Shouldn't we?")
                                } else {
                                    const specificMethod = oneRecord.method;
                                    const specificAnnotation = oneRecord.annotation;
                                    const existingCell = rowWeAreAddingTo.columnCells[indexOfColumn + 2];
                                    const renderData = variantTableTissueDominant( oneRecord,
                                        specificMethod, specificAnnotation,
                                        safeTissueId, existingCell,
                                        dataAnnotationTypeCode,
                                        0.5,
                                        oneRecord.name);
                                    rowWeAreAddingTo.columnCells[indexOfColumn + 2] = new IntermediateStructureDataCell(oneRecord.name,
                                        renderData, "tissue specific", dataAnnotationTypeCode);

                                }
                                if (rowWeAreAddingTo.columnCells.length>dataVector.length+2){
                                    console.log("rowWeAreAddingTo.columnCells.length="+rowWeAreAddingTo.columnCells.length+".")
                                }
                            });

                            addedRows++;
                        });
                    }

                    mpgSoftware.variantTable.fillAnnotationDropDownBox("#annotationSelectorChoice");
                    //mpgSoftware.variantTable.updateAnnotationDropDownBox(currentMethod, annotationOptions);

                }

                intermediateDataStructure.tableToUpdate = idForTheTargetDiv;
            }
        }

        const annotationDisplayArray = getAccumulatorObject("annotationDisplayArray",baseDomElement);
        annotationDisplayArray.push(intermediateDataStructure);
        prepareToPresentToTheScreen("#dynamicGeneHolder div.dynamicUiHolder",
            '#dynamicAbcGeneTable',
            baseDomElement, // unused
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'variantTableVariantHeaders',
            prepend,
            true );


    };





    var displayGregorSubTableForVariantTable = function (idForTheTargetDiv, // which table are we adding to
                                                 // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                                 // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                                 callingParameters,
                                                 placeDataIntoRenderForm )
    { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        let dataAnnotationTypeCode = callingParameters.code; // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
        let nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        let baseDomElement = callingParameters.baseDomElement;
        const chosenHeaderField = 'bestAnnotationAndMethods';
        const headerRecordField = 'annotationAndMethod';
        const chosenRowField = 'bestTissues';
        const rowRecordField = 'tissue';
        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var objectContainingRetrievedRecords = getAccumulatorObject(nameOfAccumulatorField,callingParameters.baseDomElement);

        var intermediateDataStructure = new IntermediateDataStructure();
        let vectorOfHeadersToUse = [];

        if ((typeof objectContainingRetrievedRecords !== 'undefined')||
            ( objectContainingRetrievedRecords.length > 0)
            (typeof objectContainingRetrievedRecords[0].header !== 'undefined')){

            // start with a blank, since the first column will label tissues
            intermediateDataStructure.headerNames.push('');
            intermediateDataStructure.headers.push(new IntermediateStructureDataCell('blank',
                Mustache.render($('#'+dataAnnotationType.dataAnnotation.headerWriter)[0].innerHTML, {}),"asc ",'LIT'));
            // set up the headers, and give us an empty row of column cells
            vectorOfHeadersToUse = objectContainingRetrievedRecords[0].header[chosenHeaderField];
            _.forEach(vectorOfHeadersToUse, function (oneRecord,index) {
                intermediateDataStructure.headerNames.push(oneRecord[headerRecordField]);
               // intermediateDataStructure.headerContents.push(Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, oneRecord));
                intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord[headerRecordField],
                    Mustache.render($('#'+dataAnnotationType.dataAnnotation.headerWriter)[0].innerHTML, oneRecord),"asc ",'LIT'));
            });

            intermediateDataStructure.tableToUpdate = idForTheTargetDiv;
            let numberOfColumns = vectorOfHeadersToUse.length+1;

            let vectorOfRowsToUse = objectContainingRetrievedRecords[0].header[chosenRowField];
            _.forEach(vectorOfRowsToUse, function (rowTitle,index) {

                addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,
                    intermediateDataStructure,
                    'noRowTag',
                    callingParameters.baseDomElement );
                _.last(intermediateDataStructure.rowsToAdd).columnCells = _.map(_.range(0,numberOfColumns),function( index)
                                                                                    {
                                                                                        if (index === 0){
                                                                                            return new IntermediateStructureDataCell(rowTitle[rowRecordField],
                                                                                                Mustache.render($('#'+dataAnnotationType.dataAnnotation.categoryWriter)[0].innerHTML, rowTitle),"asc ",'LIT')
                                                                                        }else{
                                                                                            return new IntermediateStructureDataCell('farLeftCorner',{},'emptyGregorSubTableCell','EMP')
                                                                                        }

                                                                                    });
                // fill in all of the column cells
                _.forEach(objectContainingRetrievedRecords[0].data[rowTitle.tissue], function (oneRecord) {
                    var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames, oneRecord[headerRecordField]);
                    if (indexOfColumn === -1) {
                        console.log("Did not find index of header.  Shouldn't we?")
                    } else if (rowTitle[rowRecordField] ===  oneRecord[rowRecordField]) {
                        var renderData = oneRecord;
                        renderData['prettyPValue']= UTILS.realNumberFormatter(""+oneRecord.p_value);
                        renderData['prettyFEValue']= UTILS.realNumberFormatter(""+oneRecord.fe_value);
                        _.last(intermediateDataStructure.rowsToAdd).columnCells[indexOfColumn] = new IntermediateStructureDataCell([headerRecordField],
                            renderData,'gregorSubTableCell',dataAnnotationTypeCode );

                    }
                });
            });

        }


        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#notUsed',
            baseDomElement,
            true,
            intermediateDataStructure,
            false,
            'gregorSubTable',
            false,
            true ); // we want to display blank rows in this case, since they are informative
    };










    var displayHeaderForVariantTable = function (idForTheTargetDiv, // which table are we adding to
                                                 callingParameters,
                                                 // dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                                                 // nameOfAccumulatorField, // name of the persistent field where the data we received is stored
                                                 placeDataIntoRenderForm )
    { // sort and filter the records we will use.  Resulting array must have fields tissue, value, and numericalValue
        deferredObject.resolve();
        let dataAnnotationTypeCode = callingParameters.code; // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
        let nameOfAccumulatorField = callingParameters.nameOfAccumulatorField;
        let baseDomElement = callingParameters.baseDomElement;

        var selectorForIidForTheTargetDiv = idForTheTargetDiv;
        $(selectorForIidForTheTargetDiv).empty();
        var dataAnnotationType= getDatatypeInformation(dataAnnotationTypeCode,callingParameters.baseDomElement);
        var objectContainingRetrievedRecords = getAccumulatorObject(nameOfAccumulatorField,callingParameters.baseDomElement);
        console.log("displayHeaderForVariantTable:"+dataAnnotationTypeCode+".");
        var intermediateDataStructure = new IntermediateDataStructure();
        let vectorOfVariantRecords = [];

        if ((typeof objectContainingRetrievedRecords !== 'undefined')||
            ( objectContainingRetrievedRecords.length > 0)
            (typeof objectContainingRetrievedRecords[0].data !== 'undefined')){
            // set up the headers, and give us an empty row of column cells
            vectorOfVariantRecords = objectContainingRetrievedRecords[0].data;
            if (vectorOfVariantRecords.length===0) { return; }
            _.forEach(vectorOfVariantRecords, function (oneRecord,index) {
                intermediateDataStructure.headerNames.push(oneRecord.var_id);
                intermediateDataStructure.headerContents.push(Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, oneRecord));
                intermediateDataStructure.headers.push(new IntermediateStructureDataCell(oneRecord.name,
                    Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, oneRecord),"asc ",'LIT'));
            });

            intermediateDataStructure.tableToUpdate = idForTheTargetDiv;
            var sharedTable = getSharedTable(idForTheTargetDiv,callingParameters.baseDomElement);
            sharedTable["numberOfColumns"] = vectorOfVariantRecords.length+2;


            const rowTypesToAdd = ["VAR_CODING","VAR_SPLICE","VAR_UTR","VAR_PVALUE","VAR_POSTERIORPVALUE"];
            _.forEach(rowTypesToAdd, function (rowTypeToAdd, rowIndex) {
                addRowHolderToIntermediateDataStructure(rowTypeToAdd,
                                                        intermediateDataStructure,
                                                        'noRowTag',
                                                        callingParameters.baseDomElement );
                // fill in all of the column cells
                _.forEach(vectorOfVariantRecords, function (oneRecord) {
                    var indexOfColumn = _.indexOf(intermediateDataStructure.headerNames, oneRecord.name);
                    if (indexOfColumn === -1) {
                        console.log("Did not find index of ABC var_id.  Shouldn't we?")
                    } else {
                        let emphasisSwitch = "false";
                        let pValue = 0.0;
                        let posteriorPValue = 0.0;
                        switch(rowTypeToAdd){
                            case "VAR_CODING":
                                if ((oneRecord.most_del_score>0)&&
                                    (oneRecord.most_del_score<4)){
                                    emphasisSwitch = "true";
                                }
                                break;
                            case "VAR_SPLICE":
                                if ( typeof oneRecord.consequence !== 'undefined'){
                                    if (($.isArray(oneRecord.consequence) &&
                                        (oneRecord.consequence.join(",").indexOf('splice')>-1))){
                                        emphasisSwitch = "true";
                                    } else  if (oneRecord.consequence.indexOf('splice')>-1){
                                        emphasisSwitch = "true";
                                    }
                                }
                                // if (( typeof oneRecord.consequence !== 'undefined')&&(oneRecord.consequence.join(",").indexOf('splice')>-1)){
                                //     emphasisSwitch = "true";
                                // }
                                break;
                            case "VAR_UTR":
                                if ( typeof oneRecord.consequence !== 'undefined'){
                                    if (($.isArray(oneRecord.consequence) &&
                                        (oneRecord.consequence.join(",").indexOf('UTR')>-1))){
                                        emphasisSwitch = "true";
                                    } else  if (oneRecord.consequence.indexOf('UTR')>-1){
                                        emphasisSwitch = "true";
                                    }
                                }
                                // if (( typeof oneRecord.consequence !== 'undefined')&&(oneRecord.consequence.join(",").indexOf('UTR')>-1)){
                                //     emphasisSwitch = "true";
                                // }
                                break;
                            case "VAR_PVALUE":
                                if ( typeof oneRecord.p_value !== 'undefined'){
                                    pValue = oneRecord.p_value;
                                }
                                break;
                            case "VAR_POSTERIORPVALUE":
                                // if ( typeof oneRecord.POSTERIOR_PROBABILITY !== 'undefined'){
                                //     posteriorPValue = oneRecord.POSTERIOR_PROBABILITY;
                                // }
                                if ( typeof oneRecord.posterior !== 'undefined'){
                                    posteriorPValue = oneRecord.posterior;
                                }
                                break;
                            default:
                                alert(" unexpected rowTypeToAdd="+rowTypeToAdd+".");
                                break;
                        }
                        var renderData = placeDataIntoRenderForm(   "",
                            oneRecord.name,
                            (sharedTable["numberOfColumns"]*(rowIndex+1))+indexOfColumn+2,
                            emphasisSwitch,
                            pValue,
                            posteriorPValue);
                        _.last(intermediateDataStructure.rowsToAdd).columnCells[indexOfColumn] = new IntermediateStructureDataCell(oneRecord.name,
                            renderData,rowTypeToAdd,dataAnnotationTypeCode );

                    }
                });
            });

        }
        setAccumulatorObject('topPortionDisplay',intermediateDataStructure, callingParameters.baseDomElement);


        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#notUsed',
            baseDomElement,
            clearBeforeStarting,
            intermediateDataStructure,
            true,
            'variantTableVariantHeaders',
            true,
            true ); // we want to display blank rows in this case, since they are informative
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




    var retrieveRemotedContextInformation=function(collectionOfRemoteCallingParameters){

        var objectContainingRetrievedRecords = [];
        var promiseArray = [];



        _.forEach(collectionOfRemoteCallingParameters.multiples,function(eachRemoteCallingParameter){
            var rememberUrl = eachRemoteCallingParameter.retrieveDataUrl;
            var rememberData = eachRemoteCallingParameter.dataForCall;
            promiseArray.push(
                $.ajax({
                    cache: false,
                    type: "post",
                    url: eachRemoteCallingParameter.retrieveDataUrl,
                    data: eachRemoteCallingParameter.dataForCall,
                    async: true
                }).done(function (data, textStatus, jqXHR) {

                    var accumulatorObject;
                    if ( typeof collectionOfRemoteCallingParameters.nameOfAccumulatorField  !== 'undefined'){
                        accumulatorObject =  getAccumulatorObject(collectionOfRemoteCallingParameters.nameOfAccumulatorField,
                            collectionOfRemoteCallingParameters.baseDomElement);
                    }
                    objectContainingRetrievedRecords = eachRemoteCallingParameter.processEachRecord(    data,
                                                                                                        accumulatorObject,
                                                                                                        collectionOfRemoteCallingParameters );

                }).fail(function (jqXHR, textStatus, errorThrown) {
                    loading.hide();
                    alert("Ajax call failed, url="+rememberUrl+", data="+rememberData+".");
                    core.errorReporter(jqXHR, errorThrown)
                })
            );
        });


        $.when.apply($, promiseArray).then(function(allCalls) {

            if (( typeof collectionOfRemoteCallingParameters.displayRefinedContextFunction !== 'undefined') &&
                ( collectionOfRemoteCallingParameters.displayRefinedContextFunction !== null ) ) {

                if ( typeof collectionOfRemoteCallingParameters.displayEverythingFromThisCall === 'undefined'){

                }

                collectionOfRemoteCallingParameters.displayRefinedContextFunction(  collectionOfRemoteCallingParameters.placeToDisplayData,
                                                                                    objectContainingRetrievedRecords,
                                                                                    collectionOfRemoteCallingParameters );

            } else if  ( typeof collectionOfRemoteCallingParameters.actionId !== 'undefined')  {

                var actionToUndertake = actionContainer( collectionOfRemoteCallingParameters.actionId,
                    actionDefaultFollowUp(collectionOfRemoteCallingParameters.actionId),
                    collectionOfRemoteCallingParameters.baseDomElement);
                actionToUndertake();

            } else {

                alert("we had no follow-up action.  That's okay, right?");

            }


        }, function(e) {
            alert("Ajax call failed.");
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
                returnValue["nameOfAccumulatorField"] = startingMaterials.nameOfAccumulatorField;
                returnValue["code"] = startingMaterials.code;
                returnValue["nameOfAccumulatorFieldWithIndex"] = startingMaterials.nameOfAccumulatorFieldWithIndex;
                returnValue["baseDomElement"] = startingMaterials.baseDomElement;
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

    };





    var modifyScreenFields = function (data, additionalParameters) {

        initializeAccumulatorObject(additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage,additionalParameters);


        if ( typeof data.phenotype !== 'undefined'){
            setAccumulatorObject("preferredPhenotype", data.phenotype,
                additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
            setAccumulatorObject("phenotype", data.phenotype,
                additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        }


        let dataAnnotationTypes = [];
        let dataAnnotationTypesFollowUp = [];

        switch (additionalParameters.dynamicTableType) {
            case 'geneTable':
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

                dataAnnotationTypes = additionalParameters.dataAnnotationTypes;
                break;
            case 'effectorGeneTable':
                var sharedTable = new SharedTableObject( 'fegtAnnotationHeaders',0,0);
                $( window ).resize(function() {
                    adjustTableWrapperWidth(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory);
                });
                // sharedTable.currentForm = additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory;
                setAccumulatorObject("sharedTable_"+additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
                    sharedTable,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                dataAnnotationTypes = additionalParameters.dataAnnotationTypes;
                break;
            case 'tissueTable':
                resetAccumulatorObject('gregorTissueArray',
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                resetAccumulatorObject('tissueTableChosenAnnotations',
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                destroySharedTable(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory);
                var sharedTable = new SharedTableObject('tissueTableTissueHeaders',0,0);
                setAccumulatorObject("sharedTable_" + additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,sharedTable,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                dataAnnotationTypes = additionalParameters.dataAnnotationTypes;
                break;
            case 'variantTable':
                //setAccumulatorObject("phenotype","T2D");
                //setAccumulatorObject("chromosome","8");
                //setAccumulatorObject("extentBegin","117862462");
                //setAccumulatorObject("extentEnd","118289003");

                // setAccumulatorObject("phenotype","T2D");
                // setAccumulatorObject("chromosome","19");
                // setAccumulatorObject("extentBegin","58838000");
                // setAccumulatorObject("extentEnd","58875000");

                // setAccumulatorObject("phenotype","T2D");
                // setAccumulatorObject("chromosome","1");
                // setAccumulatorObject("extentBegin","3504650");
                // setAccumulatorObject("extentEnd","3614660");

                setAccumulatorObject("phenotype",data.phenotype,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject("chromosome",data.chromosome,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject("extentBegin",data.startPosition,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject("extentEnd",data.endPosition,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);

                const chromosomeInput = $('input#chromosomeInput').val();
                const startExtentInput = $('input#startExtentInput').val();
                const endExtentInput = $('input#endExtentInput').val();
                //const chosenPhenotype = $('select.phenotypePicker').children("option:selected"). val();
                var chosenPhenotype = data.phenotype;

                if (( typeof chromosomeInput !== 'undefined')&&(chromosomeInput.length>0)){setAccumulatorObject("chromosome",chromosomeInput,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);}
                if (( typeof startExtentInput !== 'undefined')&&(startExtentInput.length>0)){setAccumulatorObject("extentBegin",startExtentInput,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);}
                if (( typeof endExtentInput !== 'undefined')&&(endExtentInput.length>0)){setAccumulatorObject("extentEnd",endExtentInput,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);}
                if (( typeof chosenPhenotype !== 'undefined')&&(chosenPhenotype.length>0)){
                    setAccumulatorObject("phenotype",chosenPhenotype,
                        additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                }

                destroySharedTable(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory);
                var sharedTable = new SharedTableObject('variantTableVariantHeaders',0,0);
                setAccumulatorObject("sharedTable_" + additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,sharedTable,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject('variantInfoArray',undefined,
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject("variantTableOrientation","annotationDominant",
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
                setAccumulatorObject("annotationDisplayArray", [],
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);

                dataAnnotationTypes = _.filter(additionalParameters.dataAnnotationTypes,function(o){
                    return o.code === 'VHDR';
                });
                dataAnnotationTypesFollowUp = _.filter(additionalParameters.dataAnnotationTypes,function(o){
                    return o.code !== 'VHDR';
                });

                break;
            default:
                alert (' unexpected dynamicTableType === '+ additionalParameters.dynamicTableType +'.');
                break;
        }





        var arrayOfRoutinesToUndertake = [];

        //  If we ever want to update this page without reloading it then were going to need to get rid of the information in the accumulators
        resetAccumulatorObject("geneInfoArray",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("tissuesForEveryGene",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("genesForEveryTissue",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("rawDepictInfo",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("abcAggregatedPerVariant",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("sharedTable_table.combinedGeneTableHolder",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);
        resetAccumulatorObject("modNameArray",
            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage);


        destroySharedTable('table.combinedGeneTableHolder');


        if (additionalParameters.dynamicTableType!=='variantTable'){
            _.forEach(dataAnnotationTypes, function (oneAnnotationType){
                if ( typeof oneAnnotationType.code !== 'undefined'){
                    arrayOfRoutinesToUndertake.push( actionContainer(oneAnnotationType.internalIdentifierString,
                        actionDefaultFollowUp(oneAnnotationType.internalIdentifierString),
                        additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage));
                }
            });
            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});
        } else {
            _.forEach(dataAnnotationTypes, function (oneAnnotationType){
                arrayOfRoutinesToUndertake.push( actionContainer(oneAnnotationType.internalIdentifierString,
                    actionDefaultFollowUp(oneAnnotationType.internalIdentifierString),
                    additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage));
            });
            _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});
            deferredObject = $.Deferred();
            deferredObject.done(function () {
                console.log("about to execute the other callbacks");
                arrayOfRoutinesToUndertake = [];
                _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});
                if (dataAnnotationTypesFollowUp.length>0){
                    arrayOfRoutinesToUndertake = [];
                    _.forEach(dataAnnotationTypesFollowUp, function (oneAnnotationType){
                        arrayOfRoutinesToUndertake.push( actionContainer(oneAnnotationType.internalIdentifierString,
                            actionDefaultFollowUp(oneAnnotationType.internalIdentifierString),
                            additionalParameters.dynamicTableConfiguration.domSpecificationForAccumulatorStorage));
                    });
                    _.forEach(arrayOfRoutinesToUndertake, function(oneFunction){oneFunction()});

                }
                console.log("the other callbacks are all queued up");
            });

            deferredObject.fail(function () {
                console.log("Executed if the async work fails");
            });

        }
     };



    var adjustExtentHolders = function(storageField,spanClass,basesToShift){
        alert('adjustExtentHolders is no longer called, right?');
        var extentBegin = parseInt( getAccumulatorObject(storageField) );
        if ((extentBegin+basesToShift)>0){
            extentBegin += basesToShift;
        } else {
            extentBegin = 0;
        }
        setAccumulatorObject(storageField,extentBegin);
        $(spanClass).html(""+extentBegin);
   //     resetAccumulatorObject("geneNameArray");
        resetAccumulatorObject("geneInfoArray");
        resetAccumulatorObject("tissueNameArray");
    };

    var adjustLowerExtent = function(basesToShift){
        alert('adjustLowerExtent is no longer called, right?');
        if (basesToShift>0){
            if ( ( parseInt(getAccumulatorObject("extentBegin") )+basesToShift ) > //
                 ( parseInt(getAccumulatorObject("extentEnd") ) ) ){
                return;
            }
        }
        adjustExtentHolders("extentBegin","span.dynamicUiGeneExtentBegin",basesToShift);
    };

    var adjustUpperExtent = function(basesToShift){
        alert('adjustUpperExtent is no longer called, right?');
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




    var storeCellInMemoryRepresentationOfSharedTable = function (   whichTable,
                                                                    cell,
                                                                    annotation,
                                                                    rowIndex,
                                                                    columnIndex,
                                                                    numberOfColumns,
                                                                    baseDomElement ){
        var indexInOneDimensionalArray = (rowIndex*numberOfColumns)+columnIndex;
        var sharedTable = getAccumulatorObject("sharedTable_"+whichTable,baseDomElement);
        if (($.isArray(sharedTable)) && (sharedTable.length === 0)){
            // data structure is empty.  Let us give it the correct form, and then store it
            sharedTable = new SharedTableObject(annotation,numberOfColumns,rowIndex);
            setAccumulatorObject("sharedTable_"+whichTable,sharedTable, baseDomElement);
        }
        if (indexInOneDimensionalArray > sharedTable.length){
            // we must be on a new row. We know that rows are added sequentially

            sharedTable.dataCells.push.apply(sharedTable.dataCells, new Array(numberOfColumns));
            sharedTable.addDataToMatrix(numberOfColumns);
        }
        sharedTable.dataCells [indexInOneDimensionalArray] = new SharedTableDataCell(   cell.title,
                                                                                        cell,
                                                                                        cell.annotation,
                                                                                        indexInOneDimensionalArray,
                                                                                        cell.dataAnnotationTypeCode
            );
        sharedTable.assignDataToMatrix(cell,
            rowIndex,
            columnIndex,
            numberOfColumns,
            indexInOneDimensionalArray);
        // update the row count
        var maximumLinearDataLength = sharedTable.dataCells.length;
        sharedTable.numberOfRows = Math.floor(maximumLinearDataLength/numberOfColumns);
    }




    const emptyFieldHandler = function (textAEmpty,textBEmpty,direction){
        let returnValue =  0;
        if ( textAEmpty && textBEmpty ) {
            returnValue = 0;
        }
        else if ( textAEmpty ) {
            if (direction==='desc') {
                returnValue = -1;
            } else {
                returnValue = 1;
            }
        }else if ( textBEmpty )
        {
            if (direction==='desc') {
                returnValue = 1;
            } else {
                returnValue = -1;
            }
        }
        return returnValue;
    }


        var generalPurposeSort  = function(a, b, direction, currentSortObject  ){

            var defaultSearchField = 'sortField';
            const sortTermOverride = currentSortObject.desiredSearchTerm;
            switch (currentSortObject.currentSort){
                case 'variantAnnotationCategory':
                case 'methods':
                    var textA = $(a).attr(defaultSearchField).toUpperCase();
                    var textB = $(b).attr(defaultSearchField).toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                case'VariantAssociationPValue':
                case'VariantAssociationPosterior':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                    break;
                case 'geneMethods':
                case 'H3k27ac':
                case 'DNase':
                //case 'ABC':
                //case 'eQTL':
                case 'variantHeader':
                    var x = parseInt($(a).attr(defaultSearchField));
                    var y = parseInt($(b).attr(defaultSearchField));
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
                    var x = parseInt($(a).attr(defaultSearchField));
                    var y = parseInt($(b).attr(defaultSearchField));
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'P-value':
                    var x = parseFloat($(a).attr(defaultSearchField));
                    var y = parseFloat($(b).attr(defaultSearchField));
                    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                    break;
                case 'sortMethodsInVariantTable':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                    break;
                case 'ldsrValuesInTissueTable':
                case 'gregorValuesInTissueTable':
                case 'depictTissueValuesInTissueTable':
                case 'tissueHeader':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                case 'DEPICT':
                case 'MetaXcan':
                //case 'ABC':
                case 'MOD':
                case 'eCAVIAR':
                case 'COLOC':
                case 'Firth':
                case 'SKAT':
                case 'geneHeader':
                case  'categoryName':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                    break;
                case 'straightAlphabetic':
                    var textA = a.trim().toUpperCase();
                    var textB = b.trim().toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                    break;
                case 'fegtHeader':
                case 'Combined_category':
                case 'tissueNameInTissueTable':
                case 'Genetic_combined':
                case 'Genomic_combined':
                case 'Gene_name':
                case 'Locus_name':
                case 'Perturbation_combined':
                case 'GWAS_coding_causal':
                case 'Exome_array_coding_causal':
                case 'Exome_sequence_burden':
                case 'Monogenic':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                     break;
                case 'external_evidence':
                case 'homologous_gene':
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
                case 'VariantId':
                case 'VariantIds':
                case 'VariantAtacSeq':
                case 'VariantChromHmm':
                case 'VariantCoding':
                case 'VariantSplicing':
                case 'VariantUtr':
                case 'VariantAbc':
                    return eval(currentSortObject.dataAnnotationType.packagingString+'.sortRoutine(a, b, direction, currentSortObject)');
                    break;
                default:
                    break;
            }
            var x = UTILS.extractAnchorTextAsInteger(a);
            var y = UTILS.extractAnchorTextAsInteger(b);
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        }



        var findCellColoringChoice=function(whereTheTableGoes,baseDomElement){
            var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes,baseDomElement);
            if ( typeof sharedTable.cellColoringScheme === 'undefined'){
                sharedTable["cellColoringScheme"] = "Significance";
            }
            return sharedTable.cellColoringScheme;
        }





    var findDesiredSearchTerm=function(whereTheTableGoes,requestedSort,baseDomElement){
            var favoredSortField = 'sortField';
            const sharedTable = getSharedTable(whereTheTableGoes,baseDomElement);
            const currentTableForm = sharedTable.currentForm;
            var cellColoringScheme = findCellColoringChoice(whereTheTableGoes,baseDomElement);
            if ((currentTableForm==='geneTableGeneHeaders') || (currentTableForm==='geneTableAnnotationHeaders')) { // gene table
                if ( cellColoringScheme === 'Significance'){
                    favoredSortField = 'significance_sortfield'
                } else if ( cellColoringScheme === 'Records'){
                    favoredSortField = 'sortfield'
                }
                // the upper left corner gets special treatment, ince it may be sorted differently depending on table orientation
                 if ( requestedSort==='categoryName'){
                    if (currentTableForm==='geneTableGeneHeaders') {
                        favoredSortField = 'sortfield';
                    } else if (currentTableForm==='geneTableAnnotationHeaders') {
                        favoredSortField = 'geneName';
                    }
                 }
            } else if ((currentTableForm==='fegtAnnotationHeaders') || (currentTableForm==='fegtGeneNameHeaders')) { //
                favoredSortField = 'sortfield';
            } else {
                favoredSortField = 'sortfield';
            }
            return favoredSortField;
        }



        jQuery.fn.dataTableExt.oSort['generalSort-asc'] = function (a, b ) {
            //var currentSortRequest = getAccumulatorObject("currentSortRequest",baseDomElement);
            var currentSortRequest = getCurrentSortRequest ();

            return generalPurposeSort(  a,b,'asc',
                                        currentSortRequest );
        };

        jQuery.fn.dataTableExt.oSort['generalSort-desc'] = function (a, b) {
            //var currentSortRequest = getAccumulatorObject("currentSortRequest",baseDomElement);
            var currentSortRequest = getCurrentSortRequest ();
//            return generalPurposeSort(a,b,'desc',currentSortRequest);
            if (currentSortRequest.currentSort === "variantAnnotationCategory"){
                return generalPurposeSort(a,b,'desc',currentSortRequest);
            } else {
                return generalPurposeSort(b,a,'desc',currentSortRequest);
            }
        };



var howToHandleSorting = function(e,callingObject,typeOfHeader,dataTable,baseDomElement) {
    var classList = $(callingObject).attr("class").split(/\s+/);
    // we need to find out the index of this column, which is potentially tricky, since after
    //  a transposed sorting the column may have moved. So we pull our unique identifier for every
    //  cell (initialLinearIndex_) out, and then march across every header and compare its unique
    //  number, and when we find a match then we know the index of our column.
    var columnNumberValue = -1;
    var initialLinearIndex = extractClassBasedIndex($(callingObject)[0].innerHTML,"initialLinearIndex_");
    var numberOfHeaders = dataTable.table().columns()[0].length;
    if (initialLinearIndex !== -1){
        _.each(_.range(0,numberOfHeaders),function(index){
            var header=dataTable.table().column(index).header();
            if ( typeof header.children[0] !== 'undefined'){
                var divDom = $(header.children[0].outerHTML);
                if (extractClassBasedIndex(divDom,"initialLinearIndex_")===initialLinearIndex){
                    columnNumberValue = index;
                }
            }
        });
    }
    var currentSortRequestObject = {};
    const dyanamicUiVariables = getAccumulatorObject(undefined, baseDomElement);
    console.log("table to sort "+dyanamicUiVariables.dynamicTableConfiguration.initializeSharedTableMemory+".");
    let sortOrder = extractClassBasedTrailingString(callingObject,"sorting_");
    _.forEach(classList, function (oneClass){

        if (dyanamicUiVariables.columnDefinitions === 'static'){
            // with static columns we can keep the sorting descriptions might be held at multiple possible levels
            let dataAnnotationTypeIndex = _.findIndex(dyanamicUiVariables.dataAnnotationTypes,['sortingSubroutine',oneClass]);
            if ((dyanamicUiVariables.dataAnnotationTypes.length > 0) &&
                ( typeof dyanamicUiVariables.dataAnnotationTypes[0].customColumnOrdering !== 'undefined')){
                if (dataAnnotationTypeIndex === -1){
                    dataAnnotationTypeIndex = _.findIndex(dyanamicUiVariables.dataAnnotationTypes[0].customColumnOrdering.topLevelColumns,['sortingSubroutine',oneClass]);
                }
                if (dataAnnotationTypeIndex === -1){
                    dataAnnotationTypeIndex = _.findIndex(dyanamicUiVariables.dataAnnotationTypes[0].customColumnOrdering.constituentColumns,['sortingSubroutine',oneClass]);
                }
                if (dataAnnotationTypeIndex>-1){
                    currentSortRequestObject = {
                        'currentSort':oneClass,
                        'dataAnnotationType':dyanamicUiVariables.dataAnnotationTypes[0],
                        'desiredSearchTerm':findDesiredSearchTerm(  dyanamicUiVariables.dynamicTableConfiguration.initializeSharedTableMemory,
                                                                    oneClass,baseDomElement ),
                        'table':dyanamicUiVariables.dynamicTableConfiguration.initializeSharedTableMemory
                    };
                    return false;
                }
                if (sortOrder.length===0){
                    sortOrder = 'asc';
                }
            }

        } else {
            let dataAnnotationTypeIndex = _.findIndex(dyanamicUiVariables.dataAnnotationTypes,['sortingSubroutine',oneClass]);
            if (dataAnnotationTypeIndex>-1){
                currentSortRequestObject = {
                    'currentSort':oneClass,
                    'dataAnnotationType': dyanamicUiVariables.dataAnnotationTypes[dataAnnotationTypeIndex],
                    'desiredSearchTerm':findDesiredSearchTerm(dyanamicUiVariables.dynamicTableConfiguration.initializeSharedTableMemory,
                        oneClass, baseDomElement ),
                    'table':dyanamicUiVariables.dynamicTableConfiguration.initializeSharedTableMemory
                };
                return false;
            }
        }


    });
    if ($.isEmptyObject(currentSortRequestObject)) return;
    var actualColumnIndex = columnNumberValue;
    currentSortRequestObject['sortOrder'] = (sortOrder === 'asc')?'desc':'asc';
    currentSortRequestObject['columnNumberValue'] = actualColumnIndex;
    var setOfColumnsToSort = [];
    if ((typeOfHeader === "variantTableVariantHeaders")&&
        ( currentSortRequestObject.currentSort !== "variantAnnotationCategory")){
        setOfColumnsToSort.push([0,'asc']);
        if ( currentSortRequestObject.currentSort !== 'methods'){
            setOfColumnsToSort.push([1,'asc']);
        }
    }
    else  if ((typeOfHeader === "geneTableGeneHeaders")&&
        ( currentSortRequestObject.currentSort === "geneHeader")){
       // setOfColumnsToSort.push([0,'desc']);
    }
    setOfColumnsToSort.push([ currentSortRequestObject.columnNumberValue, currentSortRequestObject.sortOrder ]);

    setAccumulatorObject("currentSortRequest", currentSortRequestObject,baseDomElement );
    setCurrentSortRequest(getAccumulatorObject("currentSortRequest",baseDomElement));

    dataTable
        .order( setOfColumnsToSort )
        .draw();
};


    var getDisplayableCellContent  = function (intermediateStructureDataCell,baseDomElement){
        var returnValue = "";
        var additionalParameters = getAccumulatorObject(undefined, baseDomElement);
        switch (intermediateStructureDataCell.dataAnnotationTypeCode){
            case 'LIT': // a literal. Used when we recall the headers straight from the table
                returnValue = intermediateStructureDataCell.renderData;
                break;
            case 'EMC':  // an empty cell
                returnValue = Mustache.render($(additionalParameters.dynamicTableConfiguration.emptyHeaderRecord)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case 'EMP':  // the first two columns are always empty, but contains some information in render data
                returnValue = Mustache.render($(additionalParameters.dynamicTableConfiguration.emptyBodyRecord)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case 'GHD':  // the first two columns are always empty, but contains some information in render data
                returnValue = Mustache.render($('#dynamicGeneTableHeaderV2')[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case "TITA":
                var dataAnnotationType= getDatatypeInformation(intermediateStructureDataCell.dataAnnotationTypeCode,baseDomElement);
                var revisedValues = mpgSoftware.dynamicUi.gregorTissueTable.createSingleGregorCell(intermediateStructureDataCell.renderData.allTissueRecords,
                    dataAnnotationType,
                    getAccumulatorObject('tissueTableChosenAnnotations',baseDomElement));
                intermediateStructureDataCell.renderData["cellPresentationString"] = revisedValues.significanceCellPresentationString;
                    intermediateStructureDataCell.renderData.cellPresentationStringMap[findCellColoringChoice('#mainTissueDiv table.tissueTableHolder', baseDomElement)];
                intermediateStructureDataCell.renderData["tissueRecords"]=revisedValues.tissuesFilteredByAnnotation;
                returnValue = Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case "ABC_VAR":
                var displayDetails = getDatatypeInformation(intermediateStructureDataCell.dataAnnotationTypeCode,baseDomElement);
                returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.cellBodyWriter)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case "ABC list":
                returnValue = "ABC list";
                break;
            case "VHDR":
                var displayDetails = getDatatypeInformation(intermediateStructureDataCell.annotation,baseDomElement);
                returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.cellBodyWriter)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;
            case "GREGOR_FOR_VAR":
                var displayDetails = getDatatypeInformation(intermediateStructureDataCell.dataAnnotationTypeCode,baseDomElement);
                returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.cellBodyWriter)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;

            case undefined:
                returnValue = "wtf";
                break;

            default:  //  the standard case, where a cell renders its own data using its chosen mustache template
                var cellColoringScheme ="records";

                intermediateStructureDataCell.renderData["cellPresentationString"] =
                    intermediateStructureDataCell.renderData.cellPresentationStringMap[findCellColoringChoice('table.combinedGeneTableHolder', baseDomElement)];

                var displayDetails = getDatatypeInformation(intermediateStructureDataCell.dataAnnotationTypeCode,baseDomElement);
                returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.cellBodyWriter)[0].innerHTML,intermediateStructureDataCell.renderData);
                break;

        }
        if (typeof returnValue === "string"){
            return returnValue.trim();
        } else {
            return "object";
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
                                            additionalDetailsForHeaders,
                                            baseDomElement ){

        var NewColumn = function(contentOfHeader,header,classesToPromote,intermediateStructureDataCell){
            return {contentOfHeader:contentOfHeader,
                header:header,
                classesToPromote:classesToPromote,
                intermediateStructureDataCell:intermediateStructureDataCell}
        };

        if (( typeof headers !== 'undefined') &&
            (headers.length > 0)){
            var datatable;
            if ( ! $.fn.DataTable.isDataTable( whereTheTableGoes ) ) {
                var sharedTable = getAccumulatorObject("sharedTable_"+whereTheTableGoes, baseDomElement);
                var dyanamicUiVariables = getAccumulatorObject(undefined, baseDomElement);
                var headerDescriber = {
                    "dom": '<"top">rt<"bottom"iplB>',
                    "buttons": [
                        {extend: "copy", text: "Copy all to clipboard"},
                        {extend: "csv", text: "Copy all to csv"}
                    ],
                    "aLengthMenu": [
                        [150,15, -1],
                        [150,15, "All"]
                    ],
                    "bDestroy": true,
                    "bSort": true,
                    "bAutoWidth": false,
                    "aoColumnDefs": []
                };
                // if we are building the table for the first time *only*, then give it a default ordering
                if (storeHeadersInDataStructure){
                    headerDescriber["aaSorting"] =  [[ 1, "asc" ]];
                } else {
                    headerDescriber["aaSorting"] =  [];
                }
                var addedColumns = [];
                if (prependColumns){ // we may wish to add in some columns based on metadata about a row.
                                     //  Definitely we don't if we are transposing, however, since we've already built that material
                                     //  Definitely we don't if we are transposing, however, since we've already built that material
                    var sortability = [];
                    switch(typeOfHeader){
                        case 'geneTableGeneHeaders':
                            var isdc = new IntermediateStructureDataCell('farLeftCorner',
                                {initialLinearIndex:"initialLinearIndex_0"},
                                'categoryName','EMP');
                            var header = {title:isdc.title, annotation:isdc.annotation};
                            addedColumns.push(new NewColumn(    getDisplayableCellContent(isdc,baseDomElement),
                                                                header,
                                                                ['initialLinearIndex_0'],
                                                                isdc));
                            var isdc2 = new IntermediateStructureDataCell('b',
                                {initialLinearIndex:"initialLinearIndex_1"},
                                'geneMethods','EMP');
                            var header2 = {title:isdc2.title, annotation:isdc2.annotation};
                            addedColumns.push(new NewColumn(    getDisplayableCellContent(isdc2,baseDomElement),
                                header2,
                                ['initialLinearIndex_1'],
                                isdc2));
                            sortability.push(true);
                            break;
                        case 'variantTableVariantHeaders':
                            setAccumulatorObject( "currentSortRequest",
                                dyanamicUiVariables.dynamicTableConfiguration.defaultSort,
                                baseDomElement );
                            var isdc = new IntermediateStructureDataCell('farLeftCorner',
                                {initialLinearIndex:"initialLinearIndex_0"},
                                'methodCategories variantIds','EMP');
                            var header = {title:isdc.title, annotation:isdc.annotation};
                            addedColumns.push(new NewColumn(    getDisplayableCellContent(isdc,baseDomElement),
                                header,
                                ['initialLinearIndex_0'],
                                isdc));
                            var isdc2 = new IntermediateStructureDataCell('b',
                                {initialLinearIndex:"initialLinearIndex_1"},
                                'methods','EMP');
                            var header2 = {title:isdc2.title, annotation:isdc2.annotation};
                            addedColumns.push(new NewColumn(    getDisplayableCellContent(isdc2,baseDomElement),
                                header2,
                                ['initialLinearIndex_1'],
                                isdc2));
                            sortability.push(true);
                            break;
                        case 'tissueTableTissueHeaders':
                            var isdc = new IntermediateStructureDataCell('farLeftCorner',
                                displayCategoryHtml('TITA',0,baseDomElement),
                                'tissueNameInTissueTable','LIT');
                            var header = {title:isdc.title, annotation:isdc.annotation};
                            addedColumns.push(new NewColumn(    getDisplayableCellContent(isdc,baseDomElement),
                                header,
                                ['initialLinearIndex_0'],
                                isdc));
                            break;
                        case 'variantTableAnnotationHeaders':
                        case 'geneTableAnnotationHeaders':
                        default:
                            break;
                    }


                }



                var numberOfAddedColumns = addedColumns.length;
                 _.forEach(headers, function (header, count) {
                     var classesToPromote = [];
                     // first let us extract any classes that we need to promote to the header
                     var headerContent = getDisplayableCellContent(header,baseDomElement);
                     if ((headerContent.length>0)&&
                         ( typeof  $(headerContent).attr("class") !== 'undefined')){
                         var classList = $(headerContent).attr("class").split(/\s+/);
                         var currentSortRequestObject = {};
                         _.forEach(classList, function (oneClass){
                             var sortOrderDesignation = "sorting_";
                             var bigGroupDesignation = "BigGroupNum";
                             var combinedCategory = "Combined_category";
                             var  sortingClass = 'sortClass_';
                             if (
                                 ( oneClass.substr(0,sortOrderDesignation.length) === sortOrderDesignation )||
                                 ( oneClass.substr(0,bigGroupDesignation.length) === bigGroupDesignation )||
                                 ( oneClass.substr(0,combinedCategory.length) === combinedCategory )
                             ){
                                 classesToPromote.push (oneClass);
                             }
                             if (
                                 ( oneClass.substr(0,sortingClass.length) === sortingClass )
                             ){
                                 classesToPromote.push ( oneClass.substr(sortingClass.length));
                             }

                         });
                     }
                     var contentOfHeader = headerContent;
                     if ((typeOfHeader === 'variantTableAnnotationHeaders')&&
                         (additionalDetailsForHeaders.length > 0)){
                         contentOfHeader += getDisplayableCellContent(additionalDetailsForHeaders[count],baseDomElement);
                     }
                     if ((typeOfHeader === 'geneTableAnnotationHeaders')&&
                         (additionalDetailsForHeaders.length > 0)){
                         contentOfHeader += getDisplayableCellContent(additionalDetailsForHeaders[count],baseDomElement);
                     }

                     var initialLinearIndex = extractClassBasedIndex(headerContent,"initialLinearIndex_");
                     if (initialLinearIndex === -1){
                         var domContent = $(headerContent);
                         domContent.addClass("initialLinearIndex_"+(count+numberOfAddedColumns));
                         contentOfHeader = '';
                         _.forEach(domContent,function(domElement){
                             if ( typeof domElement.outerHTML !== 'undefined'){
                                 contentOfHeader += domElement.outerHTML;
                             }
                         });
                         //contentOfHeader = domContent[0].outerHTML;
                     }

                     addedColumns.push({contentOfHeader:contentOfHeader,
                                         header:header,
                                         classesToPromote:classesToPromote,
                                        intermediateStructureDataCell:
                                            new IntermediateStructureDataCell(header.title,contentOfHeader,header.annotation,'LIT')
                     });
                });

                var noSorting = false;
                if (storeHeadersInDataStructure){
                    _.forEach(addedColumns,function(oneCol,columnIndex){
                        storeCellInMemoryRepresentationOfSharedTable(whereTheTableGoes,
                            oneCol.intermediateStructureDataCell,
                            typeOfHeader,
                            0,
                            columnIndex,
                            addedColumns.length,
                            baseDomElement );
                    });
                }

                var revisedHeaderList = addedColumns;
                if (dyanamicUiVariables.dynamicTableConfiguration.formOfStorage ==='loadOnce') {
                    // what we display and what we store may be different in the static case
                    //
                    // let's restrict the headers based on our notion of which columns we want to see
                     revisedHeaderList = mpgSoftware.matrixMath.deleteColumnsInDataStructure(addedColumns,1,addedColumns.length,
                        sharedTable.getAllColumnsToExclude()).dataArray;
                }

                // We have built up all the data we need.  Now we can make the headers themselves,
                _.forEach(revisedHeaderList,function(oneCol,count){
                    headerDescriber.aoColumnDefs.push({
                        "title": oneCol.contentOfHeader,
                        "targets": noSorting?'nosort':[count],
                        "name": oneCol.header.title,
                        "className": oneCol.header.annotation+" "+oneCol.classesToPromote.join(" "),
                        "sortable": !noSorting,
                        "type": "generalSort"
                    });
                });

                datatable = $(whereTheTableGoes).DataTable(headerDescriber);

                var headerContents = _.map(headerDescriber.aoColumnDefs,function(o){
                    return o.title
                });
                var numberOfHeaders = headerContents.length;

                // here is where we define the table


                //create your own click handler for the header
                $(whereTheTableGoes+' th').unbind('click.DT');
                $(whereTheTableGoes+' th').click(function(e){howToHandleSorting(e,this,typeOfHeader,datatable,baseDomElement)});



            }
            // update our notion of the header contents
            if( typeof sharedTable !== 'undefined'){
                sharedTable.mostRecentHeaders  =headerContents;// sometimes I update other tables, which may not
                // reference the shared table memory structure
            }

        }
        return $(whereTheTableGoes).dataTable();

    };

    const adjustAnnotationTable = function(callingObject,cssSelector){
        $('#gregorSubTableDiv').find('div.dataTables_wrapper').css('height','100%');
        const domToAdjust = $(cssSelector);
        const domCallingObject = $(callingObject);
        if (domToAdjust.css('display')==='none'){
            domToAdjust.show();
            domCallingObject.text('Hide filters from GREGOR enrichment');
        } else {
            domToAdjust.hide();
            domCallingObject.text('Adjust filters from GREGOR enrichment');
        }
    }

    const getMethodsAnnotationsAndTissuesFromGregorTable = function(getEverything){
        let getEverythingString = (!getEverything)?":checked":"";
        const arrayForMethodsAndAnnotations = $('div.gregorSubTableRow').find('input.gregorSubTableRowHeader'+getEverythingString);
        let  allMethods = [];
        let allAnnotations = [];
        let allTissues = []
        let returnValue = {
            uniqueMethods:[],
            uniqueAnnotations:[],
            uniqueTissues:[]
        };
        _.forEach(arrayForMethodsAndAnnotations,function(annotationMethodInput){
            const annotationMethod = $(annotationMethodInput).attr('value');
            if (annotationMethod.length>2){
                const annotationMethodArray = annotationMethod.split("_");
                allAnnotations.push(annotationMethodArray[0]);
                allMethods.push(annotationMethodArray[1]);
            }
        });
        _.forEach($('div.gregorSubTableHeader').find('input.gregorSubTableRowHeader'+getEverythingString),function(tissueInput){
            allTissues.push($(tissueInput).attr('value'));
        });
        returnValue.uniqueMethods = _.uniq(allMethods);
        returnValue.uniqueAnnotations = _.uniq(allAnnotations);
        returnValue.uniqueTissues = _.uniq(allTissues);
    return returnValue;
    };


    const getMethodsAnnotationsAndTissuesFromExplicitAnnotationSpecification= function(getEverything){
        var selectedElements = $('#annotationSelectorChoice option:selected');
        var selectedValuesAndText = [];
        _.forEach(selectedElements,function(oe){
            const annotationAndMethod = $(oe).val().split("_");
            selectedValuesAndText.push({name:annotationAndMethod[0],
                             method:annotationAndMethod[1],
                             text:$(oe).text()});
        });
        return {uniqueMethods:_.uniq(_.map(selectedValuesAndText,function(o){return o.method})),
            uniqueTissues:[1],
            uniqueAnnotations:_.map(selectedValuesAndText,function(o){return o.name})};
    };



    const filterEpigeneticTableAnnotationsOnTop = function(oneDiv,blankRowsAreOkay,weAreInTissueMode,uniqueAnnotations,uniqueMethods,filterByGregor){
        if (blankRowsAreOkay){
            $('tr.doNotDisplay').removeClass('doNotDisplay').show(); // these should never exist.  Can we remove this line?
            // now go through every annotation that is marked is not displayed, and display everythi
            $('div.varAnnotation.doNotDisplay').removeClass('doNotDisplay').show();
            $('#mainVariantDiv div').parent('.varAllEpigenetics').parent().show();
            $('#mainVariantDiv div').parent('.header').show();
            return;
        }

        const currentAnnotation = extractClassBasedTrailingString(oneDiv,"annotationName_");
        const currentMethod = extractClassBasedTrailingString(oneDiv,"methodName_");
        const currentTissue = extractClassBasedTrailingString(oneDiv,"tissueId_");
        let methodNameToProcess = extractClassBasedTrailingString(oneDiv,"methodName_");
        let annotationNameToProcess = extractClassBasedTrailingString(oneDiv,"annotationName_");
        let isBlank  = extractClassBasedTrailingString(oneDiv,"isBlank");

        if (weAreInTissueMode){

            if (filterByGregor){
                if ((_.includes(uniqueAnnotations,currentAnnotation))&&
                    (_.includes(uniqueMethods,currentMethod))&&
                    $('#mainVariantDiv div.yesDisplay.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).length>0){

                    // Mark this tissue as  displayed
                    $('#mainVariantDiv div.varAnnotation.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).removeClass('doNotDisplay');
                    // now show the row
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).parent().show();
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).parent('.header').show();

                } else {
                    // Mark this annotation as NOT displayed
                    $('#mainVariantDiv div.varAnnotation.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).addClass('doNotDisplay');
                    // now hide the row
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).parent().hide();
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess+'.tissueId_'+currentTissue).parent('.header').hide();
                }

            } else {
                if ((_.includes(uniqueAnnotations,currentAnnotation))&&
                    $('#mainVariantDiv div.yesDisplay.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).length>0){

                    // Mark this tissue as  displayed
                    $('#mainVariantDiv div.varAnnotation.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).removeClass('doNotDisplay');
                    // now show the row
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).parent().show();
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).parent('.header').show();

                } else {
                    // Mark this annotation as NOT displayed
                    $('#mainVariantDiv div.varAnnotation.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).addClass('doNotDisplay');
                    // now hide the row
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).parent().hide();
                    $('#mainVariantDiv div.varAllEpigenetics.annotationName_'+annotationNameToProcess+'.tissueId_'+currentTissue).parent('.header').hide();
                }

            }


        } else {
            if ((_.includes(uniqueAnnotations,currentAnnotation))&&
                (_.includes(uniqueMethods,currentMethod))&&
                $('#mainVariantDiv div.yesDisplay.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).length>0){

                // Mark this annotation as displayed
                $('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).removeClass('doNotDisplay');
                // display the rest of the column
                $('#mainVariantDiv div.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().show();
                $('#mainVariantDiv div.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).parent('.header').show();



            } else {

                // Mark this annotation as NOT displayed
                $('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).addClass('doNotDisplay');
                // hide the rest of the column
                $('#mainVariantDiv div.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().hide();
                $('#mainVariantDiv div.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).parent('.header').hide();



            }
        }



    };

    const filterEpigeneticTableVariantsOnTop = function(oneDiv,blankRowsAreOkay,weAreInTissueMode,uniqueAnnotations,uniqueMethods,filterByGregor){
        if (blankRowsAreOkay){
            // mark the rows as displayed
            $('tr.doNotDisplay').removeClass('doNotDisplay').show();
            return;
        }

        const currentAnnotation = extractClassBasedTrailingString(oneDiv,"annotationName_");
        const currentMethod = extractClassBasedTrailingString(oneDiv,"methodName_");
        let methodNameToProcess = extractClassBasedTrailingString(oneDiv,"methodName_");
        let annotationNameToProcess = extractClassBasedTrailingString(oneDiv,"annotationName_");
        let isBlank  = extractClassBasedTrailingString(oneDiv,"isBlank");


        if (weAreInTissueMode){

                // $(oneDiv).parent().parent().show();
                // $(oneDiv).parent().parent().removeClass('doNotDisplay');
            if ((_.includes(uniqueAnnotations,currentAnnotation))&&
                $(oneDiv).parent().parent().find('div.yesDisplay').length>0){

                // Mark this annotation as  displayed
                //$('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess).removeClass('doNotDisplay');
                $(oneDiv).removeClass('doNotDisplay');

                // now hide the row
                $(oneDiv).parent().parent().show();
                $(oneDiv).parent().parent().removeClass('doNotDisplay');

            } else {

                // Mark this annotation as NOT displayed
                //$('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess).addClass('doNotDisplay');
                $(oneDiv).addClass('doNotDisplay');

                // now hide the row
                $(oneDiv).parent().parent().addClass('doNotDisplay');
                $(oneDiv).parent().parent().hide();

            }


        } else {
            if ((_.includes(uniqueAnnotations,currentAnnotation))&&
                (_.includes(uniqueMethods,currentMethod))&&
                $(oneDiv).parent().parent().find('div.yesDisplay').length>0){

                // Mark this annotation as  displayed
                $('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).removeClass('doNotDisplay');
                // now hide the row
                $(oneDiv).parent().parent().show();
                $(oneDiv).parent().parent().removeClass('doNotDisplay');

            } else {

                // Mark this annotation as NOT displayed
                $('#mainVariantDiv div.varAnnotation.annotationName_'+annotationNameToProcess+'.methodName_'+methodNameToProcess).addClass('doNotDisplay');
                // now hide the row
                $(oneDiv).parent().parent().addClass('doNotDisplay');
                $(oneDiv).parent().parent().hide();

            }
        }

    };




    const filterEpigeneticTable = function(whereTheTableGoes, useTissueMode, baseDomElement){
        // we can filter either on tissue enrichments, or explicitly selected annotations, or we can accept either
        let uniqueLists = {};
        const currentTableForm = getSharedTable(whereTheTableGoes, baseDomElement)['currentForm'];
        const filterByGregor =  ($('#gregorFilterCheckbox').is(":checked"));
        const filterByExplicitMethod =  ($('#methodFilterCheckbox').is(":checked"));
        const blankRowsAreOkay = ($('#displayBlankRows').is(":checked"));
        if ( filterByGregor &&
             (!filterByExplicitMethod) ){
            uniqueLists = getMethodsAnnotationsAndTissuesFromGregorTable(false);
        } else if ( (!filterByGregor) &&
                    filterByExplicitMethod ){
            uniqueLists = getMethodsAnnotationsAndTissuesFromExplicitAnnotationSpecification(false)
        }
        let weAreInTissueMode = false;
        const variantTableOrientation = getAccumulatorObject("variantTableOrientation",baseDomElement);
        if (( typeof variantTableOrientation !== 'undefined') && (variantTableOrientation==="tissueDominant")){
            weAreInTissueMode = true;
        }



        let uniqueMethods = uniqueLists.uniqueMethods;
        let uniqueAnnotations = uniqueLists.uniqueAnnotations;
        let uniqueTissues = uniqueLists.uniqueTissues;
        $('div.epigeneticCellElement').removeClass('yesDisplay');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_0');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_1');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_2');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_3');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_4');
        $('div.epigeneticCellElement').removeClass('gregorQuantile_5');
        $('div.epigeneticCellElement').removeClass('skipDisplay');
        if ( ( typeof uniqueMethods !== 'undefined') && (uniqueMethods.length>0) &&
            ( typeof uniqueAnnotations !== 'undefined') && (uniqueAnnotations.length>0) &&
            ( typeof uniqueTissues !== 'undefined') &&  (uniqueTissues.length>0)) {

        }

        const gregorAcc = getAccumulatorObject("gregorVariantInfo",baseDomElement);
        let quantileDef = {};
        if (gregorAcc.length>0){
            quantileDef =  gregorAcc[0].header['quickLookup']
        }
        // now go through every cell and determine if we want to display it


        if (filterByGregor){
            _.forEach($('div.epigeneticCellElement'),function(oneTr){
                const currentAnnotation = extractClassBasedTrailingString(oneTr,"annotationName_");
                const currentTissue = extractClassBasedTrailingString(oneTr,"tissueId_");
                const currentMethod = extractClassBasedTrailingString(oneTr,"methodName_");
                if (_.includes(uniqueTissues,currentTissue)&&
                    ((currentAnnotation.length===0)||(_.includes(uniqueAnnotations,currentAnnotation)))&&
                    ((currentMethod.length===0)||(_.includes(uniqueMethods,currentMethod)))
                ){
                    $(oneTr).show();
                    $(oneTr).addClass('yesDisplay');
                    $(oneTr).parent().addClass('yesDisplay');
                    if (!$.isEmptyObject(quantileDef)){

                        const quanAss = quantileDef[currentAnnotation+"_"+currentTissue.replace("_",":")];
                        if ( typeof quanAss !== 'undefined'){
                            $(oneTr).addClass('gregorQuantile_'+quanAss.quantile);
                        }
                    }
                } else {
                    $(oneTr).hide();
                    $(oneTr).addClass('skipDisplay');
                }
            });

        } else if (filterByExplicitMethod){
            _.forEach($('div.epigeneticCellElement'),function(oneTr){
                const currentAnnotation = extractClassBasedTrailingString(oneTr,"annotationName_");
                const currentMethod = extractClassBasedTrailingString(oneTr,"methodName_");
                if ((_.includes(uniqueMethods,currentAnnotation)||
                    ((currentAnnotation.length===0)||(_.includes(uniqueAnnotations,currentAnnotation))))){
                    $(oneTr).show();
                    $(oneTr).addClass('yesDisplay');
                    $(oneTr).parent().addClass('yesDisplay');

                } else {
                    $(oneTr).hide();
                    $(oneTr).addClass('skipDisplay');
                }
            });
        }
        _.forEach($('div.multiRecordCell'),function(multiRecordCell){
            const multiRecordCellDom = $(multiRecordCell);
            if (multiRecordCellDom.find('div.epigeneticCellElement.yesDisplay').length === 0){
                multiRecordCellDom.hide();
            } else {
                multiRecordCellDom.show();
            }
        });

        // there are two reasons we might want to NOT display a row.
        //   1) it is not one of our 'uniqueAnnotations' that the user has asked about
        //   2) it has no values that make the significance cut off


        // Loop once for each annotation
        _.forEach($('div.varAnnotation'),function(oneDiv){
            if (currentTableForm === 'variantTableVariantHeaders') {
                filterEpigeneticTableVariantsOnTop(oneDiv,blankRowsAreOkay,weAreInTissueMode,uniqueAnnotations,uniqueMethods,filterByGregor);
            } else  if (currentTableForm === 'variantTableAnnotationHeaders') {
                filterEpigeneticTableAnnotationsOnTop(oneDiv,blankRowsAreOkay,weAreInTissueMode,uniqueAnnotations,uniqueMethods,filterByGregor);
            } else {
                alert('illegal currentTableForm='+currentTableForm+'.');
            }
            // const currentAnnotation = extractClassBasedTrailingString(oneDiv,"annotationName_");
            // const currentMethod = extractClassBasedTrailingString(oneDiv,"methodName_");
            // let methodNameToProcess;
            // let annotationNameToProcess;
            // let isBlank;
            // if (currentTableForm === 'variantTableAnnotationHeaders'){
            //     methodNameToProcess = extractClassBasedTrailingString(oneDiv,"methodName_");
            //     annotationNameToProcess = extractClassBasedTrailingString(oneDiv,"annotationName_");
            //     isBlank = extractClassBasedTrailingString(oneDiv,"isBlank");
            //     // if the line is completely blank then we must hide it based on method name.  Otherwise we use annotation name
            // }
            //
            // let suppressRowDisplay = false;
            // if (!blankRowsAreOkay){
            //     if (currentTableForm === 'variantTableVariantHeaders'){ // If the variants are on top then we simply look for elements in the containing row
            //         suppressRowDisplay = ($(oneDiv).parent().parent().find('div.epigeneticCellElement.yesDisplay').length === 0);
            //     } else { // Otherwise we have to pull out the elements by name
            //         suppressRowDisplay = ($('#mainVariantDiv td div.epigeneticCellElement.yesDisplay.annotationName_'+annotationNameToProcess).length === 0);
            //     }
            //
            // }
            // if (weAreInTissueMode){
            //     if (currentTableForm === 'variantTableVariantHeaders') {
            //         if (suppressRowDisplay){
            //             $(oneDiv).parent().parent().addClass('doNotDisplay');
            //             $(oneDiv).parent().parent().hide();
            //         } else {
            //             $(oneDiv).parent().parent().show();
            //             $(oneDiv).parent().parent().removeClass('doNotDisplay');
            //         }
            //     } else  if (currentTableForm === 'variantTableAnnotationHeaders') {
            //         if (suppressRowDisplay){
            //             if (isBlank.length>0){
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.header').hide();
            //             } else {
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.header').hide();
            //             }
            //
            //         } else {
            //
            //             if (isBlank.length>0){
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().show();
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.header').show();
            //             } else {
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.varAllEpigenetics').parent().show();
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.header').show();
            //             }
            //
            //
            //         }
            //     }
            // } else {
            //     if ((_.includes(uniqueAnnotations,currentAnnotation))||
            //         (_.includes(uniqueMethods,currentAnnotation))){
            //
            //         if (currentTableForm === 'variantTableVariantHeaders') {
            //             if (suppressRowDisplay){
            //                 $(oneDiv).parent().parent().addClass('doNotDisplay');
            //                 $(oneDiv).parent().parent().hide();
            //             } else {
            //                 $(oneDiv).parent().parent().show();
            //                 $(oneDiv).parent().parent().removeClass('doNotDisplay');
            //             }
            //         } else  if (currentTableForm === 'variantTableAnnotationHeaders') {
            //             if (suppressRowDisplay){
            //                 if (isBlank.length>0){
            //                     $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                     $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.header').hide();
            //                 } else {
            //                     $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                     $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.header').hide();
            //                 }
            //
            //             } else {
            //
            //                 if (isBlank.length>0){
            //                     $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().show();
            //                     $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.header').show();
            //                 } else {
            //                     $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.varAllEpigenetics').parent().show();
            //                     $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.header').show();
            //                 }
            //
            //
            //             }
            //         }
            //
            //
            //     } else {
            //         if (currentTableForm === 'variantTableVariantHeaders') {
            //             $(oneDiv).parent().parent().addClass('doNotDisplay');
            //             $(oneDiv).parent().parent().hide();
            //         }
            //         else  if (currentTableForm === 'variantTableAnnotationHeaders') {
            //             if (isBlank.length>0){
            //                 //we have a header with one annotation but no table cells. This must mean that we had no data, this is a blank row, and we have to work strictly with the method
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                 $('#mainVariantDiv div.methodName_'+methodNameToProcess).parent('.header').hide();
            //             } else {
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.varAllEpigenetics').parent().hide();
            //                 $('#mainVariantDiv div.annotationName_'+annotationNameToProcess).parent('.header').hide();
            //             }
            //         }
            //
            //     }
            // }


        });

    };


    var refineTableRecords = function (whereTheTableGoes,datatable,headerType,adjustVisibilityCategories,headerSpecific,baseDomElement){
        if( typeof datatable === 'undefined'){
            console.log(" ERROR: failed to receive a valid datatable parameter");
        } else if (( typeof datatable.DataTable() === 'undefined') ||
            ( typeof datatable.DataTable().columns() === 'undefined') ||
            ( typeof datatable.DataTable().columns().header() === 'undefined') ) {
            console.log(" ERROR: invalid parameter in refineTableRecords");
        } else {
            var sharedTable = getSharedTable(whereTheTableGoes,baseDomElement);
            switch(headerType){
                case 'geneTableGeneHeaders':
                    if (headerSpecific){
                        setUpDraggable(whereTheTableGoes,baseDomElement);
                        $('div.geneName span.glyphicon-remove').show();
                    } else{
                        $('div.geneAnnotationShifters').hide ();
                        $('div.geneHeaderShifters').show ();

                        if ( typeof sharedTable.cellColoringScheme === 'undefined'){
                            sharedTable["cellColoringScheme"] = "Significance";
                        }
                        if (sharedTable["cellColoringScheme"]==="Records"){
                            $('div.tissueCategory_0').parents('td').css('background',CELL_COLORING_REDDISH_BOTTOM);
                            $('div.tissueCategory_1').parents('td').css('background',CELL_COLORING_REDDISH_TOP);
                            $('div.tissueCategory_2').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS1);
                            $('div.tissueCategory_3').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS2);
                            $('div.tissueCategory_4').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS3);
                            $('div.tissueCategory_5').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS4);
                            $('div.tissueCategory_6').parents('td').css('background',CELL_COLORING_UNUSED);

                        } else if (sharedTable["cellColoringScheme"]==="Significance"){
                            $('div.significanceCategory_0').parents('td').css('background',CELL_COLORING_BLUISH_BOTTOM);
                            $('div.significanceCategory_1').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS1);
                            $('div.significanceCategory_2').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS2);
                            $('div.significanceCategory_3').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS3);
                            $('div.significanceCategory_4').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS4);
                            $('div.significanceCategory_5').parents('td').css('background',CELL_COLORING_BLUISH_BOTTOM);
                            $('div.significanceCategory_6').parents('td').css('background',CELL_COLORING_UNUSED);
                        }
                        $('div.subcategory').css('font-weight','normal');
                        $('[data-toggle="popover"]').popover({
                            animation: true,
                            html: true,
                            template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                        });
                    }
                    break;
                case 'geneTableAnnotationHeaders':
                    if (headerSpecific){
                        setUpDraggable(whereTheTableGoes,baseDomElement);
                    }
                    else{
                        $('div.geneAnnotationShifters').show ();
                        $('div.geneHeaderShifters').hide ();

                        if ( typeof sharedTable.cellColoringScheme === 'undefined'){
                            sharedTable["cellColoringScheme"] = "Significance";
                        }
                        if (sharedTable["cellColoringScheme"]==="Records"){
                            $('div.tissueCategory_0').parents('td').css('background',CELL_COLORING_REDDISH_BOTTOM);
                            $('div.tissueCategory_1').parents('td').css('background',CELL_COLORING_REDDISH_TOP);
                            $('div.tissueCategory_2').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS1);
                            $('div.tissueCategory_3').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS2);
                            $('div.tissueCategory_4').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS3);
                            $('div.tissueCategory_5').parents('td').css('background',CELL_COLORING_REDDISH_TOP_MINUS4);
                            $('div.tissueCategory_6').parents('td').css('background',CELL_COLORING_UNUSED);

                        } else if (sharedTable["cellColoringScheme"]==="Significance"){
                           $('div.significanceCategory_0').parents('td').css('background',CELL_COLORING_BLUISH_BOTTOM);
                            $('div.significanceCategory_1').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS1);
                            $('div.significanceCategory_2').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS2);
                            $('div.significanceCategory_3').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS3);
                            $('div.significanceCategory_4').parents('td').css('background',CELL_COLORING_BLUISH_TOP_MINUS4);
                            $('div.significanceCategory_5').parents('td').css('background',CELL_COLORING_BLUISH_BOTTOM);
                            $('div.significanceCategory_6').parents('td').css('background',CELL_COLORING_UNUSED);
                        }
                        $('div.subcategory').css('font-weight','bold');
                        $('th>div>a[data-toggle="popover"]').hide();
                        $('div.geneName span.glyphicon-remove').hide();
                    }
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
                        $('td div.variantHeaderShifters').hide();
                        if ( typeof sharedTable.cellColoringScheme === 'undefined'){
                            sharedTable["cellColoringScheme"] = "sortfield";
                        }
                        $('td:has(div.variantAnnotation.emphasisSwitch_true)').addClass('emphasisSwitch_true');
                        // $('div.variantAnnotation:last').parent().parent().children('td').css('border-bottom','2px solid black');
                        // $('div.variantAnnotation:not(:last)').parent().parent().children('td').css('border-bottom','0.5px solid #ccc');
                        $('div.phenotypeRelatedData').parent().css('background','#eee');

                         // collapse first cell across all 'Annotation' rows
                        _.forEach($('div.annotationLabel'), function(domElement,index){
                            if (index===0){
                                $(domElement).parent().prop('rowspan',$('div.annotationLabel').length);
                            } else {
                                $(domElement).parent().hide();
                            }
                        });

                        // collapse first cell across all 'Association' rows
                        _.forEach($('div.associationLabel'), function(domElement,index){
                            if (index===0){
                                $(domElement).parent().prop('rowspan',$('div.associationLabel').length);
                            } else {
                                $(domElement).parent().hide();
                            }
                        });
                    }

                    setUpDraggable(whereTheTableGoes,baseDomElement);
                    filterEpigeneticTable(whereTheTableGoes,false,baseDomElement);
                    break;
                case 'variantTableAnnotationHeaders':
                    if (headerSpecific) {

                    } else {
                        _.forEach($('table.variantTableHolder div.variantHeaderHolder'),function(o,columnIndex){ //  make nice headers out of VAR_IDs
                            var domElement = $(o);
                            var headerName = domElement.text().trim();
                            if ((headerName.length >  5) &&
                                (headerName.split('_').length === 4)) {
                                var partsOfId = headerName.split('_');
                                domElement.addClass("niceHeadersThatAreLinks");
                                domElement.addClass("headersWithVarIds");
                                domElement.attr("defrefa", partsOfId[2]);
                                domElement.attr("defeffa", partsOfId[3]);
                                domElement.attr("chrom", partsOfId[0]);
                                domElement.attr("position", partsOfId[1]);
                                domElement.attr("varid", partsOfId[0] + ":" + partsOfId[1] + "_" +
                                    partsOfId[2] + "/" + partsOfId[3]);
                                domElement.attr("data-toggle", "popover");

                            }
                        });
                        $('div.phenotypeRelatedData').parent().css('background','#eee');
                        $('td div.variantHeaderShifters').hide();
                        if ( typeof sharedTable.cellColoringScheme === 'undefined'){
                            sharedTable["cellColoringScheme"] = "sortfield";
                        }
                        $('td:has(div.variantAnnotation.emphasisSwitch_true)').addClass('emphasisSwitch_true');
                        // $('div.variantAnnotation:last').parent().parent().children('td').css('border-bottom','2px solid black');
                        filterEpigeneticTable(whereTheTableGoes,false,baseDomElement);
                    }

;
                    adjustTableWrapperWidth("table.variantTableHolder");
                    break;
                case 'fegtAnnotationHeaders':
                    if (headerSpecific){
                        var compressedGroups = sharedTable.getAllCompressedGroups();

                        _.forEach(compressedGroups,function(groupspecifier){
                            var domspecCollapse = "span."+groupspecifier.groupName+" span.collapse-trigger";
                            var domspecExpand = "span."+groupspecifier.groupName+" span.expand-trigger";
                            var domspecGroupHelpText = "span."+groupspecifier.groupName+".groupHelpText";
                            var domspecColumnHelpText = "span."+groupspecifier.groupName+".columnHelpText";
                            if (groupspecifier.expansionPossible){
                                $(domspecCollapse).hide();
                                $(domspecExpand).show();
                                $("span."+groupspecifier.groupName+".groupDisplayName").show();
                                $("span."+groupspecifier.groupName+".columnDisplayName").hide();
                                $(domspecGroupHelpText).show();
                                $(domspecColumnHelpText).hide();
                            } else {
                                $(domspecCollapse).hide();
                                $(domspecExpand).hide();
                                $(domspecGroupHelpText).hide();
                                $(domspecColumnHelpText).show();
                            }


                        });

                        $('[data-toggle="popover"]').popover();

                    }
                    adjustTableWrapperWidth("table.fullEffectorGeneTableHolder");
                    break;


                case 'tissueTableTissueHeaders':
                    adjustTableWrapperWidth("table.tissueTableHolder");
                    break;
                case 'tissueTableMethodHeaders':
                    $('[data-toggle="popover"]').popover({
                        animation: true,
                        html: true,
                        template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                    });
                    if (headerSpecific){
                    //    setUpDraggable(whereTheTableGoes,baseDomElement);
                    }
                    break;


                default:
                    break;
            }
        }
    };

    /***
     * find the last part of a class name if we know the prefix
     *
     * @param domString
     * @param classNameToExtract
     * @returns {string}
     */
    var extractClassBasedTrailingString = function (domString,classNameToExtract) {
        let stringToExtract = "";
        const classes = $(domString).attr("class");
        if ( typeof classes !== 'undefined'){
            const classList = classes.split(/\s+/);
            _.forEach(classList, function (oneClass) {
                if (oneClass.substr(0, classNameToExtract.length) === classNameToExtract) {
                    stringToExtract = oneClass.substr(classNameToExtract.length);
                }
            });
        }
        return stringToExtract;
    };

    /***
     * find the last part of a class name if we know the prefix, aand if we know that the last part is an integer
     * @param domString
     * @param classNameToExtract
     * @returns {number}
     */
    var extractClassBasedIndex = function (domString,classNameToExtract) {
        let numberToExtract = -1;
        const stringExtracted = extractClassBasedTrailingString(domString,classNameToExtract);
        if (stringExtracted.length > 0){
            numberToExtract = parseInt(stringExtracted);
        }
        return numberToExtract;
    };



    var displayCategoryHtml = function (dataAnnotationCode,indexInOneDimensionalArray, baseDomElement){
        var displayDetails = getDatatypeInformation( dataAnnotationCode, baseDomElement );
        displayDetails["indexInOneDimensionalArray"]=indexInOneDimensionalArray;
        var returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.categoryWriter)[0].innerHTML,displayDetails);
        return returnValue;
    }
    var displaySubcategoryHtml = function (dataAnnotationCode,indexInOneDimensionalArray, baseDomElement){
        var displayDetails = getDatatypeInformation( dataAnnotationCode, baseDomElement );
        displayDetails["indexInOneDimensionalArray"]=indexInOneDimensionalArray;
        var returnValue = Mustache.render($('#'+displayDetails.dataAnnotation.subCategoryWriter)[0].innerHTML,displayDetails);
        return returnValue;
    }



    var addContentToTable = function (  whereTheTableGoes,
                                        rowsToAdd,
                                        storeRecordsInDataStructure,
                                        typeOfRecord,
                                        prependColumns,
                                        blankRowsAreAcceptable,
                                        baseDomElement){
        var rememberCategories = [];
        _.forEach(rowsToAdd, function (row,newRowCount) {
            if ( !_.includes (rememberCategories,row.category)) {
                rememberCategories.push(row.category);
            } else if ( !_.includes (rememberCategories,row.subcategory)) {
                rememberCategories.push(row.subcategory);
            }
            var dyanamicUiVariables = getAccumulatorObject(undefined, baseDomElement);
            var numberOfExistingRows = $(whereTheTableGoes).dataTable().DataTable().rows()[0].length+1;
            var sharedTable = getAccumulatorObject("sharedTable_"+whereTheTableGoes,baseDomElement);
            var numberOfColumns  = sharedTable.numberOfColumns;
            var rowDescriber = [];
            var numberOfColumnsAdded = 0;
            var indexInOneDimensionalArray;
            if (prependColumns){
                 switch (typeOfRecord) {
                    case 'geneTableGeneHeaders':
                        indexInOneDimensionalArray = (numberOfExistingRows*numberOfColumns);
                        rowDescriber.push( new IntermediateStructureDataCell(row.category,
                            displayCategoryHtml(row.code,indexInOneDimensionalArray,baseDomElement),
                            row.subcategory+" categoryNameToUse","LIT")) ;
                        indexInOneDimensionalArray++;
                        rowDescriber.push( new IntermediateStructureDataCell(row.subcategory,
                            displaySubcategoryHtml(row.code,indexInOneDimensionalArray,baseDomElement),
                            "insertedColumn2","LIT"));
                        numberOfColumnsAdded += rowDescriber.length;
                        break;
                    case 'variantTableVariantHeaders':
                        indexInOneDimensionalArray = (numberOfExistingRows*numberOfColumns);
                        var primarySortField =  ( typeof row.sortField === 'undefined') ? row.category : row.sortField;
                        rowDescriber.push( new IntermediateStructureDataCell(row.category,
                            displayCategoryHtml(row.code,indexInOneDimensionalArray,baseDomElement),
                            row.subcategory,"LIT"));
                        indexInOneDimensionalArray++;
                        rowDescriber.push( new IntermediateStructureDataCell(row.subcategory,
                            displaySubcategoryHtml(row.code,indexInOneDimensionalArray,baseDomElement),
                            "insertedColumn2","LIT"));
                        numberOfColumnsAdded += rowDescriber.length;
                        break;
                     case 'tissueTableTissueHeaders':
                         indexInOneDimensionalArray = (numberOfExistingRows*numberOfColumns);
                         var datatypeClassIdentifier;
                         if (row.code === 'TITA'){
                             datatypeClassIdentifier =  "gregorValuesInTissueTable";
                         } else if (row.code === 'LDSR'){
                             datatypeClassIdentifier =  "ldsrValuesInTissueTable";
                         } else if (row.code === 'DEP_TI'){
                             datatypeClassIdentifier =  "depictTissueValuesInTissueTable";
                         }
                         rowDescriber.push( new IntermediateStructureDataCell(row.category,
                             displaySubcategoryHtml(row.code,indexInOneDimensionalArray,baseDomElement),
                             row.subcategory+" tissueTableHeader "+datatypeClassIdentifier,"LIT")) ;
                         indexInOneDimensionalArray++;
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
                            numberOfColumns,
                            baseDomElement );
                    }
                });



            }
            _.forEach(rowDescriber, function(oneRow,columnIndex){
                if ( !_.includes (rememberCategories,oneRow.title)) {
                    rememberCategories.push(oneRow.title);
                }
            });

            var weHaveDataWorthDisplaying = false;
            _.forEach(row.columnCells, function (val, index) {
                    var valContent =  getDisplayableCellContent(val,baseDomElement);
                    var initialLinearIndex = extractClassBasedIndex(valContent,"initialLinearIndex_");
                    if (initialLinearIndex === -1){ // no index assigned.  add one
                        indexInOneDimensionalArray = (numberOfExistingRows*numberOfColumns)+index + numberOfColumnsAdded;
                        if (val.dataAnnotationTypeCode==='LIT'){// literals are handled differently than everything else
                            val.renderData = $(val.renderData).removeClass('initialLinearIndex_').addClass('initialLinearIndex_'+indexInOneDimensionalArray)[0].outerHTML;
                        } else {
                            val.renderData['initialLinearIndex'] = "initialLinearIndex_"+indexInOneDimensionalArray;
                        }
                    }
                    rowDescriber.push(val);
                var domContent = $(valContent);
                if ((!weHaveDataWorthDisplaying)&&
                    (domContent.text().trim().length>0)){
                    weHaveDataWorthDisplaying = true;
                }
                if (storeRecordsInDataStructure){
                    storeCellInMemoryRepresentationOfSharedTable(whereTheTableGoes,
                        val,
                        'content',
                        numberOfExistingRows,
                        index + numberOfColumnsAdded,
                        numberOfColumns,
                        baseDomElement );
                }
            });
            // push the data into the table if we have at least one cell that contains text
            if ((blankRowsAreAcceptable)||(weHaveDataWorthDisplaying)){
                var revisedRowDescriber = rowDescriber;
                if (dyanamicUiVariables.dynamicTableConfiguration.formOfStorage ==='loadOnce') {
                    // what we display and what we store may be different in the static case
                    //
                    // let's restrict the headers based on our notion of which columns we want to see
                    revisedRowDescriber = mpgSoftware.matrixMath.deleteColumnsInDataStructure(rowDescriber,1,rowDescriber.length,
                        sharedTable.getAllColumnsToExclude()).dataArray;
                }
                // adding data starts a sort, and we have to pass in the sort parameter is a global variable
                setCurrentSortRequest(getAccumulatorObject("currentSortRequest",baseDomElement));

                $(whereTheTableGoes).dataTable().fnAddData(_.map(revisedRowDescriber,function(o){return getDisplayableCellContent(o,baseDomElement)}));

            }


        });
        return rememberCategories;
    }




    var buildOrExtendDynamicTable = function (whereTheTableGoes, // DOM specification for the table
                                              intermediateStructure, // everything we need to display one or more rows/headers
                                              storeRecords, // the store records for later recall
                                              typeOfRecord, // describes particular table and orientation
                                              prependColumns, // add some label columns?
                                              blankRowsAreAcceptable,
                                              baseDomElement ) { // allow a row with nothing in it, or suppress it?
        var datatable;

        if (( typeof intermediateStructure !== 'undefined') &&
            ( typeof intermediateStructure.headers !== 'undefined') &&
            (intermediateStructure.headers.length > 0)){
                datatable = buildHeadersForTable(   whereTheTableGoes,
                                                    intermediateStructure.headers,
                                                    storeRecords,
                                                    typeOfRecord,
                                                    prependColumns,
                                                    [],
                                                    baseDomElement);
                refineTableRecords(whereTheTableGoes,datatable,typeOfRecord,[], true,
                    baseDomElement);
        }


        if (( typeof intermediateStructure.rowsToAdd !== 'undefined') &&
            (intermediateStructure.rowsToAdd.length > 0)){
            try{
                datatable =  $(whereTheTableGoes).dataTable();
                var rememberCategories = addContentToTable( whereTheTableGoes,
                    intermediateStructure.rowsToAdd,
                    storeRecords,
                    typeOfRecord,
                    prependColumns,
                    blankRowsAreAcceptable,
                    baseDomElement );
                refineTableRecords(whereTheTableGoes,datatable,typeOfRecord,rememberCategories, false,
                    baseDomElement);
            } catch(e){

            }


        }


    };


 var formConversionOfATranspose = function (originalForm){
     var currentForm = "";
     switch (originalForm){
         case 'geneTableGeneHeaders':
             currentForm = 'geneTableAnnotationHeaders';
             break;
         case 'geneTableAnnotationHeaders':
             currentForm = 'geneTableGeneHeaders';
             break;

         case 'variantTableVariantHeaders':
             currentForm = 'variantTableAnnotationHeaders';
             break;
          case 'variantTableAnnotationHeaders':
             currentForm = 'variantTableVariantHeaders';
             break;

         case 'fegtAnnotationHeaders':
             currentForm = 'fegtGeneNameHeaders';
             break;
         case 'fegtGeneNameHeaders':
             currentForm = 'fegtAnnotationHeaders';
             break;
         case 'tissueTableTissueHeaders':
             currentForm = 'tissueTableMethodHeaders';
             break;
         case 'tissueTableMethodHeaders':
             currentForm = 'tissueTableTissueHeaders';
             break;


         default:
             console.log("CRITICAL ERROR: unrecognized table form = "+ originalForm +"." );

     }
     return currentForm;
 }


    /***
     * This operation can extract everything that's in the table in the form of HTML.  However we store a little additional information
     * about each cell as well, and this is particularly useful when a cell becomes a header upon transposition. Can we put an index
     * on every cell that would allow us to match it up with the original information that we store?
     *
     * @param whereTheTableGoes
     * @returns {Array}
     */
    var extractSortedDataFromTable = function (whereTheTableGoes,
                                               numberOfRows,
                                               numberOfColumns,
                                               tableAndOrientation,
                                               baseDomElement) {
        var returnValue = [];
        if  ($.fn.DataTable.isDataTable( whereTheTableGoes )){
            var dataTable = $(whereTheTableGoes).dataTable().DataTable();
            if (dataTable.table().columns().length>0){
                var fullDataVector = [];
                var numberOfHeaders = dataTable.table().columns()[0].length;
                _.each(_.range(0,numberOfHeaders),function(index){
                    var header=dataTable.table().column(index).header();
                    var divContents;
                    if ( typeof header.children[0] === 'undefined'){
                        // I'm completely unclear about why this special case is required.  It seems as if the first header in
                        // the gene table has no div.  But why?  All the other headers have DIVs.  Here's a workaround until I can figure it out.
                        divContents = '<div class="initialLinearIndex_0 geneFarLeftCorner">category X</div>'
                    } else {
                        divContents = header.children[0].outerHTML;
                    }
                    fullDataVector.push(divContents);
                });
                if (tableAndOrientation ==='variantTableAnnotationHeaders'){// in this case we collapse the first row into the header, so we now need to re-extract it into data
                    _.each(_.range(0,numberOfHeaders),function(index){
                        var header=dataTable.table().column(index).header();
                        fullDataVector.push(header.children[1].outerHTML);
                    });
                }
                if (tableAndOrientation ==='geneTableAnnotationHeaders'){// in this case we collapse the first row into the header, so we now need to re-extract it into data
                    _.each(_.range(0,numberOfHeaders),function(index){
                        var header=dataTable.table().column(index).header();
                        fullDataVector.push(header.children[1].outerHTML);
                    });
                }
                var dataFromTable = dataTable.rows().data();
                _.forEach(dataFromTable, function (row, rowIndex) {
                    _.forEach(row, function (cell, columnIndex) {
                        fullDataVector.push(cell);
                    });
                });
                var sharedTable = getAccumulatorObject("sharedTable_"+whereTheTableGoes,baseDomElement);
                _.forEach(fullDataVector,function(oneCell){
                    var initialLinearIndex = extractClassBasedIndex(oneCell,"initialLinearIndex_");
                    var associatedData = _.find(sharedTable.dataCells,{ascensionNumber:initialLinearIndex})
                    if ( typeof  associatedData === 'undefined'){
                        console.log("Could not find data cell="+initialLinearIndex+".")
                    }
                    returnValue.push(associatedData);
                });
            }

        }
        return returnValue;
    };


    var retrieveSortedDataForTable = function (whereTheTableGoes,baseDomElement) {
        var returnValue;
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes,baseDomElement);
        const dyanamicUiVariables = getAccumulatorObject(undefined, baseDomElement);
        var sortedData;
        if (dyanamicUiVariables.dynamicTableConfiguration.formOfStorage ==='loadOnce') { // get the table straight from memory
            sortedData =sharedTable.dataCells;
            returnValue = new mpgSoftware.matrixMath.Matrix(sortedData,
                                                                sharedTable.numberOfRows,
                                                                sharedTable.numberOfColumns);
        }else{ // collect the table cells dynamically from the on-screen presentation of the table
            sortedData = extractSortedDataFromTable(whereTheTableGoes,
                                                    sharedTable.matrix.numberOfRows,
                                                    sharedTable.matrix.numberOfColumns,
                                                    sharedTable.currentForm,
                                                    baseDomElement );
            returnValue = new mpgSoftware.matrixMath.Matrix( sortedData,
                                                                sharedTable.matrix.numberOfRows,
                                                                sharedTable.matrix.numberOfColumns);

        }
        return returnValue;
    }




    var getArrayOfRowHeaders = function (whereTheTableGoes,baseDomElement) {
        return mpgSoftware.matrixMath.getRowHeaders(retrieveSortedDataForTable(whereTheTableGoes,baseDomElement));
    };


    var getArrayOfColumnHeaders = function (whereTheTableGoes,baseDomElement) {
        return mpgSoftware.matrixMath.getColumnHeaders(retrieveSortedDataForTable(whereTheTableGoes,baseDomElement));
    };



    var linearDataTransposor = function (linearArray,numberOfRows,numberOfColumns,mapper){
        var temporaryArray = [];
        _.forEach(linearArray, function (oneCell, linearIndex){
            var xIndex = linearIndex%numberOfColumns;
            //var yIndex = linearIndex%numberOfRows;
            var yIndex = Math.floor(linearIndex/numberOfRows);
            var newIndex = mapper(xIndex,yIndex,numberOfRows,numberOfColumns);//(yIndex*numberOfRows)+xIndex;
            temporaryArray.push({newIndex:newIndex,cell: oneCell});
        });
        var nowTransposed = _.sortBy(temporaryArray,['newIndex']);
        return _.map(nowTransposed,'cell');
    };


    var retrieveTransposedDataForThisTable =  function (whereTheTableGoes, baseDomElement) {
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes, baseDomElement);
        var sortedData = retrieveSortedDataForTable(whereTheTableGoes, baseDomElement);
        return new mpgSoftware.matrixMath.Matrix(
            linearDataTransposor(sortedData.dataArray, sharedTable.matrix.numberOfRows, sharedTable.matrix.numberOfColumns, function (x, y, rows, cols) {
                return (x * cols) + y
            }), sharedTable.matrix.numberOfColumns, sharedTable.matrix.numberOfRows);
    }



    /***
     *   Give this function a table, and it will transpose it.  The basic parts of this routine are:
     *     Look at the current form, and decide whether we need to switch the number of cols and rows
     *     Once we know, then pull all the data (including headers) out of the Jquery datatable. This gives us the cells and their sorted order
     *     Use the sorted cell information to retrieve the original data in each cell from a place where we stored it. (extractSortedDataFromTable)
     *     Destroy the old table
     *     Now we have the data from the original table data. Transpose it using linearDataTransposor
     *     Build the new table
     *
     * @param whereTheTableGoes
     */
    var transposeThisTable = function (whereTheTableGoes,baseDomElement) {
        var sharedTable = getSharedTable(whereTheTableGoes,baseDomElement);

        sharedTable['matrix'] = retrieveTransposedDataForThisTable(whereTheTableGoes, baseDomElement);
        sharedTable['currentForm'] = formConversionOfATranspose(sharedTable.currentForm);

        destroySharedTable(whereTheTableGoes,baseDomElement);

        rebuildTableOnPageFromMatrix(sharedTable['matrix'],sharedTable.currentForm,whereTheTableGoes,baseDomElement);

    };

    /***
     * The variant table needs to have a variety of different forms. Can make a way to swap between them:
     *    formSwitch=1 : toggle between displaying epigenetic data
     *
     *    sharedTable['currentFormVariation'] :
     *       1 = epigenetic data is hidden
     *       2 = epigenetic data is displayed
     *
     * @param whereTheTableGoes
     * @param formVariation
     */
    var reviseDisplayOfVariantTable = function (whereTheTableGoes,formSwitch,originatingObject) {
        alert("reviseDisplayOfVariantTable is no longer used");
     };






    var rebuildTableOnPageFromMatrix = function (matrix,currentForm,whereTheTableGoes,baseDomElement){
        //  Now we should be all done fiddling with the data order.
        var additionalDetailsForHeaders = [];
        var currentLocationInArray = 0;
        var headers = _.slice(matrix.dataArray, currentLocationInArray, matrix.numberOfColumns);
        let blankRowsAreOkay = true;
        currentLocationInArray += matrix.numberOfColumns;
        if (currentForm === 'variantTableAnnotationHeaders') { // collapse the first row into the header
            additionalDetailsForHeaders = _.slice(matrix.dataArray, currentLocationInArray,
                (currentLocationInArray + matrix.numberOfColumns));
            currentLocationInArray += matrix.numberOfColumns;
            blankRowsAreOkay = ($('#displayBlankRows').is(":checked"));
        }
        if (currentForm === 'geneTableAnnotationHeaders') { // collapse the first row into the header
            additionalDetailsForHeaders = _.slice(matrix.dataArray, currentLocationInArray,
                (currentLocationInArray + matrix.numberOfColumns));
            currentLocationInArray += matrix.numberOfColumns;
        }
        var datatable = buildHeadersForTable(   whereTheTableGoes,
                                                headers,
                                                false,
                                                currentForm,
                                                false,
                                                additionalDetailsForHeaders,
                                                baseDomElement );
        refineTableRecords(whereTheTableGoes,datatable, currentForm, [], true,baseDomElement);

        // build the body
        var rowsToAdd = [];
        var content = _.slice(matrix.dataArray, currentLocationInArray);

        _.forEach(content, function (datacell, index) {
            var modulus = index % matrix.numberOfColumns;
            if (modulus === 0) {
                rowsToAdd.push({category: datacell.title, columnCells: new Array()});
            }
            var lastRow = rowsToAdd[rowsToAdd.length - 1];
            return lastRow.columnCells.push(datacell);
        });
        datatable = $(whereTheTableGoes).dataTable();
        var rememberCategories = addContentToTable( whereTheTableGoes,
                                                    rowsToAdd,
                                                    false,
                                                    currentForm,
                                                    false,
                                                    blankRowsAreOkay,
                                                    baseDomElement );
        refineTableRecords(whereTheTableGoes,datatable, currentForm, rememberCategories, false,baseDomElement);
    }



    var  dataTableZoomSet =    function (TGWRAPPER,TGZOOM) {
        $(TGWRAPPER).find(".dataTables_wrapper").removeClass("dk-zoom-0 dk-zoom-1 dk-zoom-2 dk-zoom-3 dk-zoom-4 dk-zoom-5 dk-zoom-6").addClass("dk-zoom-"+TGZOOM);
    }
    var  dataTableZoomDynaSet =    function (zoomWrapper,getBigger,event) {
        if ( typeof event !== 'undefined'){
            event.stopPropagation();
        }
        if (typeof $(zoomWrapper).data("zoomParmHolder") === 'undefined') {
            $(zoomWrapper).data("zoomParmHolder",1);
        }
        var currentSize = $(zoomWrapper).data("zoomParmHolder");
        if (getBigger) {
            if (currentSize > 0){
                currentSize--;
            }
        } else {
            if (currentSize < 6){
                currentSize++;
            }
        }
        $(zoomWrapper).data("zoomParmHolder",currentSize);

        $(zoomWrapper).find(".dataTables_wrapper").removeClass("dk-zoom-0 dk-zoom-1 dk-zoom-2 dk-zoom-3 dk-zoom-4 dk-zoom-5 dk-zoom-6").addClass("dk-zoom-"+currentSize);

    }



    var destroySharedTable = function (whereTheTableGoes) {
        if ( $.fn.DataTable.isDataTable( whereTheTableGoes ) ) {
            var datatable = $(whereTheTableGoes).dataTable();
            try{
                datatable.fnDestroy(false);
            } catch (e){
                // this routine throws a JavaScript error, but doesn't seem to indicate any trouble
            }
            $(whereTheTableGoes).empty()
        }
    };



    var displayTissuesForAnnotation = function (annotationId,nameOfAccumulatorObject,tableToUpdate){
        alert('displayTissuesForAnnotation is not used anymore?');
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
        alert('hideTissuesForAnnotation is not used anymore?');
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





    var retrieveGwasCodingCredibleSetFromServer = function(event){
        var dataTarget = $(event.target).attr('data-target').substring(1).trim();
        if (dataTarget.indexOf("gwasCoding_")>=0){
            var geneName = dataTarget.substring("gwasCoding_".length);
            var uniqueId  = dataTarget+'_uniquifier';
            var additionalParameters = getAccumulatorObject(undefined, '#mainTissueDiv');
            var dataSaver = [];
            $.ajax({
                cache: false,
                type: "post",
                url: additionalParameters.getVariantsForNearbyCredibleSetsUrl,
                data: {
                    gene: geneName,
                    phenotype: 'T2D'
                },
                async: true
            }).done(function (data, textStatus, jqXHR) {
                mpgSoftware.dynamicUi.fullEffectorGeneTable.processRecordsFromGetData(data,dataSaver);
                var tissueTranslations = [];
                if (dataSaver.length>0){
                    tissueTranslations = dataSaver[0].TISSUE_TRANSLATIONS;
                }
                var sortedDisplayableRecords;
                var uniqueCodingSetIds;
                var credibleSetsWithCodingVariants=[];
                    // figure out which credible sets have a coding variant
                _.forEach(dataSaver,function(allRecords) {
                    if (allRecords.posteriorsAvailable){
                        var codingSets = _.map(_.filter(allRecords.contents, function (o) {
                            return o.mds < 3;
                        }), function (recToKeep) {
                            return recToKeep.credibleSetId;
                        });
                        uniqueCodingSetIds = _.uniq(codingSets);
                        credibleSetsWithCodingVariants = _.filter(allRecords.contents, function (o) {
                            return ($.inArray(o.credibleSetId, uniqueCodingSetIds)!== -1);
                        });
                    }
                });
                _.forEach(dataSaver,function(allRecords){
                    sortedDisplayableRecords = _.map(_.orderBy(credibleSetsWithCodingVariants,['posteriorProbability','pValue'],['desc','asc']),function(record){
                        return { varId:record.varId,
                            credibleSetId: record.credibleSetId,
                            pValue: UTILS.realNumberFormatter(""+record.pValue),
                            coding:(record.mds<=2)?'yes':'',
                            posteriorProbability: UTILS.realNumberFormatter(""+record.posteriorProbability) };
                    })
                });
                $('#'+uniqueId).empty().append(Mustache.render($('#fillUpTheCodingGwasCredibleSet')[0].innerHTML,
                    {variantsExist:(sortedDisplayableRecords.length>0)?[1]:[],
                        variants:sortedDisplayableRecords}
                ));

            }).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                alert("Ajax call failed, url="+rememberUrl+", data="+rememberData+".");
                core.errorReporter(jqXHR, errorThrown)
            })

        }
        return;
    };









    var retrieveDataFromServer = function(event){
        var dataTarget = $(event.target).attr('data-target').substring(1).trim();
        if (dataTarget.indexOf("geneBurdenTest_")>=0){
            var geneName = dataTarget.substring("geneBurdenTest_".length);
            var uniqueId  = dataTarget+'_uniquifier';
            var additionalParameters = getAccumulatorObject(undefined, '#mainTissueDiv');
            var dataSaver = [];
            $.ajax({
                cache: false,
                type: "post",
                url: additionalParameters.retrieveGeneLevelAssociationsUrl,
                data: {
                    gene: geneName,
                    phenotype: 'T2D',
                    propertyNames: "[\"P_VALUE\"]",
                    preferredSampleGroup: "ExSeq_52k"
                },
                async: true
            }).done(function (data, textStatus, jqXHR) {
                mpgSoftware.dynamicUi.geneBurdenSkat.processGeneSkatAssociationRecords(data,dataSaver);
                var tissueTranslations = [];
                if (dataSaver.length>0){
                    tissueTranslations = dataSaver[0].TISSUE_TRANSLATIONS;
                }
                var sortedDisplayableRecords;
                _.forEach(dataSaver,function(allRecords){
                    sortedDisplayableRecords = _.map(_.sortBy(_.filter(allRecords.tissues,function(t){return t.tissue.includes("FIRTH")}),['value']),function(tissueRecord){
                        return {  tissueName:  translateATissueName(tissueTranslations,tissueRecord.tissue),
                            tissue: tissueRecord.tissue,
                            value: UTILS.realNumberFormatter(""+tissueRecord.value),
                            numericalValue: tissueRecord.value };
                    })
                });
                $('#'+uniqueId).empty().append(Mustache.render($('#fillUpTheGeneBurdenSpecifics')[0].innerHTML,
                    {tissuesExist:(sortedDisplayableRecords.length>0)?[1]:[],
                        tissues:sortedDisplayableRecords}
                ));

            }).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                alert("Ajax call failed, url="+rememberUrl+", data="+rememberData+".");
                core.errorReporter(jqXHR, errorThrown)
            })

        }
        return;
    };




    /***
     * helper function for showAttachedData.  This one creates a nice big D3 graphic.  I built it for ABC data, but it should work
     * equally well whenever you have multiple regions that influence the expression of a gene
     *
     * @param event
     * @returns {string}
     */
    var createOutOfRegionGraphic = function (event){
        var dataTarget = $(event.target).attr('data-target').substring(1).trim();
        if (dataTarget.indexOf("tissues_")>=0){
            var geneName = dataTarget.substring("tissues_".length);
            var uniqueId  = dataTarget+'_uniquifier';
            buildRegionGraphic('#'+uniqueId,'#'+uniqueId,'#tissues_'+geneName);
        }
        return "";
    };

    /***
     * helper function for showAttachedData
     *
     * @param event
     * @returns {*|jQuery}
     */
    var extractStraightFromTarget = function (event){
        var dataTarget = $(event.target).attr('data-target').substring(1).trim();
        return $("#"+dataTarget).html();
    };

    /***
     * click handler for the cells in the dynamic UI tables.  Note that I pass in a function as an argument to help showAttachedData
     * to provide exactly the sort of drill down display we need
     *
     * @param event
     * @param title
     * @param functionToGenerateContents
     */
    var showAttachedData = function( event, title, functionToGenerateContents) {
        var dataTarget = $(event.target).attr('data-target').substring(1).trim();
        var uniqueId  = dataTarget+'_uniquifier';


        if($(".dk-new-ui-data-wrapper.wrapper-"+dataTarget).length) { // if we already have a window then get rid of it.
            $(".dk-new-ui-data-wrapper.wrapper-"+dataTarget).remove();
        } else {
            var dataWrapper = '<div class="dk-new-ui-data-wrapper wrapper-'+dataTarget+'"><div class="closer-wrapper" style="text-align: center;"><span style="">'+title+
                '</span><span style="float:right; font-size: 12px; color: #888;" onclick="mpgSoftware.dynamicUi.removeWrapper(event);" class="glyphicon glyphicon-remove" aria-hidden="true">\n' +
                '</span></div><div class="content-wrapper" id="'+uniqueId+'"></div></div>';
            $('body').append(dataWrapper);  // add the div to the DOM
            var dataTargetContent = functionToGenerateContents(event);  // either gather data, and append it, or else insert it right into the div.
            $('#'+uniqueId).append(dataTargetContent);

            // we have two kinds of drill down graphics at this point, one of which is a table and one of which is a D3 graphic.  Let's look for
            //  the table, and if it doesn't exist then extract the size from the presumed SVG element
            var holderElement = $(".dk-new-ui-data-wrapper.wrapper-"+dataTarget);
            var contentWidth = 0;
            var contentHeight = 0;
            if (holderElement.find("table").length>0){
                contentWidth = holderElement.find("table").width();
                contentHeight = holderElement.find("table").height();
                contentWidth = (contentWidth > 350)? 350 : contentWidth + 25;
                contentHeight = (contentHeight > 300)? 300 : contentHeight + 25;
            } else {
                contentWidth = holderElement.find("svg").width()+25;
                contentHeight = holderElement.find("svg").height()+95;
            }

            var divTop = $(event.target).offset().top;
            var divLeft = $(event.target).offset().left + $(event.target).width();

            $(".dk-new-ui-data-wrapper.wrapper-"+dataTarget).find(".content-wrapper").css({"width":"100%", "height":"100%"});
            $(".dk-new-ui-data-wrapper.wrapper-"+dataTarget).css({"top":divTop,"left":divLeft});

            $(".dk-new-ui-data-wrapper").draggable({ handle:".closer-wrapper"});
            $(".dk-new-ui-data-wrapper").resizable({});
        }


    };


    var removeWrapper = function ( event ) {
        $(event.target).parent().parent().remove();
    };


    var setColorButtonActive = function(event,DEACTIVATE,whereTheTableGoes,baseDomElement) {
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes,baseDomElement);
        sharedTable["cellColoringScheme"] = event.target.textContent.trim();
        if ($(event.target).hasClass("active")) {
            $(event.target).removeClass("active");
        } else {
            $(event.target).addClass("active");
        }

        $.each(DEACTIVATE, function(index,value) {
            var className = "." + value;
            var idName = "#" + value;

            if ($(className).length) { $("button"+className).removeClass("active") }
            if ($(idName).length) { $("button"+className).removeClass("active") }
        });
        redrawTableOnClick('table.combinedGeneTableHolder',function(sortedData, numberOfRows, numberOfColumns){
            return mpgSoftware.matrixMath.doNothing (sortedData, numberOfRows, numberOfColumns);
        },{},baseDomElement);
        refineTableRecords(whereTheTableGoes,$(whereTheTableGoes).dataTable(),sharedTable.currentForm,[],false,baseDomElement);
    }




    var redrawTableOnClick = function (whereTheTableGoes, manipulationFunction, manipulationFunctionArgs,baseDomElement ) {
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes,baseDomElement);
        var dyanamicUiVariables = getAccumulatorObject(undefined, baseDomElement);
        var sortedData = retrieveSortedDataForTable(whereTheTableGoes,baseDomElement);
        if (dyanamicUiVariables.dynamicTableConfiguration.formOfStorage ==='loadOnce') {
            sharedTable["matrix"]= manipulationFunction(sortedData.dataArray,sortedData.numberOfRows,sortedData.numberOfColumns,manipulationFunctionArgs);
        } else{
            sharedTable["matrix"]= manipulationFunction(sortedData.dataArray,sharedTable.matrix.numberOfRows,sharedTable.matrix.numberOfColumns,manipulationFunctionArgs);
        }

        destroySharedTable(whereTheTableGoes);

        rebuildTableOnPageFromMatrix(sharedTable["matrix"],sharedTable.currentForm,whereTheTableGoes,baseDomElement);
    };





    /***
     * provide a category number which we will use to decide what class will use for coloring.  In this case
     * we are coloring by the number of tissues.
     *
     * @param numberOfTissues
     * @returns {number}
     */
    var categorizeTissueNumbers = function ( numberOfTissues ) {
        var returnValue = 0;
        if ((numberOfTissues>0) &&(numberOfTissues<=2)) {
            returnValue = 1;
        } else if ((numberOfTissues>2) &&(numberOfTissues<=8)) {
            returnValue = 2;
        } else if ((numberOfTissues>8) &&(numberOfTissues<=25)) {
            returnValue = 3;
        } else if ((numberOfTissues>25) &&(numberOfTissues<=100)) {
            returnValue = 4;
        } else if (numberOfTissues>100) {
            returnValue = 5;
        }
        return returnValue;
    };




    var categorizeSignificanceNumbers = function ( significance, datatype, overrideValue ) {
        var returnValue = 0;
        if ( ( typeof significance !== 'undefined') &&
             ( $.isArray(significance) ) &&
            ( significance.length>0 ) ){
            var recordToAssess = significance[0];
            switch (datatype){
                //case "MOD": // significance is not a meaningful concept
                //    returnValue = 6;
                //    break;
                case "ABC": // activity by contact predictions -- higher numbers are good
                    var valueToAssess = significance[0].value;
                    if ((valueToAssess>0) &&(valueToAssess<=0.2)) {
                        returnValue = 5;
                    } else if ((valueToAssess>0.2) &&(valueToAssess<=0.4)) {
                        returnValue = 4;
                    } else if ((valueToAssess>0.4) &&(valueToAssess<=0.6)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.6) &&(valueToAssess<=0.8)) {
                        returnValue = 2;
                    } else if (valueToAssess>0.9) {
                        returnValue = 1;
                    }
                    break
                 case "DEG":
                    var valueToAssess = significance[0].pvalue;
                    if ((valueToAssess>0) &&(valueToAssess<=0.5E-8)) {
                        returnValue = 1;
                    } else if ((valueToAssess>0.5E-8) &&(valueToAssess<=0.5E-4)) {
                        returnValue = 2;
                    } else if ((valueToAssess>0.5E-4) &&(valueToAssess<=0.05)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.05) &&(valueToAssess<=0.4)) {
                        returnValue = 4;
                    } else if (valueToAssess>0.4) {
                        returnValue = 5;
                    }
                    break;

                case "DEP":
                //case "MET":
                case "EQT":
                case "FIR":
                case "SKA":
                    var valueToAssess;
                    if ( typeof  overrideValue !== 'undefined') {
                        valueToAssess = overrideValue
                    } else {
                        valueToAssess = significance[0].numericalValue;
                    }
                    if (valueToAssess===0)  {
                        returnValue = 6;
                    } else if ((valueToAssess>0) &&(valueToAssess<=0.5E-8)) {
                        returnValue = 1;
                    } else if ((valueToAssess>0.5E-8) &&(valueToAssess<=0.5E-4)) {
                        returnValue = 2;
                    } else if ((valueToAssess>0.5E-4) &&(valueToAssess<=0.05)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.05) &&(valueToAssess<=0.1)) {
                        returnValue = 4;
                    } else if (valueToAssess>0.1) {
                        returnValue = 5;
                    }
                    break;
                default:
                    break;
            }

        }

        return returnValue;
    };



    var Categorizor = function(){

    };
    Categorizor.prototype.genePValueSignificance = function ( valueToAssess ) {
        var returnValue = 0;
        if (valueToAssess === 0) {
            returnValue = 6;
        } else if ((valueToAssess > 0) && (valueToAssess <= 0.5E-8)) {
            returnValue = 1;
        } else if ((valueToAssess > 0.5E-8) && (valueToAssess <= 0.5E-4)) {
            returnValue = 2;
        } else if ((valueToAssess > 0.5E-4) && (valueToAssess <= 0.05)) {
            returnValue = 3;
        } else if ((valueToAssess > 0.05) && (valueToAssess <= 0.1)) {
            returnValue = 4;
        } else if (valueToAssess > 0.1) {
            returnValue = 5;
        }
        return returnValue;
    }
    Categorizor.prototype.posteriorProbabilitySignificance = function ( valueToAssess, datatype, overrideValue ){
        var returnValue = 0;
        if ((valueToAssess>0) &&(valueToAssess<=0.2)) {
            returnValue = 5;
        } else if ((valueToAssess>0.2) &&(valueToAssess<=0.4)) {
            returnValue = 4;
        } else if ((valueToAssess>0.4) &&(valueToAssess<=0.6)) {
            returnValue = 3;
        } else if ((valueToAssess>0.6) &&(valueToAssess<=0.8)) {
            returnValue = 2;
        } else if (valueToAssess>0.9) {
            returnValue = 1;
        }
        return returnValue;
    };
    Categorizor.prototype.categorizeTissueNumbers = categorizeTissueNumbers;
    Categorizor.prototype.categorizeSignificanceNumbers = categorizeSignificanceNumbers;


    var SortUtility = function(){

    };
    SortUtility.prototype.simpleIntegerComparison = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = parseInt($(a).attr(defaultSearchField));
        var y = parseInt($(b).attr(defaultSearchField));
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    };
    SortUtility.prototype.textComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        const textA = $(a).attr(defaultSearchField).toUpperCase();
        const textAEmpty = (textA.length===0);
        const textB = $(b).attr(defaultSearchField).toUpperCase();
        const textBEmpty = (textB.length===0);
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
    }
    SortUtility.prototype.textComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        const textA = $(a).attr(defaultSearchField).toUpperCase();
        const textAEmpty = (textA.length===0);
        const textB = $(b).attr(defaultSearchField).toUpperCase();
        const textBEmpty = (textB.length===0);
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
    };
    SortUtility.prototype.numericalComparisonWithEmptiesAtBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = parseFloat($(a).attr(defaultSearchField));
        if (isNaN(x)){
            x = parseInt($(a).attr('subSortField'));
        }
        var y = parseFloat($(b).attr(defaultSearchField));
        if (isNaN(y)){
            y = parseInt($(b).attr('subSortField'));
        }
        if (isNaN(x) || isNaN(y)){
            return emptyFieldHandler(isNaN(x),isNaN(y), direction);
        }else {
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        }
    };
    SortUtility.prototype.notSortable = function(a, b, direction, currentSortObject){
        return 0;
    }




    var getNumberOfHeaders =function(whereTheTableGoes) {
        var dataTable = $(whereTheTableGoes).dataTable().DataTable();
        var numberOfHeaders = dataTable.table().columns()[0].length;
        return numberOfHeaders;
    }



    var retrieveCurrentIndexOfColumn  = function(whereTheTableGoes,initialLinearIndex){
        var dataTable = $(whereTheTableGoes).dataTable().DataTable();
        var numberOfHeaders = dataTable.table().columns()[0].length;
        var indexOfClickedColumn = -1;
        _.each(_.range(0,numberOfHeaders),function(index) {
            var header = dataTable.table().column(index).header();
            var headerLinearIndex = extractClassBasedIndex($(header)[0].innerHTML,"initialLinearIndex_");
            if (headerLinearIndex ===initialLinearIndex){
                indexOfClickedColumn = index;
            }
        });
        return indexOfClickedColumn;
    };



    var getCurrentTableFormat =function(whereTheTableGoes) {
        alert('getCurrentTableFormat is not used');
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes);
        return sharedTable.currentForm;
    }




    var shiftColumnsByOne = function ( event, offeredThis, direction, whereTheTableGoes, baseDomElement) {
        event.stopPropagation();
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes, baseDomElement);
        var identifyingNode = $(offeredThis).parent().parent().parent();
        var initialLinearIndex = extractClassBasedIndex(identifyingNode[0].innerHTML,"initialLinearIndex_");
        var numberOfHeaders = getNumberOfHeaders (whereTheTableGoes);
        var indexOfClickedColumn =retrieveCurrentIndexOfColumn (whereTheTableGoes,initialLinearIndex);
        var additionalParameters = getAccumulatorObject(undefined, baseDomElement)
        var leftBackstop;
        if ((sharedTable.currentForm === 'geneTableGeneHeaders') || (sharedTable.currentForm === 'variantTableVariantHeaders')){
            leftBackstop = 1;
        } else {
            leftBackstop = 0;
        }
        if (direction==="forward"){
            if ((indexOfClickedColumn>leftBackstop) &&(indexOfClickedColumn<(numberOfHeaders-1))){
                redrawTableOnClick(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
                    function(sortedData,numberOfRows,numberOfColumns,arguments){
                        return mpgSoftware.matrixMath.moveColumnsInDataStructure(sortedData,numberOfRows,numberOfColumns,
                            arguments.sourceColumn,arguments.targetColumn);
                    },
                {targetColumn:numberOfHeaders-1,sourceColumn:indexOfClickedColumn},baseDomElement);
            }
        }else if (direction==="backward") {
            if ((indexOfClickedColumn>(leftBackstop+1)) &&(indexOfClickedColumn<(numberOfHeaders))){
                redrawTableOnClick(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
                     function(sortedData,numberOfRows,numberOfColumns,arguments){
                        return mpgSoftware.matrixMath.moveColumnsInDataStructure(sortedData,numberOfRows,numberOfColumns,
                            arguments.sourceColumn,arguments.targetColumn);
                    },
                    {targetColumn:leftBackstop+1,sourceColumn:indexOfClickedColumn}, baseDomElement);
            }
        }

    };




    var removeColumn = function ( event, offeredThis, direction, whereTheTableGoes,baseDomElement) {
        event.stopPropagation();
        var identifyingNode = $(offeredThis).parent().parent().parent();
        var initialLinearIndex = extractClassBasedIndex(identifyingNode[0].innerHTML,"initialLinearIndex_");
        var indexOfClickedColumn =retrieveCurrentIndexOfColumn (whereTheTableGoes,initialLinearIndex);
                redrawTableOnClick(whereTheTableGoes,
                    function(sortedData,numberOfRows,numberOfColumns,arguments){
                        return mpgSoftware.matrixMath.deleteColumnsInDataStructure(sortedData,numberOfRows,numberOfColumns,
                            arguments.columnsToDelete);
                    },
                    {columnsToDelete:[indexOfClickedColumn]},baseDomElement);

    };


    var retrieveIndexesOfColumnsWithMatchingNames  = function(whereTheTableGoes,arrayOfMatchingNames,baseDomElement){
        var indexesOfIdentifiedColumns = [];
        var staticDataForTable = retrieveSortedDataForTable(whereTheTableGoes,baseDomElement);
        _.each(_.range(0,staticDataForTable.numberOfColumns),function(index) {
            var cellContent = staticDataForTable.dataArray[index];
            if (_.includes(arrayOfMatchingNames,$(cellContent.renderData).find('span.displayMethodName').attr('methodKey'))){
                indexesOfIdentifiedColumns.push(index);
            }
        });
        return indexesOfIdentifiedColumns;
    };




    var contractColumns = function ( event, offeredThis, direction, whereTheTableGoes, baseDomElement) {
        event.stopPropagation();
        const additionalParameters = getAccumulatorObject(undefined, baseDomElement);
        whereTheTableGoes = additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory;
        var identifyingNode = $(offeredThis).parent().parent().parent();
        var dataAnnotationType= getDatatypeInformation('FEGT',baseDomElement);
        var expectedColumns = dataAnnotationType.dataAnnotation.customColumnOrdering.constituentColumns;
        var groupNumber = extractClassBasedIndex(identifyingNode[0].innerHTML,"groupNum");
        var grouping = dataAnnotationType.dataAnnotation.customColumnOrdering.topLevelColumns[groupNumber];
        var columnsToDelete = _.filter(expectedColumns,function (o){return ((o.pos===groupNumber) && (o.subPos!==0))});
        var columnsNamesToDelete = _.map(columnsToDelete,function(o){return o.key});
        var indexesOfColumnsToDelete =retrieveIndexesOfColumnsWithMatchingNames (whereTheTableGoes,columnsNamesToDelete,baseDomElement);
        var sharedTable = getSharedTable(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
                                        baseDomElement);
        sharedTable.addColumnExclusionGroup(groupNumber,grouping.key,indexesOfColumnsToDelete);
        redrawTableOnClick(whereTheTableGoes,
            function(sortedData,numberOfRows,numberOfColumns,arguments){
                // I had previously deleted the columns here, but now I do it when the headers and the body are added every time
                return mpgSoftware.matrixMath.doNothing (sortedData, numberOfRows, numberOfColumns);
            },{},baseDomElement);
    };

    var expandColumns = function ( event, offeredThis, direction, whereTheTableGoes, baseDomElement) {
        event.stopPropagation();
        var additionalParameters = getAccumulatorObject(undefined, baseDomElement)
        whereTheTableGoes = additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory;
        var identifyingNode = $(offeredThis).parent().parent().parent();
        var groupNumber = extractClassBasedIndex(identifyingNode[0].innerHTML,"groupNum");
        var sharedTable = getSharedTable(additionalParameters.dynamicTableConfiguration.initializeSharedTableMemory,
                                        baseDomElement);
        sharedTable.removeColumnExclusionGroup(groupNumber, baseDomElement);


        var initialLinearIndex = extractClassBasedIndex(identifyingNode[0].innerHTML,"initialLinearIndex_");
        var indexOfClickedColumn =retrieveCurrentIndexOfColumn (whereTheTableGoes,initialLinearIndex);
        redrawTableOnClick(whereTheTableGoes,
            function(sortedData,numberOfRows,numberOfColumns,arguments){
                return mpgSoftware.matrixMath.doNothing (sortedData, numberOfRows, numberOfColumns);
            },{},baseDomElement);
    };






    var handleRequestToDropADraggableColumn = function (offeredThis,originatingObject,whereTheTableGoes, baseDomElement){
        var targetColumn =$(offeredThis) ;
        var draggedColumn = $(originatingObject.draggable);
        var initialLinearIndexTargetColumn = extractClassBasedIndex(targetColumn[0].innerHTML,"initialLinearIndex_");
        var initialLinearIndexColumnBeingDragged = extractClassBasedIndex(draggedColumn[0].innerHTML,"initialLinearIndex_");
        var currentIndexTargetColumn = retrieveCurrentIndexOfColumn (whereTheTableGoes,initialLinearIndexTargetColumn);
        var currentIndexColumnBeingDragged = retrieveCurrentIndexOfColumn (whereTheTableGoes,initialLinearIndexColumnBeingDragged);
        redrawTableOnClick(whereTheTableGoes,
            function(sortedData,numberOfRows,numberOfColumns,arguments){
                return mpgSoftware.matrixMath.moveColumnsInDataStructure(sortedData,numberOfRows,numberOfColumns,
                    arguments.sourceColumn,arguments.targetColumn);
            },
            {targetColumn:currentIndexTargetColumn,sourceColumn:currentIndexColumnBeingDragged},baseDomElement);
    };



    var setUpDraggable = function(whereTheTableGoes, baseDomElement) {
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes, baseDomElement);
        var classNameToIdentifyHeader;
        if ((sharedTable.currentForm === 'geneTableGeneHeaders')){
            classNameToIdentifyHeader =  "th.geneHeader";
        } else if ((sharedTable.currentForm === 'geneTableAnnotationHeaders')){
            classNameToIdentifyHeader =  "th.categoryNameToUse";
        } else if ((sharedTable.currentForm === 'tissueTableMethodHeaders') ){
            classNameToIdentifyHeader =  "th.tissueTableHeader";
        } else if ((sharedTable.currentForm === 'variantTableVariantHeaders') ){
            classNameToIdentifyHeader =  "th.headersWithVarIds";
        }

        $( classNameToIdentifyHeader ).draggable({
             axis: "x",
            opacity: 0.8,
            containment: "parent",
            revert:"invalid",
            stack: ".ui-draggable"
        });
        $( classNameToIdentifyHeader).droppable({
            classes: {
                "ui-droppable-hover": "ui-state-hover"
            },
            accept:classNameToIdentifyHeader,
            drop: function( event, ui ) {
                handleRequestToDropADraggableColumn(this,ui,whereTheTableGoes, baseDomElement);
            }
        });

    }


    function adjustTableWrapperWidth(TABLE) {

        var windowWidth = $(window).width();
        var mainContainerWidth = $(".container").eq(0).width();

        var sideMargin = ((mainContainerWidth - windowWidth)/2)*0.9;

        $(TABLE).parent().css({"margin-left": sideMargin+"px", "margin-right": sideMargin+"px"});
    }





    var displayAnnotationFilter = function(event,reportingElement){
        event.stopPropagation();
        if ($("#filter_modal").is(':visible')){
            $("#filter_modal").hide();
        } else {
            $("#filter_modal").show();
        }
    }


    var openFilter = function(TARGETCLMID) {

        var filterModalContent = '<div id="filter_modal" ><div class="closer-wrapper" style="text-align: center;">Filter\
                <span style="float:right; font-size: 12px; color: #888;" onclick="mpgSoftware.dynamicUi.closeFilterModal(event);" class="glyphicon glyphicon-remove" aria-hidden="true"></span></div>\
                <div class="content-wrapper" style="width: auto; height:auto; min-width: 300px; min-height: 200px;"></div></div>';

        if(!$("#filter_modal").length) {
            $("body").append(filterModalContent);
            $("#filter_modal").find(".content-wrapper").append(TARGETCLMID);
        } else {
            $("#filter_modal").find(".content-wrapper").html("").append(TARGETCLMID);
        }

        var filterModalLeft = ($(window).width() - $("#filter_modal").width())/2;
        var filterModalTop = ($(window).height() - $("#filter_modal").height())/2;
        $("#filter_modal").css({"top":filterModalTop,"left":filterModalLeft});
    };

    var closeFilterModal = function(event) {
        $("#filter_modal").remove();
    };

    var redrawTissueTable= function(){
        const baseDomElement = '#mainTissueDiv';
        var whereTheTableGoes = '#mainTissueDiv table.tissueTableHolder';
        var selectedElements = $('#annotationPicker option:selected');
        var selectedValues = [];
        _.forEach(selectedElements,function(oe){
            selectedValues.push($(oe).val());
        });
        setAccumulatorObject('tissueTableChosenAnnotations', selectedValues,baseDomElement);
        var sharedTable = getAccumulatorObject("sharedTable_" + whereTheTableGoes,'#mainTissueDiv');
        redrawTableOnClick(whereTheTableGoes,function(sortedData, numberOfRows, numberOfColumns){
            return mpgSoftware.matrixMath.doNothing (sortedData, numberOfRows, numberOfColumns);
        },{},'#mainTissueDiv');
        refineTableRecords(whereTheTableGoes,$(whereTheTableGoes).dataTable(),sharedTable.currentForm,[],false,baseDomElement);

    };
    const displayVariantTablePerTissue  = function (whereTheTableGoes, tissueDominant) {
        var sharedTable = getSharedTable(whereTheTableGoes,'#mainVariantDivHolder');
        // the switch to tissue dominant wants to have the the variance across the top
        if ((tissueDominant) &&(sharedTable.currentForm === 'variantTableAnnotationHeaders')){
            transposeThisTable('#mainVariantDiv table.variantTableHolder','#mainVariantDivHolder');
        }

        destroySharedTable(whereTheTableGoes);
        sharedTable['dataCells'] = [];

        // Make the variant headers, the strictly genetic annotations, and the genetic association rows
        const indexAccumulator = getAccumulatorObject("variantInfoArray",'#mainVariantDivHolder');
        const intermediateDataStructureHdr = getAccumulatorObject("topPortionDisplay",'#mainVariantDivHolder');
        if (tissueDominant) {
            // $('button.actualTransposeButton').attr("disabled", true);
            setAccumulatorObject("variantTableOrientation","tissueDominant",'#mainVariantDivHolder');
        } else {
            // $('button.actualTransposeButton').attr("disabled", false);
            setAccumulatorObject("variantTableOrientation","annotationDominant",'#mainVariantDivHolder');
        }

        const clearBeforeStarting = false;
        const idForTheTargetDiv = whereTheTableGoes;
        const storeRecords = true;

        prepareToPresentToTheScreen(idForTheTargetDiv,
            '#notUsed',
            '#mainVariantDivHolder',
            clearBeforeStarting,
            intermediateDataStructureHdr,
            storeRecords,
            'variantTableVariantHeaders',
            true,
            true ); // we want to display blank rows in this case, since they are informative

        if (tissueDominant){
            const intermediateDataStructureBody = indexAccumulator[0].header['tissueDisplay'];
            intermediateDataStructureBody['tableToUpdate'] = idForTheTargetDiv;

            prepareToPresentToTheScreen(idForTheTargetDiv,
                '#notUsed',
                '#mainVariantDivHolder',
                clearBeforeStarting,
                intermediateDataStructureBody,
                storeRecords,
                'variantTableVariantHeaders',
                false,
                true );
        } else {
            const intermediateDataStructureBodyArray = getAccumulatorObject('annotationDisplayArray','#mainVariantDivHolder');
            _.forEach(intermediateDataStructureBodyArray,function(intermediateDataStructureBody){
                intermediateDataStructureBody['tableToUpdate'] = idForTheTargetDiv;
                prepareToPresentToTheScreen(idForTheTargetDiv,
                    '#notUsed',
                    '#mainVariantDivHolder',
                    clearBeforeStarting,
                    intermediateDataStructureBody,
                    storeRecords,
                    'variantTableVariantHeaders',
                    false,
                    true );
            });

        }

        sharedTable['matrix'] = new mpgSoftware.matrixMath.Matrix(sharedTable['dataCells'],sharedTable['numberOfRows'],sharedTable['numberOfColumns'])
        filterEpigeneticTable(idForTheTargetDiv,true,'#mainVariantDivHolder');
    }


// public routines are declared below
    return {
        displayAnnotationFilter:displayAnnotationFilter,
        redrawTissueTable:redrawTissueTable,
        displayForGeneTable:displayForGeneTable,
        displayForFullEffectorGeneTable:displayForFullEffectorGeneTable,
        displayTissueTable:displayTissueTable,
        displayHeaderForGeneTable:displayHeaderForGeneTable,
        addRowHolderToIntermediateDataStructure:addRowHolderToIntermediateDataStructure,
        IntermediateStructureDataCell:IntermediateStructureDataCell,
        shiftColumnsByOne:shiftColumnsByOne,
        extractStraightFromTarget:extractStraightFromTarget,
        showAttachedData:showAttachedData,
        setColorButtonActive: setColorButtonActive,
        removeWrapper:removeWrapper,
        createOutOfRegionGraphic:createOutOfRegionGraphic,
        transposeThisTable:transposeThisTable,
        reviseDisplayOfVariantTable:reviseDisplayOfVariantTable,
        dataTableZoomSet:dataTableZoomSet,
        dataTableZoomDynaSet:dataTableZoomDynaSet,
        displayTissuesForAnnotation:displayTissuesForAnnotation,
        hideTissuesForAnnotation:hideTissuesForAnnotation,
        installDirectorButtonsOnTabs: installDirectorButtonsOnTabs,
        modifyScreenFields: modifyScreenFields,
        adjustLowerExtent: adjustLowerExtent,
        adjustUpperExtent: adjustUpperExtent,
        Categorizor:Categorizor,
        SortUtility:SortUtility,
        translateATissueName:translateATissueName,
        removeColumn:removeColumn,
        contractColumns:contractColumns,
        expandColumns:expandColumns,
        openFilter:openFilter,
        closeFilterModal:closeFilterModal,
        retrieveDataFromServer:retrieveDataFromServer,
        retrieveGwasCodingCredibleSetFromServer: retrieveGwasCodingCredibleSetFromServer,
        displayHeaderForVariantTable:displayHeaderForVariantTable,
        displayForVariantTable:displayForVariantTable,
        displayGregorSubTableForVariantTable:displayGregorSubTableForVariantTable,
        getAccumulatorObject:getAccumulatorObject,
        filterEpigeneticTable:filterEpigeneticTable,
        adjustAnnotationTable:adjustAnnotationTable,
        extractClassBasedIndex:extractClassBasedIndex,
        displayVariantTablePerTissue:displayVariantTablePerTissue
    }
}());
