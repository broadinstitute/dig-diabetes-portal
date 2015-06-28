
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="sigma"/>
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
</head>

<body>
<div class="container-fluid">
    <div class="row dk-sigma-small-nav text-center visible-sm visible-xs">
        <div class="col-sm-4 col-xs-4 sigma-about-gradient">
            <g:if test="${params.section == 'about' || params.section == null}">
                <g:link params="[section: 'about']"><strong>ABOUT</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'about']">ABOUT</g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-data-gradient">
            <g:if test="${params.section == 'data'}">
                <g:link params="[section: 'data']"><strong>DATA</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'data']">DATA</g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-papers-gradient">
            <g:if test="${params.section == 'papers'}">
                <g:link params="[section: 'papers']"><strong>PAPERS</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'papers']">PAPERS</g:link>
            </g:else>
        </div>
    </div>
    <div class="row dk-sigma-small-nav text-center visible-sm visible-xs">
        <div class="col-sm-4 col-xs-4 sigma-partners-gradient">
            <g:if test="${params.section == 'partners'}">
                <g:link params="[section: 'partners']"><strong>PARTNERS</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'partners']">PARTNERS</g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-learn-gradient">
            <g:if test="${params.section == 'learn'}">
                <g:link params="[section: 'learn']"><strong>LEARN</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'learn']">LEARN</g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-contact-gradient">
            <g:if test="${params.section == 'contact'}">
                <g:link params="[section: 'contact']"><strong>CONTACT</strong></g:link>
            </g:if>
            <g:else>
                <g:link params="[section: 'contact']">CONTACT</g:link>
            </g:else>
        </div>
    </div>
    <g:if test="${params.section == 'about' || params.section == null}"> 
        <div class="row sigma-about-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.about.summary"></g:message></div>
        </div>
        <div class="row sigma-about-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.about.summary"></g:message></div>
        </div>
    </g:if>
    <g:if test="${params.section == 'data'}"> 
        <div class="row sigma-data-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.data.summary"></g:message></div>
        </div>
        <div class="row sigma-data-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.data.summary"></g:message></div>
        </div>
    </g:if>
    <g:if test="${params.section == 'papers'}"> 
        <div class="row sigma-papers-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.research.summary"></g:message></div>
        </div>
        <div class="row sigma-papers-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.research.summary"></g:message></div>
        </div>
    </g:if>
    <g:if test="${params.section == 'partners'}"> 
        <div class="row sigma-partners-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.partners.summary"></g:message></div>
        </div>
        <div class="row sigma-partners-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.partners.summary"></g:message></div>
        </div>
    </g:if>
    <g:if test="${params.section == 'learn'}"> 
        <div class="row sigma-learn-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.learn.summary"></g:message></div>
        </div>
        <div class="row sigma-learn-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.learn.summary"></g:message></div>
        </div>
    </g:if>
    <g:if test="${params.section == 'contact'}"> 
        <div class="row sigma-contact-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link params="[section: 'about']">ABOUT</g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary"><g:message code="sigmasite.contact.summary"></g:message></div>
        </div>
        <div class="row sigma-contact-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary"><g:message code="sigmasite.contact.summary"></g:message></div>
        </div>
    </g:if>
    <div class="row">
        <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding visible-lg visible-md">
            <div class="sigma-data-gradient dk-sigma-section-link">
                <g:link params="[section: 'data']">DATA</g:link>
                <g:if test="${params.section == 'data'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-papers-gradient dk-sigma-section-link">
                <g:link params="[section: 'papers']">PAPERS</g:link>
                <g:if test="${params.section == 'papers'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-partners-gradient dk-sigma-section-link">
                <g:link params="[section: 'partners']">PARTNERS</g:link>
                <g:if test="${params.section == 'partners'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-learn-gradient dk-sigma-section-link">
                <g:link params="[section: 'learn']">LEARN</g:link>
                <g:if test="${params.section == 'learn'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-contact-gradient dk-sigma-section-link">
                <g:link params="[section: 'contact']">CONTACT</g:link>
                <g:if test="${params.section == 'contact'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
        </div>
        <!-- Content -->
        <div class="col-lg-offset-0 col-md-offset-0 col-lg-8 col-md-8 col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10">
            <g:if test="${params.section == 'about' || params.section == null}"> 
                <g:render template="about"/> 
            </g:if> 
            <g:if test="${params.section == 'data'}"> 
                <g:render template="data"/> 
            </g:if> 
            <g:if test="${params.section == 'papers'}"> 
                <g:render template="papers"/> 
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