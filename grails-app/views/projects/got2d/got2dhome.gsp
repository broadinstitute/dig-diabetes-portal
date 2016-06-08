
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="got2d"/>
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
</head>

<body>
<div class="container-fluid">
    <div class="row dk-sigma-small-nav text-center visible-sm visible-xs">
        <div class="col-sm-4 col-xs-4 sigma-about-gradient">
            <g:if test="${params.section == 'about' || params.section == null}">
                <g:link action='got2d' params="[section: 'about']"><strong><g:message code="sigmasite.home.section.caps.about" /></strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-data-gradient">
            <g:if test="${params.section == 'data'}">
                <g:link action='got2d' params="[section: 'data']"><strong><g:message code="sigmasite.home.section.caps.data" /></strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'data']"><g:message code="sigmasite.home.section.caps.data" /></g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-papers-gradient">
            <g:if test="${params.section == 'papers'}">
                <g:link action='got2d' params="[section: 'papers']"><strong><g:message code="sigmasite.home.section.caps.papers" /></strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'papers']"><g:message code="sigmasite.home.section.caps.papers" /></g:link>
            </g:else>
        </div>
    </div>
    <div class="row dk-sigma-small-nav text-center visible-sm visible-xs">
        <div class="col-sm-4 col-xs-4 sigma-partners-gradient">
            <g:if test="${params.section == 'partners'}">
                <g:link action='got2d' params="[section: 'partners']"><strong><g:message code="sigmasite.home.section.caps.partners" /></strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'partners']"><g:message code="sigmasite.home.section.caps.partners" /></g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-learn-gradient">
            <g:if test="${params.section == 'learn'}">
                <g:link action='got2d' params="[section: 'learn']"><strong>COHORTS</strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'learn']"><strong>COHORTS</strong></g:link>
            </g:else>
        </div>
        <div class="col-sm-4 col-xs-4 sigma-contact-gradient">
            <g:if test="${params.section == 'contact'}">
                <g:link action='got2d' params="[section: 'contact']"><strong><g:message code="sigmasite.home.section.caps.contact" /></strong></g:link>
            </g:if>
            <g:else>
                <g:link action='got2d' params="[section: 'contact']"><g:message code="sigmasite.home.section.caps.contact" /></g:link>
            </g:else>
        </div>
    </div>
    <g:if test="${params.section == 'about' || params.section == null}"> 
        <div class="row sigma-about-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">a consortium investigating the Genetics of Type 2 Diabetes</div>
        </div>
        <div class="row sigma-about-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">a consortium investigating the Genetics of Type 2 Diabetes</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'data'}"> 
        <div class="row sigma-data-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">data from the GoT2D consortium in the T2D Knowledge Portal</div>
        </div>
        <div class="row sigma-data-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">data from the GoT2D consortium in the T2D Knowledge Portal</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'papers'}"> 
        <div class="row sigma-papers-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">publications from the GoT2D consortium</div>
        </div>
        <div class="row sigma-papers-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">publications from the GoT2D consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'partners'}"> 
        <div class="row sigma-partners-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">members of the GoT2D consortium</div>
        </div>
        <div class="row sigma-partners-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">members of the GoT2D consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'learn'}"> 
        <div class="row sigma-learn-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">find out more about cohorts studied by the GoT2D consortium</div>
        </div>
        <div class="row sigma-learn-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">find out more about cohorts studied by the GoT2D consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'contact'}"> 
        <div class="row sigma-contact-gradient dk-sigma-section-header visible-lg visible-md">
            <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='got2d' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-lg-8 col-md-8 dk-sigma-content-summary">contact the GoT2D consortium with questions or suggestions</div>
        </div>
        <div class="row sigma-contact-gradient dk-sigma-section-header-sm visible-sm visible-xs">
            <div class="col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10 dk-sigma-content-summary">contact the GoT2D consortium with questions or suggestions</div>
        </div>
    </g:if>
    <div class="row">
        <div class="col-lg-3 col-md-3 text-center dk-sigma-nopadding visible-lg visible-md">
            <div class="sigma-data-gradient dk-sigma-section-link">
                <g:link action='got2d' params="[section: 'data']"><g:message code="sigmasite.home.section.caps.data" /></g:link>
                <g:if test="${params.section == 'data'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-papers-gradient dk-sigma-section-link">
                <g:link action='got2d' params="[section: 'papers']"><g:message code="sigmasite.home.section.caps.papers" /></g:link>
                <g:if test="${params.section == 'papers'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-partners-gradient dk-sigma-section-link">
                <g:link action='got2d' params="[section: 'partners']"><g:message code="sigmasite.home.section.caps.partners" /></g:link>
                <g:if test="${params.section == 'partners'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-learn-gradient dk-sigma-section-link">
                <g:link action='got2d' params="[section: 'learn']"><g:message code="sigmasite.home.section.caps.learn" /></g:link>
                <g:if test="${params.section == 'learn'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-contact-gradient dk-sigma-section-link">
                <g:link action='got2d' params="[section: 'contact']"><g:message code="sigmasite.home.section.caps.contact" /></g:link>
                <g:if test="${params.section == 'contact'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
        </div>
        <!-- Content -->
        <div class="col-lg-offset-0 col-md-offset-0 col-lg-8 col-md-8 col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10">
            <g:if test="${params.section == 'about' || params.section == null}"> 
                <g:render template="got2d/about"/> 
            </g:if> 
            <g:if test="${params.section == 'data'}"> 
                <g:render template="got2d/data"/> 
            </g:if> 
            <g:if test="${params.section == 'papers'}"> 
                <g:render template="got2d/papers"/> 
            </g:if> 
            <g:if test="${params.section == 'partners'}"> 
                <g:render template="got2d/partners"/> 
            </g:if> 
            <g:if test="${params.section == 'learn'}"> 
                <g:render template="got2d/learn"/> 
            </g:if> 
            <g:if test="${params.section == 'contact'}"> 
                <g:render template="got2d/contact"/> 
            </g:if> 
        </div>
    </div>
</div>
</body>
</html>
