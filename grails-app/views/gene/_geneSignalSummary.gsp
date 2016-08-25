<style>
.trafficExplanations {
    margin: 8px 0 10px 0;
    font-family: "Times New Roman", Times, serif;
    font-style: normal;
    font-size: 24px;
    font-weight: 100;
}
.trafficExplanations.emphasize {
    font-weight: 900;
}
.boxOfVariants {
    border: 1px solid black;
    padding: 10px;
}
</style>

<div class="row">
    <div class="pull-right">
        <label for="signalPhenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                            default="Change phenotype choice"/></label>
        &nbsp;
        <select id="signalPhenotypeTableChooser" name="phenotypeTableChooser"
                onchange="mpgSoftware.geneSignalSummary.refreshTopVariantsByPhenotype(this,mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay)">
        </select>
    </div>
</div>
<div class="panel panel-default">%{--should hold the Choose data set panel--}%
    <div class="panel-heading" style="background-color: #E0F3FD">
        <div class="row">
            <div class="col-md-2 col-xs-12">
                <g:if test="${signalLevel == 1}">
                    <r:img uri="/images/redlight.png"/>
                </g:if>
                <g:elseif test="${signalLevel == 2}">
                    <r:img uri="/images/yellowlight.png"/>
                </g:elseif>
                <g:elseif test="${signalLevel == 3}">
                    <r:img uri="/images/greenlight.png"/>
                </g:elseif>
            </div>

            <div class="col-md-8 col-xs-12">
                <div class="row">
                    <div class="col-lg-12 trafficExplanations trafficExplanation1">
                        Evidence of no signal
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation2">
                        Absence of strong evidence
                    </div>

                    <div class="col-lg-12 trafficExplanations trafficExplanation3">
                        Signal exists
                    </div>
                </div>
            </div>

            <div class="col-md-2 col-xs-12">
                <button name="singlebutton"
                        class="btn btn-secondary btn-lg burden-test-btn vcenter"
                        type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">Summary</button>
            </div>

        </div>
    </div>
</div>
<div class="collapse" id="collapseExample">
    <div class="well">
        <div id="highImpactVariantsLocation"></div>
        <script id="highImpactTemplate"  type="x-tmpl-mustache">
        <div class="row">
            <div class="col-lg-12">
                <h3 style="">High impact variants</h3>

                <div class="row">
                    <div class="col-lg-offset-1">
                        <h4>Individual variants</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-offset-2 col-lg-8">
                        <div class="boxOfVariants">
                            {{ #variants }}
                            <div class="row">
                                <div class="col-lg-3">{{id}}</div>

                                <div class="col-lg-2">{{rsId}}</div>

                                <div class="col-lg-2">{{impact}}</div>

                                <div class="col-lg-3">{{deleteriousness}}</div>

                                <div class="col-lg-1">{{referenceAllele}}</div>

                                <div class="col-lg-1">{{effectAllele}}</div>
                            </div>
                            {{ /variants }}

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-offset-1">
                        <h4>Aggregate variants</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-offset-2  col-lg-8">
                        <div class="boxOfVariants">
                            <div class="row">
                                <div class="col-lg-1"></div>

                                <div class="col-lg-2">all coding</div>

                                <div class="col-lg-2">all missense</div>

                                <div class="col-lg-2">possibly damaging</div>

                                <div class="col-lg-2">probably damaging</div>

                                <div class="col-lg-2">protein truncating</div>

                                <div class="col-lg-1"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        </script>

        <div class="row">
            <div class="col-lg-12">
                <h3>Common variants</h3>

                <div class="row">
                    <div class="col-lg-offset-1">
                        <h4>Individual variants</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-offset-2 col-lg-6">
                        <div class="boxOfVariants">
                            <div class="row">
                                <div class="col-lg-3">2:1234567</div>

                                <div class="col-lg-3">r1234567</div>

                                <div class="col-lg-3">T</div>

                                <div class="col-lg-3">C</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3">2:1234567</div>

                                <div class="col-lg-3">r1234567</div>

                                <div class="col-lg-3">T</div>

                                <div class="col-lg-3">C</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3">2:1234567</div>

                                <div class="col-lg-3">r1234567</div>

                                <div class="col-lg-3">T</div>

                                <div class="col-lg-3">C</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";


        mpgSoftware.geneSignalSummary = (function () {
            var updateSignificantVariantDisplay = function (data) {
                var renderData = {variants:[]};
                if ((typeof data !== 'undefined') &&
                        (typeof data.variants !== 'undefined')&&
                        (typeof data.variants.variants !== 'undefined')&&
                        (data.variants.variants.length > 0)){
                    var obj;
                    _.forEach(data.variants.variants,function(v,index,y){
                        obj = {};
                        _.forEach(v,function(actObj){
                            _.forEach(actObj,function(val,key){
                                if (key==='VAR_ID'){
                                    obj['id']= (val)?val:'';
                                } else if (key==='DBSNP_ID'){
                                    obj['rsId']= (val)?val:'';
                                } else if (key==='Protein_change'){
                                    obj['impact']= (val)?val:'';
                                } else if (key==='Consequence'){
                                    obj['deleteriousness']= (val)?val:'';
                                } else if (key==='Reference_Allele'){
                                    obj['referenceAllele']= (val)?val:'';
                                } else if (key==='Effect_Allele') {
                                    obj['effectAllele'] = (val)?val:'';
                                }
                                });
                            });
                            if (index < 10 ){
                                renderData.variants.push(obj);
                            }
                        });

                    };
                $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                };



            var updateDisplayBasedOnSignificanceLevel = function (significanceLevel) {
                var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
                if (typeof significanceLevelDom !== 'undefined') {
                    significanceLevelDom.addClass('emphasize');
                }
            };

            var refreshTopVariantsByPhenotype = function (sel, callBack) {
                var rememberCallBack = callBack;
                var phenotypeName = sel.value;
                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                    data: {phenotype: phenotypeName},
                    async: true,
                    success: function (data) {
                        rememberCallBack(data);
                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });

            };

            return {
                updateSignificantVariantDisplay:updateSignificantVariantDisplay,
                updateDisplayBasedOnSignificanceLevel: updateDisplayBasedOnSignificanceLevel,
                refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype
            }
        }());


    })();

    $( document ).ready(function() {
        mpgSoftware.geneInfo.fillPhenotypeDropDown('#signalPhenotypeTableChooser',
                '${g.defaultPhenotype()}',
                "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
                refreshVAndAByPhenotype );
        mpgSoftware.geneSignalSummary.updateDisplayBasedOnSignificanceLevel (${signalLevel});
    });
</script>

