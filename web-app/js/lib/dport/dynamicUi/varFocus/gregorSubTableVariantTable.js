var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.gregorSubTableVariantTable = (function () {
    "use strict";


    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    // var processRecordsFromGregor = function (data, arrayOfRecords) {
    //     if (( typeof data !== 'undefined')&&
    //         ( typeof data.data !== 'undefined')){
    //         arrayOfRecords.splice(0,arrayOfRecords.length);
    //         let arrayOfData = [];
    //         var recordsGroupedByVarId = _.groupBy(data.data, function (o) { return o.var_id });
    //         _.forEach(recordsGroupedByVarId, function (value,key) {
    //             var allRecordsForOneVariety = {name:key,arrayOfRecords:value};
    //             arrayOfData.push(allRecordsForOneVariety);
    //         });
    //         arrayOfRecords.push({header:{ },
    //             data:arrayOfData});
    //     }
    //     return arrayOfRecords;
    // };
    var processRecordsFromGregor = function (data,rawGeneAssociationRecords) {

        if ( ( typeof data !== 'undefined') &&
            ( typeof data.data !== 'undefined') ){
            var geneRecord = {header:{}, data:[]};
            geneRecord.header['annotations'] = _.map(_.uniqBy(data.data,'annotation'),function(o){return o.annotation});
            geneRecord.header['ancestries'] = _.map(_.uniqBy(data.data,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['tissues'] = _.map(_.uniqBy(data.data,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});
            const recordsToDrawFrom = _.take(_.orderBy(data.data,['p_value'],['asc']),10)
            geneRecord.header['bestAnnotations'] = _.map(_.uniqBy(recordsToDrawFrom,'annotation'),function(o){return o.annotation});
            geneRecord.header['bestAncestries'] = _.map(_.uniqBy(recordsToDrawFrom,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['bestTissues'] = _.map(_.uniqBy(recordsToDrawFrom,'tissue'),function(o){return o.tissue.replace('\'','').toLowerCase()});

            _.forEach(recordsToDrawFrom, function (oneRec) {
                geneRecord.data.push({
                    ancestry:oneRec.ancestry,
                    annotation:oneRec.annotation,
                    tissue:oneRec.tissue.replace('\'','').toLowerCase(),
                    p_value:oneRec.p_value,
                    pValueString:UTILS.realNumberFormatter(""+oneRec.p_value)
                })
            });
            rawGeneAssociationRecords.push(geneRecord);
        }
        return rawGeneAssociationRecords;
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
    var displayGregorSubTable = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters ) {

        mpgSoftware.dynamicUi.displayGregorSubTableForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            callingParameters.nameOfAccumulatorField, // name of the persistent field where the data we received is stored
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




// public routines are declared below
    return {
        processRecordsFromGregor: processRecordsFromGregor,
        displayGregorSubTable:displayGregorSubTable
    }
}());