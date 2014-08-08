<h2><%=variantIdentifier%>: association statistics across 25 traits</h2>

<div class="gwas-table-container">
    <table id="traitsPerVariantTable" class="table table-striped basictable gwas-table">
        <thead>
        <tr>
            <th>trait</th>
            <th>p-value</th>
            <th>direction of effect</th>
            <th>odds ratio</th>
            <th>minor allele frequency</th>
            <th>effect</th>
        </tr>
        </thead>
        <tbody id="traitsPerVariantTableBody">
        %{--<% _.each(variant_gwas_info, function(trait) { %>--}%
        %{--<tr>--}%
            %{--<td><%= _.find(gwas_traits, function(p) { return p.db_key == trait.TRAIT }).name %></td>--}%
            %{--<td><%= trait.PVALUE.toPrecision(3) %></td>--}%
            %{--<td>--}%
                %{--<% if (trait.DIR == 'up') { print('<span class="assoc-up">&uarr;</span>'); } %>--}%
                %{--<% if (trait.DIR == 'down') { print('<span class="assoc-down">&darr;</span>'); } %>--}%
            %{--</td>--}%
            %{--<td><% if (trait.ODDS_RATIO){ print(trait.ODDS_RATIO.toPrecision(3)); } %></td>--}%
            %{--<td><% if (trait.MAF){ print(trait.MAF.toPrecision(3)); } %></td>--}%
            %{--<td>--}%
                %{--<%--}%
                        %{--if (trait.BETA){ print('beta: ' + trait.BETA.toPrecision(3)); }--}%
                        %{--else if (trait.Z_SCORE){ print('z-score: ' + trait.ZSCORE.toPrecision(3)); }--}%
                %{--%>--}%
            %{--</td>--}%
        %{--</tr>--}%
        %{--<% }); %>--}%
        </tbody>
    </table>
</div>