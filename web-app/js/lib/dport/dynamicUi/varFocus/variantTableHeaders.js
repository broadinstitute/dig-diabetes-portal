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


    const calculatePosteriorPValues = function (objectWithVariantInfo) {
        const nlogpValArray = _.map( objectWithVariantInfo.data, function(eachVariant){
            var pValue = eachVariant.p_value;
            if (pValue !== "") {
                return 0 - (Math.log(pValue) / Math.LN10);
            } else {
                return 0;
            }
        });
        const scores = gwasCredibleSets.scoring.bayesFactors(nlogpValArray);
        const posteriorProbabilities = gwasCredibleSets.scoring.normalizeProbabilities(scores);
        const credSetLevels = [0.95,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];
        let chosenCredSetLevel = -1;
        let credibleSet = [];
        _.forEach(credSetLevels, function(credSetLevel,index){
            credibleSet = gwasCredibleSets.marking.findCredibleSet(posteriorProbabilities, credSetLevel );
            //let numberOfElements =_.filter(credibleSet,function(o){return o>0}).length;
            let numberOfElements =_.filter(credibleSet,function(o){return true}).length;
            if ((numberOfElements>0)&&(numberOfElements<11)){
                chosenCredSetLevel = index;
                objectWithVariantInfo.header['credSetLevel'] = ""+credSetLevel;
                return false;
            }} );
        {

        }
        if (chosenCredSetLevel>-1){
            const credibleSetBoolean = gwasCredibleSets.marking.markBoolean(credibleSet);
            let filteredVariants = [];
            objectWithVariantInfo.data.forEach(function (item, index) {
                if (credibleSetBoolean[index]) {
                    item["POSTERIOR_PROBABILITY"]=posteriorProbabilities[index];
                }
                filteredVariants.push(item);// push this inside of the above conditional and you will only get elements in the credible so

            });
            objectWithVariantInfo.data = filteredVariants;
        }
        return objectWithVariantInfo;


    }




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
            ( data !== null ) ){
            // data from the old API call comes back as an array, while the new API call
            // comes back as an object with the array held in a field. Let's support either.
            let dataArray = [];
            let returnValue = { header: {}, data: []};
            if  ( typeof data.data !== 'undefined') {
                dataArray = data.data;
            } else {
                dataArray = data;
            }
            if (dataArray.length === 0) {
                //alert(' No variants in the specified region')
            } else {
                rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                _.forEach(dataArray, function (variantRec) {
                    var variantRecToExtend  = variantRec;
                    variantRecToExtend["name"] = variantRec.var_id; // standard field in which to store the index value?
                    returnValue.data.push(variantRecToExtend);
                    // rawVariantAssociationRecords.push(variantRecToExtend);
                });
                let filteredVariants = calculatePosteriorPValues(returnValue);
                rawVariantAssociationRecords.push(filteredVariants);
            }
        }
        return rawVariantAssociationRecords;
    };


    var displayRefinedVariantsInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {
        mpgSoftware.dynamicUi.displayHeaderForVariantTable(idForTheTargetDiv, // which table are we adding to
            callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            callingParameters.nameOfAccumulatorField,
            function(
                presentationString, variantId, indexInOneDimensionalArray,emphasisSwitch,pValue,posteriorPValue
            ){
            let pValueDisplayable = "";
            if (pValue>0){
                pValueDisplayable = UTILS.realNumberFormatter(pValue,2);
            }
                let posteriorPValueDisplayable = "";
                if (posteriorPValue>0){
                    posteriorPValueDisplayable = UTILS.realNumberFormatter(posteriorPValue,4);
                }

                return {indexInOneDimensionalArray:indexInOneDimensionalArray,
                    emphasisSwitch:emphasisSwitch,
                    pValue:pValue,
                    pValueDisplayable:pValueDisplayable,
                    posteriorPValue:posteriorPValue,
                    posteriorPValueDisplayable:posteriorPValueDisplayable
            }
            });


    };





    /***
     *  3) set of categorizor routines
     * @type {Categorizor}
     */
    var categorizor = new mpgSoftware.dynamicUi.Categorizor();
    categorizor.categorizeSignificanceNumbers = Object.getPrototypeOf(categorizor).posteriorProbabilitySignificance;


    let sortUtility = new mpgSoftware.dynamicUi.SortUtility();
    const sortRoutine = Object.getPrototypeOf(sortUtility).textComparisonWithEmptiesAtBottom;

// public routines are declared below
    return {
        processRecordsFromProximitySearch: processRecordsFromProximitySearch,
        displayRefinedVariantsInARange:displayRefinedVariantsInARange,
        sortRoutine:sortRoutine
    }
}());
