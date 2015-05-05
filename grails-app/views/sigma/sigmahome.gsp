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
    <div>
        <table>
            <tr>
                <td style="width:20%">
                    <g:if test="${params.section == 'data'}">
                        <h1>Data</h1>
                    </g:if>
                    <g:if test="${params.section == 'about' || params.section == null}">
                        <h1>About</h1>
                    </g:if>
                </td>
                <td>
                    <g:if test="${params.section == 'data'}">
                        <g:render template="data-overview"/>
                    </g:if>
                    <g:if test="${params.section == 'about' || params.section == null}">
                        <g:render template="about-overview"/>
                    </g:if>
                </td>
            </tr>
        </table>
    </div>

    <div>
        <table>
            <tr>
                <td style="width:20%;vertical-align: top;">
                    <table>
                        <g:if test="${params.section != 'about' && params.section != null}">
                            <tr>
                                <td><g:link params="[section: 'about']">About</g:link></td>
                            </tr>
                        </g:if>
                        <g:if test="${params.section != 'data'}">
                            <tr>
                                <td><g:link params="[section: 'data']">Data</g:link></td>
                            </tr>
                        </g:if>
                        <tr>
                            <td>Etc...</td>
                        </tr>
                    </table>
                </td>
                <td>
                    <div class="jumbotron">
                        <g:if test="${params.section == 'data'}">
                            <g:render template="data"/>
                        </g:if>
                        <g:if test="${params.section == 'about' || params.section == null}">
                            <g:render template="about"/>
                        </g:if>
                    </div>
                </td>
            </tr>
        </table>

    </div>
</body>
</html>