<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:11 PM
--%>

<div class="row">
    <h1>User list</h1>
    <div class="pull-right" style="margin-bottom: 10px; margin-right: 20px">
        <g:link class="page-nav-link" action="create">Create new user</g:link>
        <g:link class="page-nav-link" action="dump">Dump user list</g:link>
    </div>
    %{--<g:link action="create" class="btn btn-lg btn-primary pull-right">Create new user</g:link>--}%
</div>
<div class="row"></div>
<table id="userTable" class="table table-striped basictable">
<thead>
<tr>
    <th>user name</th>
    <th>password</th>
    <th>account enabled</th>
</tr>
</thead>
    <tbody id="userTableBody">
    </tbody>
</table>

