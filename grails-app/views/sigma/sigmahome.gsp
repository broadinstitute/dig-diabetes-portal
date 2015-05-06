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
<div class="row clearfix">
    <div class="col-xs-12">
        <div class="row clearfix text-center" style="height: 200px">
            <h1>my header</h1>
        </div>
    </div>
</div>
<div class="row clearfix">
    <div class="col-md-5 col-xs-12">
        <div class="row clearfix">
            <div class="col-md-12" style="background-color: red; height: 50px">
            </div>
        </div>
        <div class="row clearfix">
            <div class="col-md-12" style="background-color: orange; height: 50px">
            </div>
        </div>
        <div class="row clearfix">
            <div class="col-md-12" style="background-color: blue; height: 50px">
            </div>
        </div>
        <div class="row clearfix">
            <div class="col-md-12" style="background-color: green; height: 50px">
            </div>
        </div>
        <div class="row clearfix">
            <div class="col-md-12" style="background-color: purple; height: 50px">
            </div>
        </div>
    </div>
    <div  class="col-md-7 col-xs-12">
        <h1>howdy</h1>
        <h1>howdy</h1>
        <h1>howdy</h1>
    </div>
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