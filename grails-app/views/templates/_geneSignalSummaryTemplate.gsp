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




<script id="locusZoomTemplate"  type="x-tmpl-mustache">
        <div style="margin-top: 20px">

            <ul class="nav navbar-nav navbar-left" style="display: flex;">
                <li class="dropdown" id="tracks-menu-dropdown-dynamic">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Phenotypes (dynamic)<b class="caret"></b></a>
                    <ul id="trackList-dynamic" class="dropdown-menu">
                        <g:each in="${lzOptions?.findAll{it.dataType=='dynamic'}}">
    <li>
        <a onclick="mpgSoftware.locusZoom.addLZPhenotype({
                    phenotype: '${it.key}',
                                            dataSet: '${it.dataSet}',
                                            datasetReadableName: '${g.message(code: "metadata." + it.name)}',
                                            propertyName: '${it.propertyName}',
                                            description: '${it.description}'
                                        },
                                        '${it.dataSet}','${createLink(controller:"gene", action:"getLocusZoom")}',
                                        '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                        '${it.dataType}',('#'+'{{lzDomSpec}}'),{colorBy:1,positionBy:1})">
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
                                            datasetReadableName: '${g.message(code: "metadata." + it.dataSet)}',
                                            propertyName: '${it.propertyName}',
                                            description: '${it.description}'
                                        },
                                        '${it.dataSet}','${createLink(controller:"gene", action:"getLocusZoom")}',
                                        '${createLink(controller:"variantInfo", action:"variantInfo")}',
                                        '${it.dataType}',('#'+'{{lzDomSpec}}'),{colorBy:1,positionBy:1})">
    ${g.message(code: "metadata." + it.name)+"("+g.message(code: "metadata." + it.dataSet)+")"}
    </a>
</li>
</g:each>
                    </ul>
                </li>
                <li class="dropdown" id="tracks-menu-dropdown-functional">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Tissues<b class="caret"></b></a>
                       <ul id="trackList-tissue" class="dropdown-menu">
                           <g:each in="${lzOptions?.findAll{it.dataType=='tissue'}}">
                           <li>
                              <a onclick="mpgSoftware.locusZoom.addLZTissueAnnotations({
                        tissueCode: '${it.name}',
                        tissueDescriptiveName: '${it.description}',
                        retrieveFunctionalDataAjaxUrl:'${createLink(controller:"variantInfo", action:"retrieveFunctionalDataAjax")}'
                    },('#'+'{{lzDomSpec}}'),{colorBy:1,positionBy:1});">${it.description}</a>
                           </li>
                           </g:each>
                       </ul>
                </li>
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
                                <div class="row clearfix">
                                    <div class="row clearfix">
                                        <div class="col-md-3 col-lg-offset-2">
                                            <h4>Genome coordinates:</h4>
                                        </div>
                                        <div class="col-md-7 regionParams">
                                            <ul class="pull-left list-unstyled">
                                                <li>Chromosome ${geneChromosome}</li>
                                                <li>${geneExtentBegin} - ${geneExtentEnd}</li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="row clearfix">
                                        <div class="col-md-3 col-lg-offset-2">
                                            <h4>Genes in window:</h4>
                                        </div>
                                        <div class="col-md-7 regionParams">
                                            <div class="matchedGenesGoHere"></div>
                                        </div>
                                    </div>
                                    <div class="row clearfix">
                                        <div class="col-md-3 col-lg-offset-2">
                                            <h4>Credible set:</h4>
                                        </div>
                                        <div class="col-md-7 regionParams">
                                            [credible set name]
                                        </div>
                                    </div>
                                </div>
                                <div class="credibleSetTableGoesHere"></div>
                                <div id="allVariantsLocation"></div>
                                <div id="locusZoomLocationCredSet" class="locusZoomLocation"></div>
                        </div>
                    </div>
                </div>
                {{/credibleSetTab}}
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
<div class='dataTable'>
<h5>Variants in the credible set</h5>
<table class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%;">
    <thead>
        <tr>
            <th></th>
            <th></th>
            {{#variants}}
                <th class="niceHeaders">
                    {{name}}
                </th>
            {{/variants}}
        </tr>
    </thead>
    <tbody>
    {{#const}}

        <tr>
            <td></td>
            <td>Coding</td>
        {{#coding}}
            <td class="{{descr}}">{{val}}</td>
        {{/coding}}
        </tr>

        <tr>
            <td></td>
            <td class="{{descr}}">Splice site</td>
            {{#spliceSite}}
            <td class="{{descr}}">{{val}}</td>
            {{/spliceSite}}
        </tr>

        <tr>
            <td></td>
            <td>UTR</td>
            {{#utr}}
            <td class="{{descr}}">{{val}}</td>
            {{/utr}}
        </tr>

        <tr>
            <td></td>
            <td class="{{descr}}">Promoter</td>
            {{#promoter}}
            <td class="{{descr}}">{{val}}</td>
            {{/promoter}}
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
</div>
</script>

