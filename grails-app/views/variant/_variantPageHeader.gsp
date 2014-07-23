<g:if test="${show_exseq}">
<p>
    This
    <script>
    %{--print( UTILS.getSimpleVariantsEffect(<%=variant.MOST_DEL_SCORE%>));--}%
     </script>
     variant
    <g:if test="${variant.IN_GENE}">
    lies in the gene <em><%= variant.IN_GENE %></em>.
    </g:if>
    <g:else>
is nearest to the gene <em><%= variant.CLOSEST_GENE %></em>.
    </g:else>
    <script>
        var pVal= UTILS.getLowestPValue(<%=variant.IN_EXCHP%>,<%=variant.EXCHP_T2D_P_value%>,<%=variant.IN_EXSEQ%>,<%=variant._13k_T2D_P_EMMAX_FE_IV%>,<%=variant.IN_GWAS%>,<%=variant.GWAS_T2D_PVALUE%>);
    </script>
Among datasets available on this portal, its strongest association with T2D has a p-value of <script>pVal[0]</script>,
in
    <script>
         if (pVal[1] == 'exchp') { print('exome chip.'); }
         if (pVal[1] == 'exseq') { print('exome sequencing.'); }
         if (pVal[1] == 'gwas') { print('GWAS.'); }
    </script>

</p>

</g:if>


<div class="separator"></div>