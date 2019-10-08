/***
 * the COLOC version of colocalization
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

mpgSoftware.dynamicUi.coloc = (function () {
    "use strict";

    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromColoc = function (data, rawGeneAssociationRecords) {
        var dataArrayToProcess = [];
        if ( typeof data !== 'undefined'){
            var geneName = '';
            dataArrayToProcess = {
                tissues:_.map(data,function(oneRec){
                    geneName = oneRec.gene;
                    return oneRec;
                })
            };
            dataArrayToProcess ['gene'] = geneName;
        }
        rawGeneAssociationRecords.push(dataArrayToProcess);
        return rawGeneAssociationRecords;
    };


    /***
     *  2) a function to display the processed records
     * @param idForTheTargetDiv
     * @param objectContainingRetrievedRecords
     */
    var displayGenesFromColoc = function (idForTheTargetDiv, objectContainingRetrievedRecords) {
        mpgSoftware.dynamicUi.displayForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            'COL', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            'rawColoInfo', // name of the persistent field where the data we received is stored
            '', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.orderBy(records,["prob_exists_coloc"],["desc"]),function(tissueRecord){
                    return {  tissue: tissueRecord.tissue_trans,
                        conditional_prob_snp_coloc: UTILS.realNumberFormatter(""+tissueRecord.conditional_prob_snp_coloc),
                        unconditional_prob_snp_coloc: UTILS.realNumberFormatter(""+tissueRecord.unconditional_prob_snp_coloc),
                        prob_exists_coloc: UTILS.realNumberFormatter(""+tissueRecord.prob_exists_coloc),
                        var_id: tissueRecord.var_id,
                        value:tissueRecord.prob_exists_coloc,
                        numericalValue: tissueRecord.prob_exists_coloc
                    }});
            },
            function(records, // all records
                     recordsCellPresentationString,// record count cell text
                     significanceCellPresentationString,// significance cell text
                     dataAnnotationTypeCode,// driving code
                     significanceValue,
                     gene ){ // value of significance for sorting
                return {
                    cellPresentationStringMap:{ Records:recordsCellPresentationString,
                        Significance:significanceCellPresentationString },
                    numberOfRecords:records.length,
                    tissueCategoryNumber:categorizor.categorizeTissueNumbers( records.length ),
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( records[0].prob_exists_coloc, "COL" ),
                    recordsExist:(records.length)?[1]:[],
                    gene:gene,
                    significanceValue:significanceValue,
                    records:records
                }
            } );
    };


    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).posteriorProbabilitySignificance;



// public routines are declared below
    return {
        processRecordsFromColoc: processRecordsFromColoc,
        displayGenesFromColoc:displayGenesFromColoc
    }
}());
