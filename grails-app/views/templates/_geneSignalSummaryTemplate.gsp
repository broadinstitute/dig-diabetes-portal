<script id="genomeBrowserTemplate"  type="x-tmpl-mustache">
<div class="row">
    <div class="col-xs-offset-7 col-xs-5">
        <div class="row" style="margin: 10px 10px 0px 0; background-color: #eeeeee">
            <div class="col-xs-5">
                <label class="radio-inline" style="font-weight: bold">Genome browser</label>
            </div>
            <div class="col-xs-4">
                <label class="radio-inline"><input type="radio"  checked name="genomeBrowser" value=1
                                                   onclick="mpgSoftware.geneSignalSummaryMethods.refreshSignalSummaryBasedOnPhenotype()"
                                                   checked>LocusZoom</label>
            </div>
            <div class="col-xs-3">
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
    <div >%{--should hold the Choose data set panel--}%
        <div class="panel-heading">
            <div class="row">
                <div class="col-md-2 col-xs-12">
                    <div id='trafficLightHolder'>
                        <r:img uri="/images/undeterminedlight.png"/>
                        <div id="signalLevelHolder" style="display:none"></div>
                    </div>

                </div>

                <div class="col-md-5 col-xs-12">
                    <div class="row">
                        <div class="col-lg-12 trafficExplanations trafficExplanation1">
                            No evidence for signal
                        </div>

                        <div class="col-lg-12 trafficExplanations trafficExplanation2">
                            Suggestive evidence for signal
                        </div>

                        <div class="col-lg-12 trafficExplanations trafficExplanation3">
                            Strong evidence for signal
                        </div>
                    </div>
                </div>

                <div class="col-md-5 col-xs-12">

                </div>

            </div>
            <div class="row interestingPhenotypesHolder">
                <div class="col-xs-12">
                    <div id="interestingPhenotypes">

                    </div>
                </div>
                <g:if test="${g.portalTypeString()?.equals('t2d')}">
                    <div class="col-xs-offset-2 col-xs-8" style="font-size:10px">
                        Note: traits from the Oxford Biobank exome chip dataset are currently missing from this analysis.  We hope to rectify this problem soon.
                    </div></g:if>
                <div class="col-xs-2">

                </div>
            </div>
            <div class="row geneWindowDescriptionHolder">
                <div class="col-sm-3">
                    <div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="geneWindowDescription">
                    {{geneName}} is located on chromosome {{geneChromosomeMinusChr}} between position {{geneExtentBegin}} and {{geneExtentEnd}}
                    </div>
                </div>
                <div class="col-sm-3">
                    <div>
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
                <li style="margin: auto;">
                    <b>Region: <span id="lzRegion"></span></b>
                </li>
            </ul>

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
                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">All variants&nbsp;<g:helpText title="geneSignalSummary.allVariants.help.header" placement="right" body="geneSignalSummary.allVariants.help.text"/></span>
                                                <div id="allVariants"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">All coding&nbsp;<g:helpText title="geneSignalSummary.allCoding.help.header" placement="right" body="geneSignalSummary.allCoding.help.text"/></span>
                                                <div id="allCoding"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NS 1%&nbsp;<g:helpText title="geneSignalSummary.PTV-NS-1.help.header" placement="right" body="geneSignalSummary.PTV-NS-1.help.text"/></span>
                                                <div id="allMissense"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NSbroad 1%&nbsp;<g:helpText title="geneSignalSummary.PTV-NSbroad-1.help.header" placement="right" body="geneSignalSummary.PTV-NSbroad-1.help.text"/></span>
                                                <div id="possiblyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV+NSstrict&nbsp;<g:helpText title="geneSignalSummary.PTV-NSstrict.help.header" placement="right" body="geneSignalSummary.PTV-NSstrict.help.text"/></span>
                                                <div id="probablyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV&nbsp;<g:helpText title="geneSignalSummary.PTV.help.header" placement="right" body="geneSignalSummary.PTV.help.text"/></span>
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

                        <table id="highImpactTemplateHolder" class="compact row-border"></table>

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

                        <table id="commonVariantsLocationHolder" class="compact row-border"></table>

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
                        <li role="presentation" class="variantTableLabels credibleSetChooser"><a href="#credibleSetTabHolder" aria-controls="credibleSetTabHolder" role="tab" data-toggle="tab">Credible sets: {{pName}}</a></li>
                        {{/credibleSetTab}}
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
                                <div id="locusZoomLocation" class="locusZoomLocation"></div>
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
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">Credible sets are calculated sets of variants that are highly likely to include the causal variant for association with the selected phenotype.
                                <div class="row clearfix credibleSetHeader" style="margin: 5px 0 0 0">
                                    <div class="col-md-3 credSetWindowSummary">
                                        Start position
                                        <input type="text" name="startPosition" class="credSetStartPos">
                                    </div>
                                    <div class="col-md-3 credSetWindowSummary">
                                        End position
                                        <input type="text" name="endPosition"  class="credSetEndPos">
                                    </div>
                                    <div class="col-md-2">
                                          <button class="btn btn-secondary btn-sm" onclick="mpgSoftware.geneSignalSummaryMethods.buildNewCredibleSetPresentation()" style="margin-top: 15px">
                                          Reset range
                                          </button>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="row clearfix">
                                            <div class="col-md-3 credSetWindowSummary">
                                                Genes in window
                                            </div>
                                            <div class="col-md-9 regionParams">
                                                <div class="matchedGenesGoHere"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="credibleSetChooserGoesHere"></div>
                                <div class="credibleSetTableGoesHere"></div>
                                <div id="allVariantsLocation" class="in"></div>
                                <div id="locusZoomLocationCredSet" class="locusZoomLocation"></div>
                        </div>
                    </div>
                </div>
                {{/credibleSetTab}}
            </div>
