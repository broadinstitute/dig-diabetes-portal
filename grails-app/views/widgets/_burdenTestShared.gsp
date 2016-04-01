<style>

div.burden-test-wrapper-options {
    background-color: #eee;
    border: solid 1px #ddd;
    font-size: 16px;
    padding-top: 15px;
    padding-bottom: 15px;
}
div.burden-test-wrapper-options .row {
    margin: 0 0 8px 0;
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
                delayedBurdenDataPresentation = {functionToRun: mpgSoftware.variantInfo.fillUpBarChart,
                    barchartPtr: retainBarchartPtr,
                    launch: function () {
//                        retainBarchartPtr = mpgSoftware.variantInfo.fillUpBarChart(caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName);
//                        return retainBarchartPtr;
                    },
                    removeBarchart: function () {
//                        if ((typeof retainBarchartPtr !== 'undefined') &&
//                            (typeof retainBarchartPtr.clear !== 'undefined')) {
//                            retainBarchartPtr.clear('T2D');
//                        }
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

            var retrieveMatchingDataSets = function (selPhenotypeSelector,selDataSetSelector){
                var processReturnedDataSets = function (phenotypeName,matchingDataSets){
                   var dataSetDropDown = $(selDataSetSelector);
                   if ((typeof dataSetDropDown !== 'undefined') &&
                     (typeof matchingDataSets !== 'undefined') &&
                     (matchingDataSets.length > 0)) {
                     for ( var i = 0 ; i < matchingDataSets.length; i++ )
                        dataSetDropDown.append(new Option(matchingDataSets[i].translation,matchingDataSets[i].name,matchingDataSets[i].translation));
                     }
                };
                UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],selPhenotypeSelector.value,
                "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",processReturnedDataSets );
            };





        /***
        *  Fill the drop down list with values.  Presumably we need to run this method right after the page load completes.
        *
        */
        var fillFilterDropDown = function (){
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'burdenTestTraitSelectionOptionsAjax')}",
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
                            // DIGP-211: hiding t2d for now
                            if (optionList[i].name != 't2d') {
                                dropDownHolder.append('<option value="'+optionList[i].name+'">'+optionList[i].description+'</option>')
                            }
                           }
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });
        }; // fillFilterDropDown

        var retrievePhenotypes = function (dropDownSelector) {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'VariantSearch', action:'retrieveGwasSpecificPhenotypesAjax')}",
                data: {},
                async: true,
                success: function (data) {
                    if (( data !==  null ) &&
                            ( typeof data !== 'undefined') &&
                            ( typeof data.datasets !== 'undefined' ) &&
                            (  data.datasets !==  null ) ) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets,dropDownSelector);
                        $("select#trait-input").val("${g.defaultPhenotype()}");
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
        /**
         *  run the burden test, then display the results.  We will need to start by extracting
         *  the data fields we need from the DOM.
         */
        var runBurdenTest = function (){

            var collectingCovariateValues = function (){
               var pcCovariates = [];
               for ( var i = 0 ; i < 10 ; i++ ) {
                  var pcId = 'PC'+(i+1);
                  var pcElement = $('#covariate_'+pcId);
                  if ((pcElement).is(':checked')){
                    pcCovariates.push(""+(i+1))
                  }
               }
               return "{\"covariates\":[\n" + pcCovariates.join(",") + "\n]}";
            }

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
            var traitFilterSelectedOption = $('#phenotypeFilter').val();

            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'burdenTestAjax')}",
                data: {variantName: '<%=variantIdentifier%>',
                       covariates: collectingCovariateValues(),
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
                               ciDisplay = (ciLevel * 100) + '% CI: (' + ciLower + ' to ' + ciUpper + ')';
                            }

                            fillInResultsSection('p-Value = '+ pValue,
                                (isDichotomousTrait ? 'odds ratio = ' + oddsRatio : 'beta = ' + beta),
                                ciDisplay, isDichotomousTrait);

                            // now see if we fill the hypothesis section
                            if (!isDichotomousTrait) {
                             console.log('burdenTestAjax returned undefined for case/control number, so not displaying hypothesis graphic.');

                            } else {
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
            fillFilterDropDown:fillFilterDropDown,
            retrieveMatchingDataSets:retrieveMatchingDataSets,
            retrievePhenotypes:retrievePhenotypes
        }

    }());

$( document ).ready( function (){
  // mpgSoftware.burdenTestShared.fillFilterDropDown ();
  mpgSoftware.burdenTestShared.retrievePhenotypes('#phenotypeFilter');
} );

</g:javascript>

<div class="accordion-group">
<div class="accordion-heading">
    <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
        <h2><strong><g:message code="variant.info.burden.test.title"
                               default="Test for association with quantitative traits"/></strong></h2>
    </a>
</div>

<div id="collapseBurden" class="accordion-body collapse">
<div class="accordion-inner">

<div class="container">
<h3>Select a trait to test for association.</h3>

