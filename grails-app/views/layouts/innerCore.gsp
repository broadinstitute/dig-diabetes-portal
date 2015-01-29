<!DOCTYPE html>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="temporary.BuildInfo" %>
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
    <g:external uri="/images/icons/dna-strands.ico"/>


    <g:layoutHead/>
</head>

<body>

<g:javascript src="lib/bootstrap.min.js" />

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
            errorText += '\nVersion=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}';
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

<g:layoutBody/>


</body>
</html>