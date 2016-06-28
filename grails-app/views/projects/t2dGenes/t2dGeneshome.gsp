
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="t2dGenes"/>
    <r:require modules="core"/>
    <r:require modules="sigma"/>
    <r:layoutResources/>
</head>

<body>
<div class="container-fluid">
    <g:if test="${params.section == 'about' || params.section == null}"> 
        <div class="row sigma-about-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">a consortium for Type 2 Diabetes Genetic Exploration by Next-generation sequencing in multi-Ethnic Samples</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'data'}"> 
        <div class="row sigma-data-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">data from the T2D-GENES consortium in the T2D Knowledge Portal</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'papers'}"> 
        <div class="row sigma-papers-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">publications from the T2D-GENES consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'partners'}"> 
        <div class="row sigma-partners-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">members of the T2D-GENES consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'learn'}"> 
        <div class="row sigma-learn-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">find out more about cohorts studied by the T2D-GENES consortium</div>
        </div>
    </g:if>
    <g:if test="${params.section == 'contact'}"> 
        <div class="row sigma-contact-gradient dk-sigma-section-header">
            <div class="col-xs-3 text-center dk-sigma-nopadding"><div class="sigma-about-gradient dk-sigma-section-link"><g:link action='t2dGenes' params="[section: 'about']"><g:message code="sigmasite.home.section.caps.about" /></g:link></div></div>
            <div class="col-xs-8 dk-sigma-content-summary">contact the T2D-GENES consortium with questions or suggestions</div>
        </div>
    </g:if>
    <div class="row">
        <div class="col-xs-3 text-center dk-sigma-nopadding">
            <div class="sigma-data-gradient dk-sigma-section-link">
                <g:link action='t2dGenes' params="[section: 'data']"><g:message code="sigmasite.home.section.caps.data" /></g:link>
                <g:if test="${params.section == 'data'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-papers-gradient dk-sigma-section-link">
                <g:link action='t2dGenes' params="[section: 'papers']"><g:message code="sigmasite.home.section.caps.papers" /></g:link>
                <g:if test="${params.section == 'papers'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-partners-gradient dk-sigma-section-link">
                <g:link action='t2dGenes' params="[section: 'partners']"><g:message code="sigmasite.home.section.caps.partners" /></g:link>
                <g:if test="${params.section == 'partners'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-learn-gradient dk-sigma-section-link">
                <g:link action='t2dGenes' params="[section: 'learn']">COHORTS</g:link>
                <g:if test="${params.section == 'learn'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
            <div class="sigma-contact-gradient dk-sigma-section-link">
                <g:link action='t2dGenes' params="[section: 'contact']"><g:message code="sigmasite.home.section.caps.contact" /></g:link>
                <g:if test="${params.section == 'contact'}"> 
                    <img src="${resource(dir: 'images/icons', file: 'triangle.png')}" class="dk-sigma-section-pointer" />
                </g:if> 
            </div>
        </div>
        <!-- Content -->
        <div class="col-xs-offset-1 col-xs-7">
            <g:if test="${params.section == 'about' || params.section == null}"> 
                <g:render template="t2dGenes/about"/> 
            </g:if> 
            <g:if test="${params.section == 'data'}"> 
                <g:render template="t2dGenes/data"/> 
            </g:if> 
            <g:if test="${params.section == 'papers'}"> 
                <g:render template="t2dGenes/papers"/> 
            </g:if> 
            <g:if test="${params.section == 'partners'}"> 
                <g:render template="t2dGenes/partners"/> 
            </g:if> 
            <g:if test="${params.section == 'learn'}"> 
                <g:render template="t2dGenes/learn"/> 
            </g:if> 
            <g:if test="${params.section == 'contact'}"> 
                <g:render template="t2dGenes/contact"/> 
            </g:if> 
        </div>
    </div>
</div>
</body>
</html>
