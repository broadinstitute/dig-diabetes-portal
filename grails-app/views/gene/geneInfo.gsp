<h1>
    <em><%=gene_info.ID%></em>
    <a class="page-nav-link" href="#associations">Associations</a>
    <a class="page-nav-link" href="#populations">Populations</a>
    <a class="page-nav-link" href="#biology">Biology</a>
</h1>

<% if (gene_info.GENE_SUMMARY_TOP) { %>
<div class="gene-summary">
    <div class="title">Curated Summary</div>

    <div class="top">
        <%=gene_info.GENE_SUMMARY_TOP%>
    </div>

    <div class="bottom ishidden" style="display: none;">
        <%=gene_info.GENE_SUMMARY_BOTTOM%>
    </div>
    <a class="boldlink" id="gene-summary-expand">click to expand</a>
</div>
<% } %>

<p><strong>Uniprot Summary:</strong> <%=gene_info.Function_description%></p>

<div class="separator"></div>

<a name="associations"></a>

<h2><strong>Variants and associations</strong></h2>

<% if (show_gwas) { %>
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
<% } %>

<% if (show_exchp) { %>
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
<% } %>

<% if (show_exseq) { %>
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
<% } %>

<% if (show_sigma) { %>
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
<% } %>


<% if (show_gwas) { %>
<% if (gene_info.GWS_TRAITS) { %>
<strong>
    <p>Variants in or near this gene have been convincingly associated at genome-wide significance in GWAS meta-analyses with the following traits:</p>
    <ul>
        <% _.each(gene_info.GWS_TRAITS, function(t) { %>
        <li><%=_.find(phenotypes, function(p) { return p.db_key == t }).name%></li>
        <% }); %>
    </ul>
</strong>
<% } else { %>
<p>Variants in or near this gene have not been convincingly associated with any traits at genome-wide significance in the GWAS meta-analyses included in this portal.</p>
<% } %>
<% } %>

<p><a class="boldlink"
      href="/region/chr<%=gene_info.CHROM%>:<%=gene_info.REGION_BEG%>-<%=gene_info.REGION_END%>/gwas">See p-values and other statistics across 25 traits for all GWAS variants included in this portal</a>
</p>

<div class="separator"></div>

<% if (show_exseq) { %>
<a name="populations"></a>

<h2><strong>Variation across continental ancestry groups</strong></h2>

<p>
    Variants are defined as common (found in 5 percent of the population or more), low-frequency (.5 percent to 5 percent), rare (below .5 percent), or private (seen in only one individual or family).
</p>

<p>
    Click on a number to view variants.
</p>

<table class="table table-striped basictable">
    <thead>
    <tr>
        <th>cohort</th>
        <th>participants</th>
        <th>total variants</th>
        <th>common</th>
        <th>low-frequency</th>
        <th>rare</th>
    </tr>
    </thead>
    <tbody>
    <% _.each(ethnicities, function(e) { %>
    <tr>
        <td><%=e.name%> (exome sequencing)</td>
        <td><%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].NS%></td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-<%=e.small_key%>">
                <%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].TOTAL%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=common-<%=e.small_key%>">
                <%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].COMMON%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=lowfreq-<%=e.small_key%>">
                <%=gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].LOW_FREQUENCY%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=rare-<%=e.small_key%>">
                <%=
                        gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].RARE + gene_info._13k_T2D_ORIGIN_VAR_TOTALS[e.small_key].SING%>
            </a>
        </td>
    </tr>
    <% }); %>
    <tr>
        <td>European (exome chip)</td>
        <td><%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.NS%></td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=total-exchp">
                <%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.TOTAL%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=common-exchp">
                <%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.COMMON%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=lowfreq-exchp">
                <%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.LOW_FREQUENCY%>
            </a>
        </td>
        <td>
            <a class="boldlink" href="/gene/<%=gene_info.ID%>/variants?filters=rare-exchp">
                <%=gene_info.EXCHP_T2D_VAR_TOTALS.EU.RARE%>
            </a>
        </td>
    </tr>
    </tbody>
</table>

<div class="separator"></div>
<% } %>

<% if (show_exseq) { %>
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
                    (100 * gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[0] / gene_info._13k_T2D_lof_OBSA).toPrecision(2)%>%)
        </li>
        <li>
            <%=gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[1]%> out of
            <%=gene_info._13k_T2D_lof_OBSU%>
            do not have type 2 diabetes.
            (<%=
                    (100 * gene_info._13k_T2D_lof_MINA_MINU_RET.split('/')[1] / gene_info._13k_T2D_lof_OBSU).toPrecision(2)%>%)
        </li>
    </ul>
    <% if (gene_info._13k_T2D_lof_METABURDEN) { %>
    <p>Collectively, these variants' p-value for association with type 2 diabetes is <%=
            gene_info._13k_T2D_lof_METABURDEN.toPrecision(3)%>.</p>
    <% } %>
    <p class="term-description">
        Variants in this module are predicted to be protein-truncating by three annotation programs (VEP, CHAOS, and SNPEff). Variants in the table are annotated only by VEP. A small fraction of the time, this may result in inconsistencies.
    </p>
</div>

<div class="separator"></div>
<% } %>

<h2>Find out more</h2>

<div class="linkout">
    <a target="_blank" href="http://www.gtexportal.org/home/?page=geneSearchAction&id=<%=gene_info.ID%>">GTEx</a>
    See expression levels for this gene across dozens of human tissue types.
</div>

<div class="linkout">
    <a href="http://www.ncbi.nlm.nih.gov/gene?cmd=search&term=<%=gene_info.ID%>%5Bsym%5D">Entrez Gene</a>
    Check NCBI's database for gene-specific information across a wide range of species.
</div>

<div class="linkout">
    <a href="http://www.omim.org/search?index=entry&sort=score+desc%2C+prefix_sort+desc&start=1&limit=10&search=<%=gene_info.ID%>">OMIM</a>
    Find information on genotype-phenotype relationships, 12,000 genes and all known Mendelian disorders
</div>

<div class="linkout">
    <a href="http://www.genecards.org/cgi-bin/carddisp.pl?gene=<%=gene_info.ID%>">GeneCards</a>
    Search for comprehensive information on all known and predicted human genes.
</div>

<div class="linkout">
    <a href="http://www.ncbi.nlm.nih.gov/pubmed/?term=<%=gene_info.ID%>">PubMed</a>
    Search the published literature for references to this gene.
</div>

<div class="linkout">
    <a href="http://scholar.google.com/scholar?hl=en&q=<%=gene_info.ID%>">Google Scholar</a>
    Search the published literature for references to this gene.
</div>

<div class="linkout">
    <a href="http://biogps.org/">BioGPS</a>
    Choose a variety of publicly available annotations for this gene.
</div>



