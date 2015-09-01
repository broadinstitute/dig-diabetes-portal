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
var runBurdenTest = function (){
$.ajax({
    cache: false,
    type: "post",
    url: "${createLink(controller:'gene',action: 'burdenTestAjax')}",
    data: {geneName: '<%=geneName%>'},
        async: true,
        success: function (data) {


                    var variantsAndAssociationsTableHeaders = {};


            if ((typeof data !== 'undefined') && (data)){
                   console.log('successfully retrieved data from burdenTestAjax');
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
                       $('.burden-test-result .pValue').append('p-Value = '+UTILS.realNumberFormatter(pValue));
                       $('.burden-test-result .orValue').append('odds ratio = ' +UTILS.realNumberFormatter(oddsRatio));
                   }
                }
            $('[data-toggle="popover"]').popover();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });

};


//runBurdenTest ();



</g:javascript>



<div class="container">
    <h3>Preparing to run a burden test based on the variants in gene <%=geneName%>.</h3>

    <div class="row burden-test-wrapper-options">
        <div class="col-md-3 col-sm-3 col-xs-3">
            <label>Select data set:&nbsp;&nbsp;</label>
            <div class="form-inline">
                <div class="radio">
                    <label><input type="radio" name="dataset" checked>&nbsp;17k&nbsp;&nbsp;</label>
                </div>
                <div class="radio">
                    <label><input type="radio" name="dataset" />&nbsp;26k</label>
                </div>
            </div>
        </div>
        <div class="col-md-5 col-sm-5 col-xs-5">
            <label>Available variant filter:
                <select class="form-control">
                    <option selected hidden>Select a filter</option>
                    <option>All coding variants</option>
                    <option>All missense variants</option>
                    <option>All <span class="medTextEmphasize">possibly</span> deleterious missense variants</option>
                    <option>All <span class="medTextEmphasize">probably</span> deleterious missense variants</option>
                    <option>Protein truncating variants</option>
                </select>
            </label>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-43 burden-test-btn-wrapper">
            <button id="singlebutton" name="singlebutton" class="btn btn-primary btn-lg burden-test-btn" onclick="runBurdenTest()">Run burden test</button>
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










