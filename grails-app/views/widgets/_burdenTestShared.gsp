
<g:javascript>

$( document ).ready( function (){

    mpgSoftware.burdenTestShared.buildGaitInterface('.gaitSectionGoesHere',{
            accordionHeaderClass:'${accordionHeaderClass}',
            modifiedTitle:'${modifiedTitle}',
            modifiedTitleStyling:'${modifiedTitleStyling}',
            allowExperimentChoice: ${allowExperimentChoice},
            allowPhenotypeChoice : ${allowPhenotypeChoice},
            allowStratificationChoice: ${allowStratificationChoice}
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

} );

</g:javascript>

<div class="row">
    <div class="gaitSectionGoesHere col-xs-12"></div>
</div>

%{--IAT results section--}%



