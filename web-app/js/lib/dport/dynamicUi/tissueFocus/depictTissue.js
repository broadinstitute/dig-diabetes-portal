var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.depictTissues = (function () {
    "use strict";


    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromDepictTissues = function (data, rawGeneAssociationRecords) {
        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            var combinedRecord = {header:{}, contents:[]};
            combinedRecord.header['tissues'] = _.map(_.uniqBy(data,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});
            _.forEach(data, function (oneRec) {
                combinedRecord.contents.push({
                    category:oneRec.mesh_second_level_term,
                    tissue:oneRec.tissue.replace('\'','').toLowerCase(),
                    value:oneRec.pvalue,
                    pValueString:UTILS.realNumberFormatter(""+oneRec.pvalue)
                })
            });
            rawGeneAssociationRecords.push(combinedRecord);
        }
        return rawGeneAssociationRecords;
    };



    var createSingleDepictTissueCell = function (recordsPerTissue,dataAnnotationType) {
        var significanceValue = 0;
        var returnValue = {};
        if (( typeof recordsPerTissue !== 'undefined')&&
            (recordsPerTissue.length>0)){
            var mostSignificantRecord=recordsPerTissue[0];

            significanceValue = mostSignificantRecord.value;
            returnValue['significanceValue'] = significanceValue;
            returnValue['significanceCellPresentationString'] = Mustache.render($('#'+dataAnnotationType.dataAnnotation.significanceCellPresentationStringWriter)[0].innerHTML,
                {significanceValue:significanceValue,
                    recordsPerTissue:recordsPerTissue,
                    significanceValueAsString:UTILS.realNumberFormatter(""+significanceValue),
                    recordDescription:mostSignificantRecord.tissue,
                    numberRecords:recordsPerTissue.length});
        }
        return returnValue;
    };




    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayTissueInformationFromDepict = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        var dataAnnotationTypeCode = "DEP_TI";

        mpgSoftware.dynamicUi.displayTissueTable(idForTheTargetDiv, // which table are we adding to
            dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'depictTissueArray', // name of the persistent field where the data we received is stored

            // insert header records as necessary into the intermediate structure, and return header names that we can match on for the columns
            function(incomingData,tissuesAlreadyInTheTable,dataAnnotationType,intermediateDataStructure,returnObject){
                var headersObjects = [];
                var initialLinearIndex = 1;
                if ( typeof incomingData !== 'undefined') {

                    mpgSoftware.dynamicUi.addRowHolderToIntermediateDataStructure(dataAnnotationTypeCode, intermediateDataStructure);

                    var tissuesAsHeaders = [];
                    if (( typeof incomingData.header !== 'undefined' ) &&
                        ( typeof incomingData.header.tissues !== 'undefined' )){
                        var sortedHeaderObjects = returnObject.header.tissues.sort();
                        returnObject.headers = _.map(sortedHeaderObjects, function(tissue,index){
                            return Mustache.render($('#'+dataAnnotationType.dataAnnotation.headerWriter)[0].innerHTML,
                                {   tissueName: tissue,
                                    initialLinearIndex:initialLinearIndex++
                                }
                            )
                        });

                    }

                    _.forEach(returnObject.headers, function (oneRecord) {
                        intermediateDataStructure.headers.push(new mpgSoftware.dynamicUi.IntermediateStructureDataCell(oneRecord,
                            oneRecord, "tissueHeader", 'LIT'));
                    });
                }
                return sortedHeaderObjects;
            },

            // this function is for organizing and/or translating all of the names within a single cell
            function(records,tissueTranslations){
                //return _.orderBy(_.filter(records,function(o){return (o.p_value<0.05)}),['p_value'],['asc']);
                return _.orderBy(records,['value'],['asc']);
            },

            // take all the records for each row and insert them into the intermediateDataStructure
            function(tissueRecords,
                     allTissueRecords,
                     recordsCellPresentationString,
                     significanceCellPresentationString,
                     dataAnnotationTypeCode,
                     significanceValue,
                     tissueName ){
                return {
                    allTissueRecords:allTissueRecords,
                    tissueRecords:allTissueRecords,
                    recordsExist:(allTissueRecords.length>0)?[1]:[],
                    cellPresentationStringMap:{
                        'Significance':significanceCellPresentationString,
                        'Records':recordsCellPresentationString
                    },
                    dataAnnotationTypeCode:dataAnnotationTypeCode,
                    significanceValue:significanceValue,
                    tissueNameKey:tissueName.replace(/ /g,"_"),
                    tissueName:tissueName,
                    tissuesFilteredByAnnotation:allTissueRecords};

            },
            createSingleDepictTissueCell
        )

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;



// public routines are declared below
    return {
        processRecordsFromDepictTissues: processRecordsFromDepictTissues,
        displayTissueInformationFromDepict:displayTissueInformationFromDepict,
        sortRoutine:sortRoutine
    }
}());
