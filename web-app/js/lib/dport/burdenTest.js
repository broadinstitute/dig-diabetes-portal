var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.burdenInfo = (function () {


        var delayedBurdenDataPresentation = {};

        // burden testing hypothesis testing section
        var fillBurdenBiologicalHypothesisTesting = function (caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName) {
            var retainBarchartPtr;

            // The bar chart graphic
            if ((caseNumerator) ||
                (caseDenominator) &&
                (controlNumerator) &&
                (controlDenominator)) {
                delayedBurdenDataPresentation = {functionToRun: mpgSoftware.geneInfo.fillUpBarChart,
                    barchartPtr: retainBarchartPtr,
                    launch: function () {
                        retainBarchartPtr = mpgSoftware.geneInfo.fillUpBarChart(caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName);
                        return retainBarchartPtr;
                    },
                    removeBarchart: function () {
                        if ((typeof retainBarchartPtr !== 'undefined') &&
                            (typeof retainBarchartPtr.clear !== 'undefined')) {
                            retainBarchartPtr.clear('T2D');
                        }
                    }
                };
            }
        };

        var retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter = function () {
            return delayedBurdenDataPresentation;
        };

        return {
            // public routines
            fillBurdenBiologicalHypothesisTesting: fillBurdenBiologicalHypothesisTesting,
            retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter: retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter
        }
    }());

    mpgSoftware.initializeGaitBackgroundData = function(burdenTestVariantSelectionOptionsAjaxUrl){
        return (function () {

            var fillVariantOptionFilterDropDown = function (burdenProteinEffectFilterName) {
                var burdenProteinEffectFilter = burdenProteinEffectFilterName;
                var promise = $.ajax({
                    cache: false,
                    type: "post",
                    url: burdenTestVariantSelectionOptionsAjaxUrl,
                    data: {},
                    async: true
                });
                promise.done(
                    function (data) {
                        if ((typeof data !== 'undefined') && (data)) {
                            //first check for error conditions
                            if (!data) {
                                console.log('null return data from burdenTestVariantSelectionOptionsAjax');
                            } else if (data.is_error) {
                                console.log('burdenTestAjax returned is_error =' + data.is_error + '.');
                            }
                            else if ((typeof data.options === 'undefined') ||
                                (data.options.length <= 0)) {
                                console.log('burdenTestAjax returned undefined (or length = 0) for options.');
                            } else {
                                var optionList = data.options;
                                var dropDownHolder = $(burdenProteinEffectFilter);
                                for (var i = 0; i < optionList.length; i++) {
                                    dropDownHolder.append('<option value="' + optionList[i].id + '">' + optionList[i].name + '</option>')
                                }
                            }
                        }

                    });
                promise.fail();
            }; // fillFilterDropDown


            return {
                // public routines
                fillVariantOptionFilterDropDown: fillVariantOptionFilterDropDown
            }
        }());

    }


})();
