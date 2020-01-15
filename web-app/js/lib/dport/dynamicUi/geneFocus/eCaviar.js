/***
 * the eCAVIAR version of colocalization
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

mpgSoftware.dynamicUi.eCaviar = (function () {
    "use strict";




    const prepareDataForApiCall = function ( objectWithDataToPrepare ) {
        var phenotype = objectWithDataToPrepare.getAccumulatorObject("phenotype", objectWithDataToPrepare.baseDomElement);
        var dataForCall = _.map(objectWithDataToPrepare.getAccumulatorObject(objectWithDataToPrepare.nameOfAccumulatorFieldWithIndex,
            objectWithDataToPrepare.baseDomElement), function (o) {
            return {
                gene: o.name,
                phenotype: phenotype
            }
        });
        return dataForCall;
    };




    /***
     * 1) a function to process records
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromECaviar = function (data, rawGeneAssociationRecords) {


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
    var displayGenesFromECaviar = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {
        mpgSoftware.dynamicUi.displayForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            callingParameters,
            // 'ECA', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            // 'rawColocalizationInfo', // name of the persistent field where the data we received is stored
            '', // we may wish to pull out one record for summary purposes
            function(records,tissueTranslations){
                return _.map(_.orderBy( records,["clpp"],["desc"]),function(tissueRecord){
                    return {  tissue: tissueRecord.tissue_trans,
                        clpp: UTILS.realNumberFormatter(""+tissueRecord.clpp),
                        prob_in_causal_set: UTILS.realNumberFormatter(""+tissueRecord.prob_in_causal_set),
                        gwas_z_score: UTILS.realNumberFormatter(""+tissueRecord.gwas_z_score),
                        eqtl_z_score: UTILS.realNumberFormatter(""+tissueRecord.eqtl_z_score),
                        var_id:tissueRecord.var_id,
                        value:tissueRecord.clpp,
                        numericalValue: tissueRecord.clpp
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
                    significanceCategoryNumber:categorizor.categorizeSignificanceNumbers( records[0].clpp, "ECA" ),
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

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom;

// public routines are declared below
    return {
        prepareDataForApiCall:prepareDataForApiCall,
        processRecordsFromECaviar: processRecordsFromECaviar,
        displayGenesFromECaviar:displayGenesFromECaviar,
        sortRoutine:sortRoutine
    }
}());
