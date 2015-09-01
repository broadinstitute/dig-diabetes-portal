<style>
    div.observeMargins {
        margin-left: 0;
        margin-right: 0;
    }
    div.burdenResultsHolder {
        border: 2px black solid;
        padding: 10px 5px 10px 5px;
    }
    div.burdenLauncherHolder {
        margin: 20px auto 20px auto;
    }
    div.burdenResultsHolder .burdenResults {
        font-size: 22px;
        font-weight: 600;
    }
    .btn-xlarge {
        padding: 18px 22px;
        font-size: 22px; //change this to your desired size
    line-height: normal;
        -webkit-border-radius: 8px;
        -moz-border-radius: 8px;
        border-radius: 8px;
        margin: 10px 0 20px 0;
    }
</style>

<h4>
Preparing to run a burden test based on the variants in gene <%=geneName%>.
</h4>

<p>
<div class="row clearfix">
    <div class="observeMargins row">
        <div class="col-md-12 medTextStrong">
            Select data set
        </div>
    </div>
    <div class="observeMargins row">
        <div class="col-med-offset-3 col-md-9 col-xs-12 medTextStrong">
            <ul>
                <li>17k</li>
                <li>26k</li>
            </ul>
        </div>
    </div>
</div>
</p>




<p>
<div class="row clearfix">
    <div class="observeMargins row">
        <div class="col-md-12 medTextStrong">
            Currently available variant filters:
        </div>
    </div>
    <div class="observeMargins row">
        <div class="col-med-offset-3 col-md-9 col-xs-12 medTextStrong">
            <ul>
                <li>All coding variants</li>
                <li>All missense variants</li>
                <li>All <span class="medTextEmphasize">possibly</span> deleterious missense variants</li>
                <li>All <span class="medTextEmphasize">probably</span> deleterious missense variants</li>
                <li>Protein truncating variants</li>
            </ul>
        </div>
    </div>
</div>
</p>


<p>
<div class="row clearfix">
    <div class="observeMargins row">
        <div class="medTextStrong center-block">
                    <div class="text-center">
                        <button id="singlebutton" name="singlebutton" class="btn btn-primary btn-xlarge">Run burden test</button>
                    </div>
        </div>
    </div>
    <div class="observeMargins row">
        <div class="col-md-offset-3 col-md-6 col-sm-offset-2 col-sm-8  col-xs-offset-1 col-xs-10 medTextStrong">
            <div class = "burdenResultsHolder">
                <div class = "burdenResults">
                    <div class="burdenResults text-center">p-Value = 0.002</div>
                    <div class="burdenResults text-center">OR = 1.20</div>
                    <div class="burdenResults text-center">confidence interval = +/- 0.20</div>
                </div>
            </div>

        </div>
    </div>
</div>
</p>




<g:javascript>
var runBurdenTest = function (){
$.ajax({
    cache: false,
    type: "post",
    url: "${createLink(controller:'gene',action: 'genepValueCounts')}",
    data: {geneName: '<%=geneName%>'},
        async: true,
        success: function (data) {


                    var variantsAndAssociationsTableHeaders = {};


            if ((typeof data !== 'undefined') &&
                (data)){
                   alert(' ran Ajax call')
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

