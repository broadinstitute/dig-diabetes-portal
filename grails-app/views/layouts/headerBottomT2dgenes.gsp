<div id="header-bottom" class="container-fluid dk-t2d-menu-banner" style="background-image:url(${resource(dir: 'images', file:'menu_bg.jpg')}); background-size:100% 100%;">
    <ul class="container-fluid rightlinks nav nav-pills dk-t2d-menu">
        <sec:ifLoggedIn>
            <sec:ifAllGranted roles="ROLE_ADMIN">
                <li><g:link controller='admin' action="users" class="mgr"><g:message code='site.layouts.option.manage_users'/></g:link></li>
                <li>
                    <script>
                        function aa(selector){
                            window.open('<g:createLink controller="home" action="pickPortal"/>'+'?portal='+$(selector).val(), '_self');
                        };
                    </script>
                    <select name="portal_typeSelector" style="background-color: #588fd3; padding-top: 0px; margin: 2px; font-weight: bold"
                    onchange="aa(this)">
                        <option value="t2d" <%=(g.portalTypeString()=='t2d')?"selected":"" %>>T2D</option>
                        <option value="stroke" <%=(g.portalTypeString()=='stroke')?"selected":"" %>>Stroke</option>
                        <option value="mi" <%=(g.portalTypeString()=='mi')?"selected":"" %>>MI</option>
                    </select>
                    %{--<g:link controller='home' action="pickPortal" class="mgr"><g:message code='site.layouts.option.manage_skin'/></g:link>--}%
                </li>
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
            <li><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}"><g:message code="variant.search.header"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'data')}"><g:message code="portal.header.nav.about_data"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'about')}"><g:message code="portal.header.nav.about"/></a></li>
            <li><a href="${createLink(controller:'informational', action:'policies')}"><g:message code="portal.header.nav.policies"/></a></li>
            <li><a href="${createLink(controller: 'home', action: 'tutorials')}"><g:message code="portal.header.nav.tutorials"/></a></li>
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <li><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
                <li><a href="${createLink(controller:'informational', action:'downloads')}"><g:message code="portal.header.nav.downloads"/></a></li>
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <li><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact_plural"/></a></li>
            </g:elseif>
            <g:else>
                <li><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a></li>
                <li><a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.header.nav.submit"/></a></li>
                <li><a href="https://t2d-genetics-portal.blogspot.com/" target="_blank"><g:message code="portal.header.nav.blog" default="blog" /></a></li>
            </g:else>
        </ul>
    </g:renderT2dGenesSection>
</div>