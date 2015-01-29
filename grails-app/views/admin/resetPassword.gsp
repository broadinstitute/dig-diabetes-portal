<!DOCTYPE html>
<html>
<head>
    <title><g:message code="springSecurity.login.title"/></title>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">

    <div class="container">

        <g:if test='${flash.message}'>
            <div class="alert alert-danger">${flash.message}</div>
        </g:if>

        <div class="row">
            <div class="col-md-8 col-md-offset-2 login-header">
                <p>Please enter a new password</p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <g:form action='updatePasswordInteractive' method='POST' id='passwordResetForm' class='form form-horizontal cssform' autocomplete='off'>

                    <div class="form-group">
                        <label class="control-label col-sm-3" id="id_email">Username:</label>

                        <div class="col-sm-8">
                            <input  type='text' class='text_' name='username' id='username' value="${username}" readonly/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-3" for="newPassword">New password:</label>

                        <div class="col-sm-8">
                            <input type='password' class='text_' name='newPassword' id='newPassword'/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-3" for="newPassword2">New password (again):</label>

                        <div class="col-sm-8">
                            <input type='password' class='text_' name='newPassword2' id='newPassword2'/>
                        </div>
                    </div>

                    <div style="text-align:center; padding-top: 20px;">
                        <input class="btn btn-primary btn-lg" type='submit' id="submit"
                               value='Reset'/>
                    </div>

                </g:form>

            </div>
        </div>
    </div>

</div>
<script type='text/javascript'>
    <!--
    (function() {
        $('#oldPassword').focus();
    })();
    // -->
</script>
</body>
</html>