<div class="row burden-test-wrapper-options">

    <div class="col-md-6 col-sm-6 col-xs-12 vcenter">
        <div class="row">
            <div class="col-sm-4 col-xs-12 text-right"><label>Choose a phenotype:</label></div>

            <div class="col-sm-8 col-xs-12 text-left">
                <select id="phenotypeFilter" class="traitFilter form-control text-left"
                        onchange="mpgSoftware.burdenTestShared.retrieveMatchingDataSets(this, '#datasetFilter')">
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-4 col-xs-12 text-right"><label>Choose a data set:</label></div>

            <div class="col-sm-8 col-xs-12 text-left">
                <select id="datasetFilter" class="traitFilter form-control text-left">
                </select>
            </div>
        </div>


        <div class="row">
            <div class="col-sm-4 col-xs-12 text-right"><label>Refine search:</label></div>

            <div class="col-sm-8 col-xs-12 text-left">

                <!-- Nav tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#covariates" aria-controls="covariates" role="tab"
                                                              data-toggle="tab">Covariates</a></li>
                    <li role="presentation"><a href="#filters" aria-controls="filters" role="tab"
                                               data-toggle="tab">Filters</a></li>
                    <li role="presentation"><a href="#stratify" aria-controls="stratify" role="tab"
                                               data-toggle="tab">Stratify</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content" style="border: 1px solid #ccc; height: 200px; padding: 4px 0 0 10px">
                    <div role="tabpanel" class="tab-pane active" id="covariates">
                        <div class="row">
                            <div id="covariate-form">
                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC1" type="checkbox" name="covariate" value="PC1"
                                                   checked/>
                                            PC1
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC2" type="checkbox" name="covariate" value="PC2"
                                                   checked/>
                                            PC2</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC3" type="checkbox" name="covariate" value="PC3"
                                                   checked/>
                                            PC3</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC4" type="checkbox" name="covariate" value="PC4"
                                                   checked/>
                                            PC4</label>
                                    </div>

                                </div>

                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC5" type="checkbox" name="covariate" value="PC5"
                                                   checked/>
                                            PC5
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC6" type="checkbox" name="covariate" value="PC6"
                                                   checked/>
                                            PC6</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC7" type="checkbox" name="covariate" value="PC7"
                                                   checked/>
                                            PC7</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC8" type="checkbox" name="covariate" value="PC8"
                                                   checked/>
                                            PC8</label>
                                    </div>

                                </div>
                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC9" type="checkbox" name="covariate" value="PC9"
                                                   checked/>
                                            PC9
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC10" type="checkbox" name="covariate" value="PC10"
                                                   checked/>
                                            PC10</label>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div role="tabpanel" class="tab-pane" id="filters">
                        <div class="row">
                            <div class="col-sm-10 col-xs-12 text-left">
                                <table class="table table-condensed">
                                    <thead>
                                    <tr>
                                        <th width="10%">Use</th>
                                        <th width="30%">Filter</th>
                                        <th width="25%">Cmp</th>
                                        <th width="35%">Parameter</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><input id="useBmi" type="checkbox" name="useBmi" value="BMI" checked/></td>
                                        <td>BMI</td>
                                        <td>
                                            <select class="form-control" data-selectfor="bmiComparator">
                                                <option>&lt;</option>
                                                <option>&gt;</option>
                                                <option>=</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" data-type="propertiesInput"
                                                   data-prop="bmiValue" data-translatedname="P-value">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><input id="useGender" type="checkbox" name="useGender" value="GENDER"
                                                   checked/></td>
                                        <td>Gender</td>
                                        <td>
                                            <label>=</label>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" data-type="propertiesInput"
                                                   data-prop="P_FE_INV" data-translatedname="P-value">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><input id="useAge" type="checkbox" name="useGender" value="GENDER" checked/>
                                        </td>
                                        <td>Age</td>
                                        <td>
                                            <select class="form-control" data-selectfor="ageComparator">
                                                <option>&lt;</option>
                                                <option>&gt;</option>
                                                <option>=</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" data-type="propertiesInput"
                                                   data-prop="ageValue" data-translatedname="P-value">
                                        </td>

                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>

                    <div role="tabpanel" class="tab-pane" id="stratify">
                        <h1 style="color: #ccc">Not yet implemented</h1>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <div class="col-md-4 col-sm-4 col-xs-12 vcenter"></div>

    <div class="col-md-2 col-sm-2 col-xs-12 burden-test-btn-wrapper vcenter">
        <button id="singlebutton" name="singlebutton" style="height: 80px"
                class="btn btn-primary btn-lg burden-test-btn"
                onclick="mpgSoftware.burdenTestShared.runBurdenTest()">Run</button>
    </div>

</div>

<div id="burden-test-some-results" class="row burden-test-result">
    <div class="col-md-8 col-sm-6">
        <div id="variantFrequencyDiv">
            <div>
                <p class="standardFont">Of the <span
                        id="traitSpan"></span> cases/controls, the following carry the variant ${variantIdentifier}.
                </p>
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








