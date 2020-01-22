<%@ page import="org.broadinstitute.mpg.RestServerService" %>
<script>
    $(document).ready(function() {
        mpgSoftware.homePage.retrieveAllPortalsInfo(
            {retrieveAllPortalsAjaxUrl:'<g:createLink controller="home" action="retrieveAllPortalsAjax"/>',
                currentPortalType:  '<%=g.portalTypeString()%>'
            }
        );
    });
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>
    <g:set var="restServer" bean="restServerService"/>

</script>

<div class="container-fluid header-bottom" id="header-bottom-${g.portalTypeString()}">

    <div class="logo-wrapper " style="position:relative; z-index: 1001; float: left;">
        <a href="${createLink(controller:'home',action:'portalHome')}">
            <img src="${resource( file:restServer.retrieveBeanForCurrentPortal().getLogoCode())}" style=" height: 50px; margin-left: 10px;" />
        </a>
    </div>

    <div class="menu-wrapper" style="float:right;">
        <ul class="dk-general-menu" style="list-style: none; float:right; margin:0; padding:10px 0 0 15px; text-align: right;">
            <li class="home-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;"><a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a></li>

            <li class="data-btn home-drop-down-menu" style="display:inline-block;margin-right:15px;padding-bottom: 15px;"><a href="javascript:;"><g:message code="portal.header.nav.about_data"/></a>
                <ul>
                    <g:if test="${g.portalTypeString()?.equals('v2f')}">
                        <li class="" style=""><a href="http://www.kp4cd.org/epigenetic_datasets/${g.portalTypeString()}">Epigenetic datasets</a></li>
                        <li class="" style=""><a href="http://www.kp4cd.org/datasets/${g.portalTypeString()}">Association datasets</a></li>
                    </g:if>
                    <g:else>
                        <li class="" style=""><a href="http://www.kp4cd.org/datasets/${g.portalTypeString()}">Datasets</a></li>
                    </g:else>

                    <li class="" style=""><a href="http://www.kp4cd.org/dataset_downloads/${g.portalTypeString()}">Downloads</a></li>
                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <li class="" style=""><a href="http://www.kp4cd.org/apis/${g.portalTypeString()}">APIs</a></li>
                    </g:if>
                </ul>
            </li>

            <li class="analysis-modules-btn home-drop-down-menu" style="display:inline-block;margin-right:15px;padding-bottom: 15px;"><a href="${createLink(controller:'informational', action:'modules')}">Tools</a>
                <ul>
                    <g:if test="${g.portalTypeString()?.equals('t2d')} || ${g.portalTypeString()?.equals('mi')}">
                        <!--<li class="" style=""><a href="javascript:;">Custom Association Analysis</a></li>-->
                    </g:if>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <g:if test="${restServer.retrieveBeanForCurrentPortal().exposeGrsModule}">
                            <li class="grs-btn" style=""><a href="${createLink(controller:'grs', action:'grsInfo')}"><g:message code="portal.header.nav.grs"/></a></li>
                        </g:if>
                    </g:if>

                    <g:if test="${g.portalTypeString() != 'v2f'}">
                        <li class="" style=""><a href="${createLink(controller:'trait', action:'traitSearch')}?trait=${g.defaultPhenotype()}&significance=0.0005"><g:message code="LD.clumping.header"/></a></li>
                    </g:if>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <li class="" style=""><a href="${createLink(controller:'gene',action:'effectorGeneTable')}">Predicted T2D Effector Genes</a></li>
                    </g:if>

                    <li class="" style=""><a href="${createLink(controller:'trait',action:'tissueTable')}">Tissue FOCUS</a></li>
                    <li class="" style=""><a href="${createLink(controller:'variantInfo',action:'variantTable')}">Variant FOCUS</a></li>
                    <li class="" style=""><a href="${createLink(controller:'variantInfo',action:'genomeBrowser')}">Genome browser</a></li>
                    <li class="" style=""><a href="${createLink(controller:'gene',action:'effectorGeneTable')}">Effector gene</a></li>

                    <g:if test="${g.portalTypeString() != 'v2f'}">
                        <li class="" style=""><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}"><g:message code="variant.search.header"/></a></li>
                    </g:if>



                </ul>
            </li>

            <li class="about-btn home-drop-down-menu" style="display:inline-block;margin-right:15px;padding-bottom: 15px;"><a href="javascript:;">Information</a>
                <ul>
                    <li class="" style=""><a href="http://www.kp4cd.org/about/${g.portalTypeString()}"><g:message code="portal.header.nav.about"/></a></li>

                    <g:if test="${g.portalTypeString()?.equals('t2d')}">
                        <li class="" style=""><a href="http://www.kp4cd.org/collaborate/${g.portalTypeString()}"><g:message code="portal.header.nav.submit"/></a></li>
                    </g:if>

                    <li class="" style=""><a href="http://www.kp4cd.org/policies/${g.portalTypeString()}"><g:message code="portal.header.nav.policies"/></a></li>

                    <li class="" style=""><a href="http://www.kp4cd.org/resources/${g.portalTypeString()}">Resources</a></li>

                    <li class="" style=""><a href="http://www.kp4cd.org/new_features/${g.portalTypeString()}">Blog</a></li>

                </ul>
            </li>

            <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;"><a href="http://www.kp4cd.org/contacts/${g.portalTypeString()}"><g:message code="portal.header.nav.contact_plural"/></a></li>


            <sec:ifLoggedIn>


                <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:-1px; margin-bottom:-1px; padding: 5px 0 5px 15px; ; border-left:solid 1px #aaaaaa;"><span class="user-name-initial" style="background-color: #93806c;"><sec:loggedInUserInfo field="username"/></span></li>
                <li id="userLogoutDisplay" title ="Log out" style="display:inline-block; margin-right:15px; border-radius: 0 5px 5px 0; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#7fc343; "><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>

                <sec:ifAllGranted roles="ROLE_ADMIN">
                    <li class="portal-settings-menu"><h5><span class="glyphicon glyphicon-cog" aria-hidden="true"></span></h5><ul>
                        <li><g:link controller='admin' action="users" class="mgr"><g:message code='site.layouts.option.manage_users'/></g:link></li>
                        <li>
                            <script>
                                function aa(selector){
                                    window.open('<g:createLink controller="home" action="pickPortal"/>'+'?portal='+$(selector).val(), '_self');
                                };
                            </script>
                            <select id="portal_typeSelector" name="portal_typeSelector" style="background-color: #588fd3; padding-top: 0px; margin: 2px; font-weight: bold"
                                    onchange="aa(this)">
                            </select>
                        </li>
                        <sec:ifAllGranted roles="ROLE_SYSTEM">
                            <li><g:link controller='system' action="systemManager"><g:message code='site.layouts.option.system_mgr'/></g:link></li>
                        </sec:ifAllGranted>
                    </ul>
                    </li>
                </sec:ifAllGranted>


            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <li class="login-btn" style="display:inline-block; margin-right:0px; padding: 5px 15px 5px 15px; border-left:solid 1px #ffffff;"><oauth:connect provider="google" id="google-connect-link"><g:message code="google.log.in"/></oauth:connect></li>
            </sec:ifNotLoggedIn>

            <li id="userNotificationDisplay" message='<g:message code="mainpage.user.notification"/>' style="display:inline-block; margin-left: -13px; text-align: left; margin-right:15px; border-radius: 5px; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#f68920; color: #fff; width: 75px; height: 21px; overflow: hidden; text-overflow: ellipsis; vertical-align: -6px;"><g:message code="mainpage.user.notification"/></li>
        </ul>

    </div>

</div>
