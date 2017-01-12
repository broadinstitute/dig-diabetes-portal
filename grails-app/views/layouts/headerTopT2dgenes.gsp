<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="container-fluid dk-amp-banner" style="background-image:url('${resource(dir:'images/stroke', file:'isgc_banner2.png')}');">
        <div class="container-fluid dk-amp-name-wrapper">
            <a href="http://www.strokegenetics.org">
                <div class="dk-amp-banner-name">
                    INTERNATIONAL STROKE GENETICS CONSORTIUM (ISGC)
                </div>
            </a>
        </div>
    </div>
</g:if>
<g:else>
    <div class="container-fluid dk-amp-banner" style="background-image:url('${resource(dir:'images', file:'AMP_banner_middle.png')}');">
        <div class="container-fluid dk-amp-name-wrapper" style="background-image:url('${resource(dir:'images', file:'AMP_banner_right.png')}');">
            <a href="http://www.nih.gov/research-training/accelerating-medicines-partnership-amp/type-2-diabetes">
                <div class="dk-amp-banner-name" style="background-image:url('${resource(dir:'images', file:'AMP_banner_left.png')}');">
                    ACCELERATING MEDICINES PARTNERSHIP (AMP)
                </div>
            </a>
        </div>
    </div>
</g:else>
<div id="header-top">
    <g:renderT2dGenesSection>
        <div class="container-fluid dk-t2d-banner" style="background-image: url('${resource(dir: 'images', file: 'logo_bg.jpg')}')">
            <g:if test="${g.portalTypeString()?.equals('stroke')}">
                <img src="${resource(dir: 'images/stroke', file:g.message(code:"files.strokeBannerText", default:"R24_logo.png"))}" />
            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                <img src="${resource(dir: 'images/mi', file:g.message(code:"files.miBannerText", default:"mi_banner.png"))}" />
            </g:elseif>
            <g:else>
                <img src="${resource(dir: 'images', file:g.message(code:"files.t2dBannerText", default:"t2d_logo.png"))}" />
            </g:else>
            <div class="container-fluid dk-t2d-user-banner">
                <a href='<g:createLink controller="home" action="index" params="[lang:'es']"/>'>
                    <g:message code="portal.language.setting.setSpanish" default="En Español" /></a> |
                <a href='<g:createLink controller="home" action="index" params="[lang:'en']"/>'>
                    <g:message code="portal.language.setting.setEnglish" default="In English" /></a>
            </div>
        </div>
    </g:renderT2dGenesSection>
</div>
