<!DOCTYPE html>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<html>
<head>
<title>${grailsApplication.config.site.title}</title>

    <r:require modules="core"/>
    <r:layoutResources/>

    <link href='http://fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'>



    <g:layoutHead/>
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
<script>
    // Whatever else happens we want to be able to get to the error reporter. Therefore I'll put it here, as opposed
    //  to locating it and a JavaScript library that might not get loaded ( which might be why we need to report an error in the first place)
    var core = core || {};
    // for now let's error out in a noisy way. Submerge this when it's time for production mode
    core.errorReporter = function (jqXHR, exception) {
        // we have three ways to report errors. 1) to the console, via alert, or through a post.
        var consoleReporter=true,
            alertReporter = false,
            postReporter = true,
                errorText = "" ;
        if (consoleReporter  || alertReporter || postReporter)  {
             if ( typeof jqXHR !== 'undefined') {
                 if (jqXHR.status === 0) {
                     errorText += 'status == 0.  Not connected?\n Or page abandoned prematurely?';
                 } else if (jqXHR.status == 404) {
                     errorText += 'Requested page not found. [404]';
                 } else if (jqXHR.status == 500) {
                     errorText += 'Internal Server Error [500].';
                 } else {
                     errorText += 'Uncaught Error.\n' + jqXHR.responseText;
                 }
             }
             if ( typeof exception !== 'undefined') {
                 if (exception === 'parsererror') {
                     errorText += 'Requested JSON parse failed.';
                 } else if (exception === 'timeout') {
                     errorText += 'Time out error.';
                 } else if (exception === 'abort') {
                     errorText += 'Ajax request aborted.';
                 } else {
                     errorText += 'exception text ='+exception;
                 }
             }
            var date=new Date();
            errorText += '\nError recorded at '+date.toString();
            if (consoleReporter)  {
                console.log(errorText);
            }
            if (alertReporter)  {
                console.log(errorText);
            }
            if (postReporter)  {
                $.ajax({
                    cache:false,
                    type:"post",
                    url:"${createLink(controller:'home', action:'errorReporter')}",
                    data:{'errorText':errorText},
                    async:true,
                    success: function (data) {
                        if (consoleReporter)  {
                            console.log('error successfully posted');
                        }
                    },
                    error: function(xhr, ex) {
                        if (consoleReporter)  {
                            console.log('error posting unsuccessful');
                        }
                    }
                });

            }
        }
   }
</script>
<div id="spinner" class="spinner" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
</div>
<div id="header">
    <div id="header-top">
        <div class="container">
            <% def locale = RequestContextUtils.getLocale(request) %>
            <g:if test="${grailsApplication.config.site.version == 'sigma'}">

                <span id="language">
                    <a href="/dig-diabetes-portal/home/index?lang=es"><i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/Mexico.png" alt="Mexico"/></i></a>
                    <a href="/dig-diabetes-portal/home/index?lang=en"> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>
                </span>

                <div id="branding">
                    SIGMA <strong>T2D</strong> <small><g:message code="site.subtext"/></small>
                </div>
            </g:if>
            <g:elseif test="${grailsApplication.config.site.version == 't2dgenes'}">
                <div id="branding">
                    Type 2 Diabetes <strong>Genetics</strong> <small>${grailsApplication.config.site.subtext}</small>
                </div>
            </g:elseif>
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
            <g:if test="${grailsApplication.config.site.version == 'sigma'}">
                <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'aboutSigma')}"><g:message code="localized.aboutTheData"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="localized.contact"/></a>
            </g:if>
            <g:elseif test="${grailsApplication.config.site.version == 't2dgenes'}">
                <a href="${createLink(controller:'home',action:'portalHome')}"><g:message code="localized.home"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'about')}"><g:message code="localized.aboutTheData"/></a> &middot;
                <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="localized.contact"/></a>
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