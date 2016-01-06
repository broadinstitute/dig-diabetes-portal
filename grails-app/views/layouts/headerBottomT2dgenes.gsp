<div id="header-bottom">
    <div class="container">
        <sec:ifLoggedIn>
            <div class="rightlinks">
                <sec:ifAllGranted roles="ROLE_ADMIN">
                    <g:link controller='admin' action="users" class="mgr"><g:message code='site.layouts.option.manage_users'/></g:link>
                    &middot;
                </sec:ifAllGranted>
                <sec:ifAllGranted roles="ROLE_SYSTEM">
                    <g:link controller='system' action="systemManager"><g:message code='site.layouts.option.system_mgr'/></g:link>
                    &middot;
                </sec:ifAllGranted>
                <sec:loggedInUserInfo field="username"/>   &middot;
                <g:link controller='logout'><g:message code="mainpage.log.out"/></g:link>
            </div>
        </sec:ifLoggedIn>
        <sec:ifNotLoggedIn>
            <div class="rightlinks">
            <oauth:connect provider="google" id="google-connect-link"><g:message code="google.log.in"/></oauth:connect>
            </div>
        </sec:ifNotLoggedIn>
        <g:renderT2dGenesSection>
            <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a> &middot;
            <a href="${createLink(controller:'informational', action:'about')}"><g:message code="portal.header.nav.about"/></a> &middot;
            <a href="${createLink(controller: 'home', action: 'introVideoHolder')}"><g:message code="portal.header.nav.tutorials"/></a> &middot;
            <a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.header.nav.policies"/></a> &middot;
            <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a>&middot;
            <a href="${createLink(controller:'informational', action:'forum')}"><g:message code="portal.header.nav.forum"/></a>
            &middot;
            <a href="http://t2d-genetics-portal.blogspot.com"><g:message code="portal.header.nav.blog"/></a>
        </g:renderT2dGenesSection>
    </div>
</div>