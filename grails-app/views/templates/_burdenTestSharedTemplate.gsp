<style>
#gaitTable td {
    outline: 0px solid #000;
}
</style>
<script id="displayResultsTemplate"  type="x-tmpl-mustache">
    <div class="">%{--should hold the Choose data set panel--}%

    <div class="row burden-test-some-results burden-test-some-results_{{stratum}}">
        <div class="row iatErrorFailure" style="display:none">
            <div class="col-md-8 col-sm-6">
                <div class="iatError">
                    <div class="iatErrorText"></div>
                </div>
            </div>

            <div class="col-md-4 col-sm-6">

            </div>
        </div>

        <div class="col-md-offset-4 col-md-4 vcenter center burden-test-btn-wrapper">
            <button name="singlebutton" style="height: 50px; z-index: 10;" id="singleRunButton"
                                                   class="btn btn-primary btn-lg burden-test-btn vcenter"
                                                   onclick="mpgSoftware.burdenTestShared.immediateFilterAndRun('${createLink(controller: "variantInfo", action: "metadataAjax")}',
                                                   '${createLink(controller: "variantInfo", action: "burdenTestAjax")}',
                                                   '<%=variantIdentifier%>',
                                                   {{#variantsSetRefinement}}
                                                   ''
                                                   {{/variantsSetRefinement}}
                                                   {{^variantsSetRefinement}}
                                                   'K'
                                                   {{/variantsSetRefinement}}
                                                   )">Launch analysis</button>
        </div>


        <div class="col-sm-12 col-xs-12">
            <div class="row burden-test-specific-results burden-test-result">



                <div class="col-md-12 col-sm-12">
                    <div>
                        <div class="vertical-center">
                            <div class="strataResults">

                            </div>
                        </div>
                    </div>
                </div>


            </div>

            <div class="row burden-test-result-large burden-test-some-results-large_{{stratum}}">
                <div class="col-md-4 col-sm-3">
                </div>

                <div class="col-md-4 col-sm-6">
                    <div class="vertical-center">
                        <div class="pValue pValue_{{stratum}}"></div>

                        <div class="orValue orValue_{{stratum}}"></div>

                        <div class="ciValue ciValue_{{stratum}}"></div>
                    </div>
                </div>

                <div class="col-md-4 col-sm-3">
                </div>
            </div>
        </div>


    </div>
</div>
</script>


%{--Choose the phenotype and stratification options. Currently the top section in the interface--}%
<script id="chooseDataSetAndPhenotypeTemplate"  type="x-tmpl-mustache">
    <div class="">%{--should hold the Choose data set panel--}%

        <div class="">
            <h3>
                Choose a phenotype and partitioning strategy
            </h3>
        </div>

        <div id="chooseSamples" class="">
            <div class="secBody">
            <div class="row">
                <div class="col-md-4 text-left">
                    <div class="secHeader chooseExperiment">
                        <!-- <div class="col-sm-4 col-xs-4 text-left"> -->
                            <label>Dataset</label>
                        <!-- </div> -->
                    </div>

                    <div class="chooseExperiment">
                        <select id="datasetFilter" class="traitFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering',true,
                                         {linkToTypeaheadUrl:'${createLink(controller:"gene", action:"variantOnlyTypeAhead")}',
                                         sampleMetadataAjaxUrl:'${createLink(controller: "VariantInfo", action: "sampleMetadataAjax")}',
                                         generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: "gene", action: "generateListOfVariantsFromFiltersAjax")}',
                                         variantInfoUrl:'${createLink(controller: "variantInfo", action: "variantInfo")}',
                                         retrieveSampleSummaryUrl:'${createLink(controller: "variantInfo", action: "retrieveSampleSummary")}',
                                         variantAndDsAjaxUrl:'${createLink(controller: "variantInfo", action: "variantAndDsAjax")}',
                                         burdenTestVariantSelectionOptionsAjaxUrl:'${createLink(controller: "gene", action: "burdenTestVariantSelectionOptionsAjax")}',
                                         getGRSListOfVariantsAjaxUrl:'${createLink(controller:"grs",action: "getGRSListOfVariantsAjax")}'})">
                        </select>
                    </div>
                </div>

                <div class="col-md-4 text-left">
                <div class="secHeader  choosePhenotype" style="padding: 0 0 0 0">
                    <!-- <div class="col-sm-4 col-xs-4 text-left">-->
                        <label>Phenotype</label>
                    <!-- </div>-->
                </div>

                <div class="choosePhenotype">
                    <select id="phenotypeFilter" class="traitFilter form-control text-left phenotypeFilter"
                            onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering',false,
                                         {linkToTypeaheadUrl:'${createLink(controller:"gene", action:"variantOnlyTypeAhead")}',
                                         sampleMetadataAjaxUrl:'${createLink(controller: "VariantInfo", action: "sampleMetadataAjax")}',
                                         generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: "gene", action: "generateListOfVariantsFromFiltersAjax")}',
                                         variantInfoUrl:'${createLink(controller: "variantInfo", action: "variantInfo")}',
                                         retrieveSampleSummaryUrl:'${createLink(controller: "variantInfo", action: "retrieveSampleSummary")}',
                                         variantAndDsAjaxUrl:'${createLink(controller: "variantInfo", action: "variantAndDsAjax")}',
                                         burdenTestVariantSelectionOptionsAjaxUrl:'${createLink(controller: "gene", action: "burdenTestVariantSelectionOptionsAjax")}',
                                         getGRSListOfVariantsAjaxUrl:'${createLink(controller:"grs",action: "getGRSListOfVariantsAjax")}'})">
                     </select>
                </div>
            </div>

            <div class="col-md-4 text-left">
                {{ #strataChooser }}
                <div class="secHeader stratificationHolder chooseStratification">
                    <!-- <div class="col-sm-4 col-xs-4 text-left">-->
                        <label>Stratify</label>
                    <!-- </div>-->
                </div>

                <div class="stratificationHolder chooseStratification">
                    <select id="stratifyDesignation" class="stratifyFilter form-control text-left"
                            onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering',false,
                                         {linkToTypeaheadUrl:'${createLink(controller:"gene", action:"variantOnlyTypeAhead")}',
                                         sampleMetadataAjaxUrl:'${createLink(controller: "VariantInfo", action: "sampleMetadataAjax")}',
                                         generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: "gene", action: "generateListOfVariantsFromFiltersAjax")}',
                                         variantInfoUrl:'${createLink(controller: "variantInfo", action: "variantInfo")}',
                                         retrieveSampleSummaryUrl:'${createLink(controller: "variantInfo", action: "retrieveSampleSummary")}',
                                         variantAndDsAjaxUrl:'${createLink(controller: "variantInfo", action: "variantAndDsAjax")}',
                                         burdenTestVariantSelectionOptionsAjaxUrl:'${createLink(controller: "gene", action: "burdenTestVariantSelectionOptionsAjax")}',
                                         getGRSListOfVariantsAjaxUrl:'${createLink(controller:"grs",action: "getGRSListOfVariantsAjax")}'})">
                                <option value="none">none</option>
                                <option value="origin">ancestry</option>
                    </select>
                </div>
                {{ /strataChooser }}
            </div>
            </div>

                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <div  id="caseControlFilteringWithLabel" class="checkbox" style="margin:20px 0 10px 0">
                                <span style="margin: 0 25px 0 0; font-weight: bold">Samples:</span>
                                <input id="caseControlFiltering" type="checkbox" name="caseControlFiltering"
                                       value="caseControlFiltering"
                                        onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering',false,
                                         {linkToTypeaheadUrl:'${createLink(controller:"gene", action:"variantOnlyTypeAhead")}',
                                         sampleMetadataAjaxUrl:'${createLink(controller: "VariantInfo", action: "sampleMetadataAjax")}',
                                         generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: "gene", action: "generateListOfVariantsFromFiltersAjax")}',
                                         variantInfoUrl:'${createLink(controller: "variantInfo", action: "variantInfo")}',
                                         retrieveSampleSummaryUrl:'${createLink(controller: "variantInfo", action: "retrieveSampleSummary")}',
                                         variantAndDsAjaxUrl:'${createLink(controller: "variantInfo", action: "variantAndDsAjax")}',
                                         burdenTestVariantSelectionOptionsAjaxUrl:'${createLink(controller: "gene", action: "burdenTestVariantSelectionOptionsAjax")}',
                                         getGRSListOfVariantsAjaxUrl:'${createLink(controller:"grs",action: "getGRSListOfVariantsAjax")}'})">
                                        <label style="padding-left:0">Filter cases and controls separately</label>
                                </input>
                        </div>
                    </div>
                </div>


            </div>
        </div>

    </div>    %{--end accordion panel for id=chooseSamples--}%
