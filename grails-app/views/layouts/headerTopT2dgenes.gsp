<div style="background-color: #457BAE">
    <div class="container">
        <div style="margin-left: -15px;">
            <img style="width:100%;" src="${resource(dir: 'images/icons', file: 'amp-banner.png')}">
        </div>
    </div>
</div>
<div id="header-top">
    <div class="container">
        <g:renderSigmaSection>
            <span id="language">
                <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'><i class="icon-user icon-white">
                    <g:message code="portal.language.setting.spanish"/>
                </i></a>
                <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'> <i class="icon-user icon-white">
                    <g:message code="portal.language.setting.english"/>
                </i></a>
            </span>
            <a style="margin: 0; padding: 0" href="${createLink(controller: 'home', action:'portalHome')}">
                <div id="branding">
                    SIGMA <strong>T2D</strong> <small><g:rendersSigmaMessage messageSpec="site.subtext"/></small>
                </div>
            </a>
        </g:renderSigmaSection>
        <g:renderT2dGenesSection>
            <div id="branding">
                Type 2 Diabetes <strong>Genetics</strong> <small>beta</small>
            </div>
        </g:renderT2dGenesSection>
    </div>
</div>
