
<g:javascript>

$( document ).ready( function (){
    mpgSoftware.burdenTestShared.buildGaitInterface('.gaitSectionGoesHere',{
            accordionHeaderClass:'${accordionHeaderClass}',
            modifiedTitle:'${modifiedTitle}',
            modifiedTitleStyling:'${modifiedTitleStyling}'
    },
    '${geneName}',
    true,
    '#datasetFilter',
    '${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}',
    "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
    "${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
    "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
    "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
    "${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
    "${createLink(controller: 'VariantInfo', action: 'variantInfo')}",
    "${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",
    "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}");
    %{--mpgSoftware.burdenTestShared.initializeGaitUi('.gaitSectionGoesHere',{--}%
            %{--accordionHeaderClass:'${accordionHeaderClass}',--}%
            %{--modifiedTitle:'${modifiedTitle}',--}%
            %{--modifiedTitleStyling:'${modifiedTitleStyling}'--}%
    %{--});--}%
    %{--mpgSoftware.burdenTestShared.storeGeneForGait('<%=geneName%>');--}%
    %{--mpgSoftware.burdenTestShared.setPortalTypeWithAncestry(true);--}%
    %{--mpgSoftware.burdenTestShared.retrieveExperimentMetadata( '#datasetFilter','${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}' );--}%
    %{--mpgSoftware.burdenTestShared.preloadInteractiveAnalysisData("${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",--}%
    %{--"${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",--}%
    %{--"${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",--}%
    %{--"${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",--}%
    %{--"${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",--}%
    %{--"${createLink(controller: 'VariantInfo', action: 'variantInfo')}",--}%
    %{--"${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",--}%
    %{--"${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}");--}%


} );

</g:javascript>

<div class="row">
    <div class="gaitSectionGoesHere col-xs-12"></div>
</div>

%{--IAT results section--}%



