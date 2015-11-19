<style>

div.burden-test-wrapper-options {
    background-color: #eee;
    border: solid 1px #ddd;
    font-size: 16px;
    padding-top: 15px;
    padding-bottom: 15px;
}

div.burden-test-btn-wrapper {
    padding-top: 8px;
}

button.burden-test-btn {
    width: 100%;
}

div.burden-test-result {
    font-size: 18px;
    padding-top: 30px;
    display: none;
}

div.burden-test-result-large {
    font-size: 25px;
    padding-top: 10px;
    display: none;
}

.burden-test-result .pValue {
    white-space: nowrap;
}

div.labelAndInput {
    white-space: nowrap;
}

div.labelAndInput > input {
    width: 150px;
}

.burden-test-result .orValue {
    white-space: nowrap;
}

.burden-test-result .ciValue {
    white-space: nowrap;
}

.mafOptionChooser div.radio {
    padding: 0 20px 0 0;
}

.vcenter {
    margin-top: 2em;
}
.vertical-center {
    margin-top: 1em;
}
.variantList {
    border: 1px solid darkgrey;
    padding: 2px;
    max-height: 140px;
    overflow-y: auto;
    font-size: 14px;
}
.variantsListLabel {
    text-align: center;
}
.burdenTestResultHolder {
    height: 140px;
}
</style>


<g:javascript>
    var mpgSoftware = mpgSoftware || {};

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
//                        $('#significanceDescriptorFormatter').empty();
//                        $('#possibleCarrierVariantsLink').empty();
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

    mpgSoftware.burdenTestShared = (function () {
         var loading = $('#rSpinner');

        /***
        *  Fill the drop down list with values.  Presumably we need to run this method right after the page load completes.
        *
        */
        var fillFilterDropDown = function (){
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'variantInfo',action: 'burdenTestTraitSelectionOptionsAjax')}",
                data: {},
                    async: true,
                    success: function (data) {

                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestTraitSelectionOptionsAjax');
                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                                }
                                else if ((typeof data.phenotypes === 'undefined') ||
                                         (data.phenotypes.length <= 0)){
                                     console.log('burdenTestAjax returned undefined (or length = 0) for options.');
                               }else {
                                   var optionList = data.phenotypes;
                                   var dropDownHolder = $('#traitFilter');
                                   for ( var i = 0 ; i < optionList.length ; i++ ){
                                        dropDownHolder.append('<option value="'+optionList[i].name+'">'+optionList[i].description+'</option>')
                                   }
                                }
                            }

                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });
        }; // fillFilterDropDown


        /**
         *  run the burden test, then display the results.  We will need to start by extracting
         *  the data fields we need from the DOM.
         *
         *
         */
        var runBurdenTest = function (){

             var fillInResultsSection = function (pValue, oddsRatio, stdError, isDichotomousTrait){
                // populate the data
                $('.pValue').text(pValue);
                $('.orValue').text(oddsRatio);
                $('.ciValue').text(stdError);

                // show the results
                if (isDichotomousTrait) {
                    $('#burden-test-some-results-large').hide();
                    $('#burden-test-some-results').show();
                } else {
                    $('#burden-test-some-results').hide();
                    $('#burden-test-some-results-large').show();
                }
             };

             $('#rSpinner').show();
            var traitFilterSelectedOption = $('#traitFilter').val();

            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'variantInfo',action: 'burdenTestAjax')}",
                data: {variantName: '<%=variantIdentifier%>',
                        traitFilterSelectedOption: traitFilterSelectedOption
                     },
                    async: true,
                    success: function (data) {

                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestAjax');

                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error =' + data.is_error +'.');

                                } else if ((typeof data.stats.pValue === 'undefined') ||
                                         (typeof data.stats.beta === 'undefined') ||
                                         (typeof data.stats.stdError === 'undefined')){
                                     console.log('burdenTestAjax returned undefined for P value, standard error or beta.');

                                } else {
                                   var isDichotomousTrait = false;
                                   if ((typeof data.stats.numCases === 'undefined') ||
                                        (typeof data.stats.numControls === 'undefined') ||
                                        (typeof data.stats.numCaseCarriers === 'undefined') ||
                                        (typeof data.stats.numControlCarriers === 'undefined')) {
                                       isDichotomousTrait = false;
                                   } else {
                                       isDichotomousTrait = true;
                                   }

                                   //var oddsRatio = data.stats.oddsRatio; // must remove oddsRatio ref due to API change
                                   var oddsRatio = UTILS.realNumberFormatter(Math.exp(data.stats.beta));
                                   var beta = UTILS.realNumberFormatter(data.stats.beta);
                                   var stdError = UTILS.realNumberFormatter(data.stats.stdError);
                                   var pValue = UTILS.realNumberFormatter(data.stats.pValue);
                                   var numberVariants = data.stats.numInputVariants;

                                   var ciDisplay = '';
                                   if (!((typeof data.stats.ciLower === 'undefined') ||
                                        (typeof data.stats.ciUpper === 'undefined') ||
                                        (typeof data.stats.ciLevel === 'undefined'))) {
                                       var ciUpper = data.stats.ciUpper;
                                       var ciLower = data.stats.ciLower;
                                       var ciLevel = data.stats.ciLevel;

                                       if (isDichotomousTrait) {
                                            ciLower = UTILS.realNumberFormatter(Math.exp(data.stats.ciLower));
                                            ciUpper = UTILS.realNumberFormatter(Math.exp(data.stats.ciUpper));
                                       } else {
                                            ciLower = UTILS.realNumberFormatter(data.stats.ciLower);
                                            ciUpper = UTILS.realNumberFormatter(data.stats.ciUpper);
                                       }
                                       ciDisplay = '( ' + (ciLevel * 100) + '% CI: ' + ciLower + ' to ' + ciUpper + ')';
                                   }

                                   fillInResultsSection('p-Value = '+ pValue,
                                   (isDichotomousTrait ? 'odds ratio = ' + oddsRatio : 'beta = ' + beta),
                                        ciDisplay, isDichotomousTrait);

                                   // now see if we fill the hypothesis section
                                   if (!isDichotomousTrait) {
                                     console.log('burdenTestAjax returned undefined for case/control number, so not displaying hypothesis graphic.');

                                   }else {
                                       // fill in the hypothesis graphic
                                       var caseCount = data.stats.numCases;
                                       var controlCount = data.stats.numControls;
                                       var caseCarrierCount = data.stats.numCaseCarriers;
                                       var controlCarrierCount = data.stats.numControlCarriers;

                                       // first clear any existing bar chart
                                       if ((typeof mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter() !== 'undefined') &&
                                            (typeof mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch !== 'undefined')) {
                                            mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().removeBarchart();
                                       }

                                       // populate the bar legend
                                       $("#traitSpan").text('T2D');
                                       $("#variantNumberSpan").text(numberVariants);

                                       /// fill up the bar chart
                                       mpgSoftware.burdenInfo.fillBurdenBiologicalHypothesisTesting(caseCarrierCount, caseCount, controlCarrierCount, controlCount, 'T2D');

                                       // launch
                                       mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch();
                                   }

                               }
                            }
                        $('#rSpinner').hide();
                    },
                    error: function (jqXHR, exception) {
                        $('#rSpinner').hide();
                        core.errorReporter(jqXHR, exception);
                    }
                });
        }; // runBurdenTest

        // public routines are declared below
        return {
            runBurdenTest:runBurdenTest,
            fillFilterDropDown:fillFilterDropDown
        }

    }());

