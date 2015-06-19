<g:if test="${(geneNamesToDisplay?.size() > 0)}">
    <g:message code="variantTable.regionSummary.regionContains" default="This region contains the following genes:"/>
</g:if>
<g:else>
    <g:message code="variantTable.regionSummary.regionContainsNothing" default="No genes:"/>
</g:else>
<div class="row clearfix" style="margin:5px 0 5px 0">
    <div class="col-md-6" style="text-align: left; max-height: 200px; overflow-y: auto">
        <ul id="geneNames">
            <g:each in="${geneNamesToDisplay}">
                <li><a class="genelink" href="<g:createLink controller='gene'
                                                            action='geneInfo'/>/${it.toUpperCase()}">${it.toUpperCase()}</a>
                </li>
            </g:each>
        </ul>
    </div>

    <div class="col-md-6" style="text-align: right; vertical-align: middle">
        <a class="boldlink pull-right"
           href="<g:createLink controller="trait" action="regionInfo"/>/${regionSpecification}">
            <g:message code="variantTable.regionSummary.clickForGwasSummary" default="Click here"/></a>
    </div>
</div>

