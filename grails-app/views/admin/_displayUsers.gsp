<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:11 PM
--%>

<div class="row">
    <h1><g:message code="users.admin.list"/></h1>
    <div class="pull-right" style="margin-bottom: 10px; margin-right: 20px">
        <g:link class="page-nav-link" action="create"><g:message code="users.admin.create"/></g:link>
        <g:link class="page-nav-link" action="dump"><g:message code="users.admin.dump"/></g:link>
    </div>
    %{--<g:link action="create" class="btn btn-lg btn-primary pull-right"><g:message code="users.admin.create"/></g:link>--}%
</div>
<div class="row"></div>
<table id="userTable" class="table table-striped basictable">
<thead>
<tr>
    <th><g:message code="users.attributes.user_name"/></th>
    <th><g:message code="users.attributes.password"/></th>
    <th><g:message code="users.attributes.account_enabled"/></th>
</tr>
</thead>
    <tbody id="userTableBody">
    </tbody>
</table>

