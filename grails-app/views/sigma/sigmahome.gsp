
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="sigma"/>
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
</head>

<body>

<div class="container-fluid sigma-nav" style="padding:0px;">
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
    <g:if test="${params.section == 'contact'}">
        <g:render template="contact-header"/>
    </g:if>
</div>
<div class="container-fluid"  style="padding:0px;">
    <div class="visible-xs visible-sm sigma-nav">
        <g:if test="${params.section != 'about' && params.section != null}">
            <div class="sigma-about-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'about']"><div class="sigma-topic"> <g:message code="sigmasite.about"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
        <g:if test="${params.section != 'data'}">
            <div class="sigma-data-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'data']"><div class="sigma-topic"> <g:message code="sigmasite.data"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
        <g:if test="${params.section != 'papers'}">
            <div class="sigma-papers-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'papers']"><div class="sigma-topic"> <g:message code="sigmasite.research"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
        <g:if test="${params.section != 'partners'}">
            <div class="sigma-partners-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'partners']"><div class="sigma-topic"> <g:message code="sigmasite.partners"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
        <g:if test="${params.section != 'learn'}">
            <div class="sigma-learn-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'learn']"><div class="sigma-topic"> <g:message code="sigmasite.learn"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
        <g:if test="${params.section != 'contact'}">
            <div class="sigma-contact-gradient col-xs-2">
                <div class="text-center">
                    <g:link params="[section: 'contact']"><div class="sigma-topic"> <g:message code="sigmasite.contact"></g:message></div></g:link>
                </div>
            </div>
        </g:if>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="visible-md visible-lg col-md-2 col-xs-4">
            <!-- topics go here -->
            <g:if test="${params.section != 'about' && params.section != null}">
                <div class="row sigma-about-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'about']"><div class="sigma-topic"> <g:message code="sigmasite.about"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>
            <g:if test="${params.section != 'data'}">
                <div class="row clearfix sigma-data-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'data']"><div class="sigma-topic"> <g:message code="sigmasite.data"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>
            <g:if test="${params.section != 'papers'}">
                <div class="row clearfix sigma-papers-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'papers']"><div class="sigma-topic"> <g:message code="sigmasite.research"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>
            <g:if test="${params.section != 'partners'}">
                <div class="row clearfix sigma-partners-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'partners']"><div class="sigma-topic"> <g:message code="sigmasite.partners"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>
            <g:if test="${params.section != 'learn'}">
                <div class="row clearfix sigma-learn-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'learn']"><div class="sigma-topic"> <g:message code="sigmasite.learn"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>
            <g:if test="${params.section != 'contact'}">
                <div class="row clearfix sigma-contact-gradient">
                    <h2 class="text-center">
                        <g:link params="[section: 'contact']"><div class="sigma-topic"> <g:message code="sigmasite.contact"></g:message></div></g:link>
                    </h2>
                </div>
            </g:if>

        </div>
        <div class="col-md-10 col-xs-12">
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
            <g:if test="${params.section == 'contact'}">
                <g:render template="contact"/>
            </g:if>
        </div>
    </div>
</div>

</body>
</html>