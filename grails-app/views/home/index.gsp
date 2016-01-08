<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>

    <r:require modules="core"/>
    <r:layoutResources/>
    <style type="text/css">
    html, body { margin: 0; padding:0;}
    #signin-button {
        padding: 5px;
    }

    #oauth2-results pre { margin: 0; padding:0; width: 600px;}
    .hide { display: none;}
    .show { display: block;}
    </style>
    <script>
        function signinCallback(authResult) {
            if (authResult['status']['signed_in']) {
                // Update the app to reflect a signed in user
                // Hide the sign-in button now that the user is authorized, for example:
                document.getElementById('signinButton').setAttribute('style', 'display: none');
            } else {
                // Update the app to reflect a signed out user
                // Possible error values:
                //   "user_signed_out" - User is signed-out
                //   "access_denied" - User denied access to your app
                //   "immediate_failed" - Could not automatically log in the user
                console.log('Sign-in state: ' + authResult['error']);
            }
        }
    </script>


</head>
<body>

<div id="main">




             <div class="container">
                %{--<div id="insertButton">--}%
                    %{--<a class="button button-blue" href="javascript:insertButton();">Click me</a> to insert a button dynamically with <code>gapi.signin.render()</code>--}%
                %{--</div>--}%
                %{--<div id="signin-button" class="show">--}%



                <div class="jumbotron">
                    <h1><g:message code="mainpage.index.title"/></h1>
                    <p class="lead"><g:message code="mainpage.index.lead"/></p>
                    <p><a class="btn btn-lg btn-success" href="#" role="button"><g:message code="mainpage.index.start"/></a></p>
                 <span id="signinButton">
                     <span
                             class="g-signin"
                             data-callback="signinCallback"
                             data-clientid="975413760331-d2nr5vq7sbbppjfog0cp9j4agesbeovt.apps.googleusercontent.com"
                             data-cookiepolicy="single_host_origin"
                             data-requestvisibleactions="http://schema.org/AddAction"
                             data-scope="https://www.googleapis.com/auth/plus.login">
                     </span>
                 </span>
                </div>


                %{--<div style='width:20px; height: 10px;'>--}%
                    %{--<div id="renderMe"></div>--}%
                %{--</div>--}%

                %{--</div>--}%
                %{--<div style='width:200px; height: 100px;'>--}%
                %{--<div id="oauth2-results" class="hide"></div>--}%
            %{--</div>--}%
                %{--<div style="font: 12px sans-serif, Arial; margin-left: 0.5em; margin-top: 0.5em"><a href="javascript:document.location.reload();">Reload the example</a> or <a--}%
                        %{--href="/+/demos/signin_demo_render" target="_blank">open in a new window</a></div>--}%


            </div>


    <script>
        //insertButton();
    </script>



</div>

<script type="text/javascript">
    (function() {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/client:plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
</script>
</body>
</html>
