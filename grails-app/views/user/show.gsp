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

    <script>


    </script>

</head>

<body>
<script>
</script>


<div id="main">

    <div class="container">

        <div class="dport-template">
            <div class="dport-template-view">

                <div class="row">
                    <div class="col-md-4"><h1><g:message code="users.admin.show"/></h1></div>

                    <div class="col-md-4"><g:link class="list btn btn-sm btn-primary" controller="admin" action="users"><g:message code="users.admin.list"/></g:link></div>
                    <div class="col-md-4"><g:link class="create btn btn-sm btn-primary" controller="admin" action="create"><g:message code="users.admin.create"/></g:link></div>
                </div>

                <div class="row">
                    <div class="col-md-2"></div>

                    <div class="col-md-10">
                        <g:if test="${flash.message}">
                            <div class="message" role="status">${flash.message}</div>
                        </g:if>

                    </div>
                </div>

                <g:form url="[resource: userInstance, action: 'save']">
                    <div class="row">

                        <div class="col-md-2"></div>

                        <div class="col-md-10">


                            <fieldset class="form">
                                <g:render template="userDisplay"/>
                            </fieldset>



                        </div>


                    </div>

                    <div class="row adminform">

                        <div class="col-md-6"></div>

                        <div class="col-md-4">


                            <fieldset class="buttons">
                                <g:link class="edit btn btn-lg btn-primary" action="edit" resource="${userInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                                <g:actionSubmit class="delete btn btn-lg btn-primary" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
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
