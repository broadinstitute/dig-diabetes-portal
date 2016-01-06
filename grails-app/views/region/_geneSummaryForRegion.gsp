<h1>${regionSpecification}</h1>
<div class="separator"></div>
<p><a class="boldlink" href="<g:createLink controller="trait" action="regionInfo" />/${regionSpecification}">
    <g:message code="variantTable.regionSummary.clickForGwasSummary" default="Click here"/></a>
<p> <g:message code="variantTable.regionSummary.regionContains" default="This region contains the following genes:"/>
<ul>
    <g:each in="${geneNamesToDisplay}">
        <li><a class="genelink" href="<g:createLink controller='gene' action='geneInfo'/>/${it.toUpperCase()}">${it.toUpperCase()}</a> </li>
    </g:each>
</ul>
</p>
<div class="separator"></div>
