<a name="associations"></a>

<h2><strong>Variants and associations</strong></h2>

<g:if test="${show_gwas}">
    <p>
        There are <strong><%=gene_info.GWAS_T2D_VAR_TOTAL%> total variants</strong> within 500 kb of this gene in GWAS data available on this portal
    | <a class="variantlink"
         href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=gene_info.REGION_END%>/variants?filters=total-gwas">view</a>
    </p>
    <ul>
        <li>
            <g:if test="${gene_info.GWAS_T2D_GWS_TOTAL}">
                <g:if test="${(gene_info.GWAS_T2D_GWS_TOTAL > 0)}">
                    print('<strong>');
                </g:if>
                <%=gene_info.GWAS_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
                <g:if test="${(gene_info.GWAS_T2D_GWS_TOTAL > 0)}">
                    print('</strong>');
                </g:if>
                | <a class="variantlink" href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=
                gene_info.REGION_END%>/variants?filters=gwas-genomewide">view</a>
            </g:if>
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
        <g:if test="${gene_info.EXCHP_T2D_VAR_TOTALS}">
            There are <strong><%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.TOTAL%> total variants</strong> in exome chip data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">view</a>
        </g:if>
        <g:else>
            There are 0 total variants in exome chip data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">view</a>
        </g:else>
    </p>
    <ul>
        <li>
            <g:if test="${gene_info.EXCHP_T2D_GWS_TOTAL}">
                <g:if test="${(gene_info.EXCHP_T2D_GWS_TOTAL > 0)}">
                    print('<strong>');
                </g:if>
                <%=gene_info.EXCHP_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
                <g:if test="${(gene_info.EXCHP_T2D_GWS_TOTAL > 0)}">
                    print('</strong>');
                </g:if>
            </g:if>
            <g:else>
                 0 are associated with type 2 diabetes at or above genome-wide significance
        | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">view</a>
            </g:else>

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
        <g:if test="${gene_info._13k_T2D_GWS_TOTAL}">
            <g:if test="${(gene_info._13k_T2D_GWS_TOTAL > 0)}">
                print('<strong>');
            </g:if>

            <%=gene_info._13k_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <g:if test="${(gene_info._13k_T2D_GWS_TOTAL > 0)}">
                print('</strong>');
            </g:if>

        </g:if>


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
        There are <strong><%=gene_info.SIGMA_T2D_VAR_TOTAL%> total variants</strong> in SIGMA sequencing data available on this portal
    | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=in-sigma">view</a>
    </p>
    <ul>
        <li>
            <g:if test="${(gene_info.SIGMA_T2D_GWS_TOTAL > 0)}">
                print('<strong>');
            </g:if>
            <%=gene_info.SIGMA_T2D_GWS_TOTAL%> are associated with type 2 diabetes at or above genome-wide significance
            <g:if test="${(gene_info.SIGMA_T2D_GWS_TOTAL > 0)}">
                print('</strong>');
            </g:if>
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=sigma-genomewide">view</a>
        </li>
        <li>
            <%=gene_info.SIGMA_T2D_NOM_TOTAL%> are associated with type 2 diabetes at or above nominal significance
            | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=sigma-nominal">view</a>
        </li>
    </ul>
</g:if>


<g:if test="${show_gwas}">
    <g:if test="${gene_info.GWS_TRAITS}">
        <strong>
            <p>Variants in or near this gene have been convincingly associated at genome-wide significance in GWAS meta-analyses with the following traits:</p>
            %{--<ul>--}%
                %{--<% _.each(gene_info.GWS_TRAITS, function(t) { %>--}%
                %{--<li><%=_.find(phenotypes, function(p) { return p.db_key == t }).name%></li>--}%
                %{--<% }); %>--}%
            %{--</ul>--}%
        </strong>
    </g:if>
    <g:else>
        <p>Variants in or near this gene have not been convincingly associated with any traits at genome-wide significance in the GWAS meta-analyses included in this portal.</p>
    </g:else>
</g:if>

<p><a class="boldlink"
      href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=gene_info.REGION_END%>/gwas">See p-values and other statistics across 25 traits for all GWAS variants included in this portal</a>
</p>
