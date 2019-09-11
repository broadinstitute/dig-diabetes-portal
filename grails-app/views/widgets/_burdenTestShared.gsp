
<g:javascript>

$( document ).ready( function (){

    mpgSoftware.burdenTestShared.buildGaitInterface('.gaitSectionGoesHere',{
            accordionHeaderClass:'${accordionHeaderClass}',
            modifiedTitle:'${modifiedTitle}',
            modifiedTitleStyling:'${modifiedTitleStyling}',
            allowExperimentChoice: ${allowExperimentChoice},
            allowPhenotypeChoice : ${allowPhenotypeChoice},
            allowStratificationChoice: ${allowStratificationChoice},
            grsVariantSet:'${grsVariantSet}',
            modifiedGaitSummary:'${modifiedGaitSummary}'||('<g:message code="singleVariantTesting.label.introduction.p1" default="GAIT test" />'+
                                    '<g:message code="singleVariantTesting.label.introduction.p2" default="" />'),
            modifiedInitialInstruction:'${modifiedInitialInstruction}'||'<g:message code="singleVariantTesting.label.initial.user.instruction" default="" />',
            standAloneTool:'${standAloneTool}'
        },
        '${geneName}',
        true,
        '#datasetFilter',{
                sampleMetadataExperimentAjaxUrl:"${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}",
                sampleMetadataAjaxWithAssumedExperimentUrl:"${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
                variantOnlyTypeAheadUrl:"${createLink(controller: 'gene', action: 'variantOnlyTypeAhead')}",
                sampleMetadataAjaxUrl:"${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjax')}",
                generateListOfVariantsFromFiltersAjaxUrl:"${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
                retrieveSampleSummaryUrl:"${createLink(controller: 'VariantInfo', action: 'retrieveSampleSummary')}",
                variantInfoUrl:"${createLink(controller: 'VariantInfo', action: 'variantInfo')}",
                variantAndDsAjaxUrl:"${createLink(controller: 'variantInfo', action: 'variantAndDsAjax')}",
                burdenTestVariantSelectionOptionsAjaxUrl:"${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}",
                getGRSListOfVariantsAjaxUrl:"${createLink(controller:'grs',action: 'getGRSListOfVariantsAjax')}"
            }
        );
console.log('${geneName}');
} );

</g:javascript>

<div class="">
    <div class="gaitSectionGoesHere"></div>
</div>
