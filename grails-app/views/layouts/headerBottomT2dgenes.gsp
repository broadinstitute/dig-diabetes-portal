<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="container-fluid" id="header-bottom" style="background-image:url(${resource(dir: 'images/stroke', file:'menu_header_bg_2017_stroke.png')}); background-size: 100% 100%; font-size: 14px; font-weight:300; padding:0; margin:0; ">
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('ibd')}">
    <div class="container-fluid" id="header-bottom" style="background-image:url(${resource(dir: 'images', file:'menu_header_bg_2017.png')}); background-size: 100% 100%; font-size: 14px; font-weight:300; padding:0; margin:0; ">
</g:elseif>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <div class="container-fluid" id="header-bottom" style="background-image:url(${resource(dir: 'images/mi', file:'menu_header_bg_2017_mi1.png')}); background-size: 100% 100%; font-size: 14px; font-weight:300; padding:0; margin:0; ">
</g:elseif>
<g:else>
    <div class="container-fluid" id="header-bottom" style="background-image:url(${resource(dir: 'images', file:'menu_header_bg_2017.png')}); background-size: 100% 100%; font-size: 14px; font-weight:300; padding:0; margin:0; ">
</g:else>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <div class="dk-logo-wrapper" style="position:relative; z-index: 1001; float: left;  width:350px; padding:12px 0 14px 0; ">
            <img src="${resource(dir: 'images/stroke', file:g.message(code:"files.stroke.header.logo", default:"stroke_header_logo.svg"))}" style=" width: 400px; margin-left: 10px;" />
        </g:if>
        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <div class="dk-logo-wrapper" style="position:relative; z-index: 1001; float: left; width:350px; padding:12px 0 14px 0;">
            <img src="${resource(dir: 'images/mi', file:g.message(code:"files.miBannerText", default:"mi_header_logo_2017.svg"))}" style=" width: 450px; margin-left: 10px;" />
        </g:elseif>
        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
            <div class="dk-logo-wrapper" style="position:relative; z-index: 1001; float: left; width:350px; padding:12px 0 14px 0;">
            <img src="${resource(dir: 'images/ibd', file:g.message(code:"files.ibd.front.logo", default:"files.ibd.front.logo"))}" style=" width: 400px; margin-left: 10px;" />
        </g:elseif>
        <g:else>
            <div class="dk-logo-wrapper" style="position:relative; z-index: 1001; float: left; width:350px; padding:12px 0 14px 0; ">
            <a href="${createLink(controller:'home',action:'portalHome')}">
                <img src="${resource(dir: 'images', file:g.message(code:"files.t2dBannerText", default:"t2d_logo.svg"))}" style=" width: 400px; margin-left: 16px;">
            </a>
        </g:else>
    </div>

<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="dk-menu-wrapper" style="position:relative; z-index: 1000; float:right; padding-left: 7px; width: 100%; margin-top:-50px; border-bottom:solid 1px #ffffff; background-image:url(${resource(dir: 'images/stroke', file:'menu_bg_2017_stroke.png')}); background-size:100% 100%; background-repeat:no-repeat; background-position: center right; ">
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('ibd')}">
    <div class="dk-menu-wrapper" style="position:relative; z-index: 1000; float:right; padding-left: 7px; width: 100%; margin-top:-50px; border-bottom:solid 1px #ffffff; background-image:url(${resource(dir: 'images', file:'menu_bg_2017_5.png')}); background-size:100% 100%; background-repeat:no-repeat; background-position: center right; ">
</g:elseif>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <div class="dk-menu-wrapper" style="position:relative; z-index: 1000; float:right; padding-left: 7px; width: 100%; margin-top:-50px; border-bottom:solid 1px #ffffff; background-image:url(${resource(dir: 'images/mi', file:'menu_band_2017_mi.png')}); background-size:100% 100%; background-repeat:no-repeat; background-position: center right; ">
</g:elseif>
<g:else>
    <div class="dk-menu-wrapper" style="position:relative; z-index: 1000; float:right; padding-left: 7px; width: 100%; margin-top:-50px; border-bottom:solid 1px #ffffff; background-image:url(${resource(dir: 'images', file:'menu_bg_2017_5.png')}); background-size:100% 100%; background-repeat:no-repeat; background-position: center right; ">
</g:else>

    <g:renderT2dGenesSection>
        <ul class="dk-general-menu" style="list-style: none; float:right; margin:0; padding:10px 0 0 15px; text-align: right;  ">
            <li class="home-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a>
            <li class="variant-search-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'variantSearch', action:'variantSearchWF')}"><g:message code="variant.search.header"/></a></li>
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
            <g:else>
                <li class="contact-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a></li>
                <li class="data-submission-btn" style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="${createLink(controller:'informational', action:'dataSubmission')}"><g:message code="portal.header.nav.submit"/></a></li>
                <li style="display:inline-block;margin-right:15px;padding-bottom: 15px;text-shadow: #333 0 1px 2px"><a href="https://t2d-genetics-portal.blogspot.com/" target="_blank"><g:message code="portal.header.nav.blog" default="blog" /></a></li>
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
                        <select name="portal_typeSelector" style="background-color: #588fd3; padding-top: 0px; margin: 2px; font-weight: bold"
                                onchange="aa(this)">
                            <option value="t2d" <%=(g.portalTypeString()=='t2d')?"selected":"" %>>T2D</option>
                            <option value="stroke" <%=(g.portalTypeString()=='stroke')?"selected":"" %>>Stroke</option>
                            <option value="mi" <%=(g.portalTypeString()=='mi')?"selected":"" %>>MI</option>
                            <option value="ibd" <%=(g.portalTypeString()=='ibd')?"selected":"" %>>IBD</option>
                        </select>
                        %{--<g:link controller='home' action="pickPortal" class="mgr"><g:message code='site.layouts.option.manage_skin'/></g:link>--}%
                    </li>
                </sec:ifAllGranted>
                <sec:ifAllGranted roles="ROLE_SYSTEM">
                    <li><g:link controller='system' action="systemManager"><g:message code='site.layouts.option.system_mgr'/></g:link></li>
                </sec:ifAllGranted>
                <li id="usernameDisplay" class="dk-user-name" style="display:inline-block; margin-right:15px; margin-bottom:-1px; padding: 5px 0 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><a><sec:loggedInUserInfo field="username"/></a></li>
                <li style="display:inline-block; margin-right:15px; padding: 5px 0 5px 0; text-shadow: #333 0 1px 2px"><g:link controller='logout'><g:message code="mainpage.log.out"/></g:link></li>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <li style="display:inline-block; margin-right:0px; padding: 5px 15px 5px 15px; text-shadow: #333 0 1px 2px; border-left:solid 1px #aaaaaa;"><oauth:connect provider="google" id="google-connect-link"><g:message code="google.log.in"/></oauth:connect></li>
            </sec:ifNotLoggedIn>
        </ul>
        </div>
    </g:renderT2dGenesSection>
</div>