</script>

%{--Handles the filters section, both with and without strata.  Note however that we do not fill in
the individual filters themselves. That work is handled later as part of a loop--}%
<script id="chooseFiltersTemplate"  type="x-tmpl-mustache">
<div class="panel panel-default">%{--should hold the Choose filters panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#filterSamples"
                       href="#filterSamples" onclick="checkGaitTabs(event);" >Step {{sectionNumber}}: Select a subset of samples based on phenotypic criteria</a>
                </h4>
            </div>

            <div id="filterSamples" class="panel-collapse collapse">
                <div class="panel-body  secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Each of the boxes below enables you to define a criterion for inclusion of samples in your analysis; each criterion is specified as a filter based on a single phenotype.
                                The final subset of samples used will be those that match all of the specified criteria; to omit a criterion leave the text box blank.
                            </p>

                            <p>
                                Click on the "graph" icon near each phenotype name to view the distribution of phenotypic values for the samples currently included
                                in the analysis. The number of samples included, as well as the distributions, will update whenever you modify the value in the text box.
                            </p>
                        </div>
                    </div>

                    <!-- <div class="row">
                        <div class="col-md-12" style="padding:0; margin: 0;">
                            <ul class="nav nav-tabs datasetNames" id="datasetNamesTabs">
                                <li class="active"><a>19K exome sequence analysis</a></li>
                                <li><a>CAMP GWAS</a></li>
                                <li><a>BioMe AMP T2D GWAS</a></li>
                            </ul>
                        </div>
                    </div> -->

                    <div class="row modeled-phenotype-div" style="{{modeledPhenotypeDisplay}}">
                        <div class="col-md-12" style="padding:0; margin: 0;">
                            <ul class="nav nav-tabs modeledPhenotypeDisplay" id="modeledPhenotypeTabs">
                                {{ #modeledPhenotype }}
                                   {{ #levels }}
                                        <li class="{{defaultDisplay}}">
                                            <a data-target="#{{name}}" data-toggle="tab" class="filterCohort {{val}} {{phenoLevelName}}">{{name}}</a>
                                                <div class="modelledPhenoIdent">

                                                </div>
                                        </li>
                                   {{ /levels }}
                                {{ /modeledPhenotype }}
                            </ul>
                        </div>
                    </div>


                    <div class="tab-content clearfix" style="border: solid 1px #ddd; border-top: none; margin-top: -6px;">
                         {{ #modeledPhenotype }}
                           {{ #levels }}
                            <div class="tab-pane  {{defaultDisplay}}" id="{{name}}">
                                <div class="">

                                    <div class="" style="{{tabDisplay}}">
                                        <div class="col-md-12" style="padding:0; margin: 0;">
                                            <ul class="nav nav-tabs stratsTabs" id="{{name}}_stratsTabs">
                                                {{ #strataContent }}
                                                   <li class="{{defaultDisplay}}">
                                                       <a data-target="#{{name}}_{{phenoLevelName}}" data-toggle="tab" class="filterCohort {{trans}} {{phenoLevelName}}">{{trans}}</a>
                                                       <div class="strataPhenoIdent">
                                                           <div class="phenoCategory  {{phenoName}}" style="display: none">{{category}}</div>
                                                           <div class="phenoInstance  {{phenoLevelName}}" style="display: none">{{val}}</div>
                                                       </div>
                                                   </li>
                                                {{ /strataContent }}
                                                <div class="stratsTabs_property {{phenoLevelName}}" id="{{name}}_{{strataProperty}}" style="display: none"></div>
                                                <div class="phenoSplitTabs_property  {{phenoLevelName}}" id="{{name}}_{{phenotypeProperty}}" style="display: none"></div>
                                                <div class="phenoRawSplitTabs_property" id="{{phenoLevelVal}}" style="display: none"></div>
                                            </ul>
                                        </div>
                                    </div>


                                    <div class="tab-content">
                                        {{ #strataContent }}
                                            <div class="tab-pane {{defaultDisplay}}" id="{{name}}_{{phenoLevelName}}">
                                                <div class="">
                                                    <div class="col-sm-5 col-xs-12 vcenter" style="margin-top:-7px;">
                                                        <div class="row secHeader" style="padding: 20px 0 0 0">
                                                            <div class="col-sm-12 col-xs-12 text-left">
                                                            <label style="font-style: italic; font-size: 14px">Click a phenotype name or set value for a phenotype to render corresponding plot.
                                                            </label>
                                                            </div>
                                                        </div>

                                                        <div class="row" style="padding: 10px 0 0 0">
                                                            <div class="col-sm-12 col-xs-12 text-left">

                                                                <div class='filterscroller' style="direction: rtl; max-height: 620px; padding: 4px 0 0 10px; overflow-y: auto;">
                                                                    <div style="direction: ltr; margin: 10px 0 0 5px">
                                                                        <div>
                                                                            <div class="row">

                                                                               <div class="user-interaction user-interaction-{{name}}">

                                                                                     <div class="filterHolder filterHolder_{{name}}">

                                                                                        {{ >allFiltersTemplate }}

                                                                                     </div>

                                                                                </div>

                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>

                                                    </div>

                                                    <div class="col-sm-7 col-xs-12 vcenter" style="padding: 15px 0 0 0; margin: 0; border-top:solid 1px #fff;border-left:solid 1px #ccc;">
                                                        <div class="sampleNumberReporter text-center">
                                                            <div>Number of samples included in analysis:<span class="numberOfSamples"></span> | Trait: <span class="trait_name">Age</span></div>
                                                            <!--<div>Phenotype: <strong class="trait_name">Age</strong></div>-->
                                                            <div><span style="display:none"
                                                                    class="phenotypeSpecifier" style="font-weight:bold"></span><span
                                                                    class="numberOfPhenotypeSpecificSamples"></span></div>
                                                        </div>

                                                        <div class="boxWhiskerPlot boxWhiskerPlot_{{name}} boxWhiskerPlot_{{name}}_{{phenoLevelName}}"></div>

                                                    </div>

                                                </div>
                                            </div>
                                        {{ /strataContent }}
                                    </div>




                                </div>
                            </div>
                           {{ /levels }}
                         {{ /modeledPhenotype }}
                    </div>



                </div>
            </div>

        </div>%{--end accordion panel for id=filterSamples--}%
</script>



<script id="allFiltersTemplate"  type="x-tmpl-mustache">
                            {{ #filterDetails }}
                                {{>filterFloatTemplate}}
                                {{>filterCategoricalTemplate}}
                            {{/filterDetails }}
            </script>

<script id="filterFloatTemplate"  type="x-tmpl-mustache">

                                {{ #realValuedFilters }}
                                <div class="row realValuedFilter {{stratum}} {{phenoLevelName}} considerFilter" id="filter_{{stratum}}_{{name}}">
                                    %{--<div class="col-sm-1">--}%
                                        <input class="utilize" id="use{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked style="display: none"/></td>
                                    %{--</div>--}%

                                    <div class="col-sm-6">
                                        <span class="btn btn-default form-control" style="{{bold}}; text-align: left !important; margin-left: -15px; border: solid 1px #fff; box-shadow: none !important;"  onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',0,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')">{{trans}} <span style="color:#6699cc; font-size: 12px; margin: -2px 0 0 3px; padding: 0 0 1px 1px; border-left: solid 1px #000; border-bottom: solid 1px #000;" class="glyphicon glyphicon-align-left"></span></span>
                                    </div>

                                    <div class="col-sm-2">
                                        <select id="cmp_{{stratum}}_{{name}}_{{phenoLevelName}}" class="form-control filterCmp cmp_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
                                                data-selectfor="{{stratum}}_{{name}}Comparator"
                                               onchange="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',0,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')">
                                            <option value="1">&lt;</option>
                                            <option value="2">&gt;</option>
                                            <option value="3">internal</option>
                                            <option value="4">external</option>
                                        </select>
                                    </div>

                                    <div class="col-sm-4">
                                        <input type="text" id="inp_{{stratum}}_{{name}}_{{phenoLevelName}}" class="filterParm form-control inp_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
                                               data-type="propertiesInput"
                                               data-prop="{{stratum}}_{{name}}Value" data-translatedname="{{stratum}}_{{name}}"
                                               onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',0,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')"
                                               onkeyup="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',0,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}');highlightActiveTabs(event);">

                                    </div>

                                    <div class="" style="display:none;">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',0,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')"
                                              class="glyphicon glyphicon-arrow-right pull-right distPlotter {{phenoLevelName}}" id="distPlotter_{{stratum}}_{{name}}"></span>
                                    </div>

                                </div>
                                {{ /realValuedFilters }}
                    </script>

<script id="filterCategoricalTemplate" type="x-tmpl-mustache">
                                {{ #categoricalFilters }}
                                <div class="row categoricalFilter considerFilter {{stratum}} {{phenoLevelName}}" id="filter_{{stratum}}_{{name}}">
                                   %{-- <div class="col-sm-1">--}%
                                        <input class="utilize" id="use_{{stratum}}_{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked  style="display: none"/></td>
                                   %{-- </div>--}%

                                    <div class="col-sm-6">
                                        <span class="btn btn-default form-control" style="{{bold}}; text-align: left !important; margin-left: -15px; border: solid 1px #fff; box-shadow: none !important;"  onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',1,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')">{{trans}}  <span style="color:#6699cc; font-size: 12px; margin: -2px 0 0 3px; padding: 0 0 1px 1px; border-left: solid 1px #000; border-bottom: solid 1px #000;" class="glyphicon glyphicon-align-left"></span></span>
                                    </div>


                                    <div class="col-sm-6">
                                        <select id="multi_{{stratum}}_{{name}}_{{phenoLevelName}}" class="form-control multiSelect multi_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
                                                data-selectfor="{{stratum}}_{{name}}FilterOpts" multiple="multiple"
                                                onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',1,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')">
                                        </select>

                                    </div>

                                    <div class="" style="display:none;">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',
                                               '${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}',1,'{{phenoLevelName}}'); $(this).closest('.tab-pane').find('.trait_name').text('{{trans}}')"
                                              class="glyphicon glyphicon-arrow-right pull-right"  id="distPlotter_{{stratum}}_{{name}}"></span>
                                    </div>

                                </div>
                                {{ /categoricalFilters }}
                    </script>

<script id="filterStringTemplate" type="x-tmpl-mustache">
                                <p><span>str name={{name}},type={{type}}</span></p>
                    </script>



<script id="chooseCovariatesTemplate"  type="x-tmpl-mustache">
        <div class="panel panel-default">%{--should hold the initiate analysis set panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#initiateAnalysis_{{stratum}}"
                       href="#initiateAnalysis_{{stratum}}">Step {{sectionNumber}}: Control for covariates</a>
                </h4>
            </div>


            <div id="initiateAnalysis_{{stratum}}" class="panel-collapse collapse">
                <div class="panel-body secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Select principal components and/or phenotypes to be used as covariates in your association analysis. Principal
                                components 1-4 are selected by default to minimize the influence of ancestry, though additional principal components
                                may be selected to control for finer grained substructure within a population. Selecting phenotypes as covariates
                                allows you to estimate the effects of the response phenotype independently of the covariate phenotypes.
                            </p>
                        </div>
                    </div>


                    <div class=""  style="{{tabDisplay}}">
                        <div class="">
                            <ul class="nav nav-tabs" id="stratsCovTabs">
                                {{ #modeledPhenotype }}
                                    {{ #levels }}
                                        {{ #strataContent }}
                                           <li class="{{defaultDisplay}}" style="{{firstPhenotypeModelLevel}}"><a data-target="#cov_{{name}}" data-toggle="tab" class="covariateCohort {{name}}">{{trans}}</a></li>
                                        {{ /strataContent }}
                                    {{ /levels }}
                                {{ /modeledPhenotype }}
                            </ul>
                        </div>
                    </div>

                    <div class="tab-content" style="border:solid 1px #ddd; margin-top: -7px;">
                        {{ #modeledPhenotype }}
                            {{ #levels }}
                                {{ #strataContent }}
                                    <div class="tab-pane {{defaultDisplay}}" id="cov_{{name}}{{undisplayedPhenotypeModelLevel}}" style="{{firstPhenotypeModelLevel}}">

                                        <div class="row">
                                            <div class="col-sm-8 col-xs-12 vcenter covariate_holder">
                                                <div class="covariates">
                                                    <div class="row"  style="{{firstPhenotypeModelLevel}}">
                                                        <div class="col-md-10 col-sm-10 col-xs-12 vcenter" style="margin-top:0">

                                                            <div class="covariateHolder covariateHolder_{{name}}"  style="{{firstPhenotypeModelLevel}}">
                                                                {{ >allCovariateSpecifierTemplate }}
                                                            </div>

                                                        </div>

                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-sm-6 col-xs-12">
                                            </div>
                                         </div>
                                    </div>
                                {{ /strataContent }}
                            {{ /levels }}
                        {{ /modeledPhenotype }}
                    </div>

                </div>
            </div>

        </div>%{--end id=initiateAnalysis panel--}%
</script>


<script id="allCovariateSpecifierTemplate"  type="x-tmpl-mustache">
                                {{ #covariateDetails }}
                                <div class="row">
                                   <div class="col-sm-6">
                                   {{>covariateTemplateC1}}
                                   </div>
                                   <div class="col-sm-6">
                                   {{>covariateTemplateC2}}
                                   </div>
                                </div>
                                {{ /covariateDetails }}

        </script>


<script id="covariateTemplateC1"  type="x-tmpl-mustache">
                                    {{ #covariateSpecifiersC1 }}
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{stratum}}_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}" {{defaultCovariate}} onchange="mpgSoftware.burdenTestShared.carryCovChanges('{{name}}', '{{stratum}}')"/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                    {{ /covariateSpecifiersC1 }}
                </script>

<script id="covariateTemplateC2"  type="x-tmpl-mustache">
                                    {{ #covariateSpecifiersC2 }}
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{stratum}}_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}" {{defaultCovariate}} onchange="mpgSoftware.burdenTestShared.carryCovChanges('{{name}}', '{{stratum}}')"/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                    {{ /covariateSpecifiersC2 }}
                </script>




<script id="variantFilterSelectionTemplate"  type="x-tmpl-mustache">
        <div class="panel panel-default">%{--should hold the initiate analysis set panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#variantFilterSelection"
                       href="#variantFilterSelection">Step {{sectionNumber}}: Manage variant selection</a>
                </h4>
            </div>


            <div id="variantFilterSelection" class="panel-collapse collapse">
                <div class="panel-body secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Choose a collection of variants which will be analyzed together to assess disease burden.
                                You may choose a set of variants with a specific consequence or minor allele frequency, and
                                potentially remove variants from this set by using the check boxes at the left of the table.
                            </p>
                        </div>
                    </div>

                    <div class="row">
                    <div class="container">

                        <div class="row burden-test-wrapper-options">

                            <div class="col-md-11 col-sm-11 col-xs-12">
                                <div  class="row">

                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <label><g:message code="gene.burdenTesting.label.available_variant_filter"/>:
                                            {{#variantsSetRefinement}}
                                            <select id= "burdenProteinEffectFilter" class="burdenProteinEffectFilter form-control"
                                            onchange="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters({generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}'},
                                                                                         mpgSoftware.burdenTestShared.buildVariantTable,
                                            '${createLink(controller: 'variantInfo', action: 'variantInfo')}')">
                                            </select>
                                            {{/variantsSetRefinement}}
                                            {{^variantsSetRefinement}}
                                            <select id= "variantSetFilter" class="variantSetFilter form-control">
                                                <option>Mahajan T2D variant set (243)</option>
                                            </select>
                                            {{/variantsSetRefinement}}
                                        </label>
                                    </div>
                                </div>
                                <div  class="row">
                                      <div style="margin:15px 8px 15px 10px" class="separator"></div>
                                </div>
                                {{#variantsSetRefinement}}
                                    <div  class="row">
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <label for="mafInput"><g:message code="gene.burdenTesting.label.maf"/>:</label>
                                            <div class="labelAndInput">
                                                MAF &lt;&nbsp;
                                                <input style="display: inline-block" type="text" class="form-control" id="mafInput" placeholder="value"
                                                onkeyup="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters({generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}'},
                                                                                             mpgSoftware.burdenTestShared.buildVariantTable,
                                                '${createLink(controller: 'variantInfo', action: 'variantInfo')}')">
                                            </div>

                                        </div>
                                        <div class="col-md-6 col-sm-6 col-xs-12">
                                            <label><g:message code="gene.burdenTesting.label.apply_maf"/>:&nbsp;&nbsp;</label>
                                            <div class="form-inline mafOptionChooser">
                                                <div class="radio">
                                                    <label><input type="radio" name="mafOption" value="1" onclick="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters({generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}'},
                                                                                                 mpgSoftware.burdenTestShared.buildVariantTable,
                                                '${createLink(controller: 'variantInfo', action: 'variantInfo')}')"/>&nbsp;<g:message code="gene.burdenTesting.label.all_samples"/></label>
                                                </div>
                                                <div class="radio">
                                                    <label><input type="radio" name="mafOption"  value="2" checked onclick="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters({generateListOfVariantsFromFiltersAjaxUrl:'${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}'},
                                                    mpgSoftware.burdenTestShared.buildVariantTable,
                                                '${createLink(controller: 'variantInfo', action: 'variantInfo')}')"/>&nbsp;<g:message code="gene.burdenTesting.label.each_ancestry"/></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div  class="row">
                                          <div style="margin:15px 8px 15px 10px" class="separator"></div>
                                    </div>

                                <div  class="row" style="margin: 10px 0 0px 0">
                                    <div class="col-md-offset-2 col-md-8 col-sm-12 col-xs-12">
                                        <div  class="row">


                                            <div class="col-md-6 col-sm-6 col-xs-12">
                                                <div  class="row">
                                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                                        <label>Add a new variant to list</label>
                                                    </div>
                                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                                        <div class="form-inline mafOptionChooser">
                                                            <div class="radio">
                                                                <label  style="font-size: 11px">
                                                                    <input type="radio" name="additionalVariantOption" value="1" onclick="mpgSoftware.burdenTestShared.swapSingleMultipleVariantAdditionMode(1)" checked/>
                                                                    &nbsp;Single variant
                                                                </label>
                                                            </div>
                                                            <div class="radio">
                                                                <label style="font-size: 11px">
                                                                    <input type="radio" name="additionalVariantOption"  value="2" onclick="mpgSoftware.burdenTestShared.swapSingleMultipleVariantAdditionMode(2)"/>
                                                                    &nbsp;Multiple
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>                                            </div>
                                            <div class="col-md-5 col-sm-5 col-xs-12">
                                                <input style="display: inline-block" type="text" class="form-control input-sm" id="proposedVariant"/>
                                                <textarea style="display: none" type="text" class="form-control" cols=20 rows=4 id="proposedMultiVariant"/>
                                            </div>
                                            <div class="col-md-1 col-sm-1 col-xs-4">
                                                <button id="addVariant" class="btn btn-secondary"
                                                onclick="mpgSoftware.burdenTestShared.respondedToAddVariantButtonClick(
                                                '${createLink(controller: "variantInfo", action: "variantAndDsAjax")}',
                                                '${createLink(controller: 'variantInfo', action: 'variantInfo')}')">
                                                    Add
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2"></div>
                                </div>
                                {{/variantsSetRefinement}}
                            </div>
                            <div  class="col-md-1 col-sm-1 col-xs-12 burden-test-btn-wrapper vcenter">
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                <div id="gaitTableDataHolder" style="margin-top: 20px"></div>
                            </p>
                            <table id="gaitTable" class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%;" role="grid"
                            aria-describedby="variantTable_info">

                            </table>


                        </div>
                    </div>

                </div>
            </div>

        </div>%{--end id=initiateAnalysis panel--}%
</script>
<script id="mainGaitHolder"  type="x-tmpl-mustache">
    <div class="accordion-group">
    <div class="{{accordionHeaderClass}}">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
            {{#modifiedTitle}}
                <h2><strong style="{{modifiedTitleStyling}}">{{modifiedTitle}}</strong></h2>
            {{/modifiedTitle}}
            {{^modifiedTitle}}
                <h2><strong>Genetic Association Interactive Tool</strong></h2>
            {{/modifiedTitle}}
        </a>
    </div>

    <div id="collapseBurden"
    {{#variantsSetRefinement}}
    class="accordion-body collapse"
    {{/variantsSetRefinement}}
    {{^variantsSetRefinement}}
    class="accordion-body collapse in"
    {{/variantsSetRefinement}}
    >

        <div class="accordion-inner">

            {{#variantsSetRefinement}}
                <div style="float: right; margin-top: 15px;" class="btn dk-t2d-green dk-reference-button dk-right-column-buttons-compact ">
                    <a href="https://s3.amazonaws.com/broad-portal-resources/tutorials/KP_GAIT_guide.pdf" target="_blank">GAIT guide</a>
                </div>
            {{/variantsSetRefinement}}

            <div class="container">
                <h5>
                    {{#modifiedGaitSummary}}
                        {{modifiedGaitSummary}}
                    {{/modifiedGaitSummary}}
                    {{^modifiedGaitSummary}}
                        The Genetic Association Interactive Tool allows you to compute custom association statistics by specifying the phenotype to test for association, a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.
     In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.
                    {{/modifiedGaitSummary}}
                </h5>


                <div class="row burden-test-wrapper-options">

                    <r:img class="caatSpinner" uri="/images/loadingCaat.gif" alt="Loading GAIT data"/>



                    <div class="user-interaction">

                        <div id="chooseDataSetAndPhenotypeLocation"></div>

                        <div class="stratified-user-interaction"></div>

                        <div class="panel-group" id="accordion_iat" style="margin-bottom: 0px">%{--start accordion --}%
                            <div id="chooseVariantFilterSelection" id="chooseVariantFilterSelectionTool" style="margin-bottom:10px;"></div>
                            <div id="chooseFiltersLocation" style="margin-bottom:10px;"></div>
                            <div id="chooseCovariatesLocation" style="margin-bottom:10px;"></div>
                        </div>

                    </div>
                    <div id="displayResultsLocation"></div>

                </div>

            </div>  %{--close container--}%

        </div>  %{--close accordion inner--}%
        <g:render template="/widgets/dataWarning" />
    </div>  %{--accordion body--}%
</div> %{--end accordion group--}%

</script>
