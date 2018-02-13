
<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion3"
           href="#collapseLZ">
            <h2><strong><g:message code="variant.locusZoom.title" default="Locus Zoom"/></strong></h2>
        </a>
    </div>

    <div id="collapseLZ" class="accordion-body collapse">
        <div class="row">
            <div class="col-md-12">
                <g:if test="${g.portalTypeString()?.equals('t2d')}">
                    <p><g:message code="variant.locusZoom.text1"></g:message><br/>
                        <g:message code="variant.locusZoom.text2"></g:message><br/>
                        <g:message code="variant.locusZoom.text3"></g:message><br/>
                        <g:message code="variant.locusZoom.text4"></g:message></p>

                </g:if>
                <g:else>
                    <p><g:message code="variant.locusZoom.text1"></g:message><br/>
                        <g:message code="variant.locusZoom.text3"></g:message><br/>
                        <g:message code="variant.locusZoom.text4"></g:message></p>

                </g:else>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <ul>
                    <li style="display:inline-block; margin-right: 10px;">Linkage disequilibrium (r<sup>2</sup>) with the reference variant:</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #d43f3a"></i> 1 - 0.8</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #eea236"></i> 0.8 - 0.6</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #5cb85c"></i> 0.6 - 0.4</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #46b8da"></i> 0.4 - 0.2</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #357ebd"></i> 0.2 - 0</li>
                    <li style="display:inline-block; margin-right: 10px;"><i class="fa fa-circle" style="color: #B8B8B8"></i> no information</li>
                    <li style="display:inline-block"><i class="fa fa-circle" style="color: #9632b8"></i> reference variant</li>
                </ul>
            </div>
        </div>

        <style>

        </style>

        <script>

        </script>

        <div class="row" style="border: solid 1px #ddd; padding: 15px 15px; margin-top: 15px;">

            <strong>Add new track</strong>

            <div class="col-md-12">
                <div style="float:left; margin-right: 25px;" class="lz-list">
                    <span style="padding: 1px; background-color: #1184e8;font-size: 12px;color: #fff;width: 20px;display: inline-block;border-radius: 14px;text-align: center;margin-right: 5px;">1</span>
                    <a href="javascript:;" onclick="showLZlist(event);" >Phenotypes <b class="caret"></b></a>
                    <ul id="dk_lz_phenotype_list">
                        <g:each in="${lzOptions?.findAll{it.dataType=='dynamic' || it.dataType=='static'}}">
                            <li><a href="javascript:;">
                                ${g.message(code: "metadata." + it.name)}
                            </a>
                            </li>
                        </g:each>
                    </ul>
                </div>

                <div class="dropdown lz-list" style="float:left; margin-right: 25px;"><span style="padding: 1px;background-color: #1184e8;font-size: 12px;color: #fff;width: 20px;display: inline-block;border-radius: 14px;text-align: center;margin-right: 5px;">2</span>
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="selected-phenotype"></span> Datasets <b class="caret"></b></a>
                    <ul id="trackList-static" class="dropdown-menu" style="height: auto; max-height:500px; overflow:auto;">
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
                                    '${it.dataType}','#lz-47')">

                                    <span class="dk-lz-dataset" style="display:none">${g.message(code: "metadata." + it.name)}</span><span>${g.message(code: "metadata." + it.dataSet)}</span><span> (${it.dataType})</span>

                                </a>
                            </li>
                        </g:each>
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
                                    '${it.dataType}','#lz-47')">

                                    <span class="dk-lz-dataset" style="display:none">${g.message(code: "metadata." + it.name)}</span><span>${g.message(code: "metadata." + it.dataSet)}</span><span> (${it.dataType})</span>

                                </a>
                            </li>
                        </g:each>
                    </ul>
                </div>

                <div class="">
                    <b>Region: <span id="lzRegion"></span></b>
                </div>
            </div>
        </div>

        <div class="accordion-inner row" style="border:solid 1px #ddd; border-top:none; padding:10px;">
            <div id="lz-47" class="lz-container-responsive col-md-12" style=""></div>
        </div>

    </div>
</div>


<!--
        <ul class="nav navbar-nav navbar-left" style="display: flex;">
<g:if test="${g.portalTypeString()?.equals('t2d')}">
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
                                            '${it.dataType}','#lz-47')">
        ${g.message(code: "metadata." + it.name)}
        </a>
    </li>
    </g:each>
    </ul>
</li>
</g:if>
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
                                    '${it.dataType}','#lz-47')">
    ${g.message(code: "metadata." + it.name)+"("+g.message(code: "metadata." + it.dataSet)+")"}
    </a>
</li>
</g:each>
</ul>
</li>
<li style="margin: auto;">
<b>Region: <span id="lzRegion"></span></b>
</li>
</ul> -->