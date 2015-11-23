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
            <div class="center-block col-xs-12 text-center">

                <div id="termsAndConditions" style="text-align: left;">

                    <g:message code='contract.terms_and_conditions'/>

                    <a class='btn btn-primary btn-large' href="${createLink(controller:'home',action:'portalHome')}"> <g:message code='contract.agree'/></a>
                </div>

            </div>

        </div>
    </div>

</div>

</body>
</html>
