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
.trafficExplanations.unemphasize {
    font-weight: normal;
}
.boxOfVariants {
    border: 1px solid black;
    padding: 10px;
    max-height: 200px;
    overflow-y: auto;
    overflow-x: hidden;
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
                <div id='trafficLightHolder'>
                    <r:img uri="/images/undeterminedlight.png"/>
                    <span id="signalLevelHolder" style="display:none"></span>
                </div>

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

                                                <div class="col-lg-2">{{deleteriousness}}</div>

                                                <div class="col-lg-2">{{P_VALUE}}</div>

                                                <div class="col-lg-1">{{BETA}}</div>
                                            </div>
                                        {{ /rvar }}

                                    </div>
                                </div>
                            </div>
                        </script>

                    <div id="aggregateVariantsLocation" style="display: none"></div>
                        <script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row" style="margin-top: 15px;">
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

        <div id="noAggregatedVariantsLocation">
            <div class="row" style="margin-top: 15px;">
                <div class="col-lg-offset-1">
                    <h4>No information about aggregated variants exists for this phenotype</h4>
                </div>
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
                        <div class="col-lg-offset-1 col-lg-11">
                            <div class="boxOfVariants">
                                {{ #cvar }}
                                <div class="row">
                                        <div class="col-lg-3"><a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/{{id}}" class="boldItlink">{{id}}</a></div>

                                        <div class="col-lg-3">{{rsId}}</div>

                                        <div class="col-lg-2">{{P_VALUE}}</div>

                                        <div class="col-lg-2">{{BETA}}</div>

                                        <div class="col-lg-1">{{referenceAllele}}</div>

                                        <div class="col-lg-1">{{effectAllele}}</div>
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
        var phenotypeNameForSampleData  = function (untranslatedPhenotype) {
            var convertedName = '';
            if (untranslatedPhenotype === 'T2D') {
                convertedName = 't2d';
            } else if (untranslatedPhenotype === 'FG') {
                convertedName = 'FAST_GLU_ANAL';
            } else if (untranslatedPhenotype === 'FI') {
                convertedName = 'FAST_INS_ANAL';
            } else if (untranslatedPhenotype === 'BMI') {
                convertedName = 'BMI';
            } else if (untranslatedPhenotype === 'CHOL') {
                convertedName = 'CHOL_ANAL';
            } else if (untranslatedPhenotype === 'TG') {
                convertedName = 'TG_ANAL';
            } else if (untranslatedPhenotype === 'HDL') {
                convertedName = 'HDL_ANAL';
            } else if (untranslatedPhenotype === 'LDL') {
                convertedName = 'LDL_ANAL';
            } else if (untranslatedPhenotype === 'SBP') {
                convertedName = 'SBP_ANAL';
            } else if (untranslatedPhenotype === 'DBP') {
                convertedName = 'DBP_ANAL';
            }
            return convertedName;
        };

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
                                } else if (key==='MOST_DEL_SCORE') {
                                    obj['MOST_DEL_SCORE'] = (val)?val:'';
                                }  else if (key==='MAF') {
                                    _.forEach(val,function(mafval,mafkey){
                                        mafValue = (mafval)?mafval:'';
                                        obj['MAF'] = mafValue;
                                    })
                                } else if ((key==='P_FIRTH_FE_IV')||
                                        (key==='P_VALUE')||
                                        (key==='P_FE_INV')||
                                        (key==='P_FIRTH')
                                        ){
                                    _.forEach(val,function(dsetval,dsetkey){
                                        _.forEach(dsetval,function(pval,pkey) {
                                            obj['P_VALUE'] = UTILS.realNumberFormatter((pval)?pval:1);
                                            obj['P_VALUEV'] = (pval)?pval:1;
                                        });

                                    });

                                }  else if ((key==='ODDS_RATIO')||
                                        (key==='OR_FIRTH')||
                                        (key==='OR_FIRTH_FE_IV')||
                                        (key==='OR_FIRTH')
                                        ){
                                    _.forEach(val,function(dsetval,dsetkey){
                                        _.forEach(dsetval,function(pval,pkey) {
                                            obj['BETA'] = UTILS.realNumberFormatter((pval)?pval:1);
                                            obj['BETAV'] = (pval)?pval:1;
                                        });

                                    });

                                } else if (key==='BETA') {
                                    _.forEach(val,function(dsetval,dsetkey){
                                        _.forEach(dsetval,function(pval,pkey) {
                                            obj['BETA'] = UTILS.realNumberFormatter(Math.exp((pval)?pval:1));
                                            obj['BETAV'] = Math.exp((pval)?pval:1);
                                        });

                                    });

                                }
                            });
                        });
                        //if (index < 100 ){
                            renderData.variants.push(obj);
                            if (mafValue<mafCutoff){
                                renderData.rvar.push(obj);
                            } else {
                                renderData.cvar.push(obj);
                            }
                        //}

                    });
                    renderData.rvar = _.sortBy(renderData.rvar,function(o){return o.P_VALUEV});
                    renderData.cvar = _.sortBy(renderData.cvar,function(o){return o.P_VALUEV});

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
                    if (data.stats.pValue<0.000001){
                        updateDisplayBasedOnStoredSignificanceLevel(3);//green light
                    } else if (data.stats.pValue<0.01){
                        updateDisplayBasedOnStoredSignificanceLevel(2);//yellow light
                    }

                }
            };



            var updateSignificantVariantDisplay = function (data) {
                var renderData = buildRenderData (data,0.05);
                var signalLevel = assessSignalSignificance(renderData);
                updateDisplayBasedOnSignificanceLevel (signalLevel);
                $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                $("#aggregateVariantsLocation").empty().append(Mustache.render( $('#aggregateVariantsTemplate')[0].innerHTML,renderData));
                $("#commonVariantsLocation").empty().append(Mustache.render( $('#commonVariantTemplate')[0].innerHTML,renderData));
                var phenotypeName = $('#signalPhenotypeTableChooser option:selected').val();
                var sampleBasedPhenotypeName = phenotypeNameForSampleData(phenotypeName);
                if ( ( typeof sampleBasedPhenotypeName !== 'undefined') &&
                     ( sampleBasedPhenotypeName.length > 0)) {
                    $('#aggregateVariantsLocation').css('display','block');
                    $('#noAggregatedVariantsLocation').css('display','none');
                    refreshVariantAggregates(sampleBasedPhenotypeName,"0","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#allVariants");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"1","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#allCoding");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"2","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#allMissense")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"3","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#possiblyDamaging");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"4","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#probablyDamaging")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"5","samples_17k_mdv2","1","0.05","<%=geneName%>",updateAggregateVariantsDisplay,"#proteinTruncating");
                } else {
                    $('#aggregateVariantsLocation').css('display','none');
                    $('#noAggregatedVariantsLocation').css('display','block');
                }


            };


            var assessSignalSignificance = function (renderData){
               var signalCategory = 1; // 1 == red (no signal), 3 == green (signal)
                _.forEach(renderData.variants,function(v){
                    if ((signalCategory < 3)&&(v.P_VALUE < 0.00000001)){
                        signalCategory = 3;
                    } else if ((signalCategory < 2)&&(v.P_VALUE < 0.0001)) {
                        signalCategory = 2;
                    }
                });
                return signalCategory;
            }




            var updateDisplayBasedOnSignificanceLevel = function (significanceLevel) {


                    var significanceLevelDoms = $('.trafficExplanations');

                                significanceLevelDoms.removeClass('emphasize');
                                significanceLevelDoms.addClass('unemphasize');


                $('#trafficLightHolder').empty();
                var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
                significanceLevelDom.removeClass('unemphasize');
                significanceLevelDom.addClass('emphasize');
                if (significanceLevel == 1){
                    $('#trafficLightHolder').append('<r:img uri="/images/redlight.png"/>');
                } else if (significanceLevel == 2){
                    $('#trafficLightHolder').append('<r:img uri="/images/yellowlight.png"/>');
                } else if (significanceLevel == 3){
                    $('#trafficLightHolder').append('<r:img uri="/images/greenlight.png"/>');
                }
                $('#signalLevelHolder').text = significanceLevel;
            };





            var updateDisplayBasedOnStoredSignificanceLevel = function (newSignificanceLevel) {
                var currentSignificanceLevel = $('#signalLevelHolder').text;
                if (newSignificanceLevel>=currentSignificanceLevel){
                    return;
                }
                updateDisplayBasedOnSignificanceLevel(newSignificanceLevel);
            };




            var refreshVariantAggregates = function (phenotypeName, filterNum, dataSet,mafOption, mafValue, geneName, callBack,callBackParameter) {
                var rememberCallBack = callBack;
                var rememberCallBackParameter = callBackParameter;

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


            var refreshTopVariantsDirectlyByPhenotype = function (phenotypeName, callBack) {
                var rememberCallBack = callBack;
                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopVariantsAcrossSgs')}",
                    data: {phenotype: phenotypeName,
                        geneToSummarize:"${geneName}"},
                    async: true,
                    success: function (data) {
                        rememberCallBack(data);
                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });

            };
            var refreshTopVariantsByPhenotype = function (sel, callBack) {
                var phenotypeName = sel.value;
                refreshTopVariantsDirectlyByPhenotype(phenotypeName,callBack);
            };

            return {
                updateSignificantVariantDisplay:updateSignificantVariantDisplay,
                updateDisplayBasedOnSignificanceLevel: updateDisplayBasedOnSignificanceLevel,
                refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
                refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype
            }
        }());


    })();

    $( document ).ready(function() {
        mpgSoftware.geneInfo.fillPhenotypeDropDown('#signalPhenotypeTableChooser',
                '${g.defaultPhenotype()}',
                "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
                function(){
                    // retrieve the top value in the phenotype drop-down
                    mpgSoftware.geneSignalSummary.refreshTopVariantsDirectlyByPhenotype($($('#signalPhenotypeTableChooser>option')[1]).attr('value'),
                            mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay);
                } );
    });
</script>

