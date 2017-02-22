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
                                                <div class="col-lg-3">{{dsr}}</div>
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
            <div class="row">
                <div class="col-lg-12">
                    <div id="burdenGoesHere" class="row"></div>
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

                        <table id="commonVariantsLocationHolder" class="compact row-border"></table>

                        </div>
                    </div>

                </div>

            </div>
        </script>
