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

<div class="container-fluid floop" id="header-bottom" style="background-image:url(${resource( file:restServer.retrieveBeanForCurrentPortal().getBackgroundGraphic())}); background-position: left bottom; font-size: 14px; font-weight:300; padding:0; margin:0; ">
    <div class="dk-logo-wrapper" style="position:relative; z-index: 1001; float: left;  width:350px; padding:12px 0 14px 0; ">
        <a href="${createLink(controller:'home',action:'portalHome')}">
            <img src="${resource( file:restServer.retrieveBeanForCurrentPortal().getLogoCode())}" style=" width: 400px; margin-left: 10px;" />
        </a>
    </div>
    <div class="dk-menu-wrapper" style="position:relative; z-index: 1000; float:right; padding-left: 7px; width: 100%; margin-top:-50px; border-bottom:solid 1px #ffffff; background-image:url(${resource( file:restServer.retrieveBeanForCurrentPortal().getMenuHeader())}); background-size:100% 100%; background-repeat:no-repeat; background-position: center right; ">

        <ul class="dk-general-menu" style="list-style: none; float:right; margin:0; padding:10px 0 0 15px; text-align: right;  ">
            <li class="home-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a>
            <li class="variant-search-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}"><g:message code="variant.search.header"/></a></li>
            <g:if test="${restServer.retrieveBeanForCurrentPortal().exposeGrsModule}">
                <li class="grs-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'grs', action:'grsInfo')}"><g:message code="portal.header.nav.grs"/></a></li>
            </g:if>
            <li class="data-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'data')}"><g:message code="portal.header.nav.about_data"/></a></li>
            <li class="about-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'about')}"><g:message code="portal.header.nav.about"/></a></li>
            <li class="policies-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.header.nav.policies"/></a></li>
            <li class="tutorials-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller: 'home', action: 'tutorials')}"><g:message code="portal.header.nav.tutorials"/></a></li>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
                %{--<li class="downloads-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'downloads')}"><g:message code="portal.header.nav.downloads"/></a></li>--}%
                <li style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="https://CV-disease-portal.blogspot.com/" target="_blank"><g:message code="portal.header.nav.blog" default="blog" /></a></li>

            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
                <li style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="https://cvdgenetics.blogspot.com/" target="_blank"><g:message code="portal.header.nav.blog" default="blog" /></a></li>
            </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
            </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('t2d')}">
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a></li>
                <li class="data-submission-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.header.nav.submit"/></a></li>
                <li style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="https://t2d-genetics-portal.blogspot.com/" target="_blank"><g:message code="portal.header.nav.blog" default="blog" /></a></li>
            </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
            </g:elseif>
            <g:else>
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
            </g:else>
            <sec:ifLoggedIn>
            <sec:ifAllGranted roles="ROLE_ADMIN">
               <li style="display:inline-block; margin-right:15px; padding: 5px 0 5px 0; text-shadow: #333 0 1px 2px"><g:link controller='admin' action="users" class="mgr"><g:message code='site.layouts.option.manage_users'/></g:link></li>
               <li style="display:inline-block; margin-right:15px; padding: 5px 0 5px 0; text-shadow: #333 0 1px 2px">
                   <script>
                       function aa(selector){
                           window.open('<g:createLink controller="home" action="pickPortal"/>'+'?portal='+$(selector).val(), '_self');
                       };
                   </script>
                   <select id="portal_typeSelector" name="portal_typeSelector" style="background-color: #588fd3; padding-top: 0px; margin: 2px; font-weight: bold"
                           onchange="aa(this)">
                   </select>
                    </li>
            </sec:ifAllGranted>
           <sec:ifAllGranted roles="ROLE_SYSTEM">
               <li><g:link controller='system' action="systemManager"><g:message code='site.layouts.option.system_mgr'/></g:link></li>
           </sec:ifAllGranted>
           <g:if test="${g.portalTypeString()?.equals('stroke')}">
               <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:-1px; margin-bottom:-1px; padding: 5px 0 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><span class="user-name-initial" style="background-color: #93806c;"><sec:loggedInUserInfo field="username"/></span></li>
               <li id="userLogoutDisplay" title ="Log out" style="display:inline-block; margin-right:15px; border-radius: 0 5px 5px 0; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#7fc343; "><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
           </g:if>
           <g:elseif test="${g.portalTypeString()?.equals('mi')}">
               <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:-1px; margin-bottom:-1px; padding: 5px 0 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><span class="user-name-initial" style="background-color: #00b1f0;"><sec:loggedInUserInfo field="username"/></span></li>
               <li id="userLogoutDisplay" title ="Log out" style="display:inline-block; margin-right:15px; border-radius: 0 5px 5px 0; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#7fc343; "><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
           </g:elseif>
            <g:elseif  test="${g.portalTypeString()?.equals('t2d')}">
                <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:-1px; margin-bottom:-1px; padding: 5px 0 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><span class="user-name-initial dk-t2d-green"><sec:loggedInUserInfo field="username"/></span></li>
                <li id="userLogoutDisplay" title ="Log out" style="display:inline-block; margin-right:15px; border-radius: 0 5px 5px 0; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; " class="dk-t2d-blue"><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
            </g:elseif>
           <g:else>
               <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:-1px; margin-bottom:-1px; padding: 5px 0 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><span class="user-name-initial dk-t2d-green"><sec:loggedInUserInfo field="username"/></span></li>
               <li id="userLogoutDisplay" title ="Log out" style="display:inline-block; margin-right:15px; border-radius: 0 5px 5px 0; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; " class="dk-t2d-blue"><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
           </g:else>
           </sec:ifLoggedIn>
       <sec:ifNotLoggedIn>
           <li style="display:inline-block; margin-right:0px; padding: 5px 15px 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><oauth:connect provider="google" id="google-connect-link"><g:message code="google.log.in"/></oauth:connect></li>
       </sec:ifNotLoggedIn>
       <g:if test="${g.portalTypeString()?.equals('stroke')}">
           <li id="userNotificationDisplay" message='<g:message code="mainpage.user.notification"/>' style="display:inline-block; margin-left: -13px; text-align: left; margin-right:15px; border-radius: 5px; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#f68920; color: #fff; width: 75px; height: 21px; overflow: hidden; text-overflow: ellipsis; vertical-align: -6px;"><g:message code="mainpage.user.notification"/></li>
       </g:if>
       <g:elseif test="${g.portalTypeString()?.equals('mi')}">
           <li id="userNotificationDisplay" message='<g:message code="mainpage.user.notification"/>' style="display:inline-block; margin-left: -13px; text-align: left; margin-right:15px; border-radius: 5px; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#f68920; color: #fff; width: 75px; height: 21px; overflow: hidden; text-overflow: ellipsis; vertical-align: -6px;"><g:message code="mainpage.user.notification"/></li>
       </g:elseif>
       <g:else>
           <li id="userNotificationDisplay" message='<g:message code="mainpage.user.notification"/>' style="display:inline-block; margin-left: -13px; text-align: left; margin-right:15px; border-radius: 5px; padding: 2px 5px 2px 5px; font-size: 12px;text-shadow: none; background-color:#f68920; color: #fff; width: 75px; height: 21px; overflow: hidden; text-overflow: ellipsis; vertical-align: -6px;"><g:message code="mainpage.user.notification"/></li>
       </g:else>
   </ul>
   </div>

</div>