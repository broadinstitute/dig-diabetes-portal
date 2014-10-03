




<g:if test="${show_exseq}">

    <div id="exomeDataExists2" style="display: block">


         <p>
            <div id="carrierStatusDiseaseRiskChart"></div>
        </p>

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


