
%{--<body>--}%

%{--<div id='login'>--}%
	%{--<div class='inner'>--}%
		%{--<div class='fheader'><g:message code="springSecurity.login.header"/></div>--}%

		%{--<g:if test='${flash.message}'>--}%
			%{--<div class='login_message'>${flash.message}</div>--}%
		%{--</g:if>--}%



















		%{--<form action='${postUrl}' method='POST' id='loginForm' class='cssform' autocomplete='off'>--}%
			%{--<p>--}%
				%{--<label for='username'><g:message code="springSecurity.login.username.label"/>:</label>--}%
				%{--<input type='text' class='text_' name='j_username' id='username'/>--}%
			%{--</p>--}%

			%{--<p>--}%
				%{--<label for='password'><g:message code="springSecurity.login.password.label"/>:</label>--}%
				%{--<input type='password' class='text_' name='j_password' id='password'/>--}%
			%{--</p>--}%

			%{--<p id="remember_me_holder">--}%
            %{--<input type='checkbox' class='chk' name='${rememberMeParameter}' id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if>/>--}%
				%{--<label for='remember_me'><g:message code="springSecurity.login.remember.me.label"/></label>--}%
			%{--</p>--}%

			%{--<p>--}%
				%{--<input type='submit' id="submit" value='${message(code: "springSecurity.login.button")}'/>--}%
			%{--</p>--}%
		%{--</form>--}%
	%{--</div>--}%
%{--</div>--}%
%{--<script type='text/javascript'>--}%
	%{--<!----}%
	%{--(function() {--}%
		%{--document.forms['loginForm'].elements['j_username'].focus();--}%
	%{--})();--}%
	%{--// -->--}%
%{--</script>--}%
%{--</body>--}%
%{--</html>--}%





<!DOCTYPE html>
<html>
<head>
    <title><g:message code="springSecurity.login.title"/></title>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">

    <div class="container">

        <div class="row">
            <div class="col-md-8 col-md-offset-2 login-header">
                <p>Welcome to this prototype portal for data from large genetic studies of type 2 diabetes. If you have permission to view the site, log in below. To get permission or learn more about the site, please
                    <a class="boldlink" href="mailto://t2dgenetics@gmail.com">email the portal team</a>.</p>
            </div>
        </div>

        <div class="row">
           <div class="col-md-6 col-md-offset-3">
               <form action='${postUrl}' method='POST' id='loginForm' class='form form-horizontal' autocomplete='off'>
                    <g:if test='${flash.message}'>
                        <div class="alert alert-danger">${flash.message}</div>
                    </g:if>
                    %{--<form action="#" method="post" class="form form-horizontal">--}%
                        %{--{% csrf_token %}--}%
                        %{--{% if next %}--}%
                        %{--<input type="hidden" name="next" value="{{ next}}" >--}%
                        %{--{% endif %}--}%
                        <div class="form-group">
                            <label class="control-label col-sm-3" id="id_email"><g:message code="springSecurity.login.username.label"/>:</label>

                            <div class="col-sm-8">
                                <input type='text' class='form_control' name='j_username' id='username'/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-3" for="id_password"><g:message
                                    code="springSecurity.login.password.label"/>:</label>

                            <div class="col-sm-8">
                                <input type='password' class='text_' name='j_password' id='password'/>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-3"></div>
                            <div class="col-sm-8">
                                <input type='checkbox' class='chk' name='${rememberMeParameter}' id='remember_me'
                                <g:if test='${hasCookie}'>checked='checked'</g:if>/>
                                <label for='remember_me'><g:message code="springSecurity.login.remember.me.label"/></label>
                            </div>
                        </div>

                        <div style="text-align:center; padding-top: 20px;">
                            <input class="btn btn-primary btn-lg" type='submit' id="submit"
                                   value='${message(code: "springSecurity.login.button")}'/>
                        </div>

               </form>

            </div>
        </div>
    </div>

</div>
<script type='text/javascript'>
    <!--
    (function() {
        document.forms['loginForm'].elements['j_username'].focus();
    })();
    // -->
</script>
</body>
</html>
