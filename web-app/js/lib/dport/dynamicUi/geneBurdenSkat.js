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

mpgSoftware.dynamicUi.geneBurdenSkat = (function () {
    "use strict";

    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processGeneSkatAssociationRecords = function (data,rawGeneAssociationRecords) {

        if ( ( typeof data !== 'undefined') &&
            (  data.is_error !== true ) &&
            (  data.numRecords > 0 ) &&
            ( typeof data.variants !== 'undefined' ) ){
            var geneRecord = {};
            _.forEach(data.variants[0], function (oneRec) {
                _.forEach(oneRec, function(sampleRecord,tissue){
                    if ((tissue==='GENE')||(tissue==='Gene')) {
                        geneRecord['gene'] = sampleRecord;
                        geneRecord['tissues'] = [];
                    } else if (tissue==='TISSUE_TRANSLATIONS') {
                        geneRecord['TISSUE_TRANSLATIONS'] = sampleRecord;
                    } else {
                        _.forEach(sampleRecord, function (phenotypeRecord, dataset) {
                            _.forEach(phenotypeRecord, function (number, phenotypeString) {

                                if (number !== null) {
                                    geneRecord['tissues'].push({tissue: tissue, value: number});

                                }
                            })
                        });
                    }
                });
            });
            if ((typeof geneRecord !== 'undefined')&&(typeof geneRecord.gene !== 'undefined')){
                rawGeneAssociationRecords.push(geneRecord);
            }
        }



        return rawGeneAssociationRecords;

    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGeneSkatAssociationsForGeneTable = function (idForTheTargetDiv, objectContainingRetrievedRecords) {

        mpgSoftware.dynamicUi.displayForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            'SKA', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'rawGeneSkatRecords', // name of the persistent field where the data we received is stored
            'P_MIN_P_SKAT_NS_STRICT_NS_1PCT', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.sortBy(_.filter(records,function(t){return t.tissue.includes("SKAT")}),['value']),function(tissueRecord){
                    return {  tissueName:  mpgSoftware.dynamicUi.translateATissueName(tissueTranslations,tissueRecord.tissue),
                        tissue: tissueRecord.tissue,
                        value: UTILS.realNumberFormatter(""+tissueRecord.value),
                        numericalValue: tissueRecord.value };
                })
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
                    tissuesExist:(records.length)?[1]:[],
                    gene:gene,
                    tissueCategoryNumber:categorizor.categorizeTissueNumbers(records.length ),
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( significanceValue ),
                    significanceValue:significanceValue,
                    tissues:records
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
        processGeneSkatAssociationRecords: processGeneSkatAssociationRecords,
        displayGeneSkatAssociationsForGeneTable:displayGeneSkatAssociationsForGeneTable
    }
}());
