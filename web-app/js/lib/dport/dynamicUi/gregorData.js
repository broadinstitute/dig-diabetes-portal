/***
 * the FIRTH gene burden test
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

mpgSoftware.dynamicUi.gregorTissueTable = (function () {
    "use strict";

    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processGregorDataForTissueTable = function (data,rawGeneAssociationRecords) {

        if ( ( typeof data !== 'undefined') &&
             ( typeof data.data !== 'undefined') ){
            var geneRecord = {header:{}, contents:[]};
            geneRecord.header['annotations'] = _.map(_.uniqBy(data.data,'annotation'),function(o){return o.annotation});
            geneRecord.header['ancestries'] = _.map(_.uniqBy(data.data,'ancestry'),function(o){return o.ancestry});
            geneRecord.header['tissues'] = _.map(_.uniqBy(data.data,'tissue'),function(o){return o.tissue});
            _.forEach(data.data, function (oneRec) {
                geneRecord.contents.push({
                    ancestry:oneRec.ancestry,
                    annotation:oneRec.annotation,
                    tissue:oneRec.tissue,
                    p_value:oneRec.p_value,
                    pValueString:UTILS.realNumberFormatter(""+oneRec.p_value)
                })
            });
            rawGeneAssociationRecords.push(geneRecord);
        }
        return rawGeneAssociationRecords;
    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGregorDataForTissueTable = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

            var dataAnnotationTypeCode = "TITA";

            mpgSoftware.dynamicUi.displayTissueTable(idForTheTargetDiv, // which table are we adding to
                dataAnnotationTypeCode, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
                'gregorTissueArray', // name of the persistent field where the data we received is stored

                // insert header records as necessary into the intermediate structure, and return header names that we can match on for the columns
                function(incomingData,tissuesAlreadyInTheTable,dataAnnotationType,intermediateDataStructure,returnObject){
                    var headersObjects = [];
                    var initialLinearIndex = 0;
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
                    return _.orderBy(_.filter(records,function(o){return (o.annotation.includes('nhancer'))}),['p_value'],['asc']);
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
                            tissueNameKey:tissueName.replace(/ /g,"_"),
                            tissueName:tissueName};

                })

        };





    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;


// public routines are declared below
    return {
        processGregorDataForTissueTable: processGregorDataForTissueTable,
        displayGregorDataForTissueTable:displayGregorDataForTissueTable
    }
}());
