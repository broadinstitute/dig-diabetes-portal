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
        font-size: 16px;
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

    mpgSoftware.burdenTest = (function () {
         var loading = $('#rSpinner');

        /***
        *  Fill the drop down list with values.  Presumably we need to run this method right after the page load completes.
        *
        */
        var fillFilterDropDown = function (){
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}",
                data: {},
                    async: true,
                    success: function (data) {

                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestVariantSelectionOptionsAjax');
                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                                }
                                else if ((typeof data.options === 'undefined') ||
                                         (data.options.length <= 0)){
                                     console.log('burdenTestAjax returned undefined (or length = 0) for options.');
                               }else {
                                   var optionList = data.options;
                                   var dropDownHolder = $('.proteinEffectFilter');
                                   for ( var i = 0 ; i < optionList.length ; i++ ){
                                        dropDownHolder.append('<option value="'+optionList[i].id+'">'+optionList[i].name+'</option>')
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

             var fillInResultsSection = function (pValue, oddsRatio, stdError, numberVariants, variantArray, urlLink){
                var test = "";
                 // $('.burden-test-result').empty();  // clear out whatever was there before
                 if ((typeof variantArray === 'undefined') ||
                     (variantArray.length <= 0)){
                        // show the no results
                        $("#burden-test-some-results").hide();
                        $("#burden-test-no-results").show();
                  } else {
                     var variantAnchors = [];
                     for ( var i = 0 ; i < variantArray.length ; i++ ) {
                        variantAnchors.push("<div><a href='"+urlLink+"/"+variantArray[i]+"'>"+variantArray[i]+"</a></div>");
                     }

                    // populate the data
                    $('#pValue').text(pValue);
                    $('#orValue').text(oddsRatio);
                    $('#ciValue').text(stdError);
                    $('#variantLabel').text(numberVariants);
                    $('#variantList').html(variantAnchors.join('\n'));

                    // show the results
                    $('#burden-test-some-results').show();
                    $('#burden-test-no-results').hide();
                  }

             };

        var selectedFilterValue = $('.proteinEffectFilter option:selected').val(),
             selectedFilterValueId = parseInt(selectedFilterValue),
             selectedDataSetValue = $('input[name=dataset]:checked').val(),
             selectedDataSetValueId = parseInt(selectedDataSetValue),
             selectedMafOption = $('input[name=mafOption]:checked').val(),
             selectedMafOptionId =  parseInt(selectedMafOption),
             specifiedMafValue = $('#mafInput').val(),
             specifiedMafValueId;
             // JavaScript can't understand a number of it starts with a decimal.  Prepend a zero just to be safe, since that will never hurt
             if ((specifiedMafValue)&&
                 (specifiedMafValue.length> 0)){
                    var trimmedMafValue = specifiedMafValue.trim();
                    if (trimmedMafValue.charAt(0) === '.'){
                       specifiedMafValue = '0'+trimmedMafValue;
                    }
             }
             specifiedMafValueId = parseFloat(specifiedMafValue);
             $('#rSpinner').show();
             if (isNaN(selectedFilterValueId)){
                selectedFilterValueId = 0;
             }
             if (isNaN(selectedDataSetValueId)){
                selectedDataSetValueId = 0;
             }
             if (isNaN(selectedMafOptionId)){
                selectedMafOptionId = 0;
             }
             if (specifiedMafValue){
                 if (isNaN(specifiedMafValueId)){
                    alert("<g:message code='gene.burdenTesting.maf_error_nan' />" + specifiedMafValue + " <g:message code='gene.burdenTesting.maf_is_invalid' />");
                    $('#rSpinner').hide();
                    return;
                  } else if (specifiedMafValueId <= 0) {
                    alert("<g:message code='gene.burdenTesting.maf_error_lt0'/>" + specifiedMafValue + " <g:message code='gene.burdenTesting.maf_is_invalid' />");
                    $('#rSpinner').hide();
                    return;
                  }
                  else if (specifiedMafValueId > 1) {
                    alert("<g:message code='gene.burdenTesting.maf_error_gt1' />" + specifiedMafValue + " <g:message code='gene.burdenTesting.maf_is_invalid' />");
                    $('#rSpinner').hide();
                    return;
                  }
             }
             $('input[name=dataset]:checked').val();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'gene',action: 'burdenTestAjax')}",
                data: {geneName: '<%=geneName%>',
                       filterNum: selectedFilterValueId,
                       dataSet: selectedDataSetValueId,
                       mafValue: specifiedMafValueId,
                       mafOption: selectedMafOptionId
                     },
                    async: true,
                    success: function (data) {

                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestAjax');
                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                                }
                                else if ((typeof data.stats.pValue === 'undefined') ||
                                         (typeof data.stats.beta === 'undefined') ||
                                         (typeof data.stats.stdError === 'undefined')){
                                     console.log('burdenTestAjax returned undefined for P value, standard error or beta.');
                               }else {
                                   var pValue = data.stats.pValue;
                                   //var oddsRatio = data.stats.oddsRatio; // must remove oddsRatio ref due to API change
                                   var beta = data.stats.beta;
                                   var stdError = data.stats.stdError;
                                   var pValue = data.stats.pValue;
                                   var numberVariants = data.stats.numInputVariants;
                                   fillInResultsSection('p-Value = '+UTILS.realNumberFormatter(pValue),
                                   'odds ratio = ' +UTILS.realNumberFormatter(Math.exp(beta)),
                                   'standard error = ' +UTILS.realNumberFormatter(stdError),
                                   numberVariants,
                                   data.variants,"${createLink(controller: 'variantInfo', action: 'variantInfo')}");

                                   if ((typeof data.stats.numCases === 'undefined') ||
                                        (typeof data.stats.numControls === 'undefined') ||
                                        (typeof data.stats.numCaseCarriers === 'undefined') ||
                                        (typeof data.stats.numControlCarriers === 'undefined')) {
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
   mpgSoftware.burdenTest.fillFilterDropDown ();
} );

//runBurdenTest ();



</g:javascript>



<div class="container">
    <h3><g:message code="gene.burdenTesting.prepare_run"/> <%=geneName%>.</h3>

    <div class="row burden-test-wrapper-options">
        <div class="col-md-8 col-sm-8 col-xs-12">
            <div  class="row">
                <div class="col-md-4 col-sm-4 col-xs-4">
                    <label><g:message code="gene.burdenTesting.label.select_dataset"/>:&nbsp;&nbsp;</label>
                    <div class="form-inline">
                        <div class="radio">
                            <label><input type="radio" name="dataset" value="1" checked>&nbsp;13k&nbsp;&nbsp;</label>
                        </div>
                        <div class="radio">
                            <label><input type="radio" name="dataset"  value="2" disabled>&nbsp;<span style="color: DarkGray">26k</span></label>
                        </div>
                    </div>
                </div>
                <div class="col-md-8 col-sm-8 col-xs-8">
                    <label><g:message code="gene.burdenTesting.label.available_variant_filter"/>:
                        <select class="proteinEffectFilter form-control">
                            <option selected hidden><g:message code="gene.burdenTesting.label.select_filter"/></option>
                        </select>
                    </label>
                </div>
            </div>
            <div  class="row">
                  <div style="margin:15px 8px 15px 10px" class="separator"></div>
            </div>
            <div  class="row">
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <label for="mafInput"><g:message code="gene.burdenTesting.label.maf"/>:</label>
                    <div class="labelAndInput">
                        MAF &lt;&nbsp;
                        <input style="display: inline-block" type="text" class="form-control" id="mafInput" placeholder="value">
                    </div>

                </div>
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <label><g:message code="gene.burdenTesting.label.apply_maf"/>:&nbsp;&nbsp;</label>
                    <div class="form-inline mafOptionChooser">
                        <div class="radio">
                            <label><input type="radio" name="mafOption" value="1" />&nbsp;<g:message code="gene.burdenTesting.label.all_samples"/></label>
                        </div>
                        <div class="radio">
                            <label><input type="radio" name="mafOption"  value="2" checked />&nbsp;<g:message code="gene.burdenTesting.label.each_ancestry"/></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div  class="col-md-4 col-sm-4 col-xs-12 burden-test-btn-wrapper vcenter">
            <button id="singlebutton" name="singlebutton" style="height: 80px"
                    class="btn btn-primary btn-lg burden-test-btn" onclick="mpgSoftware.burdenTest.runBurdenTest()"><g:message code="gene.burdenTesting.label.run"/></button>
        </div>
    </div>

    <div id="burden-test-no-results" class="row burden-test-result">
        <div class="col-sm-6 col-sm-offset-3 "><g:message code="gene.burdenTesting.messages.no_results"/></div>
        <div class="col-sm-3 "></div>
    </div>

    <div id="burden-test-some-results" class="row burden-test-result">
        <div class="col-md-8 col-sm-6">
            <div>
                <p class="standardFont"><g:message code="gene.burdenTesting.messages.some_results"/></p>
            </div>
            <div class="barchartFormatter">
                <div id="chart">

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
            <div>&nbsp;</div>
            <div>
                <div class="variantsListLabel"><span  id="variantLabel"></span> <g:message code="variant.label.variants"/>:</div>
                <div id="variantList" class="variantList"></div>
            </div>
        </div>
    </div>

</div>










