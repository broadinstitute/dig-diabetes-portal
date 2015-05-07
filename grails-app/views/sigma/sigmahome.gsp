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

<div class="container-fluid sigma-nav">
    <g:if test="${params.section == 'about' || params.section == null}">
        <g:render template="about-header"/>
    </g:if>
    <g:if test="${params.section == 'data'}">
        <g:render template="data-header"/>
    </g:if>
    <g:if test="${params.section == 'papers'}">
        <g:render template="papers-header"/>
    </g:if>
</div>

<div class="container-fluid sigma-nav">
    <div class="row clearfix">
        <div class="col-md-2 col-xs-4">
            <!-- topics go here -->
            <g:if test="${params.section != 'about' && params.section != null}">
                <div class="row clearfix">
                    <div class="sigma-about text-center">
                        <g:link params="[section: 'about']"><h1>About  ${language}</h1></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'data'}">
                <div class="row clearfix">
                    <div class="sigma-data text-center">
                        <g:link params="[section: 'data']"><h1>Data</h1></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'papers'}">
                <div class="row clearfix">
                    <div class="sigma-papers text-center">
                        <g:link params="[section: 'papers']"><h1>Papers</h1></g:link>
                    </div>
                </div>
            </g:if>

        </div>
        <div class="col-md-9">
            <g:if test="${params.section == 'data'}">
                <g:render template="data"/>
            </g:if>
            <g:if test="${params.section == 'papers'}">
                <g:render template="papers"/>
            </g:if>
            <g:if test="${params.section == 'about' || params.section == null}">
                <g:render template="about"/>
            </g:if>
        </div>
    </div>
</div>

</body>
</html>