<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'username', 'error')} required">
        <div class="col-md-2">
            <label class="pull-right" for="username">
                <g:message code="users.attributes.user_name"/>
                <span class="required-indicator">*</span>
            </label>
        </div>

        <div class="col-md-6">
            <g:textField class="pull-left" name="username" required="" size="60" value="${userInstance?.username}"/>
        </div>

        <div class="col-md-4"></div>
    </div>

</div>

<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'password', 'error')} required">
        <div class="col-md-2">
            <label class="pull-right" for="password">
                <g:message code="users.attributes.password"/>
                <span class="required-indicator">*</span>
            </label>
        </div>

        <div class="col-md-6">
            <g:textField class="pull-left" name="password" required="" size="60" value="${userInstance?.password}"/>
        </div>

        <div class="col-md-4"></div>
    </div>

</div>


<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'email', 'error')} required">
        <div class="col-md-2">
            <label class="pull-right" for="email">
                <g:message code="users.attributes.email"/>
                <span class="required-indicator">*</span>
            </label>
        </div>

        <div class="col-md-6">
            <g:textField class="pull-left" name="email" required="" size="60" value="${userInstance?.email}"/>
        </div>

        <div class="col-md-4"></div>
    </div>

</div>


<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'fullName', 'error')} required">
        <div class="col-md-2">
            <label class="pull-right" for="fullName">
                <g:message code="users.attributes.fullName"/>
                <span class="required-indicator">*</span>
            </label>
        </div>

        <div class="col-md-6">
            <g:textField class="pull-left" name="fullName" required="" size="60" value="${userInstance?.fullName}"/>
        </div>

        <div class="col-md-4"></div>
    </div>

</div>


<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'nickname', 'error')} required">
        <div class="col-md-2">
            <label class="pull-right" for="nickname">
                <g:message code="users.attributes.nickname"/>
                <span class="required-indicator">*</span>
            </label>
        </div>

        <div class="col-md-6">
            <g:textField class="pull-left" name="nickname" required="" size="60" value="${userInstance?.nickname}"/>
        </div>

        <div class="col-md-4"></div>
    </div>

</div>


<div class="adminform row ">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'hasLoggedIn', 'error')} required">
        <div class="col-md-3">
            <label class="pull-right" for="hasLoggedIn">
                <g:message code="users.attributes.hasLoggedIn"/>
            </label>
        </div>

        <div class="col-md-2">
            <g:checkBox name="hasLoggedIn" value="${userInstance?.hasLoggedIn}"/>
        </div>

    </div>

    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'enabled', 'error')} required">
        <div class="col-md-3">
            <label class="pull-right" for="enabled">
                <g:message code="users.attributes.enabled"/>
            </label>
        </div>

        <div class="col-md-2">
            <g:checkBox name="enabled" value="${userInstance?.enabled}"/>
        </div>

    </div>

    <div class="col-md-2"></div>

</div>


<div class="row adminform2">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'accountExpired', 'error')} required">
        <div class="col-md-3">
            <label class="pull-right" for="accountExpired">
                <g:message code="users.attributes.accountExpired"/>
            </label>
        </div>

        <div class="col-md-2">
            <g:checkBox name="accountExpired" value="${userInstance?.accountExpired}"/>
        </div>

    </div>

    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'accountLocked', 'error')} required">
        <div class="col-md-3">
            <label class="pull-right" for="accountLocked">
                <g:message code="users.attributes.accountLocked"/>
            </label>
        </div>

        <div class="col-md-2">
            <g:checkBox name="accountLocked" value="${userInstance?.accountLocked}"/>
        </div>

    </div>

    <div class="col-md-2"></div>

</div>




<div class="row adminform">
    <div class="fieldcontain ${hasErrors(bean: userInstance, field: 'passwordExpired', 'error')} required">
        <div class="col-md-3">
            <label class="pull-right" for="passwordExpired">
                <g:message code="users.attributes.passwordExpired"/>
            </label>
        </div>

        <div class="col-md-2">
            <g:checkBox name="passwordExpired" value="${userInstance?.passwordExpired}"/>
        </div>

    </div>

    <div class="col-md-7"></div>

</div>



<div class="row adminform">

    <div class="col-md-5">
        <label class="pull-right" for="userPrivs">
            <g:message code="users.privileges.user_privs"/>
        </label>
    </div>

    <div class="col-md-2">
        <g:checkBox name="userPrivs" value="${((userPrivs&1)>0)}"/>
    </div>


    <div class="col-md-5"></div>

</div>

<div class="row adminform">

    <div class="col-md-5">
        <label class="pull-right" for="mgrPrivs">
            <g:message code="users.privileges.admin_privs"/>
        </label>
    </div>

    <div class="col-md-2">
        <g:checkBox name="mgrPrivs" value="${((userPrivs&2)>0)}"/>
    </div>


    <div class="col-md-5"></div>

</div>


<sec:ifAllGranted roles="ROLE_SYSTEM">
<div class="row adminform">

    <div class="col-md-5">
        <label class="pull-right" for="systemPrivs">
            <g:message code="users.privileges.system_privs"/>
        </label>
    </div>

    <div class="col-md-2">
        <g:checkBox name="systemPrivs" value="${((userPrivs&4)>0)}"/>
    </div>


    <div class="col-md-5"></div>

</div>
</sec:ifAllGranted>
