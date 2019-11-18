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

    <div class="container-fluid" style="margin: 0 2.5%">

        <div class="row well well-gene-page">
            <div class="center-block col-xs-12 text-center">

                <div id="sorryMessage" style="text-align: center;">

                    <p style="font-size: 20px;">Sorry. This portal is open to Broad Institute community members only.</p>
                    <a href='<g:createLink controller="logout"/>' class="btn btn-default">Go back to front page</a>
                </div>

            </div>

        </div>
    </div>

</div>
<script>
    $(".menu-wrapper").css("display","none");
    $(".logo-wrapper").find("a").attr("href","<g:createLink controller="logout"/>")
    /*<g:link controller='logout'><g:message code="mainpage.log.out"/></g:link>*/
</script>
</body>
</html>
