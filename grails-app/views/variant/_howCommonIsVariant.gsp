
<a name="populations"></a>
<h2><strong>How common is <%=variantToSearch%>?</strong></h2>

<p>
    Variants are defined as common (found in 5 percent of the population or more), low-frequency (.5 percent to 5 percent), rare (below .5 percent), or private (seen in only one individual or family).
</p>

<g:if test="${show_exseq}">
    <p>In exome sequencing data available on this portal, the minor allele frequency of <%=variantToSearch%> is:</p>
    <ul>
        <span id="howCommonInExomeSequencing"></span>
        %{--<% _.each(ethnicities, function(e) { %>--}%
        %{--<li>--}%
            %{--<%= (variant['_13k_T2D_' + e.small_key + '_MAF'] * 100).toPrecision(3) %> percent of <%= e.name %> (--}%
            %{--<% if (variant['_13k_T2D_' + e.small_key + '_MAF'] == 0) { print('unobserved'); } %>--}%
            %{--<% if (variant['_13k_T2D_' + e.small_key + '_MAF'] > 0 && variant['_13k_T2D_' + e.small_key + '_MAF'] < 0) { print('private'); } %>--}%
            %{--<% if (variant['_13k_T2D_' + e.small_key + '_MAF'] > 0 && variant['_13k_T2D_' + e.small_key + '_MAF'] < .005) { print('rare'); } %>--}%
            %{--<% if (variant['_13k_T2D_' + e.small_key + '_MAF'] >= .005 && variant['_13k_T2D_' + e.small_key + '_MAF'] < .05) { print('low frequency'); } %>--}%
            %{--<% if (variant['_13k_T2D_' + e.small_key + '_MAF'] >= .05) { print('common'); } %>--}%
            %{--)--}%
        %{--</li>--}%
        %{--<% }); %>--}%
    </ul>

    <span id="howCommonInExomeSequencing"></span>
</g:if>

<span id="howCommonInHeterozygousCarriers"></span>

<span id="howCommonInHomozygousCarriers"></span>
