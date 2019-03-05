<script>
    var phenotypeDatasetMapping = {};
    <g:applyCodec encodeAs="none">
    phenotypeDatasetMapping = ${phenotypeDatasetMapping};
    </g:applyCodec>

    var variantId = '<%=variantToSearch%>';

    var variantAssociationStrings = {
        genomeSignificance: '<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
        locusSignificance: '<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
        nominalSignificance: '<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
        nonSignificance: '<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
    };


    // this lives here so that the correct strings can be loaded by the server
    var toggleOtherAssociations = function () {
        var toggle = $('#toggleButton');
        var text = toggle.text();

        if (text == '${g.message(code:"variant.variantAssociations.expandAssociations", default:"expand associations for all traits")}') {
            // content is hidden
            toggle.text('${g.message(code:"variant.variantAssociations.hideAssociations", default:"hide associations")}');
            $('#otherTraitsSection').css({display: 'flex'});
        } else {
            // content is visible
            toggle.text('${g.message(code:"variant.variantAssociations.expandAssociations", default:"expand associations for all traits")}');
            $('#otherTraitsSection').css({display: 'none'});
        }
    };

    %{--var configDetails = {  'exposeGreenBoxes':'${portalVersionBean.getExposeGreenBoxes()}',--}%
                            %{--'exposeForestPlot': '${portalVersionBean.getExposeForestPlot()}',--}%
                            %{--'exposePhewasModule':'${portalVersionBean.getExposePhewasModule()}'};--}%
    %{--mpgSoftware.variantInfo.storeVarInfoData(configDetails);--}%
    %{--mpgSoftware.variantInfo.retrieveVariantPhenotypeData(phenotypeDatasetMapping,--}%
            %{--variantId,--}%
            %{--variantAssociationStrings,--}%
            %{--'${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}',--}%
            %{--'${g.defaultPhenotype()}');--}%

    %{--$(window).load( function() {--}%
        %{--mpgSoftware.associationStatistics.buildDynamicPage(configDetails);--}%
    %{--});--}%

</script>

<g:if test="${portalVersionBean.getExposePhewasModule()}">
    <p><g:message code="variant.PheWAShelp1a"></g:message></p>
    <p><g:message code="variant.PheWAShelp2"></g:message></p>
    <p><g:message code="variant.PheWAShelp3"></g:message></p>
    <p><g:message code="variant.PheWAShelp4"></g:message></p>

  %{--#alternative text for non-T2D portals:--}%
    %{--<p><g:message code="variant.PheWAShelp_nonT2D1"></g:message>--}%
    %{--<p><g:message code="variant.PheWAShelp_nonT2D2"></g:message></p>--}%
    %{--<p><g:message code="variant.PheWAShelp4"></g:message></p>--}%


</g:if>


<g:if test="${portalVersionBean.getExposeTraitDataSetAssociationView()}">

</g:if>
<g:else>
    <style>
    .phenotype-searchbox-wrapper {
        display: none;
    }
    #pheplot {
        display: none;
    }
    </style>
</g:else>


<div id="variantAssociationSummarySection">

</div>



