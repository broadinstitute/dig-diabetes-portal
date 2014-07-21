<g:if test="${show_exseq}">



    <a name="populations"></a>

    <h2><strong>Variation across continental ancestry groups</strong></h2>

    <p>
        Variants are defined as common (found in 5 percent of the population or more), low-frequency (.5 percent to 5 percent), rare (below .5 percent), or private (seen in only one individual or family).
    </p>

    <p>
        Click on a number to view variants.
    </p>

    <table id="continentalVariation" class="table table-striped basictable">
        <thead>
        <tr>
            <th>cohort</th>
            <th>participants</th>
            <th>total variants</th>                                                                                            are
            <th>common</th>
            <th>low-frequency</th>
            <th>rare</th>
        </tr>
        </thead>
        <tbody>
        <script>
            for (var i = 0 ; i < geneInfo.variationTable.length ; i++ )   {
                console.log(' making rows')
                var row = geneInfo.variationTable[i];
                $('#continentalVariation').append( '<tr>'+
                        '<td>' + row['cohort'] + '</td>'+
                        '<td>' + row['participants'] + '</td>'+
                        '<td>' + row['variants'] + '</td>'+
                        '<td>' + row['common'] + '</td>'+
                        '<td>' + row['lowfrequency'] + '</td>'+
                        '<td>' + row['rare'] + '</td>'+
                        '</tr>');

            }
        </script>
        </tbody>
        </table>

        %{--<% _.each(ethnicities, function(e) { %>--}%
        %{--<tr>--}%
            %{--<td><%=e.name%> (exome sequencing)</td>--}%
            %{--<td><%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].NS%></td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-<%=e.small_key%>">--}%
                    %{--<%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].TOTAL%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=common-<%=e.small_key%>">--}%
                    %{--<%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].COMMON%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=lowfreq-<%=e.small_key%>">--}%
                    %{--<%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].LOW_FREQUENCY%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=rare-<%=e.small_key%>">--}%
                    %{--<%=--}%
                            %{--gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].RARE + gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].SING%>--}%
                %{--</a>--}%
            %{--</td>--}%
        %{--</tr>--}%
        %{--<% }); %>--}%
        %{--<tr>--}%
            %{--<td>European (exome chip)</td>--}%
            %{--<td><%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.NS%></td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">--}%
                    %{--<%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.TOTAL%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=common-exchp">--}%
                    %{--<%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.COMMON%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=lowfreq-exchp">--}%
                    %{--<%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.LOW_FREQUENCY%>--}%
                %{--</a>--}%
            %{--</td>--}%
            %{--<td>--}%
                %{--<a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=rare-exchp">--}%
                    %{--<%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.RARE%>--}%
                %{--</a>--}%
            %{--</td>--}%
        %{--</tr>--}%
        %{--</tbody>--}%
    %{--</table>--}%

</g:if>