
<g:javascript>

$( document ).ready( function (){
    mpgSoftware.gaitBackgroundData = mpgSoftware.initializeGaitBackgroundData("${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}");
    mpgSoftware.burdenTestShared.storeGeneForGait('<%=geneName%>');
    mpgSoftware.burdenTestShared.setPortalTypeWithAncestry(true);
    mpgSoftware.burdenTestShared.retrieveExperimentMetadata( '#datasetFilter','${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}' );
    mpgSoftware.burdenTestShared.preloadInteractiveAnalysisData("${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
    "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
    "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
    "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
    "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
    "${createLink(controller: 'VariantInfo', action: 'variantInfo')}");


} );

</g:javascript>

<div class="accordion-group">
    <div class="${accordionHeaderClass}">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
            <g:if test="${modifiedTitle}">
                <h2><strong style="${modifiedTitleStyling}">${modifiedTitle}</strong></h2>
            </g:if>
            <g:else>
                <h2><strong>Genetic Association Interactive Tool</strong></h2>
            </g:else>

        </a>
    </div>

    <div id="collapseBurden" class="accordion-body collapse">
        <div class="accordion-inner">
            <div style="text-align: right;">
                <a href="https://s3.amazonaws.com/broad-portal-resources/GAIT_guide.pdf" target="_blank">GAIT guide</a>
            </div>
            <div class="container">
                <h5>
                    <g:if test="${modifiedGaitSummary}">
                        ${modifiedGaitSummary}
                    </g:if>
                    <g:else>
                        The Genetic Association Interactive Tool allows you to compute custom association statistics for this
                variant by specifying the phenotype to test for association, a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.
                         In order to protect patient privacy, GAIT will only allow visualization or analysis of data from more than 100 individuals.
                    </g:else>

                </h5>


                <div class="row burden-test-wrapper-options">

                    <r:img class="caatSpinner" uri="/images/loadingCaat.gif" alt="Loading GAIT data"/>



                    <div class="user-interaction">

                        <div id="chooseDataSetAndPhenotypeLocation"></div>

                        <div class="stratified-user-interaction"></div>

                        <div class="panel-group" id="accordion_iat" style="margin-bottom: 0px">%{--start accordion --}%
                            <div id="chooseVariantFilterSelection" id="chooseVariantFilterSelectionTool"></div>
                            <div id="chooseFiltersLocation"></div>
                            <div id="chooseCovariatesLocation"></div>
                        </div>

                    </div>
                    <div id="displayResultsLocation"></div>

                </div>

            </div>  %{--close container--}%

        </div>  %{--close accordion inner--}%
    <g:render template="/widgets/dataWarning" />
    </div>  %{--accordion body--}%
</div> %{--end accordion group--}%


%{--IAT results section--}%



