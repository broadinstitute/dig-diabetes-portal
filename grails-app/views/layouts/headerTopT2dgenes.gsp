<div id="header-top">
    <div class="container">
        <g:renderSigmaSection>
            <span id="language">
                <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'><i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/Mexico.png" alt="Mexico"/></i></a>
                %{--<a href="/dig-diabetes-portal/home?lang=en"> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>--}%
                <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'> <i class="icon-user icon-white"><r:img class="currentlanguage" uri="/images/United-States.png" alt="USA"/></i></a>
            </span>
            <a style="margin: 0; padding: 0" href="${createLink(controller: 'home', action:'portalHome')}">
                <div id="branding">
                    SIGMA <strong>T2D</strong> <small><g:rendersSigmaMessage messageSpec="site.subtext"/></small>
                </div>
            </a>
        </g:renderSigmaSection>
        <g:renderNotSigmaSection>
            <a style="margin: 0; padding: 0" href="${createLink(controller: 'home', action:'portalHome')}">
                <div id="branding">
                    Type 2 Diabetes <strong>Genetics</strong> <small>Beta</small>
                </div>
            </a>
        </g:renderNotSigmaSection>
    </div>
</div>
