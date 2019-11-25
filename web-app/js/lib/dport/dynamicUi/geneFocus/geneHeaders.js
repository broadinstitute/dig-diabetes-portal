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

mpgSoftware.dynamicUi.geneHeaders = (function () {
    "use strict";



    /***
     *   1) a function to process records
     * Gene proximity search
     * @param data
     * @param rawGeneAssociationRecords
     * @returns {*}
     */
    var processRecordsFromProximitySearch = function (data, rawGeneAssociationRecords) {
        var geneInfoArray = [];
        if (( typeof data !== 'undefined') &&
            ( data !== null ) &&
            (data.is_error === false ) &&
            ( typeof data.listOfGenes !== 'undefined')) {
            if (data.listOfGenes.length === 0) {
                alert(' No genes in the specified region')
            } else {
                _.forEach(data.listOfGenes, function (geneRec) {
                   if ( typeof _.find(rawGeneAssociationRecords,{name:geneRec.name2}) === 'undefined'){
                        var chromosomeString = _.includes(geneRec.chromosome, "chr") ? geneRec.chromosome.substr(3) : geneRec.chromosome;
                        rawGeneAssociationRecords.push({
                                chromosome: chromosomeString,
                                startPos: geneRec.addrStart,
                                endPos: geneRec.addrEnd,
                                name: geneRec.name2,
                                id: geneRec.id
                            }
                        );
                    }
                    ;
                });
            }
        }
        return rawGeneAssociationRecords;
    };


    var displayRefinedGenesInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords,callingParameters) {
        mpgSoftware.dynamicUi.displayHeaderForGeneTable('table.combinedGeneTableHolder', // which table are we adding to
            callingParameters
            // 'GHDR', // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            // 'geneInfoArray'
        );


    };


    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).posteriorProbabilitySignificance;

    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = function(a, b, direction, currentSortObject){
        if (currentSortObject.desiredSearchTerm==='sortfield'){
            return Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom(a, b, direction, currentSortObject);
        } else if (currentSortObject.desiredSearchTerm==='geneName'){
            return Object.getPrototypeOf(sortUtility).textComparisonWithEmptiesAtBottom(a, b, direction, currentSortObject);
        }
    };



// public routines are declared below
    return {
        processRecordsFromProximitySearch: processRecordsFromProximitySearch,
        displayRefinedGenesInARange:displayRefinedGenesInARange,
        sortRoutine:sortRoutine
    }
}());
