
<a name="populations"></a>
<h2><strong>How does carrier status affect disease risk?</strong></h2>


<g:if test="${show_exseq}">

    <div id="exomeDataExists2" style="display: block">


        <p>Heterozygous carriers</p>
        <ul>
        <span id="howCommonInHeterozygousCarriers"></span>
        </ul>

        <p>Homozygous carriers</p>
        <ul>
        <span id="howCommonInHomozygousCarriers"></span>
        </ul>

    </div>

    <div id="exomeDataDoesNotExist" style="display: none">

        <p>This variant is not in exome sequencing data available on this portal.</p>

    </div>


</g:if>
<g:else>
    <p>This variant is not in exome sequencing data available on this portal.</p>
</g:else>

<g:if test="${show_exchp}">

    <span id="eurocentricVariantCharacterization"></span>

</g:if>

<g:if test="${show_sigma}">


    <span id="sigmaVariantCharacterization"></span>

</g:if>

<div class="separator"></div>


