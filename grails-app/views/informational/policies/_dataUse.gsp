<div class="row pull-left medText consortium-spacing col-xs-12">
<h2><g:message code="policies.dataUse"/></h2>
</div>

<g:if test="${!g.portalTypeString()?.equals('stroke')}">
    <div class="row">
    <div class="col-xs-12">
        <h3><g:message code="informational.policies.data_use.header"/></h3>
        <g:message code="informational.policies.data_use.section_1"/>
        <h3><g:message code="informational.policies.data_agg.title"/></h3>
        <g:message code="informational.policies.data_agg.section_1"/>
        <h4><g:message code="informational.policies.data_agg.header"/></h4>
        <g:message code="informational.policies.data_agg.section_2"/>
        <g:message code="informational.policies.data_agg.section_3"/>
    <g:message code="informational.policies.data_agg.section_4"/>
        <g:message code="informational.policies.data_agg.section_5"/>
        <h4><g:message code="informational.policies.example_datasets.header"/></h4>
        <g:message code="informational.policies.example_datasets.section_1"/>
        <h4><g:message code="informational.policies.dataset_classes.header"/></h4>
        <g:message code="informational.policies.dataset_classes.section_1"/>
        <h4><g:message code="informational.policies.data_transfer.header"/></h4>
        <g:message code="informational.policies.data_transfer.section_1"/>
        <a href='https://s3.amazonaws.com/broad-portal-resources/AMP-T2D_DTA_and_policies_093016.pdf' target="_blank">
            <g:message code="mainpage.click.here"/>
        </a>
        <g:message code="informational.policies.data_transfer.section_2"/>
        <h4><g:message code="informational.policies.use_analysis.header"/></h4>
    <g:message code="informational.policies.use_analysis.section_1"/>
        <g:message code="informational.policies.use_analysis.section_2"/>
    <g:message code="informational.policies.use_analysis.section_3"/>
        <h4><g:message code="informational.policies.results_sharing.header"/></h4>
    <g:message code="informational.policies.results_sharing.section_1"/>
    <g:message code="informational.policies.results_sharing.section_2"/>
    <g:message code="informational.policies.results_sharing.section_3"/>
        <h4><u><g:message code="informational.policies.resource_sharing.header"/></u></h4>
        <g:message code="informational.policies.resource_sharing.section_1"/>
        <h4><g:message code="informational.policies.resource_sharing.source.header"/></h4>
        <g:message code="informational.policies.resource_sharing.section_2"/>
        <h4><g:message code="informational.policies.resource_sharing.services.header"/></h4>
        <g:message code="informational.policies.resource_sharing.section_3"/>
        <h4><g:message code="informational.policies.resource_sharing.groups.header"/></h4>
        <g:message code="informational.policies.resource_sharing.section_4"/>
        <h4><u><g:message code="informational.policies.data_release.header"/></u></h4>
        <h4><g:message code="informational.policies.data_release.process.header"/></h4>
        <g:message code="informational.policies.data_release.process.section_1"/>
        <g:message code="informational.policies.data_release.process.section_2"/>
        <g:message code="informational.policies.data_release.process.section_3"/>
        <g:message code="informational.policies.data_release.process.section_4"/>
        <g:message code="informational.policies.data_release.process.section_5"/>
        <g:message code="informational.policies.data_release.process.section_6"/>
        <h4><g:message code="informational.policies.data_release.timeline.header"/>:</h4>
        <img src="${resource(dir: 'images', file: g.message(code: "files.dataReleaseImage"))}"/>
        <h4><g:message code="informational.policies.conduct.availability.header"/></h4>
        <g:message code="informational.policies.conduct.section_1"/>
        <h4><g:message code="informational.policies.conduct.registration.header"/></h4>
        <g:message code="informational.policies.conduct.section_2"/>
        <h4><g:message code="informational.policies.conduct.user_responsibilities.header"/></h4>
        <g:message code="informational.policies.conduct.section_3"/>

        <g:message code="informational.policies.conduct.section_4"/>
    </div>
    </div>
</g:if>
<g:else>
    <div class="row pull-left medText consortium-spacing col-xs-12">
    The Broad Institute and Massachusetts General Hospital will aggregate data, support analyses, and continue to update capabilities to disseminate results relevant to the genetics of cerebrovascular disease and related traits, while coordinating collaboration within the Portal.
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
    <strong>Individual-level data will never be shared with Portal users.</strong> Individual-level data will reside in one or several data vaults behind a secure firewall. User-activated modules will be deployed behind the firewall to analyze the data or query precomputed results. The purpose of the Portal is to enable broad access to genetic information concerning cerebrovascular disease in a form that meets user needs while maintaining individual privacy requirements. Portal users are encouraged to provide feedback on the extent to which the Portal meets those goals.
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <h2>Data Deposition and Data Transfer Agreements</h2>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        Investigators who wish to deposit data into the Portal are encouraged to do so. For information on submitting individual-level data, please <a href="https://s3.amazonaws.com/broad-portal-resources/stroke/Stroke_SOP-R24IndividualLevelDataSubmission.docx">click here</a>. For information on submitting summary data, please <a href="https://s3.amazonaws.com/broad-portal-resources/stroke/Stroke_SOP-R24SummaryDataSubmission.docx">click here</a>
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <h2>Portal Access and Terms of Conduct</h2>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        <strong>User Registration</strong>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        To access the Portal, users must obtain a Google ID, which will be used for quality control and monitoring purposes.
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <strong>Data use and availability</strong>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        All users are welcome to employ Portal analysis results in their research without seeking explicit permission from the Portal team or funders. Users are also welcome to cite Portal-housed data in scientific publications, provided that they cite the Portal as the source. Users citing a single dataset from the Portal should cite both the Portal and the relevant paper for that dataset (if one has been published).
    </div>

    <div class="row pull-left medText consortium-spacing col-xs-12">
        <strong>User Responsibilities</strong>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        Portal users are expected to abide by the following provisions on data use:
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        <ol>
            <li>Users will not attempt to download any dataset in bulk from the Portal.</li>
            <li>Users will not attempt to identify or contact research participants.</li>
            <li>Users will protect data confidentiality.</li>
            <li>Users will not share any of the data with unauthorized users.</li>
            <li>Users will report any inadvertent data release, security breach, or other data management incidents of which they become aware.</li>
            <li>Users will abide by all applicable law and regulations for handling genomic data.</li>
            <li>Users will not submit a manuscript for publication until the Early Access Period is over (6 months after the clean dataset becomes available on the Portal).</li>
        </ol>
    </div>
    <div class="row pull-left medText consortium-spacing col-xs-12">
        Agreeing to these provisions is a requirement of Portal use. Violating them may result in an NIH investigation and sanctions including revocation of access to the Portal.
    </div>


</g:else>
