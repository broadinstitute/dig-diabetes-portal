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
                <p>Welcome to this prototype portal for data from large genetic studies of type 2 diabetes. In order to access the site you must have a Google log in name.  These accounts are free
                and take only a minute or two to create. If you would like to create such an account then click on the following
                    <a href="https://accounts.google.com/SignUp?service=oz&continue=https%3A%2F%2Fplus.google.com%2F%3Fgpsrc%3Dogpy0">link</a>.  If you already have a Google account then
                click on the login button below.
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
