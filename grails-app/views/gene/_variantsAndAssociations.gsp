
<a name="associations"></a>

<h2><strong>Variants and associations</strong></h2>

<g:if test="${show_gwas}">
    <p>
        There are <strong><%=
        gene_info.GWAS_T2D_VAR_TOTAL%> total variants</strong> within 500 kb of this gene in GWAS data available on this portal
    | <a class="variantlink" href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=
        gene_info.REGION_END%>/variants?filters=total-gwas">view</a>
    </p>
    <ul>
        <li>
            <% if (gene_info.GWAS_T2D_GWS_TOTAL > 0) {
                print('<strong>');
            } %>
            <%=gene_info.GWAS_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <% if (gene_info.GWAS_T2D_GWS_TOTAL > 0) {
                print('</strong>');
            } %>
            | <a class="variantlink" href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=
            gene_info.REGION_END%>/variants?filters=gwas-genomewide">view</a>
        </li>
        <li>
            <%=gene_info.GWAS_T2D_NOM_TOTAL%> are associated with type 2 diabetes at or above nominal significance
            | <a class="variantlink" href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=
            gene_info.REGION_END%>/variants?filters=gwas-nominal">view</a>
        </li>
    </ul>
</g:if>


<g:if test="${show_exchp}">
    <p>
        There are <strong><%=
        gene_info.EXCHP_T2D_VAR_TOTALS.EU.TOTAL%> total variants</strong> in exome chip data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">view</a>
    </p>
    <ul>
        <li>
            <% if (gene_info.EXCHP_T2D_GWS_TOTAL > 0) {
                print('<strong>');
            } %>
            <%=gene_info.EXCHP_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <% if (gene_info.EXCHP_T2D_GWS_TOTAL > 0) {
                print('</strong>');
            } %>
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=exchp-genomewide">view</a>
        </li>
        <li>
            <%=gene_info.EXCHP_T2D_NOM_TOTAL%> are associated with type 2 diabetes at or above nominal significance
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=exchp-nominal">view</a>
        </li>
    </ul>
</g:if>




<g:if test="${show_exseq}">
    <p>
        There are <strong><%=
        gene_info._13k_T2D_VAR_TOTAL%> total variants</strong> in exome sequencing data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=in-exseq">view</a>
    </p>
    <ul>
        <li>
            <% if (gene_info._13k_T2D_GWS_TOTAL > 0) {
                print('<strong>');
            } %>
            <%=gene_info._13k_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <% if (gene_info._13k_T2D_GWS_TOTAL > 0) {
                print('</strong>');
            } %>
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=t2d-genomewide">view</a>
        </li>
        <li>
            <%=gene_info._13k_T2D_NOM_TOTAL%> are associated with type 2 diabetes at or above nominal significance
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=t2d-nominal">view</a>
        </li>
    </ul>
</g:if>


<g:if test="${show_sigma}">
    <p>
        There are <strong><%=
        gene_info.SIGMA_T2D_VAR_TOTAL%> total variants</strong> in SIGMA sequencing data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=in-sigma">view</a>
    </p>
    <ul>
        <li>
            <% if (gene_info.SIGMA_T2D_GWS_TOTAL > 0) {
                print('<strong>');
            } %>
            <%=gene_info.SIGMA_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <% if (gene_info.SIGMA_T2D_GWS_TOTAL > 0) {
                print('</strong>');
            } %>
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=sigma-genomewide">view</a>
        </li>
        <li>
            <%=gene_info.SIGMA_T2D_NOM_TOTAL%> are associated with type 2 diabetes at or above nominal significance
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=sigma-nominal">view</a>
        </li>
    </ul>
</g:if>
