<%--
  Created by IntelliJ IDEA.
  User: ben
  Date: 8/23/2014
  Time: 5:11 PM
--%>

<div class="row">
    <h1>User list</h1>
    <g:link action="create" class="page-nav-link pull-right">Create new user</g:link>
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

