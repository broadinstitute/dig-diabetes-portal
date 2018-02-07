


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






            <div class="row interestingPhenotypesHolder">
                <div class="col-md-12">
                    <div id="interestingPhenotypes">

                    </div>
                </div>
                {{#genePageWarning}}
                <div class="col-md-12" style="font-size:13px">
                    {{.}}
                </div>
                {{/genePageWarning}}

                %{--<g:if test="${g.portalTypeString()?.equals('t2d')}">--}%
                    %{--<div class="col-md-12" style="font-size:13px">--}%
                        %{--Note: traits from the Oxford Biobank exome chip dataset are not currently included in this analysis.--}%
                    %{--</div>--}%
                %{--</g:if>--}%
            </div>
            <div class="row geneWindowDescriptionHolder">

                <div class="col-md-12">
                <!-- <label style="font-size: 20px; font-weight: 900">VARIANTS ON <em>{{geneName}}</em></label> -->
                    <div class="geneWindowDescription" style="font-size: 20px; font-weight: 900; font-style:normal;">
                    <em style="font-weight: 900; ">{{geneName}}</em> is located on chromosome {{geneChromosomeMinusChr}} between position {{geneExtentBegin}} and {{geneExtentEnd}}
                    </div>
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
        <div style="margin-top: 20px">

        <!-- DK test begin -->

            <ul class="nav navbar-nav navbar-left" style="display: flex;">

                <li class="dropdown" id="tracks-menu-dropdown-dynamic">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes <b class="caret"></b></a>
                    <ul id="dk_lz_phenotype_list" class="dropdown-menu">

                    {{#dynamic}}
                        <li>
                            {{description}}
                        </li>
                    {{/dynamic}}
                    {{#static}}
                        <li>
                            {{description}}
                        </li>
                        {{/static}}

                    </ul>
                </li>

                {{#staticDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-static">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Datasets<b class="caret"></b></a>
                    <ul id="trackList-static" class="dropdown-menu">
                    {{/staticDataExists}}
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
                    {{#staticDataExists}}
                    </ul>
                </li>
                {{/staticDataExists}}
                {{#tissueDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-functional">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                       <ul id="trackList-tissue" class="dropdown-menu">
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
                </li>
                {{/tissueDataExists}}
                {{#atacDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-functional">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                       <ul id="trackList-tissue" class="dropdown-menu">
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
                </li>
                {{/atacDataExists}}
            </ul>

            <!-- DK test end -->
<!-- original
            <ul class="nav navbar-nav navbar-left" style="display: flex;">
                {{#dynamicDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-dynamic">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes (dynamically calculated associations)<b class="caret"></b></a>
                    <ul id="trackList-dynamic" class="dropdown-menu">
                    {{/dynamicDataExists}}
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
                                        {{description}} ({{dataSetReadable}})
                            </a>
                        </li>
                    {{/dynamic}}
                    {{#dynamicDataExists}}
                    </ul>
                </li>
                {{/dynamicDataExists}}
                {{#staticDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-static">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes<b class="caret"></b></a>
                    <ul id="trackList-static" class="dropdown-menu">
                    {{/staticDataExists}}
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
                                        {{description}} ({{dataSetReadable}})
                            </a>
                        </li>
                        {{/static}}
                    {{#staticDataExists}}
                    </ul>
                </li>
                {{/staticDataExists}}
                {{#tissueDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-functional">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                       <ul id="trackList-tissue" class="dropdown-menu">
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
                </li>
                {{/tissueDataExists}}
                {{#atacDataExists}}
                <li class="dropdown" id="tracks-menu-dropdown-functional">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                       <ul id="trackList-tissue" class="dropdown-menu">
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
                </li>
                {{/atacDataExists}}
            </ul>
-->
            <div class="accordion-inner">
                <div id="{{lzDomSpec}}" class="lz-container-responsive"></div>
            </div>

        </div>
 </script>


<script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row" style="margin: 15px 0 0 15px;">
                                <h4>Aggregate variants</h4>
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



<script id="organizeSignalSummaryCommonFirstTemplate"  type="x-tmpl-mustache">
            <div class="text-right" id="phenotypeLabel">{{pName}}</div>
            <div class="row">
                <div class="col-xs-12">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active variantTableLabels commonVariantChooser"><a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab">Common variants: {{pName}}</a></li>
                        <li role="presentation" class="variantTableLabels highImpacVariantChooser"><a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab">High-impact variants: {{pName}}</a></li>
                        {{#credibleSetTab}}
                        <li role="presentation" class="variantTableLabels credibleSetChooser">
                           <a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab">{{pName}}</a></li>
                           %{--<a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab">Credible sets: {{pName}}</a></li>--}%
                        {{/credibleSetTab}}
                        {{#incredibleSetTab}}
                        <li role="presentation" class="variantTableLabels credibleSetChooser">
                           <a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab">{{pName}}</a></li>
                           %{--<a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab">Strongest associations: {{pName}}</a></li>--}%
                        {{/incredibleSetTab}}
                    </ul>
                </div>
            </div>
            <div id="cDataModalGoesHere"></div>

            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active commonVariantChooser" id="commonVariantTabHolder">
                    <div class="row"   style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">The Common variants tab shows information about variants associated with the selected phenotype whose minor allele frequency (MAF) is greater than 5%.

                                <div id="commonVariantsLocation"></div>
                                <div class="browserChooserGoesHere"></div>
                                <div id="locusZoomLocation" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                                <div class="igvGoesHere"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane highImpacVariantChooser" id="highImpactVariantTabHolder">
                    <div class="row" style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">The High-impact variants tab shows information about variants associated with the selected phenotype that are predicted to cause missense or protein-truncating mutations in the encoded protein. High-impact variants with MAF > 5% will also be shown on the Common variants tab.
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
                {{#credibleSetTab}}
                <div role="tabpanel" class="tab-pane credibleSetChooser" id="credibleSetTabHolder">
                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="variantCategoryHolder">Credible sets are collections of variants in which posterior probabilities are calculated to indicate the likelihood that each variant is causal for association with the selected phenotype.
                                <p>&nbsp;</p>
                                <div class="clearfix credibleSetHeader" style="margin: 5px 0 0 0">
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
                                                <div class="matchedGenesGoHere"></div>
                                            </div>

                                    </div>
                                </div>
                                <p>&nbsp;</p>
                                <div><p><g:message code="geneSignalSummary.credSetsT2D.help"></g:message></p></div>
                                <p>&nbsp;</p>
                                <div class="credibleSetChooserGoesHere"></div>
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
                                         <div class="col-sm-2">
                                             <button class="btn btn-secondary btn-default" onclick="mpgSoftware.regionInfo.redisplayTheCredibleSetHeatMap()">Go</button>
                                         </div>
                                         {{/displayInfoExists}}
                                         %{--<div class="col-sm-2"></div>--}%
                                    </div>
                                </div>
                                <p>&nbsp;</p>
                                %{--<p><g:message code="geneSignalSummary.variantLink.help"></g:message></p>--}%
                                <div class="credibleSetTableGoesHere"></div>
                                <div id="allVariantsLocation" class="in"></div>
                                <div id="locusZoomLocationCredSet" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                        </div>
                    </div>
                </div>
                {{/credibleSetTab}}
                {{#incredibleSetTab}}
                <div role="tabpanel" class="tab-pane credibleSetChooser" id="credibleSetTabHolder">
                    <div class="row" style="border: none">
                        <div class="col-sm-12">
                            <div class="variantCategoryHolder"><g:message code="geneSignalSummary.incredibleSets.tabDescription"></g:message>
                                <p>&nbsp;</p>
                                <div class="clearfix credibleSetHeader" style="margin: 5px 0 0 0">
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
                                <div class="col-md-12 clearfix" style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #ddd;">
                                    <div class="col-md-2 credSetWindowSummary" style="line-height: 16px;">
                                         Genes in window
                                    </div>
                                    <div class="col-md-10 regionParams">
                                         <div class="matchedGenesGoHere"></div>
                                    </div>
                                </div>

                                </div>
                                <p>&nbsp;</p>
                                <div><p><g:message code="geneSignalSummary.incredibleSetsT2D.help"></g:message></p></div>
                                <p>&nbsp;</p>
                                <div class="credibleSetChooserGoesHere"></div>
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
                                         %{--<div class="col-sm-2"></div>--}%
                                    </div>
                                </div>
                                <p>&nbsp;</p>
                                %{--<p><g:message code="geneSignalSummary.variantLink.help"></g:message></p>--}%

                                <div class="credibleSetTableGoesHere"></div>
                                <div id="allVariantsLocation" class="in"></div>
                                <div id="locusZoomLocationCredSet" class="locusZoomLocation" style="border: solid 1px #ccc; padding: 15px;"></div>
                        </div>
                    </div>
                </div>
                {{/incredibleSetTab}}

            </div>
</script>

<script id="organizeCredibleSetChooserTemplate"  type="x-tmpl-mustache">
    <div class="credibleSetNameHolder">
    <label>Credible sets in this range</label>
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
                        <li role="presentation" class="variantTableLabels commonVariantChooser"><a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab">Common variants: {{pName}}</a></li>
                        <li role="presentation" class="active variantTableLabels highImpacVariantChooser"><a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab">High-impact variants: {{pName}}</a></li>
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
        </tr>
    </thead>
    <tbody>
    {{#const}}

        <tr>
            <td class="credcellpval credSetOrgLabel" rowspan=5>annotation</td>
            <td class="credSetConstLabel">Coding</td>
        {{#coding}}
            <td class="credcell {{descr}}">{{val}}</td>
        {{/coding}}
        </tr>

        <tr>
            %{--<td class="credSetOrgLabel"></td>--}%
            <td class="credSetConstLabel">Splice site</td>
            {{#spliceSite}}
            <td class="credcell {{descr}}">{{val}}</td>
            {{/spliceSite}}
        </tr>

        <tr>
            %{--<td class="credSetOrgLabel"></td>--}%
            <td class="credSetConstLabel">UTR</td>
            {{#utr}}
            <td class="credcell {{descr}}">{{val}}</td>
            {{/utr}}
        </tr>

        <tr>
            %{--<td class="credSetOrgLabel"></td>--}%
            <td class="credSetConstLabel">Promoter</td>
            {{#promoter}}
            <td class="credcell {{descr}}">{{val}}</td>
            {{/promoter}}
        </tr>

        <tr>
            %{--<td class="credSetOrgLabel"></td>--}%
            <td class="credcellpval credSetConstLabel">TF binding motif</td>
            {{#tfBindingMotif}}
            <td class="credcellmotif {{descr}}">{{val}}</td>
            {{/tfBindingMotif}}
        </tr>

        {{#posteriorProbabilityExists}}
        <tr>
            <td class="credcellpval credSetOrgLabel" rowspan=2>association</td>
            <td class="credSetConstLabel">Posterior probability</td>
            {{/posteriorProbabilityExists}}
            {{#posteriorProbability}}
            <td class="{{descr}}">{{val}}</td>
            {{/posteriorProbability}}
       {{#posteriorProbabilityExists}}
        </tr>
        {{/posteriorProbabilityExists}}

        <tr>
            {{^posteriorProbabilityExists}}
            <td class="credcellpval credSetOrgLabel">association</td>
            {{/posteriorProbabilityExists}}
            <td class="credcellpval credSetConstLabel">P value</td>
            {{#pValue}}
            <td class="credcellpval {{descr}}">{{val}}</td>
            {{/pValue}}
        </tr>




    {{/const}}

    {{#cellTypeSpecs}}

        <tr>
            <td></td>
            <td>{{name}} DHS</td>
            {{#DHS}}
            <td>{{val}}</td>
            {{/DHS}}
        </tr>
        <tr>
            <td></td>
            <td>{{name}} H3K27AC</td>
            {{#K27}}
            <td>{{val}}</td>
            {{/K27}}
        </tr>

    {{/cellTypeSpecs}}
    </tbody>
</table>
<div class="heatmaplegend">
    <ul class="nav nav-pills">
    {{#chosenStatesForTissueDisplay}}
        <li style="margin: 0 5px 0 5px;border-left:solid  12px {{colorCode}};" val="{{name}}">
            {{#dnase}}
            <r:img class="currentlanguage" uri="/images/dnase_scale.jpg" alt="Spanish"/>
            {{/dnase}}
            {{#h3k27ac}}
            <r:img class="currentlanguage" uri="/images/h3k27ac_scale.jpg" alt="English"/>
            {{/h3k27ac}}
            &nbsp;{{descr}}
        </li>
    {{/chosenStatesForTissueDisplay}}
    </ul>
</div>

</div>

</script>

