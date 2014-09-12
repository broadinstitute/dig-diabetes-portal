<h1>${regionSpecification}</h1>
<div class="separator"></div>
<p><a class="boldlink" href="<g:createLink controller="trait" action="regionInfo" />/${regionSpecification}"> Click here to see a GWAS summary of this region </a>
<p> This region contains the following genes:
<ul>
    <g:each in="${geneNamesToDisplay}">
        <li><a class="genelink" href="<g:createLink controller='gene' action='geneInfo'/>/${it.toUpperCase()}">${it.toUpperCase()}</a> </li>
    </g:each>
</ul>
</p>
<div class="separator"></div>
