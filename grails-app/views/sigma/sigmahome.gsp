<%--
  Created by IntelliJ IDEA.
  User: andrew
  Date: 5/5/15
  Time: 9:16 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

</head>

<body>
    <h1></h1>
    <g:if test="${params.section == 'about' || params.section == null}">
        <g:render template="about"/>
    </g:if>

    <g:if test="${params.section == 'data'}">
        <g:render template="data"/>
    </g:if>

    <g:link params="[section: 'about']">About</g:link>
    <g:link params="[section: 'data']">Data</g:link>
</body>
</html>