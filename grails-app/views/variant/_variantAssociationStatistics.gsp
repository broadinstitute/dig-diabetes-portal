<a name="associations"></a>
<h2><strong>See association statistics</strong></h2>


<g:if test="${show_gwas}">
    <span id="variantInfoGwasSection"></span>
</g:if>



<g:if test="${show_exchp}">
    <span id="variantInfoExomeChipSection"></span>
</g:if>


<g:if test="${show_exchp}">
    <span id="variantInfoExomeDataSection"></span>
</g:if>



%{--<% if (variant.GWS_TRAITS) { %>--}%
%{--<p>--}%
    %{--<%= UTILS.get_variant_title(variant) %> also reaches genome-wide significance in a meta-analysis of genome-wide association studies for the following traits:--}%
%{--</p>--}%
%{--<ul>--}%
    %{--<% _.each(variant.GWS_TRAITS, function(t) { %>--}%
    %{--<li><%= _.find(phenotypes, function(p) { return p.db_key == t }).name %></li>--}%
    %{--<% }); %>--}%
%{--</ul>--}%
%{--<% } %>--}%

%{--<p>--}%
    %{--<% if (variant.IN_GWAS) { %>--}%
    %{--<a class="boldlink" href="/variant/<% if (variant.DBSNP_ID) {print(variant.DBSNP_ID)} else { print(variant.ID) } %>/gwas">Click here</a> to see a table of p-values for this variant across 25 traits studied in GWAS meta-analyses.--}%
%{--<% } %>--}%
%{--</p>--}%

<div class="separator"></div>

