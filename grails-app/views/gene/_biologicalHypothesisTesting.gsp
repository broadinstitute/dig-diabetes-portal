
<g:if test="${show_exseq}">


    <a name="biology"></a>

    <h2><strong>Biological hypothesis testing</strong></h2>

    <p>We are piloting queries inspired by translational research questions. For example:</p>

    <div class="translational-research-box">
        <p>
            <%=gene_info._13k_T2D_lof_NVAR%> variants in <em><%=gene_info.ID%></em> are predicted to truncate the protein.
        | <a class="variantlink" href="/gene/<%=gene_info.ID%>/variants?filters=lof">view</a>
        </p>

        <p>Among people who carry one copy of at least one of these variants (data drawn from exome sequencing):</p>
        <ul>
            <li>
                <%=gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[0]%> out of
                <%=gene_info._13k_T2D_lof_OBSA%>
                have type 2 diabetes.
                (<%=
                    (100 * (new BigDecimal(gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[0])) / gene_info._13k_T2D_lof_OBSA)%>%)
            </li>
            <li>
                <%=gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[1]%> out of
                <%=gene_info._13k_T2D_lof_OBSU%>
                do not have type 2 diabetes.
                (<%=
                    (100 * (new BigDecimal(gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[1])) / gene_info._13k_T2D_lof_OBSU)%>%)
            </li>
        </ul>
    <g:if test="${(gene_info._13k_T2D_lof_METABURDEN)}">
        <p>Collectively, these variants' p-value for association with type 2 diabetes is <%=
                gene_info._13k_T2D_lof_METABURDEN%>.</p>
    </g:if>
        <p class="term-description">
            Variants in this module are predicted to be protein-truncating by three annotation programs (VEP, CHAOS, and SNPEff). Variants in the table are annotated only by VEP. A small fraction of the time, this may result in inconsistencies.
        </p>
    </div>

</g:if>
