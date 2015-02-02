<!DOCTYPE html>
<html>
<head>
    <title>log in</title>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
<style>
.googleLoginButton a {
    color: white;
}
</style>

<div id="main">

    <div class="container">

        <div class="row">
            <div class="col-md-8 col-md-offset-2 login-header">
                <p>
                    <g:message code="google.login.page.intro" default="welcome, go get yourself a Google account" />
                </p>
            </div>
            <div class="col-md-2"></div>
        </div>

        <div class="row">
            <div class="center-block col-xs-12 text-center">

                <s2o:ifNotLoggedInWith provider="google">
                    <div class="btn btn-primary btn-lg googleLoginButton text-center">
                        <oauth:connect provider="google" id="google-connect-link"><g:message
                                code="google.log.in"/></oauth:connect>
                    </div>

                </s2o:ifNotLoggedInWith>

            </div>

        </div>
    </div>

</div>

</body>
</html>
