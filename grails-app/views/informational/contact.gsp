<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>

    </style>
</head>


<body>

<div id="main">
<g:if test="${g.portalTypeString()?.equals('t2d')}">
</g:if>
<g:else>
    %{--<h1><g:message code="contact.title.plural" default="Contact"/></h1>--}%
</g:else>

    <div class="container dk-static-content">


        <div class="row">
            <g:if test="${g.portalTypeString()?.equals('t2d')}">


                <div class="col-md-12">
                    <h1 class="dk-page-title"><g:message code="contact.header" /></h1>
                    </div>
                    <div class="col-md-9">
                        <h5 class="dk-under-header"><g:message code="contact.summary" /></h5>

                        <h5 class="dk-under-header"><g:message code="contact.getInTouch" />
                            <ul>
                                <li><g:message code="contact.option.contactTeam" /></li>
                                <li><g:message code="contact.option.forum" /></li>
                                <li><g:message code="contact.option.emailList" /></li>
                                <li><g:message code="contact.option.contribute" /></li>
                            </ul>
                        </h5>
                    </div>
                <div class="col-md-3" id="t2dImageHolder" style="padding-top: 15px;">
                    <div class="dk-t2d-blue dk-contact-button dk-right-column-buttons"><a href="mailto:help@type2diabetesgenetics.org" target="_blank">Contact the team for help</a></div>
                    <div class="dk-t2d-blue dk-forum-button dk-right-column-buttons"><a href="http://www.type2diabetesgenetics.org/informational/forum" target="_blank">Join the discussion in our forum</a></div>
                    <div class="dk-t2d-blue dk-email-button dk-right-column-buttons"><g:message code="contact.option.emailList" /></div>
                    <div class="dk-t2d-green dk-reference-button dk-right-column-buttons"><a href="https://s3.amazonaws.com/broad-portal-resources/sendingData.pdf" target="_blank">Guide to data submission</a></div>
                </div>
                    <div class="col-md-9">
                    <h3 class="dk-blue-bordered"><g:message code="contact.amp.t2dkp.team.title"></g:message></h3>

                <table class="dk-team-list"><g:message code="contact.amp.t2dkp.team.list"></g:message></table>


                    <h4 class="dk-blue-bordered"><g:message code="contact.methods.team.title"></g:message></h4>
                    <h4><g:message code="contact.methods.team.subtitle1"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.methods.team_ampmethods"></g:message></table>

                <h4><g:message code="contact.methods.team.subtitle2"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.methods.team_edp"></g:message></table>

                <h3><g:message code="contact.methods.team.subtitle3"></g:message></h3>

                <table class="dk-team-list"><g:message code="contact.methods.team_federated"></g:message></table>
                </div>
                     <div class="col-md-3 text-center" id="t2dImageHolder" style="padding-top: 10px;">
                        <p style="margin-top: 10px;"><a href="https://broadinstitute.org" target="_blank">

                            <img style="width:180px;" src="${resource(dir: 'images', file:'BroadInstLogoforDigitalRGB.png')}" />

                        </a></p>
                        <hr>

                        <p><a href="https://sph.umich.edu" target="_blank">

                            <img style="width:120px;" src="${resource(dir: 'images/organizations', file:'UM-SPH.png')}" />

                        </a></p>
                        <hr>

                        <p><a href="http://www.ox.ac.uk/" target="_blank">

                            <img style="width:120px;" src="${resource(dir: 'images/organizations', file:'University_of_Oxford.gif')}" />

                        </a></p>
                        <hr>

                        <p><a href="https://www.ebi.ac.uk" target="_blank">

                            <img style="width:180px;" src="${resource(dir: 'images/organizations', file:'EBI.png')}" />

                        </a></p>

                    </div>

                </div>
                </div>

                        </div>


            </g:if>


            <g:elseif test="${g.portalTypeString()?.equals('mi')}">

                <div class="row">
                    <div class="col-md-9">
                    <h4 class="dk-blue-bordered"><g:message code="informational.contact.MI.header1"></g:message></h4>
                <p><g:message code="informational.contact.MI-1"></g:message></p>
                        <p><g:message code="informational.contact.MI-2"></g:message></p>
                <h4 class="dk-blue-bordered"><g:message code="informational.contact.MI.header2"></g:message></h4>
                        <p><g:message code="informational.contact.MI.consortia"></g:message></p>

                </div></div>

                %{--<div class="buttonHolder tabbed-about-page">--}%

                    %{--<ul class="nav nav-pills">--}%
                        %{--<div class="row">--}%

                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_consortium" class="myPills activated">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.consortium" default="Consortium"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%
                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_cohort" class="myPills">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.cohort" default="Studies"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%
                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_portal" class="myPills active">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.portal" default="Portal"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%


                            %{--<div class="col-md-3 text-center">--}%
                            %{--</div>--}%

                        %{--</div>--}%

                    %{--</ul>--}%

                %{--</div>--}%


            </g:elseif>


            <g:else>
                %{--<div class="buttonHolder tabbed-about-page">--}%

                    %{--<ul class="nav nav-pills">--}%
                        %{--<div class="row">--}%

                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_consortium" class="myPills activated">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.consortium" default="Consortium"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%
                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_cohort" class="myPills">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.cohort" default="Studies"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%
                            %{--<div class="col-md-3 text-center">--}%
                                %{--<li role="presentation" id="contact_portal" class="myPills active">--}%
                                    %{--<a href="#">--}%
                                        %{--<g:message code="contact.portal" default="Portal"/>--}%
                                    %{--</a>--}%
                                %{--</li>--}%
                            %{--</div>--}%


                            %{--<div class="col-md-3 text-center">--}%
                            %{--</div>--}%

                        %{--</div>--}%

                    %{--</ul>--}%
                    %{--<g:render template="contact/stroke_consortium"/>--}%
                %{--<g:render template="contact/stroke_studies"/>--}%
                %{--<g:render template="contact/stroke_portal"/>--}%
                    %{--<div class="content">--}%
                        %{--<div id="contactContent">--}%
                            %{--<g:render template="contact/${specifics}"/>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</div>--}%

                <div id="main">

                    <p><g:message code="contact.portal.broadAttribution"></g:message></p>
                    <p><g:message code="contact.email.stroke"></g:message></p>
                    %{--<h2><g:message code="contact.portal"></g:message></h2>--}%
                    %{--<p><g:message code="contact.stroke.portal_team"></g:message></p>--}%

                <div class="row">
                <div class="col-md-9">
                <h4 class="dk-blue-bordered"><g:message code="contact.stroke.team.title"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.stroke.team.list"></g:message></table>






                </div>

            </g:else>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'contactsection')}",
                "#contactContent");
    </script>

</div>

</body>
</html>

