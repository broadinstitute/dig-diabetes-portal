<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:09 PM
--%>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>


</head>

<body>
<script>
</script>


<div id="main">

    <div class="container">

        <div class="dport-template">
            <div class="dport-template-view">

                <div class="row">
                    <div class="col-md-4"><h1>Edit user</h1></div>

                    <div class="col-md-8"></div>
                </div>

                <div class="row">
                    <div class="col-md-2"></div>

                    <div class="col-md-10">

                        <g:if test="${flash.message}">
                            <div class="message" role="status">${flash.message}</div>
                        </g:if>

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2"></div>

                    <div class="col-md-10">

                        <g:hasErrors bean="${userInstance}">
                            <ul class="errors" role="alert">
                                <g:eachError bean="${userInstance}" var="error">
                                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                            error="${error}"/></li>
                                </g:eachError>
                            </ul>
                        </g:hasErrors>

                    </div>
                </div>


                <g:form url="[resource: userInstance, action: 'update']" method="PUT" >
                    <g:hiddenField name="version" value="${userInstance?.version}" />

                    <div class="row">

                        <div class="col-md-2"></div>

                        <div class="col-md-10">


                            <fieldset class="form">
                                <g:render template="userContents"/>
                            </fieldset>



                        </div>


                    </div>

                    <div class="row adminform">

                        <div class="col-md-6"></div>

                        <div class="col-md-4">


                            <fieldset class="buttons">
                                <g:actionSubmit class="save btn btn-lg btn-primary pull-right"   action="update"
                                                value="Update"/>
                            </fieldset>


                        </div>

                        <div class="col-md-2"></div>
                    </div>


                </g:form>



            </div>
        </div>

    </div>
</div>
</body>
</html>
