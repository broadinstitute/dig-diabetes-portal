var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.dnaseVariantTable = (function () {
    "use strict";

    /***
     * some objects that we can use to access shared prototype methods
     */
    const categorizor = new mpgSoftware.dynamicUi.sharedCategorizor.Categorizor();
    const sortUtility = new mpgSoftware.dynamicUi.sharedSortUtility.SortUtility();
    const renderData = new mpgSoftware.dynamicUi.sharednameRenderData.RenderData()


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
                currentMethod:'NA',
                currentAnnotation:['DNASE']
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
                let groupedByTissue = {name:tissue,  tissue_name:recordsGroupedByTissue[0].tissue_name, arrayOfRecords:[]};
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
            callingParameters,
            // insert header records as necessary into the intermediate structure, and return header names that we can match on for the columns
            function(records,tissueTranslations){
                return _.orderBy(records,['SOURCE'],['asc']);
            },
            Object.getPrototypeOf(renderData).variantTableAnnotationDominant,
            Object.getPrototypeOf(renderData).variantTableTissueDominant
        )

    };



    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;

    const sortRoutine =  Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;



// public routines are declared below
    return {
        processRecordsFromDnase: processRecordsFromDnase,
        displayTissueInformationFromDnase:displayTissueInformationFromDnase,
        sortRoutine:sortRoutine
    }
}());
