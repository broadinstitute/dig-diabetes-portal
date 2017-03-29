<script id="locusZoomTemplate"  type="x-tmpl-mustache">
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
 </script>


<script id="aggregateVariantsTemplate"  type="x-tmpl-mustache">
                            <div class="row" style="margin: 15px 0 0 15px;">
                                <h4>Aggregate variants</h4>
                            </div>

                            <div class="row">
                                <div class="col-lg-1">
                                            <ul class='aggregatingVariantsLabels'>
                                              <li style="text-align: right">pValue</li>
                                              <li style="text-align: right">beta</li>
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

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV + NS 1%</span>
                                                <div id="allMissense"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV+ NSbroad 1%</span>
                                                <div id="possiblyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV + NSstrict</span>
                                                <div id="probablyDamaging"></div>
                                            </div>

                                            <div class="col-lg-2 text-center"><span class="aggregatingVariantsColumnHeader">PTV</span>
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
                                onclick="mpgSoftware.geneSignalSummary.adjustProperties(this)"  tableSpec="highImpact">Add / Subtract Data</button>
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




<script id="commonVariantTemplate"  type="x-tmpl-mustache">



            <div class="row">
                <div class="col-lg-12">

                    <div class="row">
                            <div class="col-xs-9"></div>
                            <div class="col-xs-3">
                                <button class="btn btn-primary btn-xs pull-right" style="margin-bottom: 5px;" data-toggle="modal" data-target="#xpropertiesModal"
                                onclick="mpgSoftware.geneSignalSummary.adjustProperties(this)" tableSpec="common">Add / Subtract Data</button>
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
                        <li role="presentation" class="active"><a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab">Common variants</a></li>
                        <li role="presentation"><a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab">High-impact variants</a></li>
                    </ul>
                </div>
            </div>
            <div id="cDataModalGoesHere"></div>

            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="commonVariantTabHolder">
                    <div class="row"   style="border: none">
                        <div class="col-xs-12">
                            <div class="variantCategoryHolder">

                                <div id="commonVariantsLocation"></div>

                                <div id="locusZoomLocation" class="locusZoomLocation"></div>
                                <div class="igvGoesHere"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="highImpactVariantTabHolder">
                    <div class="row" style="border: none">
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
            </div>
</script>

<script id="organizeSignalSummaryHighImpactFirstTemplate"  type="x-tmpl-mustache">
            <div class="text-center" id="phenotypeLabel">{{pName}}</div>
            <div class="row">
                <div class="col-xs-12">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active"><a href="#highImpactVariantTabHolder" aria-controls="highImpactVariantTabHolder" role="tab" data-toggle="tab">High-impact variants</a></li>
                        <li role="presentation"><a href="#commonVariantTabHolder" aria-controls="commonVariantTabHolder" role="tab" data-toggle="tab">Common variants</a></li>
                    </ul>
                </div>
            </div>
            <div id="cDataModalGoesHere"></div>
            <div class="row">
                <div class="col-xs-9"></div>
                <div class="col-xs-3">
                    <button class="btn btn-primary btn-xs" style="margin-bottom: 5px;" data-toggle="modal" data-target="#cDataModalGoesHere">Add / Subtract Data</button>
                </div>
            </div>
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
                            <div class="variantCategoryHolder" id=">
                                <div id="commonVariantsLocation"></div>

                                <div id="locusZoomLocation" class="locusZoomLocation"></div>
                                <div class="igvGoesHere"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</script>
