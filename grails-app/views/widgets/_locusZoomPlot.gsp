
<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" data-parent="#accordion3"
           href="#collapseLZ">
            <h2><strong><g:message code="variant.locusZoom.title" default="Locus Zoom"/></strong></h2>
        </a>
    </div>

    <div id="collapseLZ" class="accordion-body collapse">
<g:if test="${g.portalTypeString()?.equals('t2d')}">
        <g:message code="variant.locusZoom.text1"></g:message></p>
        <p><g:message code="variant.locusZoom.text2"></g:message></p>
        <p><g:message code="variant.locusZoom.text3"></g:message></p>
    <p><g:message code="variant.locusZoom.text4"></g:message></p>
    <p>&nbsp;</p>
</g:if>
        <g:else>
            <p><g:message code="variant.locusZoom.text1"></g:message></p>
            <p><g:message code="variant.locusZoom.text3"></g:message></p>
            <p><g:message code="variant.locusZoom.text4"></g:message></p>
            <p>&nbsp;</p>
        </g:else>

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
        </ul>

        <div class="accordion-inner">
            <div id="lz-47" class="lz-container-responsive"></div>
        </div>

    </div>
</div>
