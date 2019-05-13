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

        mpgSoftware.dynamicUi.displayForFullEffectorGeneTable('table.fullEffectorGeneTableHolder', // which table are we adding to
            'FEGT', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'fullEffectorGeneTable', // name of the persistent field where the data we received is stored
            '', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(records,function(oneRecord){
                    return {    gene:oneRecord.gene,
                        value:oneRecord};
                    // return {    value:UTILS.realNumberFormatter(''+tissueRecord.value),
                    //     numericalValue:tissueRecord.value,
                    //     dataset: tissueRecord.dataset };
                });

            },
            function(records, // all records
                     recordsCellPresentationString,// record count cell text
                     significanceCellPresentationString,// significance cell text
                     dataAnnotationTypeCode,// driving code
                     significanceValue,
                     gene ){ // value of significance for sorting
                return {  numberOfRecords:records.length,
                    cellPresentationStringMap:{ Records:recordsCellPresentationString,
                        Significance:significanceCellPresentationString },
                    recordsExist:(records.length)?[1]:[],
                    gene:gene,
                    tissueCategoryNumber:categorizor.categorizeTissueNumbers( records.length ),
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( significanceValue ),
                    significanceValue:significanceValue,
                    data:records
                }
            } );

    };



    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).genePValueSignificance;



// public routines are declared below
    return {
        processRecordsFromFullEffectorGeneTable: processRecordsFromFullEffectorGeneTable,
        displayFullEffectorGeneTable:displayFullEffectorGeneTable
    }
}());