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
//    postVariantReq = function (path,
//                         params,
//                         show_gene,
//                         show_sigma,
//                         show_exseq,
//                         show_exchp,
//                         variantRootUrl,
//                         geneRootUrl,
//                         variantSearchAjaxUrl,
//                         dataSetDetermination) {
//        var loading = $('#spinner').show();
//        loading.show();
//        $.ajax({
//            type:'POST',
//            cache:false,
//            data:{'keys':params},
//            url:variantSearchAjaxUrl,
//            async:true,
//            success:function(data,textStatus){
//                UTILS.fillTheVariantTable(data,
//                        show_gene,
//                        show_sigma,
//                        show_exseq,
//                        show_exchp,
//                        variantRootUrl,
//                        geneRootUrl,
//                        dataSetDetermination);
//                loading.hide();
//            },
//            error:function(XMLHttpRequest,textStatus,errorThrown){
//                loading.hide();
//                //errorReporter(XMLHttpRequest, exception) ;
//            }
//        });
//    };
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
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':params},
            url:path,
            async:true,
            success:function(data){
                fillResponseFields (data);
//                UTILS.fillTheVariantTable(data,
//                        show_gene,
//                        show_sigma,
//                        show_exseq,
//                        show_exchp,
//                        variantRootUrl,
//                        geneRootUrl,
//                        dataSetDetermination);
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };



    var  proteinEffectList;
    var dynamicBurdenTest = function (){
        $('dbtActualResultsExist').hide();
        var loading = $('#spinner').show();
        postVariantReq("./burdenAjax","${variants}");
//        $.ajax({
//            cache: false,
//            type: "post",
//            url: "./burdenAjax",
//            data: {variant: 'my variant'},
//            async: true,
//            success: function (data) {
//                console.log(' successful return='+data);
//                fillResponseFields(data);
//                loading.hide();
//            },
//            error: function (jqXHR, exception) {
//                loading.hide();
//                core.errorReporter(jqXHR, exception);
//            }
//        });
        return;
    };


    // actual code
    if ("${caller>0}"){
        // we have variants
        proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
        dynamicBurdenTest();
    }
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
                                    <g:render template="variantFilters"/>
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
                        <button class="btn btn-lg btn-primary" onclick="dynamicBurdenTest()">Execute</button>
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
        $('#collapseOne').collapse('hide');
       $('#collapseTwo').collapse('hide');
    });

</script>

</body>

</html>

