<div id="header-bottom" class="container-fluid dk-t2d-menu-banner" style="background-image:url(${resource(dir: 'images', file:'menu_bg.jpg')}); background-size:100% 100%;">
    <ul class="rightlinks nav nav-pills dk-t2d-menu">
        <sec:ifLoggedIn>
            <sec:ifAllGranted roles="ROLE_ADMIN">
                <li><g:link controller='admin' action="users" class="mgr"><g:message code='site.layouts.option.manage_users'/></g:link></li>
                <li><g:link controller='home' action="pickPortal" class="mgr"><g:message code='site.layouts.option.manage_skin'/></g:link></li>
            </sec:ifAllGranted>
            <sec:ifAllGranted roles="ROLE_SYSTEM">
                <li><g:link controller='system' action="systemManager"><g:message code='site.layouts.option.system_mgr'/></g:link></li>
            </sec:ifAllGranted>
            <li id="usernameDisplay"><a><sec:loggedInUserInfo field="username"/></a></li>
            <li><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
        </sec:ifLoggedIn>
        <sec:ifNotLoggedIn>
            <li><oauth:connect provider="google" id="google-connect-link"><g:message code="google.log.in"/></oauth:connect></li>
        </sec:ifNotLoggedIn>
    </ul>
    <g:renderT2dGenesSection>
        <ul class="nav nav-pills dk-t2d-menu">
            <li><a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a>
            <li><a href="${createLink(controller:'informational', action:'aboutthedata')}"><g:message code="portal.header.nav.about_data"/></a></li>
            <li><a href="${createLink(controller: 'home', action: 'tutorials')}"><g:message code="portal.header.nav.tutorials"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.header.nav.policies"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'forum')}"><g:message code="portal.header.nav.forum"/></a></li>
        </ul>
    </g:renderT2dGenesSection>
</div>