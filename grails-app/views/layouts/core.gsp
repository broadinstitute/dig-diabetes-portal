<!DOCTYPE html>
<html>
<head>
    %{--<title><g:layoutTitle default="Grails"/></title>--}%
<title>${grailsApplication.config.site.title}</title>

    <r:require modules="core"/>
    <r:layoutResources/>

    <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>



    <g:layoutHead/>
</head>

<body>
<style>
.spinner {
    position: fixed;
    top: 35%;
    left: 35%;
    margin-left: -50px; /* half width of the spinner gif */
    margin-top: -50px; /* half height of the spinner gif */
    text-align:center;
    z-index:1234;
    overflow: auto;
    width: 100px; /* width of the spinner gif */
    height: 102px; /*hight of the spinner gif +2px to fix IE8 issue */
}
</style>
<script>
    // for now let's error out in a noisy way. Submerge this when it's time for production mode
    function errorReporter(jqXHR, exception) {
        if (jqXHR.status === 0) {
            alert('Not connect.\n Verify Network.');
        } else if (jqXHR.status == 404) {
            alert('Requested page not found. [404]');
        } else if (jqXHR.status == 500) {
            alert('Internal Server Error [500].');
        } else if (exception === 'parsererror') {
            alert('Requested JSON parse failed.');
        } else if (exception === 'timeout') {
            alert('Time out error.');
        } else if (exception === 'abort') {
            alert('Ajax request aborted.');
        } else {
            alert('Uncaught Error.\n' + jqXHR.responseText);
        }
    }
</script>
<div id="spinner" class="spinner" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
</div>
<div id="header">
    <div id="header-top">
        <div class="container">
            <g:if test="${grailsApplication.config.site.version == 'sigma'}">

                <div id="language">
                    <form id="language-es" action="/i18n/setlang/" method="post">
                        %{--{% csrf_token %}--}%
                        <input type="hidden" name="language" value="es"/>
                    </form>

                    <form id="language-en-us" action="/i18n/setlang/" method="post">
                        %{--{% csrf_token %}--}%
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
                    Type 2 Diabetes <strong>Genetics</strong> <small>Beta</small>
                </div>
            </g:elseif>
        </div>
    </div>

    <div id="header-bottom">
        <div class="container">
            <sec:ifLoggedIn>
                <div class="rightlinks">
                    <sec:loggedInUserInfo field="username"/>   &middot;
                    <g:link controller='logout'>Log Out</g:link>
                </div>
            </sec:ifLoggedIn>
            <sec:ifNotLoggedIn>
                <div class="rightlinks">
                    <g:link controller='login' action='auth'>Login</g:link>
                </div>
            </sec:ifNotLoggedIn>
            %{--{% if user.is_authenticated %}--}%
            %{--<div class="rightlinks">--}%
                %{--{{ user.profile }} --}%%{-- --}%
                %{--User &middot;--}%
                %{--<a href="/logout">Log Out</a>--}%
            %{--</div>--}%
        %{--{% endif %}--}%
            <g:if test="${grailsApplication.config.site.version == 't2dgenes'}">
                <a href="${createLink(controller:'home',action:'portalHome')}">Home</a> &middot;
                <a href="${createLink(controller:'informational', action:'about')}">About The Data</a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}">Contact</a>
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
    <div class="container">
        <div class="separator"></div>
        <div id="helpus"><a href="${createLink(controller:'informational', action:'contact')}">Send feedback</a></div>
    </div>
</div>
<div id="belowfooter"></div>

</body>
</html>