</script>

<script id="organizeCredibleSetChooserTemplate"  type="x-tmpl-mustache">
    <div class="credibleSetNameHolder">
    <label>Credible sets in this range</label>
        <ul class="nav nav-pills">
            {{#allCredibleSets}}
                    <li id="{{credibleSetId}}"  class="nav-item credibleSetChooserButton credibleSetChooserStrength inactive" onclick="mpgSoftware.regionInfo.specificCredibleSetSpecificDisplay(this,{{renderVariantsAsArray}})">{{credibleSetId}}</li>
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
                                <div id="locusZoomLocation" class="locusZoomLocation"></div>
                                <div class="igvGoesHere"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</script>

<script id="credibleSetTableTemplate"  type="x-tmpl-mustache">
<p>&nbsp;</p>
<g:if test="${g.portalTypeString()?.equals('ibd')}">
<p><g:message code="geneSignalSummary.credSetsIBD.help"></g:message></p></g:if>
    <g:elseif test="${g.portalTypeString()?.equals('t2d')}">
        <p><g:message code="geneSignalSummary.credSetsT2D.help"></g:message></p></g:elseif>
<div class='dataTable'>
<table id="overlapTable" class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%; margin-top: 100px; margin-bottom: 30px">
    <thead>
        <tr>
            <th  class="credSetOrgLabel"></th>
            <th class="credSetConstLabel"></th>
            {{#variants}}
                <th class="niceHeaders niceHeadersThatAreLinks" style="background:rgba(0,0,0,0); text-decoration: underline;color: blue" onclick="mpgSoftware.locusZoom.replaceTissuesWithOverlappingIbdRegionsVarId('{{name}}','#lz-lzCredSet','{{assayIdList}}')"
                defRefA="{{details.Reference_Allele}}" defEffA="{{details.Effect_Allele}}" chrom="{{details.CHROM}}" position="{{details.POS}}"
                postprob="{{details.extractedPOSTERIOR_PROBABILITY}}"  data-toggle="popover">

                    {{name}}
                </th>
            {{/variants}}
        </tr>
    </thead>
    <tbody>
    {{#const}}

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">Coding</td>
        {{#coding}}
            <td class="{{descr}}">{{val}}</td>
        {{/coding}}
        </tr>

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">Splice site</td>
            {{#spliceSite}}
            <td class="{{descr}}">{{val}}</td>
            {{/spliceSite}}
        </tr>

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">UTR</td>
            {{#utr}}
            <td class="{{descr}}">{{val}}</td>
            {{/utr}}
        </tr>

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">Promoter</td>
            {{#promoter}}
            <td class="{{descr}}">{{val}}</td>
            {{/promoter}}
        </tr>

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">Posterior probability</td>
            {{#posteriorProbability}}
            <td class="{{descr}}">{{val}}</td>
            {{/posteriorProbability}}
        </tr>

        <tr>
            <td class="credSetOrgLabel"></td>
            <td class="credSetConstLabel">P value</td>
            {{#pValue}}
            <td class="{{descr}}">{{val}}</td>
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
<g:if test="${g.portalTypeString()?.equals('t2d')}">
<img src="${resource(dir:'images', file:'3-color_epigenomic_key.png')}" style="width: 400px;" align="center"></g:if>
</div>

</script>

