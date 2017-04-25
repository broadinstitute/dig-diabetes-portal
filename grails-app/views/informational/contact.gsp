<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>

        .dk-static-content {
            padding-top: 30px;
        }

        .dk-under-header {
            font-weight: 300; line-height: 20px; font-size: 16px;
        }

        .dk-notice {
            padding: 10px 20px 10px 20px;
            margin: 10px 0 10px 0;
            background-color: #7aa1fc;
            color: #fff;
            background-image:url(../images/logo_bg2.jpg);
            background-repeat:no-repeat;
            background-size:100% 100%;

        }

        .dk-notice a {
            color:#def;
            font-weight: 200;
            font-size: 18px;
        }

        .dk-notice p {
            margin-bottom: 0;
        }

        .dk-notice-header {
            font-size: 26px;
            font-weight: 100;
        }

        .dk-blue-bordered {
            display:block;
            border-top: solid 1px #39F;
            border-bottom: solid 1px #39F;
            color: #39f;
            padding: 5px 0;
            text-align:left;
            line-height:22px;
        }
        .dk-team-list {
            width: 100%;
            font-size: 14px;
            line-height: 22px;
        }

        .dk-team-list td:last-child {
            width: 50%;
        }

        .dk-team-list td {
            padding-right: 25px;
            padding-bottom: 15px;
            vertical-align:top;
        }

        .dk-team-list strong {
            float: right;
        }

        .dk-team-list td > p {
            padding-left: 15px;
        }

    </style>
</head>


<body>

<div id="main">
<g:if test="${g.portalTypeString()?.equals('t2d')}">
</g:if>
<g:else>
    <h1><g:message code="contact.title.plural" default="Contact"/></h1>
</g:else>

    <div class="container dk-static-content">


        <div class="row">
            <g:if test="${g.portalTypeString()?.equals('t2d')}">


                <div class="col-md-12">
                    <h1><g:message code="contact.header" /></h1>

                    <h5 class="dk-under-header"><g:message code="contact.summary" /></h5>

                    <h5 class="dk-under-header"><g:message code="contact.getInTouch" />
                        <ul>
                            <li><g:message code="contact.option.contactTeam" /></li>
                            <li><g:message code="contact.option.forum" /></li>
                            <li><g:message code="contact.option.emailList" /></li>
                            <li><g:message code="contact.option.contribute" /></li>
                        </ul><h5>
                    </div></div>

                <div class="row">
                    <div class="col-md-9">
                    <h4 class="dk-blue-bordered"><g:message code="contact.amp.t2dkp.team.title"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.amp.t2dkp.team.list"></g:message></table>


                    <h4 class="dk-blue-bordered"><g:message code="contact.methods.team.title"></g:message></h4>
                    <h4><g:message code="contact.methods.team.subtitle1"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.methods.team_ampmethods"></g:message></table>

                <h4><g:message code="contact.methods.team.subtitle2"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.methods.team_edp"></g:message></table>

                <h4><g:message code="contact.methods.team.subtitle3"></g:message></h4>

                <table class="dk-team-list"><g:message code="contact.methods.team_federated"></g:message></table>
                </div>

                     <div class="col-md-3 text-center" id="t2dImageHolder">
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

                <div class="buttonHolder tabbed-about-page">

                    <ul class="nav nav-pills">
                        <div class="row">

                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_consortium" class="myPills activated">
                                    <a href="#">
                                        <g:message code="contact.consortium" default="Consortium"/>
                                    </a>
                                </li>
                            </div>
                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_cohort" class="myPills">
                                    <a href="#">
                                        <g:message code="contact.cohort" default="Studies"/>
                                    </a>
                                </li>
                            </div>
                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_portal" class="myPills active">
                                    <a href="#">
                                        <g:message code="contact.portal" default="Portal"/>
                                    </a>
                                </li>
                            </div>


                            <div class="col-md-3 text-center">
                            </div>

                        </div>

                    </ul>

                </div>


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
                    <g:render template="contact/stroke_consortium"/>
                <g:render template="contact/stroke_studies"/>
                <g:render template="contact/stroke_portal"/>
                    %{--<div class="content">--}%
                        %{--<div id="contactContent">--}%
                            %{--<g:render template="contact/${specifics}"/>--}%
                        %{--</div>--}%
                    %{--</div>--}%
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

