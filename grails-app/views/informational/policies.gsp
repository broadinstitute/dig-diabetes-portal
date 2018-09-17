<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,sunburst"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

</head>
<body>
<div id="main">
<div class="container dk-static-content">
<div class="row">
<div class="col-md-12">
    <h1 class="dk-page-title"><g:message code="policies.title"></g:message></h1>
</div>

    <g:if test="${g.portalTypeString()?.equals('t2d')}">


                <div class="col-md-9">

                    <h3 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h3>

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

                    <p><g:message code="informational.policies.conduct.section_1a"></g:message></p>
                        <p><g:message code="informational.policies.conduct.section_1b"></g:message></p>
                        <p><g:message code="informational.policies.conduct.section_1c"></g:message></p>

                    <h4><g:message code="informational.policies.conduct.registration.header"></g:message></h4>

                    <p><g:message code="informational.policies.conduct.section_2"></g:message></p>

                    <h4><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></h4>

                    <p><g:message code="informational.policies.conduct.section_3"></g:message></p>



                    <ol><g:message code="informational.policies.conduct.section_4"></g:message></ol>

                    <p><g:message code="informational.policies.conduct.section_5"></g:message></p>


                        <h3 id="citing_data" class="dk-blue-bordered"><g:message code="policies.citations"></g:message></h3>
                        <p><g:message code="policies.citations.content1"></g:message></p>
                        <p><g:message code="policies.citations.content2"></g:message></p>
                        <p><g:message code="policies.citations.content3"></g:message></p>
                        <p><g:message code="policies.citations.content4"></g:message></p>
                        <p><g:message code="policies.citations.content5"></g:message></p>

                        <h3 id="reusing_text" class="dk-blue-bordered"><g:message code="informational.policies.data_reuse.header"></g:message></h3>
                        <p><g:message code="informational.policies.data_reuse.content"></g:message></p>


                        <h3 id="user_tracking" class="dk-blue-bordered"><g:message code="policies.tracking"></g:message></h3>
                        <p><g:message code="informational.policies.tracking.content"></g:message></p>




                    </div>
                <div class="col-md-3" style="padding-top: 20px;">
                    <h5 style="position:fixed; bottom:30px; margin-left:100px; z-index:50;"><a href="#"><span class="glyphicon glyphicon-arrow-up"></span> <g:message code="policies.tothetop"></g:message></a></h5>

                    <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></div>
                    <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></div>
                    <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></div>
                    <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></div>

                </div>

                </g:if>

        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <div class="col-md-9">

                <h2 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h2>

                <p> <g:message code="informational.policies.MI.subheader1"></g:message></p>

                <p><g:message code="informational.policies.MI.subheader2"></g:message></p>

                <p><g:message code="informational.policies.MI.subheader3"></g:message></p>

                %{--<h4><g:message code="informational.policies.stroke.deposition"></g:message></h4>--}%

                %{--<p><g:message code="informational.policies.stroke.submission1"></g:message>--}%
                %{--<ul><g:message code="informational.policies.stroke.submission2"></g:message></ul>--}%
            %{--</p>--}%




                <h4><g:message code="informational.policies.stroke.terms"></g:message></h4>

                <h5><u><g:message code="informational.policies.conduct.registration.header"></g:message></u></h5>

                <p><g:message code="informational.policies.MI.google"></g:message></p>

                <h5><u><g:message code="informational.policies.conduct.availability.header"></g:message></u></h5>
                <p><g:message code="informational.policies.conduct.stroke"></g:message></p>

                <h5><u><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></u></h5>

                <p><g:message code="informational.policies.conduct.section_3"></g:message></p>

                <ol><g:message code="informational.policies.MI.conduct.section_4"></g:message></ol>

                <p><g:message code="informational.policies.conduct.section_5"></g:message></p>


                <h2 id="citing_data" class="dk-blue-bordered"><g:message code="policies.citations"></g:message></h2>

                <p><g:message code="informational.policies.MI.citing"></g:message></p>

                <p><g:message code="portal.stroke.use.citation.request"></g:message></p>

                <p><g:message code="portal.mi.use.citation.itself"></g:message></p>


            </div>
            <div class="col-md-3" style="padding-top: 15px;">
                <h5 style="position:fixed; bottom:20px;"><a href="#"><span class="glyphicon glyphicon-arrow-up"></span> <g:message code="policies.tothetop"></g:message></a></h5>
                <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></div>
                <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></div>
                %{--<h4 class="dk-notice"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></h4>--}%
                %{--<h4 class="dk-notice"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></h4>--}%

            </div>

        </g:elseif>

    <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
        <div class="col-md-9">

            <h2 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h2>

            <p> <g:message code="informational.policies.epi.subheader1"></g:message></p>

            <p><g:message code="informational.policies.epi.subheader2"></g:message></p>

            <p><g:message code="informational.policies.epi.subheader3"></g:message></p>

            %{--<h4><g:message code="informational.policies.stroke.deposition"></g:message></h4>--}%

            %{--<p><g:message code="informational.policies.stroke.submission1"></g:message>--}%
            %{--<ul><g:message code="informational.policies.stroke.submission2"></g:message></ul>--}%
            %{--</p>--}%




            <h4><g:message code="informational.policies.stroke.terms"></g:message></h4>

            <h5><u><g:message code="informational.policies.conduct.registration.header"></g:message></u></h5>

            <p><g:message code="informational.policies.epi.google"></g:message></p>

            <h5><u><g:message code="informational.policies.conduct.availability.header"></g:message></u></h5>
            <p><g:message code="informational.policies.conduct.stroke"></g:message></p>

            <h5><u><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></u></h5>

            <p><g:message code="informational.policies.conduct.section_3"></g:message></p>

            <ol><g:message code="informational.policies.epi.conduct.section_4"></g:message></ol>

            <p><g:message code="informational.policies.conduct.section_5"></g:message></p>


            <h2 id="citing_data" class="dk-blue-bordered"><g:message code="policies.citations"></g:message></h2>

            <p><g:message code="informational.policies.epi.citing"></g:message></p>

            <p><g:message code="portal.stroke.use.citation.request"></g:message></p>

            <p><g:message code="portal.epi.use.citation.itself"></g:message></p>


        </div>
        <div class="col-md-3" style="padding-top: 15px;">
            <h5 style="position:fixed; bottom:20px;"><a href="#"><span class="glyphicon glyphicon-arrow-up"></span> <g:message code="policies.tothetop"></g:message></a></h5>
            <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></div>
            <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></div>
            %{--<h4 class="dk-notice"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></h4>--}%
            %{--<h4 class="dk-notice"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></h4>--}%

        </div>

    </g:elseif>

    <g:elseif test="${g.portalTypeString()?.equals('sleep')}">
        <div class="col-md-9">

            <h2 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h2>

            <p> <g:message code="informational.policies.sleep.subheader1"></g:message></p>

            <p><g:message code="informational.policies.sleep.subheader2"></g:message></p>

            <p><g:message code="informational.policies.sleep.subheader3"></g:message></p>

            %{--<h4><g:message code="informational.policies.stroke.deposition"></g:message></h4>--}%

            %{--<p><g:message code="informational.policies.stroke.submission1"></g:message>--}%
            %{--<ul><g:message code="informational.policies.stroke.submission2"></g:message></ul>--}%
            %{--</p>--}%




            <h4><g:message code="informational.policies.stroke.terms"></g:message></h4>

            <h5><u><g:message code="informational.policies.conduct.registration.header"></g:message></u></h5>

            <p><g:message code="informational.policies.sleep.google"></g:message></p>

            <h5><u><g:message code="informational.policies.conduct.availability.header"></g:message></u></h5>
            <p><g:message code="informational.policies.conduct.stroke"></g:message></p>

            <h5><u><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></u></h5>

            <p><g:message code="informational.policies.conduct.section_3"></g:message></p>

            <ol><g:message code="informational.policies.epi.conduct.section_4"></g:message></ol>

            <p><g:message code="informational.policies.conduct.section_5"></g:message></p>


            <h2 id="citing_data" class="dk-blue-bordered"><g:message code="policies.citations"></g:message></h2>

            <p><g:message code="informational.policies.sleep.citing"></g:message></p>

            <p><g:message code="portal.stroke.use.citation.request"></g:message></p>

            <p><g:message code="portal.sleep.use.citation.itself"></g:message></p>


        </div>
        <div class="col-md-3" style="padding-top: 15px;">
            <h5 style="position:fixed; bottom:20px;"><a href="#"><span class="glyphicon glyphicon-arrow-up"></span> <g:message code="policies.tothetop"></g:message></a></h5>
            %{--<div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></div>--}%
            %{--<div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></div>--}%
            %{--<h4 class="dk-notice"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></h4>--}%
            %{--<h4 class="dk-notice"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></h4>--}%

        </div>

    </g:elseif>
    <g:else>

            <div class="col-md-9">

                <h2 id="data_use" class="dk-blue-bordered"><g:message code="policies.dataUse"></g:message></h2>

                <p> <g:message code="informational.policies.stroke.subheader"></g:message></p>

                <p><g:message code="informational.policies.stroke.mission"></g:message></p>

                <p><g:message code="informational.policies.stroke.sharing"></g:message></p>

                <h4><g:message code="informational.policies.stroke.deposition"></g:message></h4>

                <p><g:message code="informational.policies.stroke.submission1"></g:message>
                <ul><g:message code="informational.policies.stroke.submission2"></g:message></ul>
                </p>




