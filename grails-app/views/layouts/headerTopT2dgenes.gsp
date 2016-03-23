<div style="background-color: #457BAE">
    <div class="container">
        <div style="margin-left: -20px;">
            <img style="width:100%;" src="${resource(dir: 'images/icons', file: 'amp-banner.png')}">
        </div>
    </div>
</div>
<div id="header-top">
    <div class="container">
        <g:renderT2dGenesSection>
            <div id="branding">
                <g:if test="${g.portalTypeString()?.equals('stroke')}">
                    <g:message code="portal.stroke.header.title.short"/> <strong style="color:white"><g:message code="portal.stroke.header.title.genetics"/></strong>
                    <small><g:message code="portal.header.title.beta"/></small>
                </g:if>
                <g:else>
                        <g:message code="portal.header.title.short"/> <strong style="color:white"><g:message code="portal.header.title.genetics"/></strong>
                </g:else>
            </div>
        </g:renderT2dGenesSection>
        <span id="language" style="margin-top: -30px">
            <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'>
                <g:message code="portal.language.setting.setSpanish" defaukt="En Español" /></a> |
            <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'>
                <g:message code="portal.language.setting.setEnglish" default="In English" /></a>
        </span>

    </div>
</div>
