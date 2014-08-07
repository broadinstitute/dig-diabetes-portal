%{--<h1><%= trait.name %></h1>--}%

<div class="separator"></div>

<p>
    %{--The following results are from the--}%
    %{--<% if (trait.dataset == 'diagram') { %>--}%
    %{--<a href="http://diagram-consortium.org/downloads.html" class="boldlink">DIAGRAM-3</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'magic') { %>--}%
    %{--<a href="http://www.magicinvestigators.org/downloads/" class="boldlink">MAGIC</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'giant') { %>--}%
    %{--<a href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download" class="boldlink">GIANT</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'glgc') { %>--}%
    %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565" class="boldlink">Global Lipid Genetics Consortium (GLGC)</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'cardiogram') { %>--}%
    %{--<a href="http://www.cardiogramplusc4d.org/downloads/" class="boldlink">CARDIoGRAM</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'ckdgen') { %>--}%
    %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146" class="boldlink">CKDGen Consortium</a>--}%
    %{--<% } %>--}%
    %{--<% if (trait.dataset == 'pgc') { %>--}%
    %{--<a href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php" class="boldlink">Psychiatric Genetics Consortium</a>--}%
    %{--<% } %>--}%
    %{--GWAS meta-analysis consortium:--}%
</p>

<table class="table basictable table-striped">
    <thead>
    <tr>
        <th>rsID</th>
        <th>nearest gene</th>
        <th>p-value</th>
        <th>
            <%
                if (effect_type == 'ODDS_RATIO') { print('odds ratio') }
                if (effect_type == 'BETA') { print('beta') }
                if (effect_type == 'ZSCORE') { print('zscore') }
            %>
        </th>
        <th>minor allele frequency</th>
        <th>see p-values for all available traits</th>
    </tr>
    </thead>
    <tbody>
    %{--<% _.each(variants, function(variant) { %>--}%
    %{--<tr>--}%
        %{--<td><a class="boldlink" href="/variant/<%= variant.DBSNP_ID %>"><%= variant.DBSNP_ID %></a></td>--}%
        %{--<td><a class="boldlink" href="/gene/<%= variant.CLOSEST_GENE %>"><%= variant.CLOSEST_GENE %></a></td>--}%
        %{--<td><%= variant.PVALUE.toPrecision(3) %></td>--}%
        %{--<td class="<% if (variant.PVALUE > .05) { print('greyedout') } %>">--}%
            %{--<%= variant[effect_type].toPrecision(3) %>--}%
        %{--</td>--}%
        %{--<td><% if (variant.MAF) { print(variant.MAF.toPrecision(3)) } %></td>--}%
        %{--<td><a class="boldlink" href="/variant/<%= variant.DBSNP_ID %>/gwas">click here</a></td>--}%
    %{--</tr>--}%
    %{--<% }); %>--}%
    </tbody>
</table>
%{--<% if (variants.length == 0) { print('<p><em>No variants found</em></p>') } %>--}%