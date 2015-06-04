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

<script>
    showLogin = function() {
        $('#googleLogin').show();
        $('#termsAndConditions').hide();
    };
</script>

<div id="main">

    <div class="container">

        <div class="row">
            <div class="center-block col-xs-12 text-center">

                <div id="termsAndConditions" style="text-align: left;">

                    <p>All users are welcome to use any data in the portal to further their research without
                    seeking explicit permission from the portal team or funders. Users are also welcome to
                    cite data in scientific publications, provided that they cite the portal as the source. If
                    users are citing a single dataset represented in the portal, we encourage them to cite
                    both the portal and the relevant paper for that dataset (if one has been published).
                    Portal users are required to abide by the following restrictions provisions on data
                    use:
                    </p>

                    <ol>
                        <li>Users will not attempt to download any dataset in bulk from the portal;</li>

                        <li>Users will not attempt to re-identify or contact research participants;</li>

                        <li>Users will protect data confidentiality;</li>

                        <li>Users will not share any of the data with unauthorized users;</li>

                        <li>Users will report any inadvertent data release, security breach or other data
                        management incidents of which users becomes aware;</li>

                        <li>Users will abide by all applicable laws and regulations for handling genomic data.</li>
                    </ol>

                    <p style="font-weight: bold;">Agreeing to these provisions is a requirement of portal use. Violating them may result in
                    an NIH investigation and sanctions including revocation of access to the portal.</p>

                    <a onclick="showLogin()"><input type="checkbox"></a> I agree the terms and conditions.
                </div>

                <div id="googleLogin" style="display:none;">

                    <div class="row">
                        <div class="col-md-8 col-md-offset-2 login-header">
                            <p>
                                <g:message code="google.login.page.intro" default="welcome, go get yourself a Google account" />
                            </p>
                        </div>
                        <div class="col-md-2"></div>
                    </div>

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

</div>

</body>
</html>
