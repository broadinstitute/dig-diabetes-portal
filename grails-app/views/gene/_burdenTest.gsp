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

    div.labelAndInput {
        white-space: nowrap;
    }

    div.labelAndInput > input {
        width: 150px;
    }

    .burden-test-result .orValue {
        white-space: nowrap;
    }

    .mafOptionChooser div.radio {
        padding: 0 20px 0 0;
    }

    .vcenter {
        margin-top: 2em;
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
             selectedDataSetValueId = parseInt(selectedDataSetValue),
             selectedMafOption = $('input[name=mafOption]:checked').val(),
             selectedMafOptionId =  parseInt(selectedMafOption),
             specifiedMafValue = $('#mafInput').val(),
             specifiedMafValueId;
             // JavaScript can't understand a number of it starts with a decimal.  Prepend a zero just to be safe, since that will never hurt
             if ((specifiedMafValue)&&
                 (specifiedMafValue.length> 0)){
                 specifiedMafValue = '0'+specifiedMafValue;
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
                    alert('Please specify a numeric value for the minor allele frequency (MAF).  The value "'+specifiedMafValue+'" is invalid');
                    $('#rSpinner').hide();
                    return;
                  } else if (specifiedMafValueId < 0) {
                    alert('Please specify a nonnegative value for the minor allele frequency (MAF).  The value "'+specifiedMafValue+'" is invalid');
                    $('#rSpinner').hide();
                    return;
                  }
                  else if (specifiedMafValueId > 1) {
                    alert('Please specify a value less than or equal to one for the minor allele frequency (MAF).  The value "'+specifiedMafValue+'" is invalid');
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


    %{--<div class="row burden-test-wrapper-options">--}%
        %{--<div class="col-md-3 col-sm-3 col-xs-3">--}%
            %{--<label>Select data set:&nbsp;&nbsp;</label>--}%
            %{--<div class="form-inline">--}%
                %{--<div class="radio">--}%
                    %{--<label><input type="radio" name="dataset" value="1" checked>&nbsp;13k&nbsp;&nbsp;</label>--}%
                %{--</div>--}%
                %{--<div class="radio">--}%
                    %{--<label><input type="radio" name="dataset"  value="2" />&nbsp;26k</label>--}%
                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%
        %{--<div class="col-md-5 col-sm-5 col-xs-5">--}%
            %{--<label>Available variant filter:--}%
                %{--<select class="proteinEffectFilter form-control">--}%
                    %{--<option selected hidden>Select a filter</option>--}%
                %{--</select>--}%
            %{--</label>--}%
        %{--</div>--}%
        %{--<div class="col-md-4 col-sm-4 col-xs-43 burden-test-btn-wrapper">--}%
            %{--<button id="singlebutton" name="singlebutton" class="btn btn-primary btn-lg burden-test-btn" onclick="mpgSoftware.burdenTest.runBurdenTest()">Run burden test</button>--}%
        %{--</div>--}%
    %{--</div>--}%



    <div class="row burden-test-wrapper-options">
        <div class="col-md-8 col-sm-8 col-xs-12">
            <div  class="row">
                <div class="col-md-4 col-sm-4 col-xs-4">
                    <label>Select data set:&nbsp;&nbsp;</label>
                    <div class="form-inline">
                        <div class="radio">
                            <label><input type="radio" name="dataset" value="1">&nbsp;13k&nbsp;&nbsp;</label>
                        </div>
                        <div class="radio">
                            <label><input type="radio" name="dataset"  value="2" checked>&nbsp;26k</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-8 col-sm-8 col-xs-8">
                    <label>Available variant filter:
                        <select class="proteinEffectFilter form-control">
                            <option selected hidden>Select a filter</option>
                        </select>
                    </label>
                </div>
            </div>
            <div  class="row">
                  <div style="margin:15px 8px 15px 10px" class="separator"></div>
            </div>
            <div  class="row">
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <label for="mafInput">Minor Allele Frequency:</label>
                    <div class="labelAndInput">
                        MAF &lt;&nbsp;
                        <input style="display: inline-block" type="text" class="form-control" id="mafInput" placeholder="value">
                    </div>

                </div>
                <div class="col-md-6 col-sm-6 col-xs-6">
                    <label>Apply MAF across:&nbsp;&nbsp;</label>
                    <div class="form-inline mafOptionChooser">
                        <div class="radio">
                            <label><input type="radio" name="mafOption" value="1" checked>&nbsp;All samples</label>
                        </div>
                        <div class="radio">
                            <label><input type="radio" name="mafOption"  value="2" />&nbsp;Each ancestry</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div  class="col-md-4 col-sm-4 col-xs-12 burden-test-btn-wrapper vcenter">
            <button id="singlebutton" name="singlebutton" style="height: 80px"
                    class="btn btn-primary btn-lg burden-test-btn" onclick="mpgSoftware.burdenTest.runBurdenTest()">Run burden test</button>
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










