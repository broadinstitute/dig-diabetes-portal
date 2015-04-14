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
                    var options = $("#dataset-input");
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
    };
    var makeVariantFilterAppear = function (){
        $('#variantFilter').show ();
    };
    $(document).ready(function (){
        $("#phenotype-input").prepend("<option value='' selected='selected'></option>");
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
                    <div class="col-md-6">
                        <h4>Specify a request</h4>
                        <g:render template="variantWFSpec" />
                    </div>
                    <div  class="col-md-6">

                        <g:render template="variantWFDescr" />

                    </div>
                </div>


           </div>

        </div>
    </div>

</div>
<script>
    //initializeFields( encParams);
</script>

</body>
</html>

