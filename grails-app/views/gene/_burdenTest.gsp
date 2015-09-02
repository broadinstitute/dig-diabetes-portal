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
        font-size: 25px;
        padding-top: 20px;
    }

    .burden-test-result .pValue {
        white-space: nowrap;
    }

    .burden-test-result .orValue {
        white-space: nowrap;
    }

</style>


<g:javascript>
    var mpgSoftware = mpgSoftware || {};

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

             var selectedFilterValue = $('.proteinEffectFilter option:selected').val(),
             selectedFilterValueId = parseInt(selectedFilterValue),
             selectedDataSetValue = $('input[name=dataset]:checked').val(),
             selectedDataSetValueId = parseInt(selectedDataSetValue);
             $('#rSpinner').show();
             if (isNaN(selectedFilterValueId)){
                selectedFilterValueId = 0;
             }
             if (isNaN(selectedDataSetValueId)){
                selectedDataSetValueId = 0;
             }
             $('input[name=dataset]:checked').val();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'gene',action: 'burdenTestAjax')}",
                data: {geneName: '<%=geneName%>',
                       filterNum: selectedFilterValueId,
                       dataSet: selectedDataSetValueId },
                    async: true,
                    success: function (data) {

                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestAjax');
                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                                }
                                else if ((typeof data.pValue === 'undefined') ||
                                         (typeof data.oddsRatio === 'undefined')){
                                     console.log('burdenTestAjax returned undefined for P value or odds ratio.');
                               }else {
                                   var pValue = data.pValue;
                                   var oddsRatio = data.oddsRatio;
                                   $('.burden-test-result .pValue').text("");
                                   $('.burden-test-result .pValue').append('p-Value = '+UTILS.realNumberFormatter(pValue));
                                   $('.burden-test-result .orValue').text("");
                                   $('.burden-test-result .orValue').append('odds ratio = ' +UTILS.realNumberFormatter(oddsRatio));
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

        // constructor statements go here
        //fillFilterDropDown();

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
    <h3>Preparing to run a burden test based on the variants in gene <%=geneName%>.</h3>

    <div class="row burden-test-wrapper-options">
        <div class="col-md-3 col-sm-3 col-xs-3">
            <label>Select data set:&nbsp;&nbsp;</label>
            <div class="form-inline">
                <div class="radio">
                    <label><input type="radio" name="dataset" value="1" checked>&nbsp;13k&nbsp;&nbsp;</label>
                </div>
                <div class="radio">
                    <label><input type="radio" name="dataset"  value="2" />&nbsp;26k</label>
                </div>
            </div>
        </div>
        <div class="col-md-5 col-sm-5 col-xs-5">
            <label>Available variant filter:
                <select class="proteinEffectFilter form-control">
                    <option selected hidden>Select a filter</option>
                </select>
            </label>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-43 burden-test-btn-wrapper">
            <button id="singlebutton" name="singlebutton" class="btn btn-primary btn-lg burden-test-btn" onclick="mpgSoftware.burdenTest.runBurdenTest()">Run burden test</button>
        </div>

    </div>

    <div class="row burden-test-result">
        <div class="col-md-7 col-sm-7 col-xs-3 col-md-offset-5 col-sm-offset-5 col-xs-offset-3">
            <div class="pValue"></div>
            <div class="orValue"></div>
            <div class="ciValue"></div>
        </div>
    </div>
</div>










