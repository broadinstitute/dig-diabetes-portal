<g:applyLayout name="innerCore">
<html>
<head>
    <title><g:layoutTitle/></title>


    <r:require modules="core"/>
    <r:layoutResources/>


    <g:layoutHead/>

    %{--<g:layoutHead/>--}%
    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-54286044-1', 'auto');
        ga('send', 'pageview');

    </script>
</head>

<body>

<g:javascript src="lib/bootstrap.min.js" />

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
        <div class="container">
            <% def locale = RequestContextUtils.getLocale(request) %>
            <g:renderSigmaSection>
                <span id="language">
                    <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'><i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/Mexico.png" alt="Mexico"/></i></a>
                    %{--<a href="/dig-diabetes-portal/home?lang=en"> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>--}%
                    <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>
                </span>
                <a style="margin: 0; padding: 0" href="${createLink(controller: 'home', action:'portalHome')}">
                    <div id="branding">
                        SIGMA <strong>T2D</strong> <small><g:rendersSigmaMessage messageSpec="site.subtext"/></small>
                    </div>
                </a>
            </g:renderSigmaSection>
            <g:renderNotSigmaSection>
                <a style="margin: 0; padding: 0" href="${createLink(controller: 'home', action:'portalHome')}">
                    <div id="branding">
                        Type 2 Diabetes <strong>Genetics</strong> <small>Beta</small>
                    </div>
                </a>
            </g:renderNotSigmaSection>
        </div>
    </div>

    <div id="header-bottom">
        <div class="container">
            <sec:ifLoggedIn>
                <div class="rightlinks">
                    <sec:ifAllGranted roles="ROLE_ADMIN">
                        <g:link controller='admin' action="users" class="mgr">manage  users</g:link>
                        &middot;
                    </sec:ifAllGranted>
                    <sec:ifAllGranted roles="ROLE_SYSTEM">
                        <g:link controller='system' action="systemManager">System Mgr</g:link>
                        &middot;
                    </sec:ifAllGranted>
                    <sec:loggedInUserInfo field="username"/>   &middot;
                    <g:link controller='logout'><g:message code="mainpage.log.out"/></g:link>
                </div>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <div class="rightlinks">
                    <g:link controller='login' action='auth'><g:message code="mainpage.log.in"/></g:link>
                </div>
            </sec:ifNotLoggedIn>
            <g:renderSigmaSection>
                <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'aboutSigma')}"><g:message code="localized.aboutTheData"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="localized.contact"/></a>
            </g:renderSigmaSection>
            <g:renderNotSigmaSection>
                <a href="${createLink(controller:'informational', action:'about')}"><g:message code="portal.header.nav.about"/></a>
                <a href="#"><g:message code="portal.header.nav.tutorials"/></a>
                <a href="#"><g:message code="portal.header.nav.policies"/></a>
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="portal.header.nav.contact"/></a>
            %{--<a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a>--}%


            </g:renderNotSigmaSection>
        </div>
    </div>
</div>


</body>
</html>
</g:applyLayout>