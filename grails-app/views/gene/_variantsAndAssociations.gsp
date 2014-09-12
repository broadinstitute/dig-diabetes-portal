<a name="associations"></a>

<h2><strong>Variants and associations</strong></h2>

<g:if test="${show_gwas}">
    <p>
        <span id="totalGwasVariants"></span><a id="totalGwasVariantAnchor" class="variantlink">view</a>
    </p>
    <ul>
        <li><span id="totalGwasVariantst2dgenome"></span><a id="totalGwasVariantAnchor2dgenome" class="variantlink">view</a></li>
        <li><span id="totalGwasVariantst2dnominal"></span><a id="totalGwasVariantAnchor2dnominal" class="variantlink">view</a></li>
    </ul>
</g:if>

<g:if test="${show_exchp}">
    <p>
        <span id="totalExomeChipVariants"></span><a id="totalExomeChipVariantAnchor" class="variantlink">view</a>
    </p>
    <ul>
        <li><span id="totalExomeChipVariantst2dgenome"></span><a id="totalExomeChipVariantAnchor2dgenome" class="variantlink">view</a></li>
        <li><span id="totalExomeChipVariantst2dnominal"></span><a id="totalExomeChipVariantAnchor2dnominal" class="variantlink">view</a></li>
    </ul>
</g:if>


<g:if test="${show_exseq}">
    <p>
        <span id="totalExomeSeqVariants"></span><a id="totalExomeSeqVariantAnchor" class="variantlink">view</a>
    </p>
    <ul>
        <li><span id="totalExomeSeqVariantst2dgenome"></span><a id="totalExomeSeqVariantAnchor2dgenome" class="variantlink">view</a></li>
        <li><span id="totalExomeSeqVariantst2dnominal"></span><a id="totalExomeSeqVariantAnchor2dnominal" class="variantlink">view</a></li>
    </ul>
</g:if>



<g:if test="${show_sigma}">
    <p>
        <span id="totalSigmaVariants"></span><a id="totalSigmaVariantAnchor" class="variantlink">view</a>
    </p>
    <ul>
        <li><span id="totalSigmaVariantst2dgenome"></span><a id="totalSigmaVariantAnchor2dgenome" class="variantlink">view</a></li>
        <li><span id="totalSigmaVariantst2dnominal"></span><a id="totalSigmaVariantAnchor2dnominal" class="variantlink">view</a></li>
    </ul>
</g:if>



<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>

<p><a class="boldlink"  id="linkToVariantTraitCross">

    See p-values and other statistics across 25 traits for all GWAS variants included in this portal</a>
</p>
<p><a class="boldlink" href="<g:createLink controller="trait" action="genomeBrowser" />/${regionSpecification}"> Click here to examine this region with the IGV browser</a>