<h4><g:message code="informational.policies.stroke.terms"></g:message></h4>

                <h5><u><g:message code="informational.policies.conduct.registration.header"></g:message></u></h5>

                <p><g:message code="informational.policies.stroke.google"></g:message></p>

                <h5><u><g:message code="informational.policies.conduct.availability.header"></g:message></u></h5>
                <p><g:message code="informational.policies.conduct.stroke"></g:message></p>

                <h5><u><g:message code="informational.policies.conduct.user_responsibilities.header"></g:message></u></h5>

                <p><g:message code="informational.policies.conduct.section_3"></g:message></p>

                <ol><g:message code="informational.policies.conduct.section_4"></g:message></ol>

                <p><g:message code="informational.policies.conduct.section_5"></g:message></p>


                <h2 id="citing_data" class="dk-blue-bordered"><g:message code="policies.citations"></g:message></h2>

                <p><g:message code="informational.policies.stroke.citing"></g:message></p>

                <p><g:message code="portal.stroke.use.citation.request"></g:message></p>

                <p><g:message code="portal.stroke.use.citation.itself"></g:message></p>


            </div>
            <div class="col-md-3" style="padding-top: 10px;">
                <h5 style="position:fixed; bottom:30px; margin-left:100px; z-index:50;"><a href="#"><span class="glyphicon glyphicon-arrow-up"></span> <g:message code="policies.tothetop"></g:message></a></h5>

                <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#data_use"><g:message code="policies.dataUse"></g:message></a></div>
                <div class="dk-t2d-yellow dk-go-button dk-right-column-buttons"><a href="#citing_data"><g:message code="policies.citations"></g:message></a></div>
                %{--<h4 class="dk-notice"><a href="#reusing_text"><g:message code="policies.reusing"></g:message></a></h4>--}%
                %{--<h4 class="dk-notice"><a href="#user_tracking"><g:message code="policies.tracking"></g:message></a></h4>--}%

            </div>

    </g:else>

</div>
</div>
</div>

</body>
</html>