$( document ).ready( function (){
   mpgSoftware.burdenTestShared.fillFilterDropDown ();
} );

//runBurdenTest ();



</g:javascript>

<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
            <h2><strong><g:message code="variant.info.burden.test.title" default="Test for association with quantitative traits"/></strong></h2>
        </a>
    </div>

    <div id="collapseBurden" class="accordion-body collapse">
        <div class="accordion-inner">


            <div class="container">
                <h3>Select a trait to test for association.</h3>

                <div class="row burden-test-wrapper-options">
                    <div  class="col-md-2 col-sm-2 col-xs-12 burden-test-btn-wrapper vcenter"></div>
                    <div  class="col-md-4 col-sm-4 col-xs-12 burden-test-btn-wrapper vcenter">
                        <label>Available traits:
                            <select id="traitFilter" class="traitFilter form-control">
                            </select>
                        </label>
                    </div>
                    <div  class="col-md-4 col-sm-4 col-xs-12 burden-test-btn-wrapper vcenter">
                        <button id="singlebutton" name="singlebutton" style="height: 80px"
                                class="btn btn-primary btn-lg burden-test-btn" onclick="mpgSoftware.burdenTestShared.runBurdenTest()">Run</button>
                    </div>
                    <div  class="col-md-2 col-sm-2 col-xs-12 burden-test-btn-wrapper vcenter"></div>
                </div>

                <div id="burden-test-some-results" class="row burden-test-result">
                    <div class="col-md-8 col-sm-6">
                        <div id="variantFrequencyDiv">
                            <div>
                                <p class="standardFont">Of the <span id="traitSpan"></span> cases/controls, the following carry the variant ${variantIdentifier}.</p>
                            </div>
                            <div class="barchartFormatter">
                                <div id="chart">

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-3">
                    </div>
                    <div class="col-md-2 col-sm-3">
                        <div class="vertical-center">
                            <div id="pValue" class="pValue"></div>
                            <div id="orValue" class="orValue"></div>
                            <div id="ciValue" class="ciValue"></div>
                        </div>
                    </div>
                </div>

                <div id="burden-test-some-results-large" class="row burden-test-result-large">
                    <div class="col-md-4 col-sm-3">
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="vertical-center">
                            <div id="pValue2" class="pValue"></div>
                            <div id="orValue2" class="orValue"></div>
                            <div id="ciValue2" class="ciValue"></div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-3">
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>








