/***
 * the entire effector gene table
 *
 * The following externally visible functions are required:
 *         1) a function to process records
 *         2) a function to display the processed records
 * As well, always create a 'new mpgSoftware.dynamicUi.Categorizor()' as a means of building a
 *         3) set of categorizor routines
 * and try to use its prototype functions.  If you like, you can always override the definitions for:
 *          categorizeTissueNumbers
 *           categorizeSignificanceNumbers
 * @type {*|{}}
 */
var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.fullEffectorGeneTable = (function () {
    "use strict";


    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromFullEffectorGeneTable = function (data, rawGeneAssociationRecords) {

        if ( typeof data !== 'undefined'){
            var headersExtracted = false;
            var headers = [];
            var contents = [];
            _.forEach(data.data,function(oneRec){
                if (!headersExtracted) {
                    _.forEach(oneRec, function (v, k){
                        headers.push(k);
                    });
                    headersExtracted = true;
                }
                contents.push(oneRec);
            });
        }
        rawGeneAssociationRecords.push({headers:  headers, contents: contents});
    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayFullEffectorGeneTable = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        var dataAnnotationTypeCode = "FEGT";

        mpgSoftware.dynamicUi.displayForFullEffectorGeneTable('table.fullEffectorGeneTableHolder', // which table are we adding to
            dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'fullEffectorGeneTable', // name of the persistent field where the data we received is stored

            // insert header records as necessary into the intermediate structure, and return header names that we can match on for the columns
            function(incomingData,dataAnnotationType,intermediateDataStructure,returnObject){
                    var headersObjects = [];
                var initialLinearIndex = 0;
                if (( typeof incomingData !== 'undefined') &&
                        ( incomingData.length > 0)) {

                        mpgSoftware.dynamicUi.addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode, intermediateDataStructure);

                        var expectedColumns = dataAnnotationType.dataAnnotation.customColumnOrdering.constituentColumns;
                        headersObjects = _.map(returnObject.headers, function (o) {
                            var index = _.findIndex(expectedColumns, {'key': o});
                            if (index > -1) {
                                var grouping = dataAnnotationType.dataAnnotation.customColumnOrdering.topLevelColumns[expectedColumns[index].pos];
                                return {
                                    name: expectedColumns[index].key,
                                    groupNum: expectedColumns[index].pos,
                                    groupKey: grouping.key,
                                    groupDisplayName: grouping.displayName,
                                    columnDisplayName: expectedColumns[index].display,
                                    groupHelpText: grouping.helptext,
                                    columnHelpText: expectedColumns[index].helptext,
                                    groupOrder: grouping.order,
                                    withinGroupNum: expectedColumns[index].subPos
                                }
                            }
                        });
                        headersObjects = _.compact(headersObjects);
                        var sortedHeaderObjects = _.sortBy(headersObjects, ['groupOrder', 'withinGroupNum', 'name']);
                        _.forEach(sortedHeaderObjects, function (sortedHeaderObject) {
                            sortedHeaderObject['initialLinearIndex'] = initialLinearIndex++;
                        })
                        returnObject.headers = _.map(sortedHeaderObjects, function (o) {
                            return o.name
                        });

                        // set up the headers
                        _.forEach(sortedHeaderObjects, function (oneRecord) {
                            intermediateDataStructure.headers.push(new mpgSoftware.dynamicUi.IntermediateStructureDataCell(oneRecord,
                                Mustache.render($('#' + dataAnnotationType.dataAnnotation.headerWriter)[0].innerHTML, oneRecord), "fegtHeader", 'LIT'));
                        });
                    }
                    return sortedHeaderObjects;
                },

            // this function is for organizing and/or translating all of the names within a single cell
            function(records,tissueTranslations){
                return _.map(records,function(oneRecord){
                    return {    gene:oneRecord.gene,
                        value:oneRecord};
                    // return {    value:UTILS.realNumberFormatter(''+tissueRecord.value),
                    //     numericalValue:tissueRecord.value,
                    //     dataset: tissueRecord.dataset };
                });
            },

            // take all the records for each row and insert them into the intermediateDataStructure
            function(returnObject,dataAnnotationType,intermediateDataStructure,initialLinearIndex){
                var constituentColumns = _.map(dataAnnotationType.dataAnnotation.customColumnOrdering.constituentColumns,function(val){
                    return val.key;
                });
                var constituentColRecs = dataAnnotationType.dataAnnotation.customColumnOrdering.constituentColumns;
                //
                _.forEach(returnObject.contents,
                    function (recordsPerGene,rowNumber) {
                        if ($.isEmptyObject(recordsPerGene)) {
                            alert('empty records not allowed in the FEGT')
                        }
                        var geneName = recordsPerGene["Gene_name"];
                        _.forEach(recordsPerGene, function (valueInGeneRecord,header) {
                            var indexOfColumn = _.indexOf(returnObject.headers, header );
                            var indexOfPreassignedColumnName = _.indexOf(constituentColumns, header );
                            if (indexOfColumn === -1) {

                            } else if (indexOfPreassignedColumnName === -1) {
                                console.log("Did not find index of indexOfPreassignedColumnName "+header+" for FEGT.  Shouldn't we?")
                            } else {
                                var groupNumber = constituentColRecs[indexOfPreassignedColumnName].pos;
                                var sortNumber = categorizor.categorizeRowsInEfgt(groupNumber, valueInGeneRecord );
                                var linkSafeText = valueInGeneRecord.replace(/\/.$/g, '').replace(/or /g, '');
                                var textWithoutQuotes = valueInGeneRecord.replace(/\"/g, '');
                                var exomeSequenceCallOut = [];
                                if ((header === 'Exome_sequence_burden') &&
                                    (valueInGeneRecord.length>0) )  {
                                    exomeSequenceCallOut = [{geneName:geneName,displayValue:linkSafeText}]
                                }
                                var categoryRecord = {
                                    initialLinearIndex:initialLinearIndex++,
                                    groupNumber:constituentColRecs[indexOfPreassignedColumnName].pos,
                                    categoryName:textWithoutQuotes,
                                    sortNumber:sortNumber,
                                    linkSafeText:linkSafeText,
                                    exomeSequenceCallOut:exomeSequenceCallOut};
                                _.forEach(dataAnnotationType.dataAnnotation.customColumnOrdering.topLevelColumns, function (grouping, index){
                                    if (grouping.order===constituentColRecs[indexOfPreassignedColumnName].pos){
                                        categoryRecord[grouping.key]=[{textToDisplay:textWithoutQuotes}];
                                    } else {
                                        categoryRecord[grouping.key]=[];
                                    }
                                });
                                var displayableRecord = Mustache.render($('#'+dataAnnotationType.dataAnnotation.cellBodyWriter)[0].innerHTML, categoryRecord);
                                intermediateDataStructure.rowsToAdd[rowNumber].columnCells[indexOfColumn] = new mpgSoftware.dynamicUi.IntermediateStructureDataCell(displayableRecord,
                                    displayableRecord,"egftRecord","LIT" );
                            }

                        });
                        mpgSoftware.dynamicUi.addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode,intermediateDataStructure);
                    });

            })

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeRowsInEfgt = function(groupNumber,valueToCategorize){
        var returnValue = 0;
        switch(groupNumber){
            case 0:
                switch (valueToCategorize){
                    case 'LIMITED_extra':
                        returnValue = 1;
                        break;
                    case 'LIMITED':
                        returnValue = 2;
                        break;
                    case 'PLAUSIBLE_extra':
                        returnValue = 3;
                        break;
                    case 'PLAUSIBLE':
                        returnValue = 4;
                        break;
                    case 'POTENTIAL_extra':
                        returnValue = 5;
                        break;
                    case 'POTENTIAL':
                        returnValue = 6;
                        break;
                    case 'STRONG_extra':
                        returnValue = 7;
                        break;
                    case 'STRONG':
                        returnValue = 8;
                        break;
                    case 'CAUSAL_extra':
                        returnValue = 9;
                        break;
                    case 'CAUSAL':
                        returnValue = 10;
                        break;
                }
                break;
            default: break;
        }
        return returnValue;
    };




// public routines are declared below
    return {
        processRecordsFromFullEffectorGeneTable: processRecordsFromFullEffectorGeneTable,
        displayFullEffectorGeneTable:displayFullEffectorGeneTable
    }
}());