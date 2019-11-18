

<script id="genomeBrowserTemplate"  type="x-tmpl-mustache">
<div class="row">
    <div class="col-md-offset-6 col-md-6">
        <div class="row" style="margin: 30px 0 -5px 0; padding: 5px; background-color: #eeeeee">
            <div class="col-md-6">
                <label class="radio-inline" style="font-weight: bold">Select genome browser</label>
            </div>
            <div class="col-md-3">
                <label class="radio-inline"><input type="radio"  checked name="genomeBrowser" value=1
                                                   onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()"
                                                   checked>LocusZoom</label>
            </div>
            <div class="col-md-3">
                <label class="radio-inline"><input {{igvChecked}} type="radio"  name="genomeBrowser" value=2
                                                   onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()">IGV</label>
            </div>
        </div>
    </div>
</div>
</script>

<script id="genePageHeaderTemplate"  type="x-tmpl-mustache">
    <div id="dataHolderForCredibleSets" style="display: none"></div>
    <div class="row">
        <div class="pull-right" style="display:none">
            <label for="signalPhenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                                default="Change phenotype choice"/></label>
            &nbsp;
            <select id="signalPhenotypeTableChooser" name="phenotypeTableChooser"
                    onchange="mpgSoftware.geneSignalSummaryMethods.refreshTopVariantsByPhenotype(this,mpgSoftware.geneSignalSummaryMethods.updateSignificantVariantDisplay,
                        {preferIgv:($('input[name=genomeBrowser]:checked').val()==='2')})">
            </select>
        </div>
    </div>






            <div class="row">
                <div class="col-md-12">
                    <div class="gene-page-section-header">
                        <h2>Phenotypes with signals <small>(Click button to reset phenotype)</small></h2>
                        {{#genePageWarning}}
                        <div style="font-size: 16px;">
                            {{.}}
                        </div>
                        {{/genePageWarning}}
                    </div>

                    <div id="interestingPhenotypes" class="well well-gene-page">

                    </div>
                </div>
            </div>
            <div class="row geneWindowDescriptionHolder">

                <div class="col-md-12">
                    %{--<div class="geneWindowDescription" style="font-size: 20px; font-weight: 900; font-style:normal;">--}%
                    %{--<em style="font-weight: 900; ">Displaying the region on chromosome {{geneChromosomeMinusChr}} between position {{geneExtentBegin}} and {{geneExtentEnd}}--}%
                    %{--</div>--}%
                </div>

            </div>

        </div>

    </div>

    <div class="collapse in" id="collapseExample">
        <div class="wellPlace">
            <div id="noAggregatedVariantsLocation">
                <div class="row" style="margin-top: 15px;">
                    <div class="col-lg-offset-1">
                        <h4>No information about aggregated variants exists for this phenotype</h4>
                    </div>
                </div>
            </div>


        </div>
    </div>
</script>



<script id="locusZoomTemplate"  type="x-tmpl-mustache">
<div class="row" style="border-bottom:solid 1px #ddd; padding-left: 15px;">
<strong style="font-size: 16px;">To add a new track, select a dataset</strong>

        <div class="col-md-12">

            <div class="lz-list col-md-2" style="padding: 10px 10px; display: none;">
                <!--<span style="padding: 1px;background-color: #1184e8;font-size: 16px; color: #fff;width: 20px;display: inline-block;border-radius: 14px;text-align: center;margin-right: 5px;">1</span>-->
                <a href="javascript:;" onclick="mpgSoftware.traitsFilter.massageLZ(); mpgSoftware.traitsFilter.showLZlist(event);"> Phenotype <b class="caret"></b></a>

                <ul id="dk_lz_phenotype_list">

                   {{#dynamic}}
                      <li>{{description}}</li>
                   {{/dynamic}}
                   {{#static}}
                      <li>{{description}}</li>
                   {{/static}}

                </ul>
            </div>
            <div class="dropdown col-md-4 lz-list" style="border-right: solid 1px #ddd; padding: 10px 10px">
                <!--<span style="padding: 1px;background-color: #1184e8;font-size: 12px;color: #fff;width: 20px;display: inline-block;border-radius: 14px;text-align: center;margin-right: 5px;">2</span>-->
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"> <span class="selected-phenotype"></span> Dataset <b class="caret"></b></a>
                <ul id="trackList-static" class="dropdown-menu" style="height:auto; max-height:500px; overflow:auto; ">

                   {{#static}}
                      <li>
                            <a onclick="mpgSoftware.locusZoom.addLZPhenotype({
                                                    phenotype: '{{key}}',
                                                    dataSet: '{{dataSet}}',
                                                    datasetReadableName: '{{dataSetReadable}}',
                                                    propertyName: '{{propertyName}}',
                                                    description: '{{description}}',
                                                    assayIdList: '{{assayIdList}}'
                                            },
                                            '{{dataSet}}',
                                            '${createLink(controller:"gene", action:"getLocusZoom")}',
                                            '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                            '{{dataType}}',
                                            ('#'+'{{lzDomSpec}}'),
                                            {colorBy:1,positionBy:1})">
                                            <span class="dk-lz-dataset" style="display:none">{{description}}</span>{{dataSetReadable}} (static)
                            </a>
                      </li>
                   {{/static}}
                   {{#dynamic}}
                      <li>
                            <a onclick="mpgSoftware.locusZoom.addLZPhenotype({
                                                        phenotype: '{{key}}',
                                                        dataSet: '{{dataSet}}',
                                                        datasetReadableName: '{{dataSetReadable}}',
                                                        propertyName: '{{propertyName}}',
                                                        description: '{{description}}',
                                                        assayIdList: '{{assayIdList}}'
                                                },
                                                '{{dataSet}}',
                                                '${createLink(controller:"gene", action:"getLocusZoom")}',
                                                '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                                '{{dataType}}',
                                                ('#'+'{{lzDomSpec}}'),
                                                {colorBy:1,positionBy:1})">
                                                <span class="dk-lz-dataset" style="display:none">{{description}}</span>{{dataSetReadable}} (dynamic)
                            </a>
                   </li>
                {{/dynamic}}

                </ul>
            </div>
            {{#tissueDataExists}}
            <div class="dropdown col-md-3 lz-list" id="tracks-menu-dropdown-functional" style="padding: 10px 10px">
                           <a href="#" class="dropdown-toggle" data-toggle="dropdown"> Tissues <b class="caret"></b></a>
                           <ul id="trackList-tissue" class="dropdown-menu" style="height:auto; max-height:500px; overflow:auto;">
                               {{/tissueDataExists}}
                               {{#tissues}}
                                    <li>
                                        <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                                        tissueCode: '{{name}}',
                                                        tissueDescriptiveName: '{{description}}',
                                                        retrieveFunctionalDataAjaxUrl:'${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',
                                                        assayIdList: '{{assayIdList}}'
                                                    },
                                                ('#'+'{{lzDomSpec}}'),
                                                {colorBy:1,positionBy:1})">{{description}}
                                        </a>
                                    </li>
                               {{/tissues}}
                               {{#tissueDataExists}}
                           </ul>
            </div>
            {{/tissueDataExists}}
            {{#atacDataExists}}
            <div class="dropdown col-md-3 lz-list" id="tracks-menu-dropdown-functional" style="padding: 10px 10px">
                           <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                           <ul id="trackList-tissue" class="dropdown-menu" style="height:auto; max-height:500px; overflow:auto;">
                               {{/atacDataExists}}
                               {{#atacData}}
                                    <li>
                                        <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                                        tissueCode: '{{name}}',
                                                        tissueDescriptiveName: '{{description}}',
                                                        retrieveFunctionalDataAjaxUrl:'${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}',
                                                        assayIdList: '{{assayIdList}}'
                                                    },
                                                ('#'+'{{lzDomSpec}}'),
                                                {colorBy:1,positionBy:1})">{{description}}
                                        </a>
                                    </li>
                               {{/atacData}}
                               {{#atacDataExists}}
                           </ul>
            </div>
            {{/atacDataExists}}
        </div>
</div>


        <div style="margin-top: 20px">

                <div id="{{lzDomSpec}}" class="lz-container-responsive"></div>

        </div>
 </script>


<script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row" style="margin: 15px 0 0 15px;">
                                <h4>Aggregate variants&nbsp;<g:helpText title="AggregateVariants.help.header" placement="right" body="AggregateVariants.help.text"/></h4>
                            </div>

                            <div class="row">
                                <div class="col-lg-1">
                                            <ul class='aggregatingVariantsLabels'>
                                              <li style="text-align: right">pValue&nbsp;<g:helpText title="variantTable.columnHeaders.sigma.pValue.help.header" placement="right" body="variantTable.columnHeaders.sigma.pValue.help.text"/></li>
                                              <li style="text-align: right">beta&nbsp;<g:helpText title="variantTable.columnHeaders.shared.effect.help.header" placement="right" body="variantTable.columnHeaders.shared.effect.help.text"/></li>
                                              <li style="text-align: right">95% CI&nbsp;<g:helpText title="geneSignalSummary.CI.help.header" placement="right" body="geneSignalSummary.CI.help.text"/></li>
                                            </ul>
                                </div>
                                <div class="col-lg-11">
                                    <div class="boxOfVariants">
                                        <div class="row">
                                            %{--<div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">All variants&nbsp;<g:helpText title="geneSignalSummary.allVariants.help.header" placement="right" body="geneSignalSummary.allVariants.help.text"/></span>--}%
                                                %{--<div id="allVariants"></div>--}%
                                            %{--</div>--}%

                                            %{--<div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">All coding&nbsp;<g:helpText title="geneSignalSummary.allCoding.help.header" placement="right" body="geneSignalSummary.allCoding.help.text"/></span>--}%
                                                %{--<div id="allCoding"></div>--}%
                                            %{--</div>--}%

                                            <div class="col-lg-3 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NS 1%&nbsp;<g:helpText title="geneSignalSummary.PTV-NS-1.help.header" placement="right" body="geneSignalSummary.PTV-NS-1.help.text"/></span>
                                                <div id="allMissense"></div>
                                            </div>

                                            <div class="col-lg-3 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NSbroad 1%&nbsp;<g:helpText title="geneSignalSummary.PTV-NSbroad-1.help.header" placement="right" body="geneSignalSummary.PTV-NSbroad-1.help.text"/></span>
                                                <div id="possiblyDamaging"></div>
                                            </div>

                                            <div class="col-lg-3 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NSstrict&nbsp;<g:helpText title="geneSignalSummary.PTV-NSstrict.help.header" placement="right" body="geneSignalSummary.PTV-NSstrict.help.text"/></span>
                                                <div id="probablyDamaging"></div>
                                            </div>

                                            <div class="col-lg-3 text-center"><span class="aggregatingVariantsColumnHeader">PTV&nbsp;<g:helpText title="geneSignalSummary.PTV.help.header" placement="right" body="geneSignalSummary.PTV.help.text"/></span>
                                                <div id="proteinTruncating"></div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </script>


<script id="highImpactTemplate"  type="x-tmpl-mustache">
            <div class="row">
                <div class="col-xs-12">

                    <div class="row">
                            <div class="col-xs-9"></div>
                            <div class="col-xs-3">
                                <button class="btn btn-primary btn-xs pull-right" style="margin-bottom: 5px;" data-toggle="modal" data-target="#xpropertiesModal"
                                onclick="mpgSoftware.geneSignalSummaryMethods.adjustProperties(this)"  tableSpec="highImpact">Add / Subtract Data</button>
                            </div>
                    </div>

                    <div class="row" >
                        <div class="col-sm-7"></div>
                        <div class="col-sm-5">
                            <div class="dropdown">
                                  <div class="dropdown-menu dsFilterHighImpact" style="padding: 0 5px 0 5px;">
                                  </div>
                            </div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-lg-12">

                        <table id="highImpactTemplateHolder" class="compact row-border dk-t2d-general-table"></table>

                        </div>
                    </div>

                </div>
            </div>
       </script>


<script id="allVariantsTemplate"  type="x-tmpl-mustache">
            <div class="row">
                <div class="col-xs-12">

                    <div class="row">
                            <div class="col-xs-9"></div>
                            <div class="col-xs-3">
                                <button class="btn btn-primary btn-xs pull-right" style="margin-bottom: 5px;" data-toggle="modal" data-target="#xpropertiesModal"
                                onclick="mpgSoftware.geneSignalSummaryMethods.adjustProperties(this)"  tableSpec="allVariants">Add / Subtract Data</button>
                            </div>
                    </div>

                    <div class="row" >
                        <div class="col-sm-7"></div>
                        <div class="col-sm-5">
                            <div class="dropdown">
                                  <div class="dropdown-menu dsFilterAllVariants" style="padding: 0 5px 0 5px;">
                                  </div>
                            </div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-lg-12">

                        <table id="allVariantsTemplateHolder" class="compact row-border"></table>

                        </div>
                    </div>

                </div>
            </div>
       </script>






<script id="commonVariantTemplate"  type="x-tmpl-mustache">



            <div class="row">
                <div class="col-lg-12">

                    <div class="row">
                            <div class="col-xs-9"></div>
                            <div class="col-xs-3">
                                <button class="btn btn-primary btn-xs pull-right" style="margin-bottom: 5px;" data-toggle="modal" data-target="#xpropertiesModal"
                                onclick="mpgSoftware.geneSignalSummaryMethods.adjustProperties(this)" tableSpec="common">Add / Subtract Data</button>
                            </div>
                    </div>

                    <div class="row" >
                        <div class="col-sm-7"></div>
                        <div class="col-sm-5">
                            <div class="dropdown">
                                  <div class="dropdown-menu dsFilterCommon" style="padding: 0 5px 0 5px;">
                                  </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-xs-12">
                            <div id="variantSearchResultsInterface"></div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">

                        <table id="commonVariantsLocationHolder" class="compact row-border dk-t2d-general-table"></table>

                        </div>
                    </div>

                </div>

            </div>
        </script>


<script id="organizeSignalSummaryOutline"  type="x-tmpl-mustache">
    <div id="organizeSignalSummaryHeaderGoesHere"></div>
    <div id="cDataModalGoesHere"></div>
    <div>
        <div class="gene-page-section-header">
            <h2><span style="">Top variants</span></h2>
        </div>
        <div class="commonVariantChooser well well-gene-page" id="commonVariantTabHolder"></div>

        <!-- <div role="tabpanel" class="tab-pane highImpacVariantChooser" id="highImpactVariantTabHolder"></div> -->

        <div class="gene-page-section-header">
            <h2><span style="">Credible sets</span></h2>
        </div>

        <div id="mainVariantDivHolder" class="well well-gene-page">

        </div>

        <div class="credibleSetChooser well well-gene-page" id="credibleSetTabHolder" style="display: none;"></div>


        <div class="genePrioritizationChooser" id="genePrioritizationTabHolder">
            {{#genePrioritizationTab}}
                   <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="row" style="border: none">
                                <div class="col-sm-6">

                                </div>
                                <div class="col-sm-3"></div>
                                <div class="col-sm-3">
                                    <button class="btn" onclick="mpgSoftware.geneSignalSummaryMethods.selfContainedGeneRanking()">Refresh</button>
                                </div>
                             </div>
                             <div class="row" style="border: none">
                                <div id="rankedGeneTableGoesHere">
                                </div>
                             </div>
                        </div>
                    </div>
            {{/genePrioritizationTab}}
        </div>

        <div role="tabpanel" class="tab-pane chromatinConfirmationChooser" id="chromatinConformationTabHolder">
            {{#chromatinConformationTab}}
            <div class="row" style="border: none">

                <div class="row" style="border: none">
                    <div class="dropdown col-md-2 lz-list" style="padding: 10px 10px">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Select from tissues: <b
                                class="caret"></b></a>
                        <ul class="dropdown-menu" style="height:auto; max-height:500px; overflow:auto;">
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                            tissueCode: 'Adipose',
                                            tissueDescriptiveName: 'adipose tissue',
                                            retrieveFunctionalDataAjaxUrl: '/dig-diabetes-portal/variantInfo/retrieveFunctionalDataAjax',
                                            assayIdList: '[3]'
                                        },
                                        ('#' + 'lz-lzCommon'),
                                        {colorBy: 1, positionBy: 1})">adipose tissue
                                </a>
                            </li>
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                            tissueCode: 'AnteriorCaudate',
                                            tissueDescriptiveName: 'brain anterior caudate',
                                            retrieveFunctionalDataAjaxUrl: '/dig-diabetes-portal/variantInfo/retrieveFunctionalDataAjax',
                                            assayIdList: '[3]'
                                        },
                                        ('#' + 'lz-lzCommon'),
                                        {colorBy: 1, positionBy: 1})">brain anterior caudate
                                </a>
                            </li>
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                            tissueCode: 'CD34-PB',
                                            tissueDescriptiveName: 'CD34-PB primary hematopoietic stem cells',
                                            retrieveFunctionalDataAjaxUrl: '/dig-diabetes-portal/variantInfo/retrieveFunctionalDataAjax',
                                            assayIdList: '[3]'
                                        },
                                        ('#' + 'lz-lzCommon'),
                                        {colorBy: 1, positionBy: 1})">CD34-PB primary hematopoietic stem cells
                                </a>
                            </li>
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                            tissueCode: 'CingulateGyrus',
                                            tissueDescriptiveName: 'brain cingulate gyrus',
                                            retrieveFunctionalDataAjaxUrl: '/dig-diabetes-portal/variantInfo/retrieveFunctionalDataAjax',
                                            assayIdList: '[3]'
                                        },
                                        ('#' + 'lz-lzCommon'),
                                        {colorBy: 1, positionBy: 1})">brain cingulate gyrus
                                </a>
                            </li>
                            <li>
                                <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                                            tissueCode: 'ColonicMucosa',
                                            tissueDescriptiveName: 'colonic mucosa',
                                            retrieveFunctionalDataAjaxUrl: '/dig-diabetes-portal/variantInfo/retrieveFunctionalDataAjax',
                                            assayIdList: '[3]'
                                        },
                                        ('#' + 'lz-lzCommon'),
                                        {colorBy: 1, positionBy: 1})">colonic mucosa
                                </a>
                            </li>

                        </ul>
                    </div>

                    <div class="dropdown col-md-3 lz-list text-left" style="padding: 10px 10px">
                        <span style='color: black'>
                            currently displaying:&nbsp;
                        </span>
                        <span style='color: blue'>
                            pancreatic islet
                        </span>
                    </div>
                </div>


                <div class="row" style="border: none">
                    <div class="col-sm-12">
                        <div id="fooyoo" style="width:800px; height: 800px"></div>
                    </div>
                </div>
            </div>
            {{/chromatinConformationTab}}
        </div>

        <div class="gene-page-section-header">
            <h2><span style="">Genes in region</span></h2>
        </div>
        <div class="exposeDynamicUiChooser well well-gene-page" id="exposeDynamicUiTabHolder">
            {{#dynamicUiTab}}
                <div class="row" style="border: none; {{suppressionOfRange}}">
                    <div id="configurableUiTabStorage" style="display: none"></div>
                    <div class="col-sm-12">
                    Current context:
                    </div>
                    <div class="col-sm-6">
                        <div class="contextHolder">
                            <div id="contextDescription">

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <button class="btn btn-secondary" type="button" data-toggle="collapse" data-target="#collapseContextRefiner" aria-expanded="false" aria-controls="collapseContextRefiner">
                            Refine context
                         </button>
                         <div class="collapse" id="collapseContextRefiner">
                            <div  style="margin-top: 10px">
                                <div class="card card-body">
                                    <div id="contextControllersInDynamicUi">

                                    </div>
                                </div>
                            </div>
                         </div>
                    </div>
                    <div class="col-sm-2 text-right">
                        <button class="btn btn-secondary" type="button" onclick="$('#retrieveMultipleRecordsTest').click()" aria-controls="collapseContextRefiner">
                            Refresh table
                         </button>
                    </div>
                </div>

                <div class="row" style="border: none; {{suppressionOfAllDynamicUiTabs}}">
                    <div class="col-sm-12">
                        <ul class="nav nav-tabs">
                            <li class="nav-item active" style="{{suppressionOfGeneTable}}">
                                <a class="nav-link sub-tab" href="#dynamicGeneHolder" role="tab" data-toggle="tab">Gene</a>
                            </li>
                            <li class="nav-item" style="{{suppressionOfVariantTable}}">
                                <a class="nav-link sub-tab" href="#dynamicVariantHolder" role="tab" data-toggle="tab">Variant</a>
                            </li>
                            <li class="nav-item"  style="display: none">
                                <a class="nav-link sub-tab" href="#dynamicTissueHolder" role="tab" data-toggle="tab">Tissue</a>
                            </li>
                            <li class="nav-item"  style="display: none">
                                <a class="nav-link sub-tab" href="#dynamicPhenotypeHolder" role="tab" data-toggle="tab">Phenotype</a>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="">
                    <div role="tabpanel" class="" id="dynamicGeneHolder">
<!--<div class="popup">Click me!
  <span class="popuptext" id="myPopup"></span>
</div>-->
                        <div class="">
                            <div class="col-sm-12">
                                %{--<h3>Gene directors</h3>--}%
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="directorButtonHolder">

                                        </div>
                                    </div>
                                </div>

                                <div style="font-size: 16px;"><p><g:message code="GenePrioritization.interface.help1"></g:message>
<g:helpText title="gene.overall.help.header" placement="bottom" body="gene.overall.help.text"/>
<g:message code="GenePrioritization.interface.help2"></g:message></p>


                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                    <div class="datatable-control-box">
                                        <div class="datatable-transpose-control">
                                            <div class="tool-label">Transpose table&nbsp;&nbsp;<g:helpText title="table.transpose.help.header" placement="bottom" body="table.transpose.help.text"/></div>
                                            <button class="btn btn-secondary btn-default transpose" type="button" title="click to transpose table"
                                            onclick = "mpgSoftware.dynamicUi.transposeThisTable('table.combinedGeneTableHolder')">
                                                Transpose
                                            </button>
                                        </div>
                                        <div class="datatable-cell-color-control">
                                            <div class="tool-label">View:</div>


                                            <button type="button" class="btn btn-secondary first-btn significance active" aria-label="click to organize by greatest significance"
                                            title="click to organize by greatest significance" onclick="mpgSoftware.dynamicUi.setColorButtonActive(event,['tissues'],'table.combinedGeneTableHolder');">Significance
                                            </button>

                                            <button type="button" class="btn btn-secondary last-btn tissues" aria-label="click to organized by number of associated tissues"
                                            title="click to organized by number of associated tissues" onclick="mpgSoftware.dynamicUi.setColorButtonActive(event,['significance'],'table.combinedGeneTableHolder');">Records

                                            </button>
                                        </div>


                                        <div class="datatable-zoom-control">
                                            <div class="tool-label">Zoom</div>
                                            <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom out"  title="click to zoom out"
                                                onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',false,event)">
                                                <span class="glyphicon glyphicon-minus" aria-hidden="true"
                                                onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',false,event)"></span>
                                            </button>
                                            <button type="button" class="btn btn-default btn-secondary" aria-label="Zoom in"  title="click to zoom in"
                                                onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',true,event)">
                                                <span class="glyphicon glyphicon-plus" aria-hidden="true"
                                                onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicGeneHolder',true,event)"></span>
                                            </button>

                                        </div>
                                        </div>
                                    </div>
                                </div>
                                <table class="combinedGeneTableHolder">
                                </table>

                            </div>
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane" id="dynamicVariantHolder">

                        <div class="row" style="display:none">
                            <div class="col-sm-12 sub-content">
                                %{--<h3>Variant directors</h3>--}%
                                <div class="directorButtonHolder">

                                </div>

                            </div>
                        </div>

                                <div class="row">
                                   %{--<div class="col-sm-12">--}%
                                        %{--<h3> Results </h3>--}%
                                    %{--</div>--}%
                                    <div class="col-sm-12">
                                        %{--<div class="refinementTable dynamicUiHolder">--}%

                                        %{--</div>--}%
                                        <!--<div class="row">
                                            <div class="col-sm-1">
                                                <button type="button" class="btn btn-link transpose" title="click to transpose table"
                                                style="font-size: 32pt"
                                                onclick = "mpgSoftware.dynamicUi.transposeThisTable('table.combinedVariantTableHolder')">
                                                    T
                                                </button>
                                            </div>
                                            <div class="col-sm-9">

                                            </div>
                                            <div class="col-sm-2">
                                                <div class="datatable-zoom-control btn-vert-block">
                                                    <button type="button" class="btn btn-default" aria-label="Zoom in"  title="click to zoom in"
                                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicVariantHolder',true)">
                                                        <span class="glyphicon glyphicon-plus" aria-hidden="true"
                                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicVariantHolder',true)"></span>
                                                    </button>
                                                    <button type="button" class="btn btn-default" aria-label="Zoom out"  title="click to zoom out"
                                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicVariantHolder',false)">
                                                        <span class="glyphicon glyphicon-minus" aria-hidden="true"
                                                        onclick="mpgSoftware.dynamicUi.dataTableZoomDynaSet('#dynamicVariantHolder',false)"></span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>-->
                                        <table class="combinedVariantTableHolder" style="border:0">
                                        </table>
                                    </div>
                               </div>


                                        </div>
                    <div role="tabpanel" class="tab-pane" id="dynamicTissueHolder" style="display: none">

                        <div class="row">
                            <div class="col-sm-12 sub-content">
                                <h3>Tissue director</h3>
                                <div class="directorButtonHolder">

                                </div>
                                <h3> Results </h3>
                                <div class="resultsTableHolder">
                                    <div class="dynamicUiHolder">
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane " id="dynamicPhenotypeHolder"  style="display: none">

                        <div class="row">
                            <div class="col-sm-12 sub-content">
                                <h3>Phenotype director</h3>
                                <div class="directorButtonHolder">

                                </div>
                                <h3> Results </h3>
                                <div class="resultsTableHolder">
                                    <div class="dynamicUiHolder">
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>
                 </div>

            {{/dynamicUiTab}}
        </div>
    </div>
</script>


<script id="contextControllerDescriptionSection"  type="x-tmpl-mustache">
       {{#directorButtons}}
            <div class="row" style="border: none">
                <button id="{{buttonId}}" class="btn btn-primary buttonsForManualContextRefinement" type="button" title="{{description}}">{{buttonName}}</button>
                <input id="{{inputBoxId}}" value="" type="text" class="form-control input-default inputForInitiatingRefinementStep">
            </div>
            <div class="row" style="border: none; margin-top: 10px">
            </div>
        {{/directorButtons}}
</script>





<script id="contextDescriptionSection"  type="x-tmpl-mustache">
 <div class="row" style="border: none">
    <div class="col-sm-3 text-center">
        chromosome
    </div>
    <div class="col-sm-9">
        <span class="dynamicUiChromosome">{{chromosome}}</span>
    </div>
</div>
<div class="row" style="border: none">
    <div class="col-sm-3 text-center" >
        starting extent
    </div>
    <div class="col-sm-9">
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustLowerExtent(-100000)"><<</button>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustLowerExtent(-10000)"><</button>
        <span class="dynamicUiGeneExtentBegin">{{extentBegin}}</span>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustLowerExtent(10000)">></button>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustLowerExtent(100000)">>></button>
    </div>
</div>
 <div class="row" style="border: none">
    <div class="col-sm-3 text-center">
        ending position
    </div>
    <div class="col-sm-9">
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustUpperExtent(-100000)"><<</button>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustUpperExtent(-10000)"><</button>
        <span class="dynamicUiGeneExtentEnd">{{extentEnd}}</span>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustUpperExtent(10000)">></button>
        <button type="button" class="btn btn-secondary btn-xs" onclick="mpgSoftware.dynamicUi.adjustUpperExtent(100000)">>></button>
    </div>
</div>
{{#additionalContext}}
    <div class="col-sm-4">
        {{name}}
    </div>
    <div class="col-sm-4">
        {{value}}
    </div>
    <div class="col-sm-4">
        {{qualifier}}
    </div>
{{/additionalContext}}
</script>



<script id="templateForDirectorButtonsOnATab"  type="x-tmpl-mustache">
 <div class="row" style="border: none; margin-top: 10px; display: none">
{{#directorButtons}}
     <div class="row">
        <div class="col-sm-2">
            <button id="{{buttonId}}" class="btn btn-success directorButtonDetails"
                                            type="button">{{buttonName}}</button>
                                            <a href="{{reference}}"  target="_blank">
                                            <span class="glyphicon glyphicon-link" aria-hidden="true"></span>
                                            </a>
        </div>
        <div class="col-sm-10">
            {{description}}
        </div>
     </div>
{{/directorButtons}}
</div>
</script>





<script id="organizeSignalSummaryHeader"  type="x-tmpl-mustache">
            <div class="text-right" id="phenotypeLabel">{{pName}}</div>
            {{#exposeGenesInRegionTab}}
                <div class="row">
                    <div class="col-xs-12">
                        <div class="row" style="margin-bottom: 20px">
                            <div class="col-xs-2"></div>
                            <div class="col-xs-8">
                                <ul class="nav nav-justified nav-pills" role="tablist">
                                    <li role="presentation" class="active variantTableLabels geneSpecificChooser">
                                         <a href="#geneSpecificHolder" aria-controls="geneSpecificHolder" role="tab" data-toggle="tab"
                                            onclick="mpgSoftware.traitsFilter.massageLZ();" class="top-level" style="margin: 20px">Gene specific data</a>
                                    </li>
                                    <li role="presentation" class=" variantTableLabels generalRangeChooser">
                                           <a href="#generalRangeHolder" aria-controls="generalRangeHolder" role="tab" data-toggle="tab"
                                            onclick="mpgSoftware.traitsFilter.massageLZ();" class="top-level" style="margin: 20px">Analyze genomic region</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="tab-content">

                            <div role="tabpanel" class="active tab-pane geneSpecificHolder" id="geneSpecificHolder">

                                <ul class="nav nav-tabs" role="tablist">
                                    {{#commonTab}}
                                        <li role="presentation" class="active variantTableLabels commonVariantChooser">
                                            <a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab"
                                            onclick="mpgSoftware.traitsFilter.massageLZ();">Top variants: {{pName}}</a>
                                        </li>
                                    {{/commonTab}}
                                    {{#highImpactTab}}
                                        <li role="presentation" class="variantTableLabels highImpacVariantChooser">
                                            <a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab"
                                            onclick="mpgSoftware.traitsFilter.massageLZ();">High-impact variants: {{pName}}</a>
                                        </li>
                                    {{/highImpactTab}}
                                </ul>

                            </div>

                            <div role="tabpanel" class="tab-pane generalRangeHolder" id="generalRangeHolder">

                                <ul class="nav nav-tabs" role="tablist">
                                    {{#credibleSetTab}}
                                        <li role="presentation" class="active variantTableLabels credibleSetChooser">
                                           <a style="float:left;" href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab"
                                           onclick="mpgSoftware.traitsFilter.massageLZ();">{{pName}}gggg</a>
                                           <!--<span class='new-dataset-flag' style="display: inline-flex; margin:-3px 0 0 -30px">&nbsp;</span>-->
                                        </li>
                                    {{/credibleSetTab}}
                                    {{#incredibleSetTab}}
                                        <li role="presentation" class="variantTableLabels credibleSetChooser">
                                           <a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab"
                                           onclick="mpgSoftware.traitsFilter.massageLZ();">{{pName}}</a>
                                        </li>
                                    {{/incredibleSetTab}}
                                    {{#genePrioritizationTab}}
                                        <li role="presentation" class="variantTableLabels genePrioritizationChooser">
                                           <a href="#genePrioritizationTabHolder" aria-controls="genePrioritizationTabHolder" role="tab"
                                           data-toggle="tab">Gene prioritization</a>
                                        </li>
                                    {{/genePrioritizationTab}}
                                    {{#chromatinConformationTab}}
                                        <li role="presentation" class="variantTableLabels chromatinConformationChooser">
                                           <a href="#chromatinConformationTabHolder" aria-controls="chromatinConformationTabHolder" role="tab"
                                           data-toggle="tab">Chromatin conformation</a>
                                        </li>
                                    {{/chromatinConformationTab}}
                                    {{#dynamicUiTab}}
                                        <li role="presentation" class="variantTableLabels chromatinConformationChooser">
                                           <a href="#exposeDynamicUiTabHolder" aria-controls="exposeDynamicUiTabHolder" role="tab"
                                           data-toggle="tab">Genes in region: {{pName}}</a>
                                        </li>
                                    {{/dynamicUiTab}}
                                </ul>

                            </div>
                        </div>

                    </div>
                </div>

            {{/exposeGenesInRegionTab}}
            {{^exposeGenesInRegionTab}}
                <div class="row">
                    <div class="col-xs-12">
                        <ul class="nav nav-tabs" role="tablist">
                            {{#commonTab}}
                                <li role="presentation" class="active variantTableLabels commonVariantChooser">
                                    <a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">Top variants: {{pName}}</a>
                                </li>
                            {{/commonTab}}
                            {{#highImpactTab}}
                                <li role="presentation" class="variantTableLabels highImpacVariantChooser">
                                    <a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">High-impact variants: {{pName}}</a>
                                </li>
                            {{/highImpactTab}}
                            {{#credibleSetTab}}
                                <li role="presentation" class="variantTableLabels credibleSetChooser">
                                   <a style="float:left;" href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">Credible sets: {{pName}}</a> <!--<span class='new-dataset-flag' style="display: inline-flex; margin:-3px 0 0 -30px">&nbsp;</span>-->
                                </li>
                            {{/credibleSetTab}}
                            {{#incredibleSetTab}}
                                <li role="presentation" class="variantTableLabels credibleSetChooser">
                                   <a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab" onclick="mpgSoftware.traitsFilter.massageLZ();">Credible sets: {{pName}}</a>
                                </li>
                            {{/incredibleSetTab}}
                            {{#genePrioritizationTab}}
                                <li role="presentation" class="variantTableLabels genePrioritizationChooser">
                                   <a href="#genePrioritizationTabHolder" aria-controls="genePrioritizationTabHolder" role="tab" data-toggle="tab">Gene prioritization</a>
                                </li>
                            {{/genePrioritizationTab}}
                            {{#chromatinConformationTab}}
                                <li role="presentation" class="variantTableLabels chromatinConformationChooser">
                                   <a href="#chromatinConformationTabHolder" aria-controls="chromatinConformationTabHolder" role="tab" data-toggle="tab">Chromatin conformation</a>
                                </li>
                            {{/chromatinConformationTab}}
                            {{#dynamicUiTab}}
                                <li role="presentation" class="variantTableLabels chromatinConformationChooser">
                                   <a href="#exposeDynamicUiTabHolder" aria-controls="exposeDynamicUiTabHolder" role="tab" data-toggle="tab">Genes in region: {{pName}}</a><span class="experimental-flag">&nbsp;</span>
                                </li>
                            {{/dynamicUiTab}}
                        </ul>
                    </div>
                </div>
            {{/exposeGenesInRegionTab}}
            %{--<div id="cDataModalGoesHere"></div>--}%





</script>
<script id="organizeSignalSummaryCommon"  type="x-tmpl-mustache">

                {{#commonTab}}
                        <div class="row"   style="border: none">
                            <div class="col-xs-12">
                                <div class="variantCategoryHolder">
                                    <!--<div  style="margin: 0 0 -15px 10px">This tab displays variants:
                                         <div>
                                            <ul style="margin: 0 0 0 10px">
                                                 <li>located on chromosome {{chromosome}} between {{geneExtentBegin}} and {{geneExtentEnd}}</li>
                                                 <li>associated with {{pname}}</li>

                                            </ul>
                                         </div>
                                    </div>-->

                                    <div id="commonVariantsLocation"></div>
                                    <div class="browserChooserGoesHere"></div>
                                    <div id="locusZoomLocation" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                                    <!--<div class="igvGoesHere"></div>-->
                                </div>
                            </div>
                        </div>

                {{/commonTab}}

</script>
<script id="organizeSignalSummaryHighImpact"  type="x-tmpl-mustache">
                {{#highImpactTab}}

                    <div class="row" style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">
                                <div  style="margin: 0 0 -15px 10px">This tab displays variants:
                                     <div>
                                        <ul style="margin: 0 0 0 10px">
                                             <li>located on chromosome {{chromosome}} between {{geneExtentBegin}} and {{geneExtentEnd}}</li>
                                             <li>associated with {{pname}}</li>
                                             <li>predicted to cause missense or protein-truncating mutations in the encoded protein</li>
                                        </ul>
                                     </div>
                                     Note: high-impact variants are also shown on the Top variants tab.
                                </div>

                                <div id="highImpactVariantsLocation"></div>
                                <div id="aggregateVariantsLocation"></div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div id="burdenGoesHere" class="row"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                {{/highImpactTab}}
</script>
<script id="organizeSignalSummaryCredibleSet"  type="x-tmpl-mustache">
    {{#credibleSetTab}}


                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="variantCategoryHolder">
                                <div style="display:none;" note="mute for V2F portal">
                                    <!-- hiding the following section only on V2F portal -->
                                    <p style="font-size:16px;">Credible sets are collections of variants in which posterior probabilities are calculated to indicate the likelihood that each variant is causal for association with the selected phenotype.</p>
                                    <!-- muting the following section only on V2F portal -->
                                        <!--<p>&nbsp;</p>-->
                                        <div class="clearfix credibleSetHeader" style="margin: 5px 0 0 0; display: none;">
                                            <div class="col-md-12">
                                                <div class="col-md-2 credSetWindowSummary">
                                                Set range:&nbsp;<g:helpText title="range.window.help.header" placement="top" body="range.window.credibleSets.help.text"/>
                                                </div>
                                                <div class="col-md-3 credSetWindowSummary">
                                                    Start position
                                                    <input type="text" name="startPosition" class="credSetStartPos form-control">
                                                </div>
                                                <div class="col-md-3 credSetWindowSummary">
                                                    End position
                                                    <input type="text" name="endPosition"  class="credSetEndPos form-control">
                                                </div>
                                                <div class="col-md-4">
                                                      <button class="btn btn-secondary btn-default" onclick="mpgSoftware.geneSignalSummaryMethods.buildNewCredibleSetPresentation()" style="margin-top: 22px">
                                                      Go
                                                      </button>
                                                </div>
                                            </div>
                                            <div class="col-md-12 clearfix" style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #ddd;">

                                                    <div class="col-md-2 credSetWindowSummary" style="line-height: 16px;">
                                                        Genes in window
                                                    </div>
                                                    <div class="col-md-10 regionParams">
                                                        <!--<div class="matchedGenesGoHere"></div>-->
                                                    </div>

                                            </div>
                                        </div>
                                        <!--<p>&nbsp;</p>-->
                                        <div><p style="font-size: 16px;"><g:message code="geneSignalSummary.credSetsT2D.help"></g:message></p></div>
                                        <p>&nbsp;</p>

                                        <div class="credibleSetTissueSelectorGoesHere" style="margin: 10px 0 0 0">

                                            <div class="row clearfix">
                                                {{#selectorInfoExists}}
                                                 <div class="col-sm-4">
                                                     <span style="display: inline-block; float: none; vertical-align: middle; width: 100%">
                                                        <label for="credSetSelectorChoice">Select tissues based on overlap with:&nbsp;</label><g:helpText title="tissue.selection.help.header" placement="top" body="tissue.selection.help.text"/>
                                                         <select id="credSetSelectorChoice" multiple="multiple">
                                                            {{#selectorInfo}}
                                                            <option {{selected}} value="{{value}}">{{name}}</option>
                                                            {{/selectorInfo}}
                                                        </select>
                                                     </span>

                                                 </div>
                                                 <div class="col-sm-2" style="margin-top: 10px">
                                                     <button class="btn btn-secondary btn-default" onclick="mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap()">Go</button>
                                                 </div>
                                                 {{/selectorInfoExists}}
                                                 {{^selectorInfoExists}}
                                                 <div class="col-sm-2"></div>
                                                 {{/selectorInfoExists}}

                                                 {{#displayInfoExists}}
                                                 <div class="col-sm-4">
                                                     <span style="display: inline-block; float: none; vertical-align: middle; width: 100%">
                                                        <label for="credSetDisplayChoice">Display genomic features:&nbsp;</label><g:helpText title="tissue.display.help.header" placement="top" body="tissue.display.help.text"/>
                                                         <select id="credSetDisplayChoice" multiple="multiple">
                                                            {{#displayInfo}}
                                                            <option {{selected}} value="{{value}}">{{name}}</option>
                                                            {{/displayInfo}}
                                                        </select>
                                                     </span>
                                                 </div>
                                                 <div class="col-sm-2" style="margin-top: 10px">
                                                     %{--<button class="btn btn-secondary btn-default" onclick="mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap()">Go</button>--}%
                                                 </div>
                                                 {{/displayInfoExists}}
                                                 {{^displayInfoExists}}

                                                 {{/displayInfoExists}}
                                                 <div class="col-sm-2"></div>
                                            </div>
                                        </div>
                                        <p>&nbsp;</p>
                                        {{#weNeedToPutTablesInTabs}}
                                        <ul class="nav nav-pills referenceSummaryTable" role="tablist">
                                                <li><a href="#tableGeneTableTab" role="tab" data-toggle="tab">gene table</a></li>
                                                <li class="active"><a href="#tableVariantTableTab" role="tab" data-toggle="tab">variant table</a></li>
                                        </ul>
                                        {{/weNeedToPutTablesInTabs}}
                                        {{#weNeedToPutTablesInTabs}}
                                        <div class="referenceSummaryTable tab-content">
                                        {{/weNeedToPutTablesInTabs}}
                                            {{#exposeGeneComparisonSubTab}}
                                                <div class="tab-pane referenceSummaryTableContent" id="tableGeneTableTab">
                                                    <div class="credGeneTableGoesHere"></div>
                                                </div>
                                            {{/exposeGeneComparisonSubTab}}
                                            {{#exposeVariantComparisonSubTab}}
                                                <div class="tab-pane active referenceSummaryTableContent" id="tableVariantTableTab">
                                                    <div class="credibleSetChooserGoesHere"></div>
                                                    <div class="credibleSetTableGoesHere"></div>
                                                </div>
                                            {{/exposeVariantComparisonSubTab}}
                                        {{#weNeedToPutTablesInTabs}}
                                        </div>
                                        {{/weNeedToPutTablesInTabs}}
                                        <div id="allVariantsLocation" class="in"></div>

                                    <div id="locusZoomLocationCredSet" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                                </div>
                        </div>
                    </div>
                </div>

                {{/credibleSetTab}}
</script>
<script id="organizeSignalSummaryIncredibleSet"  type="x-tmpl-mustache">
                {{#incredibleSetTab}}

                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="variantCategoryHolder">
                                <div style="display:none;" note="mute for V2F portal">
                                    <p style="font-size: 16px;"><g:message code="geneSignalSummary.incredibleSets.tabDescription"></g:message></p>
                                    <!--<p>&nbsp;</p>-->
                                    <div class="clearfix credibleSetHeader" style="margin: 5px 0 0 0; display: none;">
                                    <div class="col-md-12">
                                        <div class="col-md-2 credSetWindowSummary" align="right"> Set range:&nbsp;<g:helpText title="range.window.help.header" placement="top" body="range.window.credibleSets.help.text"/> </div> 
                                        <div class="col-md-3 credSetWindowSummary">
                                            Start position
                                            <input type="text" name="startPosition" class="credSetStartPos form-control">
                                        </div>
                                        <div class="col-md-3 credSetWindowSummary">
                                            End position
                                            <input type="text" name="endPosition"  class="credSetEndPos">
                                        </div>
                                        <div class="col-md-4">
                                              <button class="btn btn-secondary btn-default" onclick="mpgSoftware.geneSignalSummaryMethods.buildNewCredibleSetPresentation()" style="margin-top: 22px">
                                              Go
                                              </button>
                                        </div>
                                    </div>
                                    <div class="col-md-12 clearfix" style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #ddd; display: none;">
                                        <div class="col-md-2 credSetWindowSummary" style="line-height: 16px;">
                                             Genes in window
                                        </div>
                                        <div class="col-md-10 regionParams">
                                             <div class="matchedGenesGoHere"></div>
                                        </div>
                                    </div>

                                    </div>
                                    <!--<p>&nbsp;</p>-->
                                    <p style="font-size: 16px;"><g:message code="geneSignalSummary.incredibleSetsT2D.help"></g:message></p>
                                    <p>&nbsp;</p>

                                    <div class="credibleSetTissueSelectorGoesHere" style="margin: 10px 0 0 0">

                                        <div class="row clearfix">
                                            {{#selectorInfoExists}}
                                             <div class="col-sm-6">
                                                 <span style="display: inline-block; float: none; vertical-align: middle; width: 100%">
                                                    <label for="credSetSelectorChoice">Add/remove chromatin states:&nbsp;</label><g:helpText title="tissue.selection.help.header" placement="top" body="tissue.selection.help.text"/>
                                                     <select id="credSetSelectorChoice" multiple="multiple">
                                                        {{#selectorInfo}}
                                                        <option {{selected}} value="{{value}}">{{name}}</option>
                                                        {{/selectorInfo}}
                                                    </select>
                                                 </span>

                                             </div>
                                             {{/selectorInfoExists}}
                                             {{^selectorInfoExists}}
                                             <div class="col-sm-2"></div>
                                             {{/selectorInfoExists}}

                                             {{#displayInfoExists}}
                                             <div class="col-sm-4">
                                                 <span style="display: inline-block; float: none; vertical-align: middle; width: 100%">
                                                    <label for="credSetDisplayChoice">Display tissues:&nbsp;</label><g:helpText title="tissue.display.help.header" placement="top" body="tissue.display.help.header"/>
                                                     <select id="credSetDisplayChoice" multiple="multiple">
                                                        {{#displayInfo}}
                                                        <option {{selected}} value="{{value}}">{{name}}</option>
                                                        {{/displayInfo}}
                                                    </select>
                                                 </span>
                                             </div>
                                             <div class="col-sm-2">
                                                 <button class="btn btn-secondary btn-default" onclick="mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap()">Go</button>
                                             </div>
                                             {{/displayInfoExists}}
                                             {{^displayInfoExists}}
                                             <div class="col-sm-4">
                                                 <button class="btn btn-secondary btn-default" onclick="mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap()">Go</button>
                                             </div>
                                             {{/displayInfoExists}}
                                             <div class="col-sm-2"><span style="display: inline-block; float: none; vertical-align: middle; width: 100%;"><g:helpText title="geneTable.credset.interval.explanation.help.header" placement="bottom" body="geneTable.credset.interval.explanation.help.text"/><span class="credSetLevelHere"></span></span></div>
                                        </div>
                                    </div>
                                    <p>&nbsp;</p>
                                    {{#weNeedToPutTablesInTabs}}
                                    <ul class="nav nav-tabs referenceSummaryTable" role="tablist">
                                            <li><a href="#tableGeneTableTab" role="tab" data-toggle="tab">gene table</a></li>
                                            <li class="active"><a href="#tableVariantTableTab" role="tab" data-toggle="tab">variant table</a></li>
                                    </ul>
                                    {{/weNeedToPutTablesInTabs}}
                                    {{#weNeedToPutTablesInTabs}}
                                    <div class="referenceSummaryTable tab-content">
                                    {{/weNeedToPutTablesInTabs}}
                                        {{#exposeGeneComparisonSubTab}}
                                            <div class="tab-pane referenceSummaryTableContent" id="tableGeneTableTab">
                                                <div class="credGeneTableGoesHere"></div>
                                            </div>
                                        {{/exposeGeneComparisonSubTab}}
                                        {{#exposeVariantComparisonSubTab}}
                                            <div class="tab-pane active referenceSummaryTableContent" id="tableVariantTableTab">
                                                <div class="credibleSetChooserGoesHere"></div>
                                                <div class="credibleSetTableGoesHere"></div>
                                            </div>
                                        {{/exposeVariantComparisonSubTab}}
                                    {{#weNeedToPutTablesInTabs}}
                                    </div>
                                    {{/weNeedToPutTablesInTabs}}
                                    <div id="allVariantsLocation" class="in"></div>

                                <div id="locusZoomLocationCredSet" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                                </div>
                        </div>
                    </div>
                </div>

                {{/incredibleSetTab}}
</script>
<script id="organizeSignalSummaryGenePrioritization"  type="x-tmpl-mustache">
                {{#genePrioritizationTab}}

                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="row" style="border: none">
                                <div class="col-sm-6">
                                    <h3>gene prioritization table</h3>
                                </div>
                                <div class="col-sm-6"></div>
                             </div>
                             <div class="row" style="border: none">
                                <div id="rankedGeneTableGoesHere">
                                </div>
                             </div>
                        </div>
                    </div>

                {{/genePrioritizationTab}}
</script>

<script id="organizeDynamicUi"  type="x-tmpl-mustache">
                {{#dynamicUiTab}}

                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="row" style="border: none">
                                <div class="col-sm-6">
                                    <h3>proper dynamic UI tab</h3>
                                </div>
                                <div class="col-sm-6"></div>
                             </div>
                             <div class="row" style="border: none">
                                <h1>foo yodel</h1>
                             </div>
                        </div>
                    </div>

                {{/dynamicUiTab}}
</script>





%{--old way...--}%

<script id="organizeCredibleSetChooserTemplate"  type="x-tmpl-mustache">
    <div class="credibleSetNameHolder">
    <label>Credible sets in this range</label>
    &nbsp;&nbsp;<g:helpText title="credible_sets.help.header" placement="bottom" body="credible_sets.help.text"/>
        <ul class="nav nav-pills">
            {{#allCredibleSets}}
                    <li id="{{credibleSetId}}"  class="nav-item credibleSetChooserButton credibleSetChooserStrength inactive" toBeOnClick="mpgSoftware.regionInfo.specificCredibleSetSpecificDisplay(this,{{renderVariantsAsArray}})">{{credibleSetId}}</li>
            {{/allCredibleSets}}
            {{^allCredibleSets}}
                    <li class="nav-item redPhenotype phenotypeStrength">No credible sets</li>
            {{/allCredibleSets}}
            {{#atLeastOneCredibleSetExists}}
                    %{--<li id="allCredibleSetVariants"  class="nav-item credibleSetChooserButton credibleSetChooserStrength active" --}%
                    %{--onclick="mpgSoftware.regionInfo.specificCredibleSetSpecificDisplay(this,'ALL')">ALL</li>--}%
            {{/atLeastOneCredibleSetExists}}
        </ul>
    </div>
</script>


<script id="organizeSignalSummaryHighImpactFirstTemplate"  type="x-tmpl-mustache">
            <div class="text-center" id="phenotypeLabel">{{pName}}</div>
            <div class="row">
                <div class="col-xs-12">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="variantTableLabels commonVariantChooser">
                            <a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab">Top variants: {{pName}}</a>
                        </li>
                            <li role="presentation" class="active variantTableLabels highImpacVariantChooser"><a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab">High-impact variants: {{pName}}</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="cDataModalGoesHere"></div>

            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="highImpactVariantTabHolder">
                    <div class="row"  style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">
                                <div id="highImpactVariantsLocation"></div>
                                <div id="aggregateVariantsLocation"></div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div id="burdenGoesHere" class="row"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="commonVariantTabHolder">
                    <div class="row" style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">
                                <div id="commonVariantsLocation"></div>
                                <div class="browserChooserGoesHere"></div>
                                <div id="locusZoomLocation" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                                <div class="igvGoesHere"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</script>

<script id="credibleSetTableTemplate"  type="x-tmpl-mustache">
<p>&nbsp;</p>

{{#credibleSetInfoCode}}
<p>{{.}}</p>
{{/credibleSetInfoCode}}


<div class='dataTable'>
                <div id="ddd" style="width:100%; height: 60px">
                    <div style="float:left; width: 240px">
                        Click on a variant ID to see more information, and to access a link for tissue selection.
                         <div class='glyphicon glyphicon glyphicon-arrow-right'></div>
                    </div>
                </div>
<table id="overlapTable" class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%; margin-top: 10px; margin-bottom: 30px">
    <thead>
        <tr>
            <th  class="credSetOrgLabel" colspan=2>
            </th>
            {{#variants}}
                <th class="niceHeadersThatAreLinks headersWithVarIds" style="background:rgba(0,0,0,0)"
                defRefA="{{details.Reference_Allele}}" defEffA="{{details.Effect_Allele}}" chrom="{{details.CHROM}}" position="{{details.POS}}"
                postprob="{{details.extractedPOSTERIOR_PROBABILITY}}" varid="{{details.CHROM}}:{{details.POS}}_{{details.Reference_Allele}}/{{details.Effect_Allele}}" data-toggle="popover">{{details.CHROM}}:{{details.POS}}_{{details.Reference_Allele}}/{{details.Effect_Allele}}</th>
            {{/variants}}
            {{#columns}}
                <th class="niceHeadersThatAreGeneLinks headersWithVarIds" style="background:rgba(0,0,0,0)"
                chromosome="{{chromosome}}" addrStart="{{addrStart}}" addrEnd="{{addrEnd}}"
                data-toggle="popover">{{name}}</th>
            {{/columns}}

        </tr>
    </thead>
    <tbody>
    {{#const}}

        {{#annotation}}
            <tr>
                {{#annotationSection}}
                    <td class="{{primaryRowClass}} {{secondaryRowClass}}" rowspan={{rowsPerSection}}>{{sectionName}}</td>
                {{/annotationSection}}
                <td class="{{rowClass}}">{{rowName}}</td>
                {{#annotationRecord}}
                    <td class="credcell {{descr}}">{{val}}</td>
                {{/annotationRecord}}
            </tr>
        {{/annotation}}


    {{/const}}

    </tbody>
</table>
<div class="heatmaplegend">
    <ul class="nav nav-pills">
    {{#chosenStatesForTissueDisplay}}
        <li style="margin: 0 5px 0 5px;border-left:solid  12px {{colorCode}};" val="{{name}}">
            {{#dnase}}
            <r:img class="currentlanguage" uri="/images/dnase_scale.jpg" alt="DNase scale"/>
            {{/dnase}}
            {{#h3k27ac}}
            <r:img class="currentlanguage" uri="/images/h3k27ac_scale.jpg" alt="H3K27ac scale"/>
            {{/h3k27ac}}
            {{#tfbf}}
            <r:img class="currentlanguage" uri="/images/tfbf_scale.jpg" alt="transcription factor binding footprint scale"/>
            {{/tfbf}}
            &nbsp;{{descr}}
        </li>
    {{/chosenStatesForTissueDisplay}}
    </ul>
</div>

</div>

</script>

<script id="credibleSetHeatMapTemplate"  type="x-tmpl-mustache">
{{#tissueSpecificRow}}
    <tr style='{{rowDecoration}}' class='tissueHider_{{annotationId}}'>
    {{#createSpanningCell}}
        <td class='credSetOrgLabel' style='vertical-align: middle' rowspan={{rowSpan}}>tissue</td>
    {{/createSpanningCell}}
    <td  class='{{tissueDescriptionClass}} tissueHider_{{annotationId}}' title='{{tissueName}}'><span class='{{tissueDescriptionClass}}'>{{tissueName}}</span></td>
    {{#cellsPerLine}}
    <td class='tissueTable {{matchingRegion}} tissueHider_{{annotationId}}'
              data-toggle='tooltip' data-content="{{title}}" title='{{title}}'>
              <span data-toggle="popover" data-content="{{title}}">{{displayableContent}}</span></td>
    {{/cellsPerLine}}
    </tr>
{{/tissueSpecificRow}}
</script>

<script id="heatMapAggregatedAcrossTissueTemplate"  type="x-tmpl-mustache">
{{#assaySpecificRow}}
    <tr style='{{rowDecoration}}'>

        <td class='credSetOrgLabel' style='vertical-align: middle' rowspan={{rowSpan}}>
        <button type="button" class="btn btn-info btn-sm tissueDisplay_{{annotationId}} {{expandTissues}}" onclick="mpgSoftware.regionInfo.displayTissuesForAnnotation({{annotationId}})">display tissues</button>
        <button type="button" style="display:none" class="btn btn-info btn-sm tissueHide_{{annotationId}}" onclick="mpgSoftware.regionInfo.hideTissuesForAnnotation({{annotationId}})">hide tissues</button>
        </td>

    <td  class='{{tissueDescriptionClass}}  aggregateHider_{{annotationId}}'><span class='{{tissueDescriptionClass}}'>{{assayName}}</span></td>
    {{#cellsPerLine}}
    <td class='tissueTable {{matchingRegion}}'
              data-toggle='tooltip' title='{{title}}{{genes}}'><span data-toggle="popover" data-content="{{genes}}" class='geneCountDisplay'>{{geneCount}}</span>
              {{countDivider}}
              <span data-toggle="popover" data-content="{{tissues}}" class='tissueCountDisplay'>{{tissueCount}}</span></td>
    {{/cellsPerLine}}
    </tr>
{{/assaySpecificRow}}
</script>
<style>
table.genePrioritization {
    /*border: 1px solid black;*/
}
th.genePrioritization {
    font-family: 	Arial, Verdana, sans-serif;
    text-decoration: underline;
    font-size:	18px;
}
td.genePrioritization {
    font-family: 	Arial, Verdana, sans-serif;
    color:		#0000FF;
    font-size:	16px;
    outline: 0px solid #000;
}
span.genePrioritization {
    padding-right: 5px;
}
.tooltip-inner {
    max-width: 350px;
    width: 350px;
}
span.valuesPerPhenotype {
    padding-left: 5px;
}
tr.ledgeTable:not(:last-child){
    border-bottom: 1px solid #E3E3E3;
}
tr.ledgeTable:not(:last-child){
    border-bottom: 1px solid #E3E3E3;
}
div.explanatoryText {
   font-style: italic;
    color:		#bbbbbb;
}
span.explanatoryText {
    color:		black;
}
input.genePrioritizationPhenotype.coefficient{
    font-size:	10px;
}
#commonVariantsLocationHolder td {
    outline: 0px solid #000;
}
#highImpactTemplateHolder td {
    outline: 0px solid #000;
}
</style>


<script id="rankedGeneTable"  type="x-tmpl-mustache">
<div class="row">
    <div class="col-md-3 text-right">p-value cutoff for phenotype < &nbsp;
    </div>
    <div class="col-md-2">
    <input class="phenotypeParameter" type="text" value="{{maximumAssociation}}"></input>
    </div>
    <div class="col-md-7 text-left explanatoryText">higher values include more phenotypes</div>
</div>
<div class="row">
    <div class="col-md-3 text-right">LDSR weight >  &nbsp;
    </div>
    <div class="col-md-2">
    <input class="ldsrParameter" type="text" value="{{minimumWeight}}"></input>
    </div>
    <div class="col-md-7 text-left explanatoryText">lower values include more tissues</div>
</div>
<div class="row" style="margin-top: 20px">
    <div class="col-md-3 text-right">
        Genomic range:
    </div>



    <div class="col-md-2 text-left"> <input class="startPosition" type="text" value="{{startPosition}}"></input>
    </div>
    <div class="col-md-2 text-left">
    <input class="endPosition" type="text" value="{{endPosition}}"></input>
    </div>
    <div class="col-md-5 text-left explanatoryText">bigger ranges include more genes
    </div>


</div>



<div style="margin-top:20px;"></div>
<div clas="row" style="margin-top:30px">
<div class="col-md-12 text-left">
<h4>LEDGE ranked genes</h4>
</div>
</div>

<div clas="row">
    <div class="col-md-offset-2 col-md-8 text-left">
        <table style="width:100%" class="genePrioritization" style="border: solid 2px black">
        <tr>
            <th class="genePrioritization">gene name</th>
            <th class="genePrioritization">calculated weight</th>
            <th class="genePrioritization">phenotype contributions</th>

        </tr>
        {{#geneInformation}}
            <tr class="ledgeTable">

                <td class="genePrioritization">
                {{geneName}}
                </td>
                <td class="genePrioritization">
                {{combinedWeight}}
                </td>
                <td class="genePrioritization">
                {{#phenoRecs}}
                  <span class="btn btn-outline-secondary">{{phenotypeName}}<span class="valuesPerPhenotype">{{phenotypeValue}}</span></span>
                {{/phenoRecs}}
                </td>

            </tr>
        {{/geneInformation}}
        </table>
        <div class="col-md-2"></div>
    </div>
</div>

<div clas="row">
    <div class="col-md-6 text-left"  style="margin-top:50px">
    <h4>Phenotype weighting</h4>
    </div>
    <div class="col-md-6 text-left"  style="margin-top:50px">
        <span class="explanatoryText">
        Reset phenotype coefficients:
        <button type="button" class="btn btn-secondary btn-sm resetPhenotypeCoefficientsBySignificant"
        onclick="mpgSoftware.geneSignalSummaryMethods.resetPhenotypeCoefficientsBySignificance(this)">by phenotype significance</button>
        <button type="button" class="btn btn-secondary btn-sm"
        onclick="mpgSoftware.geneSignalSummaryMethods.resetPhenotypeCoefficientsByZero()">all 0</button>
        <button type="button" class="btn btn-secondary btn-sm"
        onclick="mpgSoftware.geneSignalSummaryMethods.resetPhenotypeCoefficientsByOne()">all 1</button>
        </span>
    </div>
</div>

<div class="row" style="margin-top:20px">
    <div class="col-md-offset-2 col-md-10 text-left">
    {{#genefullCalculatedGraph}}
         <div class="btn-group-vertical">
            <div class="btn-group">
                <button type="button" class="btn btn-secondary genePrioritizationPhenotype dropdown-toggle  btn-group-vertical" data-toggle="dropdown" data-placement="right">
                {{phenoName}}&nbsp;&nbsp;<input type="text" class="genePrioritizationPhenotype coefficient" phenotype="{{phenoName}}" value="{{phenoWeight}}" style="width: 30px">
                </button>
                <div class="dropdown-menu">
                    {{#tissues}}
                    <a type="button" class="btn btn-secondary genePrioritizationPhenotype" data-toggle="tooltip" data-placement="right" href="#"
                        title="{{#genes}}{{geneName}}&nbsp;{{/genes}}">
                        {{tissue}}&nbsp;({{weight}})
                        </a>

                    {{/tissues}}
                </div>
            </div>
        </div>
    {{/genefullCalculatedGraph}}
    </div>
</div>




<div clas="row">
    <div class="col-md-6 text-left"  style="margin-top:50px">
        <h4>Tissues to include</h4>
    </div>
    <div class="col-md-6 text-left"  style="margin-top:50px">
        <span class="explanatoryText">
        Reset tissue choices:
        <button type="button" class="btn btn-secondary btn-sm resetPhenotypeCoefficientsBySignificant"
        onclick="mpgSoftware.geneSignalSummaryMethods.setAllTissueChoicesChecked()">All</button>
                <button type="button" class="btn btn-secondary btn-sm resetPhenotypeCoefficientsBySignificant"
        onclick="mpgSoftware.geneSignalSummaryMethods.setAllTissueChoicesUnchecked()">None</button>
        </span>
    </div>
</div>


<div class="row" style="margin-top:20px">
    <div class="col-md-offset-2 col-md-10 text-left">
    {{#tissuesToConsider}}
        <label class="checkbox-inline">
            <input type="checkbox" tissueName="{{nameOfTissue}}" class="genePrioritizationTissue" {{isPresent}} value="{{nameOfTissue}}">{{nameOfTissue}}
        </label>
    {{/tissuesToConsider}}
    </div>
</div>




</script>
