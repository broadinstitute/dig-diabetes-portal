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


 %{--NOTE --- according to the code Brett was reviewing the traits at this point. An inspection of the parameters--}%
%{--does not show the traits being queried, however. My thought is that the following lines of code are vestigial,--}%
%{--but I will leave them here for now until I'm completely sure of this conclusion.   ba, July 25, 2014--}%
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

<p>
    <span id="variantInfoAssociationStatisticsLinkToTraitTable"></span>

</p>

<div class="separator"></div>

