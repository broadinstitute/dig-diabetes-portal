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
span.aggregatingVariantsColumnHeader {
    font-weight: bold;
}
ul.aggregatingVariantsLabels>li {
    padding: 18px 0 0 0;
    font-weight: bold;
}
ul.aggregatingVariantsLabels {
    list-style-type: none;
    padding: 18px 0 0 0;
}
.aggregateVariantsDescr {
    font-size: 12px;
}
.aggregateVariantsDescr+li {
    list-style-type: none;
    font-size: 11px;
}
.specialTitle {
    font-weight: bold;
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

            <div class="row">
                <div class="col-lg-12">
                    <h3 class="specialTitle">High impact variants</h3>
                        <div id="highImpactVariantsLocation"></div>
                        <script id="highImpactTemplate"  type="x-tmpl-mustache">
                            <div class="row">
                                <div class="col-lg-offset-1">
                                    <h4>Individual variants</h4>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-offset-2 col-lg-8">
                                    <div class="boxOfVariants">
                                        {{ #rvar }}
                                            <div class="row">
                                                <div class="col-lg-3"><a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/{{id}}" class="boldItlink">{{id}}</a></div>

                                                <div class="col-lg-2">{{rsId}}</div>

                                                <div class="col-lg-2">{{impact}}</div>

                                                <div class="col-lg-3">{{deleteriousness}}</div>

                                                <div class="col-lg-1">{{referenceAllele}}</div>

                                                <div class="col-lg-1">{{effectAllele}}</div>
                                            </div>
                                        {{ /rvar }}

                                    </div>
                                </div>
                            </div>
                        </script>

                    <div id="aggregateVariantsLocation"></div>
                        <script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row">
                                <div class="col-lg-offset-1">
                                    <h4>Aggregate variants</h4>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-1">
                                            <ul class='aggregatingVariantsLabels'>
                                              <li style="text-align: right">beta</li>
                                              <li style="text-align: right">pValue</li>
                                              <li style="text-align: right">CI (95%)</li>
                                            </ul>
                                </div>
                                <div class="col-lg-11">
                                    <div class="boxOfVariants">
                                        <div class="row">
                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">all variants</span>
                                                <div id="allVariants"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">all coding</span>
                                                <div id="allCoding"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">all missense</span>
                                                <div id="allMissense"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">possibly damaging</span>
                                                <div id="possiblyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">probably damaging</span>
                                                <div id="probablyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">protein truncating</span>
                                                <div id="proteinTruncating"></div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </script>
                </div>
            </div>


        <div id="commonVariantsLocation"></div>
        <script id="commonVariantTemplate"  type="x-tmpl-mustache">
            <div class="row">
                <div class="col-lg-12">
                    <h3 class="specialTitle">Common variants</h3>

                    <div class="row">
                        <div class="col-lg-offset-1">
                            <h4>Individual variants</h4>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-offset-2 col-lg-6">
                            <div class="boxOfVariants">
                                {{ #cvar }}
                                <div class="row">
                                        <div class="col-lg-4"><a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/{{id}}" class="boldItlink">{{id}}</a></div>

                                        <div class="col-lg-4">{{rsId}}</div>

                                        <div class="col-lg-2">{{referenceAllele}}</div>

                                        <div class="col-lg-2">{{effectAllele}}</div>
                                </div>
                                {{ /cvar }}
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </script>

    </div>
</div>

<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";


        mpgSoftware.geneSignalSummary = (function () {
            var buildRenderData = function (data,mafCutoff)  {
                var renderData = {variants:[],
                                    rvar:[],
                                    cvar:[]};
                if ((typeof data !== 'undefined') &&
                        (typeof data.variants !== 'undefined')&&
                        (typeof data.variants.variants !== 'undefined')&&
                        (data.variants.variants.length > 0)){
                    var obj;
                    _.forEach(data.variants.variants,function(v,index,y){
                        obj = {};
                        var mafValue;
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
                                } else if (key==='MAF') {
                                    _.forEach(val,function(mafval,mafkey){
                                        mafValue = (mafval)?mafval:'';
                                    });

                                }
                            });
                        });
                        if (index < 10 ){
                            renderData.variants.push(obj);
                            if (mafValue<mafCutoff){
                                renderData.rvar.push(obj);
                            } else {
                                renderData.cvar.push(obj);
                            }
                        }
                    });

                };
                return renderData;
            };



            var updateAggregateVariantsDisplay = function (data,locToUpdate) {
                var updateHere = $(locToUpdate);
                updateHere.empty();
                if ((data)&&
                        (data.stats)){
                    updateHere.append("<ul class='aggregateVariantsDescr list-group'>"+
                                        "<li class='list-group-item'>"+UTILS.realNumberFormatter(data.stats.beta)+"</li>"+
                                        "<li class='list-group-item'>"+UTILS.realNumberFormatter(data.stats.pValue)+"</li>"+
                                        "<li class='list-group-item'>"+UTILS.realNumberFormatter(data.stats.ciLower)+" - "+UTILS.realNumberFormatter(data.stats.ciUpper)+"</li>"+
                                    "</ul>");
                }
            };



            var updateSignificantVariantDisplay = function (data) {
                var renderData = buildRenderData (data,0.05);
                $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                $("#aggregateVariantsLocation").empty().append(Mustache.render( $('#aggregateVariantsTemplate')[0].innerHTML,renderData));
                $("#commonVariantsLocation").empty().append(Mustache.render( $('#commonVariantTemplate')[0].innerHTML,renderData));
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"0","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#allVariants");
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"1","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#allCoding");
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"2","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#allMissense")
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"3","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#possiblyDamaging");
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"4","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#probablyDamaging")
                refreshVariantAggregates($('#signalPhenotypeTableChooser'),"5","samples_17k_mdv2","1","0.47","<%=geneName%>",updateAggregateVariantsDisplay,"#proteinTruncating");


            };



            var updateDisplayBasedOnSignificanceLevel = function (significanceLevel) {
                var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
                if (typeof significanceLevelDom !== 'undefined') {
                    significanceLevelDom.addClass('emphasize');
                }
            };


            var refreshVariantAggregates = function (sel, filterNum, dataSet,mafOption, mafValue, geneName, callBack,callBackParameter) {
                var rememberCallBack = callBack;
                var rememberCallBackParameter = callBackParameter;
                var phenotypeName = sel.value;
                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'gene', action: 'burdenTestAjax')}",
                    data: { geneName:geneName,
                            dataSet:dataSet,
                            filterNum:filterNum,
                            burdenTraitFilterSelectedOption: phenotypeName,
                            mafOption:mafOption,
                            mafValue:mafValue   },
                    async: true,
                    success: function (data) {
                        rememberCallBack(data,rememberCallBackParameter);
                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });

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

