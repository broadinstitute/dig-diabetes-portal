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
                Type 2 Diabetes <strong style="color:white">Genetics</strong> <small>beta</small>
            </div>
        </g:renderT2dGenesSection>
        <span id="language" style="margin-top: -30px">
            <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'>
                <r:img class="currentlanguage" uri="/images/espanol2.png" alt="Spanish"/></a>
            <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'>
                <r:img class="currentlanguage" uri="/images/english2.png" alt="English"/></a>
            %{--<a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'><i class="icon-user icon-white">--}%
                %{--<g:message code="portal.language.spanish.switch" default="in Spanish"/></i></a>--}%
            %{--<a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'> <i class="icon-user icon-white">--}%
                %{--<g:message code="portal.language.english.switch" default="in English"/></i></a>--}%
        </span>

    </div>
</div>
