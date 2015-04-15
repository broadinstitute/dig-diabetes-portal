<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="variantWF"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";


        mpgSoftware.variantWF = (function () {


            var fillDataSetDropdown = function (dataSetJson) { // help text for each row
                if ((typeof dataSetJson !== 'undefined')  &&
                        (dataSetJson["is_error"] === false))
                {
                    var numberOfRecords = parseInt (dataSetJson ["numRecords"]);
                    var options = $("#dataSet");
                    var dataSetList = dataSetJson ["dataset"];
                    for ( var i = 0 ; i < numberOfRecords ; i++ ){
                        options.append($("<option />").val(dataSetList[i]).text(dataSetList[i]));
                    }
                }
            };

            return {
                fillDataSetDropdown:fillDataSetDropdown
            }

        }());

    })();
    var makeDataSetsAppear = function (){
        $('#dataSetChooser').show ();
        $('#filterInstructions').text('Choose a sample set  (or click GO for all sample sets):')
    };
    var makeVariantFilterAppear = function (){
        $('#variantFilter').show ();
        $('#filterInstructions').text('Add filters, if any:')
    };
    var gatherFieldsAndPostResults = function (){
        var varsToSend = {};
        var phenotypeInput = UTILS.extractValsFromCombobox(['phenotype']);
        var datasetInput = UTILS.extractValsFromCombobox(['dataSet']);
        var variantFilters = UTILS.extractValFromTextboxes(['pValue','orValue']);
        var savedValue = UTILS.extractValFromTextboxes(['savedValue']);
        varsToSend = UTILS.concatMap(varsToSend,phenotypeInput) ;
        varsToSend = UTILS.concatMap(varsToSend,datasetInput) ;
        varsToSend = UTILS.concatMap(varsToSend,variantFilters) ;
        varsToSend = UTILS.concatMap(varsToSend,savedValue) ;
        UTILS.postQuery('./variantVWRequest',varsToSend);
    };
    $(document).ready(function (){
        $("#phenotype").prepend("<option value='' selected='selected'></option>");
    });


    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "post",
        url: "./retrieveDatasetsAjax",
        data: {none: ''},
        async: true,
        success: function (data) {
            if ((typeof data !== 'undefined')  &&
                    (typeof data.datasets !== 'undefined')) {
                mpgSoftware.variantWF.fillDataSetDropdown(data.datasets);
            }
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
</script>


<div id="main">

    <div class="container" >

        <div class="variantWF-container" >
            <div class="variant-view" >

                <div class="row clearfix">
                    <div class="col-md-5">
                        <h4>Specify a request</h4>
                        <g:render template="variantWFSpec" />
                    </div>
                    <div  class="col-md-7">

                        <g:render template="variantWFDescr" />

                    </div>
                </div>


           </div>

        </div>
    </div>

</div>
<div style = "display: none">
    <div id="hiddenFields">
         <g:renderHiddenFields filterSet='${encodedFilterSets}'/>
    </div>
</div>
<script>
    //initializeFields( encParams);
</script>

</body>
</html>

