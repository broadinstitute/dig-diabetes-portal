<%--
  Created by IntelliJ IDEA.
  User: andrew
  Date: 5/5/15
  Time: 9:16 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="sigma"/>
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
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
    <g:if test="${params.section == 'partners'}">
        <g:render template="partners-header"/>
    </g:if>
    <g:if test="${params.section == 'learn'}">
        <g:render template="learn-header"/>
    </g:if>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-xs-4">
            <!-- topics go here -->
            <g:if test="${params.section != 'about' && params.section != null}">
                <div class="row sigma-about-gradient">
                    <div class="text-center">
                        <g:link params="[section: 'about']"><h2 class="sigma-topic">ABOUT</h2></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'data'}">
                <div class="row clearfix sigma-data">
                    <div class="text-center">
                        <g:link params="[section: 'data']"><h2 class="sigma-topic">DATA</h2></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'papers'}">
                <div class="row clearfix sigma-papers">
                    <div class="text-center">
                        <g:link params="[section: 'papers']"><h2 class="sigma-topic">RESEARCH</h2></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'partners'}">
                <div class="row clearfix sigma-partners">
                    <div class="text-center">
                        <g:link params="[section: 'partners']"><h2 class="sigma-topic">PARTNERS</h2></g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${params.section != 'learn'}">
                <div class="row clearfix sigma-learn">
                    <div class="text-center">
                        <g:link params="[section: 'learn']"><h2 class="sigma-topic">LEARN</h2></g:link>
                    </div>
                </div>
            </g:if>

        </div>
        <div class="col-md-10 col-xs-8">
            <g:if test="${params.section == 'data'}">
                <g:render template="data"/>
            </g:if>
            <g:if test="${params.section == 'papers'}">
                <g:render template="papers"/>
            </g:if>
            <g:if test="${params.section == 'about' || params.section == null}">
                <g:render template="about"/>
            </g:if>
            <g:if test="${params.section == 'partners'}">
                <g:render template="partners"/>
            </g:if>
            <g:if test="${params.section == 'learn'}">
                <g:render template="learn"/>
            </g:if>
        </div>
    </div>
</div>

</body>
</html>