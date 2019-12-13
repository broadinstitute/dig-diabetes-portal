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
                    item["posterior"]=posteriorProbabilities[index];
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
//the approach when we were using the graph database
        if (( typeof data !== 'undefined') &&
            ( data !== null ) ){
            let returnValue = { header: {}, data: []};
            if ( typeof data.variants !== 'undefined') {
               if ( ( typeof data.variants.variants !== 'undefined') ){// getAggData
                    if ( data.variants.variants.length === 0) {
                        rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                        returnValue.data = [];
                        rawVariantAssociationRecords.push(returnValue)
                        console.log(' No variants in the specified region');
                    } else {
                        rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                        _.forEach(_.uniqBy(data.variants.variants,'VAR_ID'), function (variantRec,index) {
                            var variantRecToExtend  = variantRec;
                            variantRecToExtend["name"] = variantRec.VAR_ID;
                            variantRecToExtend["var_id"] = variantRec.VAR_ID;
                            variantRecToExtend["p_value"] = variantRec.P_VALUE;
                            variantRecToExtend["consequence"] = [variantRec.Consequence];
                            variantRecToExtend["most_del_score"] = variantRec.MOST_DEL_SCORE;
                            returnValue.data.push(variantRecToExtend);
                            if (index>9) { return false;}
                        });
                        let filteredVariants = calculatePosteriorPValues(returnValue);
                        rawVariantAssociationRecords.push(filteredVariants);
                    }
                } else { // getData
                   if ( data.variants.length === 0) {
                       rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                       returnValue.data = [];
                       rawVariantAssociationRecords.push(returnValue)
                       console.log(' No variants in the specified region')
                   } else {
                       rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                       //var allVariants = _.flatten([{}, data.variants]);
                       var flattendVariants = _.map(data.variants,function(o){return  _.merge.apply(_,o)});
                       let weHavePrecalculatedPosteriors = false;
                       _.forEach(_.uniqBy(flattendVariants,'VAR_ID'), function (variantRec,index) {
                           var variantRecToExtend  = variantRec;
                           variantRecToExtend["name"] = variantRec.VAR_ID;
                           variantRecToExtend["var_id"] = variantRec.VAR_ID;
                           _.forEach(variantRecToExtend['P_VALUE'],function(oo){
                               _.forEach(oo,function(v,k){
                                   variantRecToExtend["p_value"] = v;
                               })
                           });
                           _.forEach(variantRecToExtend['POSTERIOR_PROBABILITY'],function(oo){
                               _.forEach(oo,function(v,k){
                                   if (v!==null){weHavePrecalculatedPosteriors = true;}
                                   variantRecToExtend["posterior"] = v;
                               })
                           });

                           variantRecToExtend["consequence"] = [variantRec.Consequence];
                           variantRecToExtend["most_del_score"] = variantRec.MOST_DEL_SCORE;
                           returnValue.data.push(variantRecToExtend);
                           if (index>9) { return false;}
                       });
                       let filteredVariants;
                       if (!weHavePrecalculatedPosteriors) {
                           filteredVariants = calculatePosteriorPValues(returnValue);
                       } else {
                           filteredVariants = returnValue;
                           filteredVariants["credSetLevel"] = "0.95";
                       }
                       rawVariantAssociationRecords.push(filteredVariants);
                   }

               }
            } else {
                let dataArray = [];
                if  ( typeof data.data !== 'undefined') {
                    dataArray = data.data;
                } else {
                    dataArray = data;
                }
                if (dataArray.length === 0) {
                    rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                    returnValue.data = [];
                    rawVariantAssociationRecords.push(returnValue)
                } else {
                    let weHavePrecalculatedPosteriors = false;
                    rawVariantAssociationRecords.splice(0,rawVariantAssociationRecords.length);
                    _.forEach(dataArray, function (variantRec) {
                        var variantRecToExtend  = variantRec;
                        if ( typeof variantRec.posterior_probability !== 'undefined'){
                            weHavePrecalculatedPosteriors = true;
                            variantRecToExtend["POSTERIOR_PROBABILITY"]=variantRec.posterior_probability;
                            variantRecToExtend["posterior"]=variantRec.posterior_probability;
                        }
                        variantRecToExtend["name"] = variantRec.var_id; // standard field in which to store the index value?
                        returnValue.data.push(variantRecToExtend);
                    });
                    let filteredVariants;
                    if (!weHavePrecalculatedPosteriors) {
                        filteredVariants = calculatePosteriorPValues(returnValue);
                    } else {
                        returnValue.data = _.filter(returnValue.data,function(o){return o.posterior>0.05})
                        filteredVariants = returnValue;
                        filteredVariants["credSetLevel"] = "0.95";
                    }
                    rawVariantAssociationRecords.push(filteredVariants);
                }

            }
        }
        return rawVariantAssociationRecords;

    };


    var displayRefinedVariantsInARange = function (idForTheTargetDiv, objectContainingRetrievedRecords, callingParameters) {
        mpgSoftware.dynamicUi.displayHeaderForVariantTable(idForTheTargetDiv, // which table are we adding to
            // callingParameters.code, // Which codename from dataAnnotationTypes in geneSignalSummary are we referencing
            // callingParameters.nameOfAccumulatorField,
            callingParameters,
            function(
                presentationString, variantId, indexInOneDimensionalArray,emphasisSwitch,pValue,posteriorPValue
            ){
            let pValueDisplayable = "";
            if (pValue>0){
                pValueDisplayable = UTILS.realNumberFormatter(pValue,2);
            }
                let posteriorPValueDisplayable = "";
                if (posteriorPValue>0){
                    posteriorPValueDisplayable = UTILS.realNumberFormatter(posteriorPValue,3);
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


    const sortBinaryEmphasis = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = $(a).attr(defaultSearchField);
        var y = $(b).attr(defaultSearchField);
        return (x < y) ? 1 : (x > y) ? -1 : 0;
    };


    const sortMethodNamesWithZerosAtTheBottom = function(a, b, direction, currentSortObject){
        const defaultSearchField = currentSortObject.desiredSearchTerm;
        var x = parseInt($(a).attr(defaultSearchField));
        var y = parseInt($(b).attr(defaultSearchField));
        if ( (x===0) && (y===0) ) {
            return 0;
        }
        else if (x===0) {
            if (direction==='asc') {
                return 1;
            } else {
                return -1;
            }
        }else if (y===0)
        {
            if (direction==='asc') {
                return -1;
            } else {
                return 1;
            }
        }
        return (x < y) ? 1 : (x > y) ? -1 : 0;
    };


    let sortUtility = new mpgSoftware.dynamicUi.sharedSortUtility.SortUtility();
    const sortRoutine = function(a, b, direction, currentSortObject){
        switch(currentSortObject.currentSort){
            case 'VariantCoding':
            case 'VariantSplicing':
            case 'VariantUtr':
                currentSortObject['desiredSearchTerm'] =  "sortfield";
                return sortBinaryEmphasis(a, b, direction, currentSortObject);
                break;
            case 'sortMethodsInVariantTable':

                return  Object.getPrototypeOf(sortUtility).textComparisonWithEmptiesAtBottom(a,b, direction, currentSortObject);

                // return sortMethodNamesWithZerosAtTheBottom(a, b, direction, currentSortObject);
                break;
            case 'VariantAssociationPValue':
                return  Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom(a, b, direction, currentSortObject);
                break;
            case 'VariantAssociationPosterior':
                return  Object.getPrototypeOf(sortUtility).numericalComparisonWithEmptiesAtBottom(a, b, direction, currentSortObject);
                break;
            default: return 0;
        }
    }

// public routines are declared below
    return {
        processRecordsFromProximitySearch: processRecordsFromProximitySearch,
        displayRefinedVariantsInARange:displayRefinedVariantsInARange,
        sortRoutine:sortRoutine
    }
}());
