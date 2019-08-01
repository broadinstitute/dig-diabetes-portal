/***
 * the gene headers that are required for the gene table
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

mpgSoftware.dynamicUi.variantTableHeaders = (function () {
    "use strict";



    /***
     *   1) a function to process records
     * Gene proximity search
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromProximitySearch = function (data, rawVariantAssociationRecords) {
        var geneInfoArray = [];
        if (( typeof data !== 'undefined') &&
            ( data !== null ) &&
            ( typeof data.data !== 'undefined') ) {
            if (data.data.length === 0) {
                alert(' No variants in the specified region')
            } else {
                rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                _.forEach(data.data, function (variantRec) {
                    var variantRecToExtend  = variantRec;
                    variantRecToExtend["name"] = variantRec.var_id; // standard field in which to store the index value?
                    rawVariantAssociationRecords.push(variantRecToExtend);
                });
            }
        }
        return rawVariantAssociationRecords;
    };


    var displayRefinedVariantsInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {
        mpgSoftware.dynamicUi.displayHeaderForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            callingParameters.nameOfAccumulatorField);


    };





    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).posteriorProbabilitySignificance;



// public routines are declared below
    return {
        processRecordsFromProximitySearch: processRecordsFromProximitySearch,
        displayRefinedVariantsInARange:displayRefinedVariantsInARange
    }
}());
