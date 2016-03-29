<!DOCTYPE html>
<html>
<head>
    <title>IGV - ${grailsApplication.config.site.title}</title>

    <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>

    <g:layoutHead/>
</head>

<body>
<style>
.spinner {
    position: fixed;
    top: 2px;
    right: 25%;
    margin-left: 0px; /* half width of the spinner gif */
    margin-top: 0px; /* half height of the spinner gif */
    text-align:center;
    z-index:1234;
    overflow: auto;
    width: 100px; /* width of the spinner gif */
    height: 102px; /*hight of the spinner gif +2px to fix IE8 issue */
}
</style>
<div id="spinner" class="spinner" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
</div>
<div id="header">
    <div id="header-top">
        <div class="container-fluid">
            <g:if test="${grailsApplication.config.site.version == 'sigma'}">

                <div id="language">
                    <form id="language-es" action="/i18n/setlang/" method="post">
                        <input type="hidden" name="language" value="es"/>
                    </form>

                    <form id="language-en-us" action="/i18n/setlang/" method="post">
                        <input type="hidden" name="language" value="en"/>
                    </form>
                    <a href="#" onclick="document.getElementById('language-es').submit();">
                        <img class="{% if LANGUAGE_CODE == 'es' %}currentlanguage{% endif %}"
                             src="images/Mexico.png" alt="Mexico"/>
                    </a>
                    <a href="#" onclick="document.getElementById('language-en-us').submit();">
                        <img class="{% if LANGUAGE_CODE == 'en' %}currentlanguage{% endif %}"
                             src="images/United-States.png" alt="USA"/>
                    </a>
                </div>

                <div id="branding">
                    SIGMA <strong>T2D</strong> <small>
                    %{--{% trans "a resource on the genetics of type 2 diabetes in Mexico" %}--}%
                </small>
                </div>
            </g:if>
            <g:elseif test="${grailsApplication.config.site.version == 't2dgenes'}">
                <div id="branding">
                	<g:message code="portal.header.title.short"/> <strong><g:message code="portal.header.title.genetics"/></strong> <small><g:message code="portal.header.title.beta"/></small>
                </div>
            </g:elseif>
        </div>
    </div>

    <div id="header-bottom">
        <div class="container-fluid">
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
                    <g:link controller='logout'><g:message code='mainpage.log.out'/></g:link>
                </div>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <div class="rightlinks">
                    <g:link controller='login' action='auth'><g:message code='mainpage.log.in'/></g:link>
                </div>
            </sec:ifNotLoggedIn>
            <g:if test="${grailsApplication.config.site.version == 't2dgenes'}">
                <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code='localized.home'/></a> &middot;
                <a href="${createLink(controller:'informational', action:'aboutthedata')}"><g:message code='localized.aboutTheData'/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code='localized.contact'/></a>
            </g:if>
            <g:elseif test="${grailsApplication.config.site.version == 'sigma'}">
                <a href="/query">{% trans "Query" %}</a> &middot;
                <a href="/">{% trans "About" %}</a> &middot;
                <a href="/contact">{% trans "Contact" %}</a>
            </g:elseif>
        </div>
    </div>
</div>

<g:layoutBody/>

<div id="footer">
    <div class="container-fluid">
        <div class="separator"></div>
        <div id="helpus"><a href="${createLink(controller:'informational', action:'contact')}"><g:message code='mainpage.send.feedback'/></a></div>
    </div>
</div>
<div id="belowfooter"></div>

</body>
</html>