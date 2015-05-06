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

<div class="container-fluid">
    <g:if test="${params.section == 'about' || params.section == null}">
        <g:render template="about-header"/>
    </g:if>
    <g:if test="${params.section == 'data'}">
        <g:render template="data-header"/>
    </g:if>
</div>

<div class="container-fluid">
    <div class="row clearfix">
        <div class="col-md-2 col-xs-4" >
            <!-- topics go here -->
            <g:if test="${params.section != 'about' && params.section != null}">
                <div class="row clearfix">
                    <div class="sigma-about">
                        <g:link params="[section: 'about']"><h1>About</h1></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'data'}">
                <div class="row clearfix">
                    <div class="sigma-data">
                        <g:link params="[section: 'data']"><h1>Data</h1></g:link>
                    </div>
                </div>
            </g:if>
            <div class="row clearfix">
                <div style="background-color: orange; height: 70px">
                    Papers
                </div>
            </div>
            <div class="row clearfix">
                <div style="background-color: green; height: 70px">
                    People
                </div>
            </div>
            <div class="row clearfix">
                <div style="background-color: purple; height: 50px">
                </div>
            </div>
        </div>
        <div class="col-md-9">
            <g:if test="${params.section == 'data'}">
                <g:render template="data"/>
            </g:if>
            <g:if test="${params.section == 'about' || params.section == null}">
                <g:render template="about"/>
            </g:if>
        </div>
    </div>
</div>

</body>
</html>