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
                    // tack on the data for the query (from variant search results page)
                    // if jqXHR.data is undefined, it'll just add "undefined"
                    errorText += 'Time out error. Data: ' + decodeURIComponent(decodeURIComponent(jqXHR.data));
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
