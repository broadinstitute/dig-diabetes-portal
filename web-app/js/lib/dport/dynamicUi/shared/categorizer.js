var mpgSoftware = mpgSoftware || {};  // encapsulating variable
mpgSoftware.dynamicUi = mpgSoftware.dynamicUi || {};   // second level encapsulating variable

mpgSoftware.dynamicUi.sharedCategorizor = (function () {

    /***
     * First we have the private routines
     */

    /***
     * provide a category number which we will use to decide what class will use for coloring.  In this case
     * we are coloring by the number of tissues.
     *
     * @param numberOfTissues
     * @returns {number}
     */
    var categorizeTissueNumbers = function ( numberOfTissues ) {
        var returnValue = 0;
        if ((numberOfTissues>0) &&(numberOfTissues<=2)) {
            returnValue = 1;
        } else if ((numberOfTissues>2) &&(numberOfTissues<=8)) {
            returnValue = 2;
        } else if ((numberOfTissues>8) &&(numberOfTissues<=25)) {
            returnValue = 3;
        } else if ((numberOfTissues>25) &&(numberOfTissues<=100)) {
            returnValue = 4;
        } else if (numberOfTissues>100) {
            returnValue = 5;
        }
        return returnValue;
    };




    var categorizeSignificanceNumbers = function ( significance, datatype, overrideValue ) {
        var returnValue = 0;
        if ( ( typeof significance !== 'undefined') &&
            ( $.isArray(significance) ) &&
            ( significance.length>0 ) ){
            var recordToAssess = significance[0];
            switch (datatype){
                //case "MOD": // significance is not a meaningful concept
                //    returnValue = 6;
                //    break;
                case "ABC": // activity by contact predictions -- higher numbers are good
                    var valueToAssess = significance[0].value;
                    if ((valueToAssess>0) &&(valueToAssess<=0.2)) {
                        returnValue = 5;
                    } else if ((valueToAssess>0.2) &&(valueToAssess<=0.4)) {
                        returnValue = 4;
                    } else if ((valueToAssess>0.4) &&(valueToAssess<=0.6)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.6) &&(valueToAssess<=0.8)) {
                        returnValue = 2;
                    } else if (valueToAssess>0.9) {
                        returnValue = 1;
                    }
                    break
                case "DEG":
                    var valueToAssess = significance[0].pvalue;
                    if ((valueToAssess>0) &&(valueToAssess<=0.5E-8)) {
                        returnValue = 1;
                    } else if ((valueToAssess>0.5E-8) &&(valueToAssess<=0.5E-4)) {
                        returnValue = 2;
                    } else if ((valueToAssess>0.5E-4) &&(valueToAssess<=0.05)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.05) &&(valueToAssess<=0.4)) {
                        returnValue = 4;
                    } else if (valueToAssess>0.4) {
                        returnValue = 5;
                    }
                    break;

                case "DEP":
                //case "MET":
                case "EQT":
                case "FIR":
                case "SKA":
                    var valueToAssess;
                    if ( typeof  overrideValue !== 'undefined') {
                        valueToAssess = overrideValue
                    } else {
                        valueToAssess = significance[0].numericalValue;
                    }
                    if (valueToAssess===0)  {
                        returnValue = 6;
                    } else if ((valueToAssess>0) &&(valueToAssess<=0.5E-8)) {
                        returnValue = 1;
                    } else if ((valueToAssess>0.5E-8) &&(valueToAssess<=0.5E-4)) {
                        returnValue = 2;
                    } else if ((valueToAssess>0.5E-4) &&(valueToAssess<=0.05)) {
                        returnValue = 3;
                    } else if ((valueToAssess>0.05) &&(valueToAssess<=0.1)) {
                        returnValue = 4;
                    } else if (valueToAssess>0.1) {
                        returnValue = 5;
                    }
                    break;
                default:
                    break;
            }

        }

        return returnValue;
    };


    /***
     * Now the prototypes that will be externally visible
     * @constructor
     */

    var Categorizor = function(){

    };
    Categorizor.prototype.genePValueSignificance = function ( valueToAssess ) {
        var returnValue = 0;
        if (valueToAssess === 0) {
            returnValue = 6;
        } else if ((valueToAssess > 0) && (valueToAssess <= 0.5E-8)) {
            returnValue = 1;
        } else if ((valueToAssess > 0.5E-8) && (valueToAssess <= 0.5E-4)) {
            returnValue = 2;
        } else if ((valueToAssess > 0.5E-4) && (valueToAssess <= 0.05)) {
            returnValue = 3;
        } else if ((valueToAssess > 0.05) && (valueToAssess <= 0.1)) {
            returnValue = 4;
        } else if (valueToAssess > 0.1) {
            returnValue = 5;
        }
        return returnValue;
    }
    Categorizor.prototype.posteriorProbabilitySignificance = function ( valueToAssess, datatype, overrideValue ){
        var returnValue = 0;
        if ((valueToAssess>0) &&(valueToAssess<=0.2)) {
            returnValue = 5;
        } else if ((valueToAssess>0.2) &&(valueToAssess<=0.4)) {
            returnValue = 4;
        } else if ((valueToAssess>0.4) &&(valueToAssess<=0.6)) {
            returnValue = 3;
        } else if ((valueToAssess>0.6) &&(valueToAssess<=0.8)) {
            returnValue = 2;
        } else if (valueToAssess>0.9) {
            returnValue = 1;
        }
        return returnValue;
    };
    Categorizor.prototype.categorizeTissueNumbers = categorizeTissueNumbers;
    Categorizor.prototype.categorizeSignificanceNumbers = categorizeSignificanceNumbers;

return {
    Categorizor: Categorizor
    }
}());