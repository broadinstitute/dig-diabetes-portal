var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.dnaseVariantTable = (function () {
    "use strict";


    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromDnase = function (data, arrayOfRecords) {
        if (( typeof data !== 'undefined')&&
            ( typeof data.data !== 'undefined')){
            arrayOfRecords.splice(0,arrayOfRecords.length);
            let uniqueRecords = _.uniqWith(
                data.data,
                (recA, recB) =>
                    recA.annotation === recB.annotation &&
                    recA.var_id === recB.var_id &&
                    recA.tissue_id === recB.tissue_id
            );
            _.forEach(uniqueRecords,function (oneValue){oneValue['safeTissueId'] = oneValue.tissue_id.replace(":","_");});
            let dataGroupings = {groupByVarId:[],
                                groupByAnnotation:[],
                                groupByTissue:[],
                                groupByTissueAnnotation:[],
                                currentMethod:'MACS'
                                };
            _.forEach(_.groupBy(uniqueRecords, function (o) { return o.var_id }), function (value,key) {
                dataGroupings.groupByVarId.push({name:key,arrayOfRecords:value});
            });
            _.forEach( _.groupBy(uniqueRecords, function (o) { return o.annotation }), function (recordsGroupedByAnnotation,annotation) {
                let groupedByAnnotation = {name:annotation, arrayOfRecords:[]};
                _.forEach( _.groupBy(recordsGroupedByAnnotation, function (o) { return o.var_id }), function (recordsSubGroupedByVarId,varId) {
                    groupedByAnnotation.arrayOfRecords.push({name:varId,arrayOfRecords:recordsSubGroupedByVarId});
                });
                dataGroupings.groupByAnnotation.push(groupedByAnnotation);
            });
            _.forEach( _.groupBy(uniqueRecords, function (o) { return o.tissue_id }), function (recordsGroupedByTissue,tissue) {
                let groupedByTissue = {name:tissue, arrayOfRecords:[]};
                _.forEach( _.groupBy(recordsGroupedByTissue, function (o) { return o.var_id }), function (recordsSubGroupedByVarId,varId) {
                    groupedByTissue.arrayOfRecords.push({name:varId,arrayOfRecords:recordsSubGroupedByVarId});
                });
                dataGroupings.groupByTissue.push(groupedByTissue);
            });
            arrayOfRecords.push({header:{ },
                                data:dataGroupings});
        }
        return arrayOfRecords;
    };




    var createSingleDnaseCell = function (recordsPerTissue,dataAnnotationType) {
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
    var displayTissueInformationFromDnase = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {

        mpgSoftware.dynamicUi.displayForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            callingParameters.nameOfAccumulatorField, // name of the persistent field where the data we received is stored
            callingParameters.nameOfAccumulatorFieldWithIndex,
            // insert header records as necessary into the intermediate structure, and return header names that we can match on for the columns
            function(records,tissueTranslations){
                //return _.orderBy(_.filter(records,function(o){return (o.p_value<0.05)}),['p_value'],['asc']);
                return _.orderBy(records,['SOURCE'],['asc']);
            },

            // take all the records for each row and insert them into the intermediateDataStructure
            function(tissueRecords,
                     recordsCellPresentationString,
                     significanceCellPresentationString,
                     dataAnnotationTypeCode,
                     significanceValue,
                     tissueName ){
                return {
                    tissueRecords:tissueRecords,
                    recordsExist:(tissueRecords.length>0)?[1]:[],
                    cellPresentationStringMap:{
                        'Significance':significanceCellPresentationString,
                        'Records':recordsCellPresentationString
                    },
                    dataAnnotationTypeCode:dataAnnotationTypeCode,
                    significanceValue:significanceValue,
                    tissueNameKey:( typeof tissueName !== 'undefined')?tissueName.replace(/ /g,"_"):'var_name_missing',
                    tissueName:tissueName,
                    tissuesFilteredByAnnotation:tissueRecords};

            },
            createSingleDnaseCell
        )

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine =  Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;



// public routines are declared below
    return {
        processRecordsFromDnase: processRecordsFromDnase,
        displayTissueInformationFromDnase:displayTissueInformationFromDnase,
        sortRoutine:sortRoutine
    }
}());
