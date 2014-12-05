<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

</head>

<body>
<script>
    var launchDynamicBurdenTest;
$( document ).ready(function (){
    var fillResponseFields = function (data){
        if ((typeof data === 'undefined') ||
                (typeof data.burdenTestResults === 'undefined') ||
                (typeof data.burdenTestResults["is_error"] === 'undefined') ){
            // the call to the backend failed.  Correct Behavior  === ?
        } else if (typeof data.burdenTestResults["is_error"] === false){
            // call was executed successfully but the data returned. Correct Behavior  === ?
        }else{
            $('#dbtPValue').text(UTILS.realNumberFormatter(data.burdenTestResults.pValue));
            $('#dbtBeta').text(UTILS.realNumberFormatter(data.burdenTestResults.oddsRatio));
            $('#stdErr').text(UTILS.realNumberFormatter(data.burdenTestResults.stdErr));
            $('#dbtActualResultsExist').show();
        }
    };

    var postVariantReq = function (path,
                                   params) {
        var loading = $('#spinner').show();
        loading.show();
        var stringForSending;
        stringForSending = params.join(',');
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':stringForSending},
            url:path,
            async:true,
            success:function(data){
                fillResponseFields (data);
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };

    var requestExpandedVariantInfo = function (path,
                                   params) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':params},
            url:path,
            async:true,
            success:function(data){
                fillBtVariantTable (data);
                $('#collapseTwo').collapse('show');
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };


    var  proteinEffectList;
    var dynamicBurdenTest = function (variantIds){
        $('dbtActualResultsExist').hide();
        var loading = $('#spinner').show();
        postVariantReq("./burdenAjax",variantIds);
        return;
    };
    %{--var dynamicBurdenTest = function (){--}%
        %{--$('dbtActualResultsExist').hide();--}%
        %{--var loading = $('#spinner').show();--}%
        %{--postVariantReq("./burdenAjax","${variants}");--}%
        %{--return;--}%
    %{--};--}%
    var dynamicBurdenTest2 = function (variantIds){
        $('dbtActualResultsExist').hide();
        var loading = $('#spinner').show();
        postVariantReq("./burdenAjax",variantIds);
        return;
    };

    var fillBtVariantTable = function (jsonObject){
        var safetyCellFiller = function (dataHolder,fieldName){
            if((typeof  dataHolder [fieldName]=== 'undefined') ){
                return ("<td></td>");
            }else {
                return ("<td>" + dataHolder [fieldName]+ "</td>");
            }
        };
        var returnValue = "";
        var arrayOfInfo = jsonObject.variant;
        var numberOfVariants = arrayOfInfo.length;
        for (var i = 0 ; i < numberOfVariants ; i++) {
            var highFreq = UTILS.determineHighestFrequencyEthnicity(arrayOfInfo[i]);
            returnValue += "<tr>";
            returnValue += safetyCellFiller(arrayOfInfo[i], "CLOSEST_GENE");
            returnValue += safetyCellFiller(arrayOfInfo[i], "ID");
            returnValue += safetyCellFiller(arrayOfInfo[i], "DBSNP_ID");
            returnValue += safetyCellFiller(arrayOfInfo[i], "Protein_change");
            returnValue += safetyCellFiller(arrayOfInfo[i], "Consequence");
            if (highFreq.highestFrequency)  {
                returnValue += "<td>" +UTILS.realNumberFormatter(highFreq.highestFrequency)+"</td>";
            } else {
                returnValue += "<td></td>";
            }
            if ((highFreq.populationWithHighestFrequency)&&
                    (!highFreq.noData)){
                returnValue += "<td>" +highFreq.populationWithHighestFrequency+"</td>";
            } else {
                returnValue += "<td></td>";
            }
            returnValue += "</tr>";
        }
        $('#btVariantTableBody').append(returnValue);
    };


    launchDynamicBurdenTest = function (){
        //first we need to pull the variant IDs out of the table
        var jQueryTable=$('#btVariantTable').dataTable();
        var dataTable = jQueryTable.fnGetData();
        // extract the particular data we want
        var variantIds = [];
        if ((!(typeof dataTable === 'undefined') ) &&
                (dataTable.length > 0)){
            for ( var i = 0 ; i < dataTable.length ; i++ ){
                var tableRow = dataTable [i];
                if (!(typeof tableRow === 'undefined') ){
                    variantIds.push (tableRow [1]);
                }
            }
        }
        dynamicBurdenTest2(variantIds);

    };


    // Decide what to do based on the state indicator.
    //   0= first time through-- we are just collecting information at this point
    //   3= We have a list of variants with which to work
    if ("${caller>0}"){
        // we have variants
        var variantsInListString = "${variants2}",
                numberOfVariants = variantsInListString.length,
                variantInfo;
        //variantInfo = decodeURIComponent("${variantInfo}");
        if (("${caller==3}") &&
                (numberOfVariants > 0)){
            // we have a list of variants, but we need to go back to the server to get more info
            // about each one in order to fill out the table
            requestExpandedVariantInfo("./variantInfoAjax","${variants}");
           // var arrayOfVariants = variantsInListString.split(',');
           // fillBtVariantTable (arrayOfVariants);
        }
        %{--if (("${caller==5}") &&--}%
                %{--(numberOfVariants > 0)){--}%
            %{--proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;--}%
            %{--dynamicBurdenTest();--}%
        %{--}--}%
    }

});
</script>

<div id="main">

    <div class="container">


            <div class="dynamicBurdenTest">
                <div class="row">
                    <div class="accordion" id="accordionDbt">
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionDbt"
                                    href="#collapseOne">
                                    <h2><strong>Step 1: Develop a list of variant</strong></h2>
                                </a>
                            </div>
                            <div id="collapseOne" class="accordion-body collapse in">
                                <div class="accordion-inner">
                                    <g:render template="geneFilters"/>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionDbt"
                                    href="#collapseTwo">
                                    <h2><strong>Step 2:  Refine variant list</strong></h2>
                                </a>
                            </div>
                            <div id="collapseTwo" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:render template="refineVariantList"/>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-group">
                            <div class="accordion-heading">
                                <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionDbt"
                                    href="#collapseThree">
                                    <h2><strong>Step 3:  Burden test results</strong></h2>
                                </a>
                            </div>
                            <div id="collapseThree" class="accordion-body collapse">
                                <div class="accordion-inner">
                                    <g:render template="burdenTestResults"/>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
<style>
.resultsCage {
    height: 400px;
    margin: 10px auto 0 0;
}
.dbtResults {
    border: 1px dashed blue;
    font-size: 18px;
    font-weight: bold;
    position: relative;
    padding: 15px;
    width: 200px;
    height: 130px;
    margin: 20px auto 0 100px;
}
.dbtResults .dbtResultsSpecifics1 {
    position: absolute;
    margin: 0px auto 10px 10px;
    width: 150px;
}
.dbtResults .dbtResultsSpecifics2 {
    position: absolute;
    margin: 30px auto 10px 20px;
    width: 150px;
}
.dbtResults .dbtResultsSpecifics3 {
    position: absolute;
    margin: 60px auto 10px 20px;
    width: 150px;
}

#dbtActualResultsExist {
    display: none;
}
</style>
                <div class="row resultsCage">

                    <div class="col-sm-2">
                        %{--<button class="btn btn-lg btn-primary" onclick="launchDynamicBurdenTest()">Execute</button>--}%
                    </div>
                    <div class="col-sm-10">
                        <div id="dbtActualResultsExist">
                            <h4>Results from dynamic burden test:</h4>
                            <div class ="dbtResults">
                                <div class ="dbtResultsSpecifics1">pValue = <span id="dbtPValue"></span></div>
                                <div class ="dbtResultsSpecifics2">Beta = <span id="dbtBeta"></span></div>
                                <div class ="dbtResultsSpecifics3">Std err = <span id="stdErr"></span></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>


    </div>

</div>
<script>
    $('#accordionDbt').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseOne") {
//            if ((typeof delayedDataPresentation !== 'undefined') &&
//                    (typeof delayedDataPresentation.launch !== 'undefined')) {
//                delayedDataPresentation.launch();
//            }
            console.log('collapseOne caught');
        }
    });
    $('#accordionDbt').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseTwo") {
//            if ((typeof delayedDataPresentation !== 'undefined') &&
//                    (typeof delayedDataPresentation.launch !== 'undefined')) {
//                delayedDataPresentation.removeBarchart();
//            }
            console.log('collapseTo caught');
        }
    });
    $( document ).ready(function() {
      //  console.log('prepping the document');
        $('#collapseOne').collapse('show');
//       $('#collapseTwo').collapse('hide');
    });

</script>

</body>

</html>

