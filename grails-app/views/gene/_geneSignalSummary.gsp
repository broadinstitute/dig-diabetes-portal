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
div.redline {
 /*   background-color: #ffb3b3;*/
}
div.yellowline {
     background-color: #ffffb3;
}
div.greenline {
      background-color: #ccffcc;
  }
.linkEmulator{
    text-decoration: underline;
    cursor: pointer;
    font-style: italic;
    color: #588fd3;
}
.boxOfVariants {
    border: 1px solid black;
    padding: 10px;
    max-height: 200px;
    overflow-y: auto;
    overflow-x: hidden;
}
div.variantCategoryLabel{
    margin-left:20px;
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
div.variantBoxHeaders {
    padding: 10px;
    font-size: 16px;
}
</style>

<div class="row">
    <div class="pull-right" style="display:none">
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
                    <div id="signalLevelHolder" style="display:none"></div>
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


        %{--<div id="highImpactVariantsLocation"></div>--}%

        %{--<div id="commonVariantsLocation"></div>--}%

        %{--<div id="aggregateVariantsLocation" style="display: none"></div>--}%




    <div id="noAggregatedVariantsLocation">
        <div class="row" style="margin-top: 15px;">
            <div class="col-lg-offset-1">
                <h4>No information about aggregated variants exists for this phenotype</h4>
            </div>
        </div>
    </div>


    </div>
</div>

<div id="locusZoomTemplate"  type="x-tmpl-mustache" style="display:none">
        <div style="margin-top: 20px">

            <div style="display: flex; justify-content: space-around;">
                <p>Linkage disequilibrium (r<sup>2</sup>) with the reference variant:</p>

                <p><i class="fa fa-circle" style="color: #d43f3a"></i> 1 - 0.8</p>

                <p><i class="fa fa-circle" style="color: #eea236"></i> 0.8 - 0.6</p>

                <p><i class="fa fa-circle" style="color: #5cb85c"></i> 0.6 - 0.4</p>

                <p><i class="fa fa-circle" style="color: #46b8da"></i> 0.4 - 0.2</p>

                <p><i class="fa fa-circle" style="color: #357ebd"></i> 0.2 - 0</p>

                <p><i class="fa fa-circle" style="color: #B8B8B8"></i> no information</p>

                <p><i class="fa fa-circle" style="color: #9632b8"></i> reference variant</p>
            </div>
            <ul class="nav navbar-nav navbar-left" style="display: flex;">
                <li class="dropdown" id="tracks-menu-dropdown-dynamic">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes (dynamic)<b class="caret"></b></a>
                    <ul id="trackList-dynamic" class="dropdown-menu">
                        <g:each in="${lzOptions?.findAll{it.dataType=='dynamic'}}">
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZPhenotype({
                                            phenotype: '${it.key}',
                                            dataSet: '${it.dataSet}',
                                            propertyName: '${it.propertyName}',
                                            description: '${it.description}'
                                        },
                                        '${it.dataSet}','${createLink(controller:"gene", action:"getLocusZoom")}',
                                        '${createLink(controller:"variantInfo", action:"variant")}',
                                        '${it.dataType}','#lz-1')">
                                    ${g.message(code: "metadata." + it.name)}
                                </a>
                            </li>
                        </g:each>
                    </ul>
                </li>
                <li class="dropdown" id="tracks-menu-dropdown-static">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes (static)<b class="caret"></b></a>
                    <ul id="trackList-static" class="dropdown-menu">
                        <g:each in="${lzOptions?.findAll{it.dataType=='static'}}">
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZPhenotype({
                                            phenotype: '${it.key}',
                                            dataSet: '${it.dataSet}',
                                            propertyName: '${it.propertyName}',
                                            description: '${it.description}'
                                        },
                                        '${it.dataSet}','${createLink(controller:"gene", action:"getLocusZoom")}',
                                        '${createLink(controller:"variantInfo", action:"variant")}',
                                        '${it.dataType}','#lz-1')">
                                    ${g.message(code: "metadata." + it.name)}
                                </a>
                            </li>
                        </g:each>
                    </ul>
                </li>

                <li style="margin: auto;">
                    <b>Region: <span id="lzRegion"></span></b>
                </li>
            </ul>

            <div class="accordion-inner">
                <div id="lz-1" class="lz-container-responsive"></div>
            </div>

        </div>
 </div>


<script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row" style="margin-top: 15px;">
                                <h3 class="specialTitle">Aggregate variants</h3>
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

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">NS 1%</span>
                                                <div id="allMissense"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">NS 1% broad</span>
                                                <div id="possiblyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">NS strict</span>
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


<script id="highImpactTemplate"  type="x-tmpl-mustache">
            <div class="row" style="margin-top: 15px;">
                <h3 class="specialTitle">High impact variants</h3>
            </div>

            <div class="row">
                <div class="col-lg-12">

                            <div class="row variantBoxHeaders">
                                <div class="col-lg-2">Variant ID</div>

                                <div class="col-lg-2">dbSNP Id</div>

                                <div class="col-lg-1">Protein<br/>change</div>

                                <div class="col-lg-2">Predicted<br/>impact</div>

                                <div class="col-lg-1">p-Value</div>

                                <div class="col-lg-1">Effect</div>
                                <div class="col-lg-3">Data set</div>
                            </div>

                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="boxOfVariants">
                                        {{ #rvar }}
                                            <div class="row  {{CAT}}">
                                                <div class="col-lg-2"><a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/{{id}}" class="boldItlink">{{id}}</a></div>

                                                <div class="col-lg-2"><span class="linkEmulator" onclick="mpgSoftware.geneSignalSummary.refreshLZ('{{id}}','{{dsr}}','{{pname}}','{{pheno}}')" class="boldItlink">{{rsId}}</a></div>


                                                <div class="col-lg-1">{{impact}}</div>

                                                <div class="col-lg-2">{{deleteriousness}}</div>

                                                <div class="col-lg-1">{{P_VALUE}}</div>

                                                <div class="col-lg-1">{{BETA}}</div>
                                                <div class="col-lg-3">{{ds}}</div>
                                            </div>
                                        {{ /rvar }}
                                        {{ ^rvar }}
                                            <div class="row">
                                                <div class="col-xs-offset-4 col-xs-4">No high impact variants</div>
                                            </div>
                                        {{ /rvar }}

                                    </div>
                                </div>
                            </div>
                </div>
            </div>
       </script>




<script id="commonVariantTemplate"  type="x-tmpl-mustache">
            <div class="row" style="margin-top: 15px;">
                <h3 class="specialTitle">Common variants</h3>
            </div>

            <div class="row">
                <div class="col-lg-12">


                    <div class="row">
                        <div class="col-sm-12">
                         <div class="row variantBoxHeaders" >
                                <div class="col-lg-3">Variant ID</div>

                                <div class="col-lg-3">dbSNP Id</div>

                                <div class="col-lg-2">p-Value</div>

                                <div class="col-lg-1">Effect</div>

                                <div class="col-lg-3">Data set</div>
                            </div>
                            <div class="boxOfVariants">
                                {{ #cvar }}
                                <div class="row {{CAT}}">

                                        <div class="col-lg-3"><a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/{{id}}" class="boldItlink">{{id}}</a></div>

                                        <div class="col-lg-3"><span class="linkEmulator" onclick="mpgSoftware.geneSignalSummary.refreshLZ('{{id}}','{{dsr}}','{{pname}}','{{pheno}}')" class="boldItlink">{{rsId}}</a></div>

                                        <div class="col-lg-2">{{P_VALUE}}</div>

                                        <div class="col-lg-1">{{BETA}}</div>

                                        <div class="col-lg-3">{{ds}}</div>

                                </div>
                                {{ /cvar }}
                                {{ ^cvar }}
                                <div class="row">
                                    <div class="col-xs-offset-4 col-xs-4">No common variants</div>
                                </div>
                                {{ /cvar }}
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </script>




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
        var phenotypeNameForHailData  = function (untranslatedPhenotype) {
            var convertedName;
            if (untranslatedPhenotype === 'T2D') {
                convertedName = {key: "T2D", description: "Type 2 Diabetes"};
            } else if (untranslatedPhenotype === 'BMI') {
                convertedName = {key: "BMI_adj_withincohort_invn", name: "BMI", description: "Body Mass Index"};
            } else if (untranslatedPhenotype === 'LDL') {
                convertedName = {key: "LDL_lipidmeds_divide.7_adjT2D_invn", name: "LDL", description: "LDL Cholesterol"};
            } else if (untranslatedPhenotype === 'HDL') {
                convertedName = {key: "HDL_adjT2D_invn", name: "HDL", description: "HDL Cholesterol"};
            } else if (untranslatedPhenotype === 'FI') {
                convertedName = {key: "logfastingInsulin_adj_invn", name: "FI", description: "Fasting Insulin"};
            } else if (untranslatedPhenotype === 'FG') {
                convertedName = {key: "fastingGlucose_adj_invn", name: "FG", description: "Fasting Glucose"};
            } else if (untranslatedPhenotype === 'HIPC') {
                convertedName = {key: "HIP_adjT2D_invn", name: "HIP", description: "Hip Circumference"};
            } else if (untranslatedPhenotype === 'WAIST') {
                convertedName = {key: "WC_adjT2D_invn", name: "WC", description: "Waist Circumference"};
            } else if (untranslatedPhenotype === 'WHR') {
                convertedName = {key: "WHR_adjT2D_invn", name: "WHR", description: "Waist Hip Ratio"};
            } else if (untranslatedPhenotype === 'SBP') {
                convertedName = {key: "TC_adjT2D_invn", name: "TC", description: "Total Cholesterol"};
            } else if (untranslatedPhenotype === 'DBP') {
                convertedName = {key: "TG_adjT2D_invn", name: "TG", description: "Triglycerides"};
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
                        var mdsValue;
                        var pValue;
                        _.forEach(v,function(val,key){
//                        _.forEach(v,function(actObj){
//                            _.forEach(actObj,function(val,key){
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
                                    if (obj['MOST_DEL_SCORE'].length > 0){
                                        mdsValue = parseInt(obj['MOST_DEL_SCORE']);
                                    }
                                } else if (key==='ds') {
                                    obj['ds'] = (val)?val:'';
                                } else if (key==='dsr') {
                                    obj['dsr'] = (val)?val:'';
                                } else if (key==='pname') {
                                    obj['pname'] = (val)?val:'';
                                } else if (key==='pheno') {
                                    obj['pheno'] = (val)?val:'';
                                } else if (key==='datasetname') {
                                    obj['datasetname'] = (val)?val:'';
                                }  else if (key==='meaning') {
                                    obj['meaning'] = (val)?val:'';
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
                                            pValue = obj['P_VALUEV'];
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
                        //});
                        renderData.variants.push(obj);
                     });
                };
                return renderData;
            };
            var refineRenderData = function (renderData,significanceLevel)  {
                renderData.rvar=[];
                renderData.cvar=[];
                var pValueCutoffHighImpact = 0;
                var pValueCutoffCommon = 0;
                var maxNumberOfVariants = 100;
                switch (significanceLevel){
                    case 3:
                        pValueCutoffHighImpact = 0.00000005;
                        pValueCutoffCommon = 0.000005;
                        break;
                    case 2:
                        pValueCutoffHighImpact = 0.0001;
                        pValueCutoffCommon = 0.0001;
                        break;
                    case 1:
                        pValueCutoffHighImpact = 1;
                        pValueCutoffCommon = 1;
                        break;
                    default: break;
                }
                _.forEach(renderData.variants,function(v){
                    var mafValue = v['MAF']
                    var mdsValue = v['MOST_DEL_SCORE'];
                    var pValue = v['P_VALUEV'];
                    if ((typeof mdsValue !== 'undefined') && (mdsValue!=='') && (mdsValue<=2) &&
                            (typeof pValue !== 'undefined') && (pValue<=pValueCutoffHighImpact)){
                        if (renderData.rvar.length < maxNumberOfVariants){
                            if (pValue < 0.00000005) {v['CAT'] = 'greenline'}
                            else if (pValue < 0.0001) {v['CAT'] = 'yellowline'}
                            else {v['CAT'] = 'redline'}
                            renderData.rvar.push(v);
                        }
                    }
                    if ((typeof mafValue !== 'undefined') && (mafValue!=='') && (mafValue>0.05)&&
                                (typeof pValue !== 'undefined') && (pValue<=pValueCutoffCommon)) {
                        if (renderData.cvar.length < maxNumberOfVariants) {
                            if (pValue < 0.00000005) {v['CAT'] = 'greenline'}
                            else if (pValue < 0.0001) {v['CAT'] = 'yellowline'}
                            else {v['CAT'] = 'redline'}
                            renderData.cvar.push(v);
                        }
                    }
                });
                renderData.rvar = _.sortBy(renderData.rvar,function(o){return o.P_VALUEV});
                renderData.cvar = _.sortBy(renderData.cvar,function(o){return o.P_VALUEV});
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


            var commonSectionComesFirst = function (renderData) { // returns true or false
                var returnValue;
                var sortedVariants = _.sortBy(renderData.variants,function(o){return o.P_VALUEV});
                for ( var i = 0 ; (i < sortedVariants.length)  && (typeof returnValue === 'undefined') ; i++ ){
                    var oneVariant  = sortedVariants[i];
                    if ((typeof oneVariant.MAF !== 'undefined')&&(oneVariant.MAF!=="")){
                        if (oneVariant.MAF < 0.05){
                            returnValue = false;
                        }else {
                            returnValue = true;
                        }
                    }
                    if ((typeof oneVariant.MOST_DEL_SCORE !== 'undefined')){
                        if (oneVariant.MOST_DEL_SCORE < 3){
                            returnValue = false;
                        }
                    }
                }
                return returnValue;
            }


            var updateSignificantVariantDisplay = function (data) {
                var renderData = buildRenderData (data,0.05);
                var signalLevel = assessSignalSignificance(renderData);
                var commonSectionShouldComeFirst = commonSectionComesFirst(renderData);
                renderData = refineRenderData(renderData,1);
                updateDisplayBasedOnSignificanceLevel (signalLevel);
                if (mpgSoftware.locusZoom.plotAlreadyExists()) {
                    mpgSoftware.locusZoom.removeAllPanels();
                }
                $('#collapseExample div.well').empty();
                if (commonSectionShouldComeFirst){
                    $('#collapseExample div.well').append('<div id="commonVariantsLocation"></div>'+
                            '<div id="locusZoomLocation"></div>'+
                            '<div id="highImpactVariantsLocation"></div>'+
                            '<div id="aggregateVariantsLocation"></div>'
                    );
                } else {
                    $('#collapseExample div.well').append('<div id="highImpactVariantsLocation"></div>'+
                            '<div id="locusZoomLocation"></div>'+
                            '<div id="aggregateVariantsLocation"></div>'+
                            '<div id="commonVariantsLocation"></div>');
                }
                $("#locusZoomLocation").empty().append(Mustache.render( $('#locusZoomTemplate')[0].innerHTML,renderData));
                $("#highImpactVariantsLocation").empty().append(Mustache.render( $('#highImpactTemplate')[0].innerHTML,renderData));
                $("#aggregateVariantsLocation").empty().append(Mustache.render( $('#aggregateVariantsTemplate')[0].innerHTML,renderData));
                $("#commonVariantsLocation").empty().append(Mustache.render( $('#commonVariantTemplate')[0].innerHTML,renderData));
                var phenotypeName = $('#signalPhenotypeTableChooser option:selected').val();
                var sampleBasedPhenotypeName = phenotypeNameForSampleData(phenotypeName);
                var hailPhenotypeInfo = phenotypeNameForHailData(phenotypeName);
                if ( ( typeof sampleBasedPhenotypeName !== 'undefined') &&
                     ( sampleBasedPhenotypeName.length > 0)) {
                    $('#aggregateVariantsLocation').css('display','block');
                    $('#noAggregatedVariantsLocation').css('display','none');
                    refreshVariantAggregates(sampleBasedPhenotypeName,"0","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allVariants");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"1","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allCoding");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"8","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#allMissense")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"7","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#possiblyDamaging");
                    refreshVariantAggregates(sampleBasedPhenotypeName,"6","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#probablyDamaging")
                    refreshVariantAggregates(sampleBasedPhenotypeName,"5","<%=sampleDataSet%>","<%=burdenDataSet%>","1","1","<%=geneName%>",updateAggregateVariantsDisplay,"#proteinTruncating");
                } else {
                    $('#aggregateVariantsLocation').css('display','none');
                    $('#noAggregatedVariantsLocation').css('display','block');
                }
                var positioningInformation = {
                    chromosome: '${geneChromosome}'.replace(/chr/g, ""),
                    startPosition:  ${geneExtentBegin},
                    endPosition:  ${geneExtentEnd}
                };
                if (!mpgSoftware.locusZoom.plotAlreadyExists()){
                    mpgSoftware.locusZoom.initializeLZPage('geneInfo', null, positioningInformation,
                            "#lz-1", "#collapseExample", '${lzOptions.first().key}','${lzOptions.first().description}','${lzOptions.first().propertyName}','${lzOptions.first().dataSet}','junk',
                            '${createLink(controller:"gene", action:"getLocusZoom")}',
                            '${createLink(controller:"variantInfo", action:"variantInfo")}','${lzOptions.first().dataType}');
                } else {
                    if (typeof hailPhenotypeInfo !== 'undefined') {
                        mpgSoftware.locusZoom.resetLZPage('geneInfo', null, positioningInformation,
                                "#lz-1","#collapseExample",'${lzOptions.first().key}','${lzOptions.first().description}','${lzOptions.first().dataSet}','${lzOptions.first().propertyName}','junk',
                                '${createLink(controller:"gene", action:"getLocusZoom")}',
                                '${createLink(controller:"variantInfo", action:"variantInfo")}','${lzOptions.first().dataType}');
                    } else {
                        $("#locusZoomLocation").css('display','none');
                    }
                }
                $('#collapseExample').on('shown.bs.collapse', function (e) {
                    mpgSoftware.locusZoom.rescaleSVG();
                });
            };


            var assessSignalSignificance = function (renderData){
               var signalCategory = 1; // 1 == red (no signal), 3 == green (signal)
                _.forEach(renderData.variants,function(v){
                    var mdsValue = parseInt(v['MOST_DEL_SCORE']);
                    var mafValue = parseFloat(v['MAF']);
                    var pValue = parseFloat(v['P_VALUEV']);
                    if (signalCategory < 3){
                        if ( ((pValue < 0.00000005)&&
                              (mdsValue < 3))||
                             ((pValue < 0.000005)&&
                              (mafValue > 0.05)) ){
                            signalCategory = 3;
                        }
                    } else if (signalCategory < 2){
                        if (pValue < 0.0001){
                            signalCategory = 2;
                        }
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
                $('#signalLevelHolder').text(significanceLevel);
            };





            var updateDisplayBasedOnStoredSignificanceLevel = function (newSignificanceLevel) {
                var currentSignificanceLevel = $('#signalLevelHolder').text();
                if (newSignificanceLevel>=currentSignificanceLevel){
                    return;
                }
                updateDisplayBasedOnSignificanceLevel(newSignificanceLevel);
            };




            var refreshVariantAggregates = function (phenotypeName, filterNum, sampleDataSet, dataSet,mafOption, mafValue, geneName, callBack,callBackParameter) {
                var rememberCallBack = callBack;
                var rememberCallBackParameter = callBackParameter;

                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'gene', action: 'burdenTestAjax')}",
                    data: { geneName:geneName,
                            dataSet:dataSet,
                            sampleDataSet:sampleDataSet,
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

    var refreshLZ = function(varId,dataSetName,propName,phenotype){
        var parseId = varId.split("_");
        var locusZoomRange = 80000;
        var variantPos = parseInt(parseId[1]);
        var begPos = 0;
        var endPos =  variantPos + locusZoomRange;
        if (variantPos > locusZoomRange ){
            begPos =  variantPos - locusZoomRange;
        }
        var positioningInformation = {
            chromosome: parseId[0],
            startPosition: begPos,
            endPosition: endPos
        };
        mpgSoftware.locusZoom.removeAllPanels();


                %{--mpgSoftware.locusZoom.resetLZPage('geneInfo', null, positioningInformation,--}%
                        %{--"#lz-1","#collapseExample",'T2D','Type 2 Diabetes',dataSetName,propName,phenotype,--}%
                        %{--'${createLink(controller:"gene", action:"getLocusZoom")}',--}%
                        %{--'${createLink(controller:"variantInfo", action:"variantInfo")}','static');--}%
    };




return {
    updateSignificantVariantDisplay:updateSignificantVariantDisplay,
    updateDisplayBasedOnSignificanceLevel: updateDisplayBasedOnSignificanceLevel,
    refreshTopVariantsDirectlyByPhenotype:refreshTopVariantsDirectlyByPhenotype,
    refreshTopVariantsByPhenotype:refreshTopVariantsByPhenotype,
    refreshLZ:refreshLZ
}
}());


})();
    //
//var loading = $('#spinner').show();
//loading.hide();
$( document ).ready(function() {
mpgSoftware.geneInfo.fillPhenotypeDropDown('#signalPhenotypeTableChooser',
    '${g.defaultPhenotype()}',
                "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
                function(){
                    // retrieve the top value in the phenotype drop-down
                    mpgSoftware.geneSignalSummary.refreshTopVariantsDirectlyByPhenotype($($('#signalPhenotypeTableChooser>option')[1]).attr('value'),
                            mpgSoftware.geneSignalSummary.updateSignificantVariantDisplay);
                } );
    var positioningInformation = {
        chromosome: '${geneChromosome}'.replace(/chr/g, ""),
        startPosition:  ${geneExtentBegin},
        endPosition:  ${geneExtentEnd}
    };

    });


</script>

