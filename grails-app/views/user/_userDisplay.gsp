

    <div class="row adminform2">
        <g:if test="${userInstance?.username}">
                <div class="col-md-2 displayUserLabel">
                   <span id="username-label" class="property-label">Username</span>
                </div>
                <div class="col-md-6 displayUserField">
                    <span class="property-value" aria-labelledby="username-label"><g:fieldValue bean="${userInstance}" field="username"/></span>
                </div>
                <div class="col-md-4"></div>
        </g:if>
    </div>


<div class="row adminform2">
    <g:if test="${userInstance?.password}">
            <div class="col-md-2 displayUserLabel">
                <span id="password-label" class="property-label">password</span>
            </div>
            <div class="col-md-6 displayUserField">
                <span class="property-value" aria-labelledby="password-label"><g:fieldValue bean="${userInstance}" field="password"/></span>
            </div>
            <div class="col-md-4"></div>

    </g:if>
</div>


<div class="row adminform2">
    <g:if test="${userInstance?.email}">
            <div class="col-md-2 displayUserLabel">
                <span id="email-label" class="property-label">email</span>
            </div>
            <div class="col-md-6 displayUserField">
                <span class="property-value" aria-labelledby="email-label"><g:fieldValue bean="${userInstance}" field="email"/></span>
            </div>
            <div class="col-md-4"></div>
    </g:if>
</div>


<div class="row adminform2">
    <g:if test="${userInstance?.fullName}">
            <div class="col-md-2 displayUserLabel">
                <span id="fullName-label" class="property-label">fullName</span>
            </div>
            <div class="col-md-6 displayUserField">
                <span class="property-value" aria-labelledby="fullName-label"><g:fieldValue bean="${userInstance}" field="fullName"/></span>
            </div>
            <div class="col-md-4"></div>
    </g:if>
</div>


<div class="row adminform2">
    <g:if test="${userInstance?.nickname}">
            <div class="col-md-2 displayUserLabel">
                <span id="nickname-label" class="property-label">nickname</span>
            </div>
            <div class="col-md-6 displayUserField">
                <span class="property-value" aria-labelledby="nickname-label"><g:fieldValue bean="${userInstance}" field="nickname"/></span>
            </div>
            <div class="col-md-4"></div>
    </g:if>
</div>




    <div class="row adminform2">
        <g:if test="${userInstance?.hasLoggedIn}">
            <div class="col-md-3">
                <span id="hasLoggedIn-label" class="property-label">
                    hasLoggedIn
                </span>
            </div>

            <div class="col-md-2">
                <span class="property-value" aria-labelledby="hasLoggedIn-label">
                    <g:formatBoolean boolean="${userInstance?.hasLoggedIn}" />
                </span>
            </div>
         </g:if>


        <g:if test="${userInstance?.enabled}">
            <div class="col-md-3">
                <span id="enabled-label" class="property-label">
                    enabled
                </span>
            </div>

            <div class="col-md-2">
                <span class="property-value" aria-labelledby="enabled-label">
                   <g:formatBoolean boolean="${userInstance?.enabled}" />
                </span>
            </div>

        </g:if>

        <div class="col-md-2"></div>

    </div>



    <div class="row adminform2">
        <g:if test="${userInstance?.accountExpired}">
            <div class="col-md-3">
                <span id="accountExpired-label" class="property-label">
                    accountExpired
                </span>
            </div>

            <div class="col-md-2">
                <span class="property-value" aria-labelledby="accountExpired-label">
                    <g:formatBoolean boolean="${userInstance?.accountExpired}" />
                </span>
            </div>
        </g:if>


        <g:if test="${userInstance?.accountLocked}">
            <div class="col-md-3">
                <span id="accountLocked-label" class="property-label">
                    accountLocked
                </span>
            </div>

            <div class="col-md-2">
                <span class="property-value" aria-labelledby="accountLocked-label">
                    <g:formatBoolean boolean="${userInstance?.accountLocked}" />
                </span>
            </div>

        </g:if>

        <div class="col-md-2"></div>

    </div>

    <div class="row adminform2">
        <g:if test="${userInstance?.passwordExpired}">
            <div class="col-md-3">
                <span id="passwordExpired-label" class="property-label">
                    passwordExpired
                </span>
            </div>

            <div class="col-md-2">
                <span class="property-value" aria-labelledby="passwordExpired-label">
                    <g:formatBoolean boolean="${userInstance?.passwordExpired}" />
                </span>
            </div>
        </g:if>



        <div class="col-md-7"></div>

    </div>



