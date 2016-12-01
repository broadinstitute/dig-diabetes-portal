<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

</head>

<body>
<style>
.consortium-spacing {
    padding-top: 15px;
}
</style>

<div id="main">
    <div class="container">


        <div class="row">
            <div class="buttonHolder tabbed-about-page">



                <g:if test="${!g.portalTypeString()?.equals('stroke')}">

                    <div class="container dk-static-content">
                        <div class="row">
                        <h5 style="position:fixed; bottom:20px;"><a href="#"><g:message code="policies.tothetop"></g:message></a></h5>
                    <div class="col-md-3">
                        <h1><g:message code="policies.title"></g:message></h1>
                        <h4 class="dk-notice"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></h4>
                        <h4 class="dk-notice"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></h4>
                        <h4 class="dk-notice"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></h4>
                        <h4 class="dk-notice"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></h4>

                    </div>

                    <div class="col-md-9">

                    <h2 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h2>

                    <h3><g:message code="informational.policies.data_use.header"></g:message></h3>

                    <p><g:message code="informational.policies.data_use.section_1"></g:message></p>

                    <h3><g:message code="informational.policies.data_agg.title"></g:message></h3>

                    <p><g:message code="informational.policies.data_agg.section_1"></g:message></p>

                    <h4><g:message code="informational.policies.data_agg.header"></g:message></h4>

                    <p><g:message code="informational.policies.data_agg.section_2"></g:message></p>

                    <p><g:message code="informational.policies.data_agg.section_3"></g:message></p>

                    <p><g:message code="informational.policies.data_agg.section_4"></g:message></p>

                    <p><g:message code="informational.policies.data_agg.section_5"></g:message></p>

                    <h4><g:message code="informational.policies.example_datasets.header"></g:message></h4>

                    <p><ol><g:message code="informational.policies.example_datasets.section_1"></g:message></p></ol></p>

        <h4><g:message code="informational.policies.dataset_classes.header"></g:message></p></h4>

                    <p><ol><g:message code="informational.policies.dataset_classes.section_1"></g:message></p></ol></p>

        <h4><g:message code="informational.policies.data_transfer.header"></g:message></p></h4>

                    <p><g:message code="informational.policies.data_transfer.section_1"></g:message></p></p>

                    <p><a href='https://s3.amazonaws.com/broad-portal-resources/AMP-T2D_DTA_and_policies.pdf' target="_blank">
                        <g:message code="mainpage.click.here"/> <g:message code="informational.policies.data_transfer.section_2"/></p>
                    </a>

                    <p><g:message code="informational.dataSubmission.section6"></g:message></p>

                    <h4><g:message code="informational.policies.use_analysis.header"></g:message></h4>

                    <p><g:message code="informational.policies.use_analysis.section_1"></g:message></p>

                    <p><g:message code="informational.policies.use_analysis.section_2"></g:message></p>

                    <p><g:message code="informational.policies.use_analysis.section_3"></g:message></p>

                    <h4><g:message code="informational.policies.results_sharing.header"></g:message></h4>

                    <p><g:message code="informational.policies.results_sharing.section_1"></g:message></p>

                    <p><g:message code="informational.policies.results_sharing.section_2"></g:message></p>

                    <p><g:message code="informational.policies.results_sharing.section_3"></g:message></p>

                    <h4><u><g:message code="informational.policies.resource_sharing.header"></g:message></u></h4>

                    <p><g:message code="informational.policies.resource_sharing.section_1"></g:message></p>

                    <h4><g:message code="informational.policies.resource_sharing.source.header"></g:message></h4>

                    <p><g:message code="informational.policies.resource_sharing.section_2"></g:message></p>

                    <h4><g:message code="informational.policies.resource_sharing.services.header"></g:message></h4>

                    <p><g:message code="informational.policies.resource_sharing.section_3"></g:message></p>

                    <h4><g:message code="informational.policies.resource_sharing.groups.header"></g:message></h4>

                    <p><g:message code="informational.policies.resource_sharing.section_4"></g:message></p>

                    <h4><u><g:message code="informational.policies.data_release.header"></g:message></u></h4>

                    <h4><g:message code="informational.policies.data_release.process.header"></g:message></h4>

                    <p><g:message code="informational.policies.data_release.process.section_1"></g:message></p>

                    <p><g:message code="informational.policies.data_release.process.section_2"></g:message></p>

                    <p><g:message code="informational.policies.data_release.process.section_3"></g:message></p>

                    <p><g:message code="informational.policies.data_release.process.section_4"></g:message></p>

                    <p><g:message code="informational.policies.data_release.process.section_5"></g:message></p>

                    <p><g:message code="informational.policies.data_release.process.section_6"></g:message></p>

                    <h4><g:message code="informational.policies.data_release.timeline.header"></g:message></h4>

                    <img src="${resource(dir: 'images', file: g.message(code: "files.dataReleaseImage"))}" width="800"/>

                    <h4><g:message code="informational.policies.conduct.availability.header"></g:message></h4>

                    <p><g:message code="informational.policies.conduct.section_1"></g:message></p>

                    <h4><g:message code="informational.policies.conduct.registration.header"></g:message></h4>

                    <p><g:message code="informational.policies.conduct.section_2"></g:message></p>

                    <h4><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></h4>

                    <p><g:message code="informational.policies.conduct.section_3"></g:message></p>



                    <ol><g:message code="informational.policies.conduct.section_4"></g:message></ol>

                    <p><g:message code="informational.policies.conduct.section_5"></g:message></p>
                </g:if>
<g:else>
                <h1><g:message code="policies.title" default="Policies"/></h1>
    <div class="row pull-left medText col-xs-12">
    The Cerebrovascular Disease Knowledge Portal will (a) serve as the gateway to a large and growing aggregation of data relevant to the genetics of cerebrovascular disease and its complications; (b) automate analyses required to interpret those data; and (c) provide a customizable workspace for permitted investigators who wish to perform analyses not otherwise available on the Portal.
    </div>
</g:else>


</div>

</body>
</html>

