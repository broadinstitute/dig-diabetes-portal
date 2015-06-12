<h1><%=phenotypeName%></h1>

<div class="separator"></div>

<p>
    %{--The following results are from the--}%
    %{--<g:if test="${phenotypeDataSet == 'diagram'}">--}%
        %{--<a href="http://diagram-consortium.org/downloads.html" class="boldlink">DIAGRAM-3</a>--}%
    %{--</g:if>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'magic'}">--}%
        %{--<a href="http://www.magicinvestigators.org/downloads/" class="boldlink">MAGIC</a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'giant'}">--}%
        %{--<a href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download"--}%
           %{--class="boldlink">GIANT</a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'glgc'}">--}%
        %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"--}%
           %{--class="boldlink">Global Lipid Genetics Consortium (GLGC)</a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'cardiogram'}">--}%
        %{--<a href="http://www.cardiogramplusc4d.org/downloads/" class="boldlink">CARDIoGRAM</a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'ckdgen'}">--}%
        %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146" class="boldlink">CKDGen Consortium</a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${phenotypeDataSet == 'pgc'}">--}%
        %{--<a href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php"--}%
           %{--class="boldlink">Psychiatric Genetics Consortium</a>--}%
    %{--</g:elseif>--}%
    %{--GWAS meta-analysis consortium:--}%
</p>

<div id="manhattanPlot1"></div>

<table id="phenotypeTraits" class="table basictable table-striped">
    <thead>
    <tr>
        <th>rsID</th>
        <th>nearest gene</th>
        <th>p-value</th>
        <th id="effectTypeHeader"></th>
        <th>minor allele frequency</th>
        <th>see p-values for all available traits</th>
    </tr>
    </thead>
    <tbody id="traitTableBody">
    </tbody>
</table>
%{--<% if (variants.length == 0) { print('<p><em>No variants found</em></p>') } %>--}%