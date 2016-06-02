<div class="container-fluid">
    <div class="row dk-sigma-site-title visible-lg visible-md ">
        <div class="col-lg-3 col-md-3 text-center">
            <g:if test="${locale?.startsWith('es')}">
                <img src="${resource(dir: 'images/', file: 'LogoSIGMASPANISH.png')}"
                     width="180" height="91px" alt="SLIM" style="margin-top: 35px"/>
            </g:if>
            <g:else>
                <img src="${resource(dir: 'images/', file: 'LogoSigmaENGLISH.png')}"
                     width="180" height="91px" alt="SLIM" style="margin-top: 35px"/>
            </g:else>
        </div>
        <div class="col-lg-offset-0 col-md-offset-0 col-lg-8 col-md-8 col-sm-offset-1 col-xs-offset-1 col-sm-10 col-xs-10">
            <span class="dk-sigma-site-name">SIGMA<strong style="font-weight: 400;color:#406993;">T2D</strong></span>
        </div>
    </div>
    <div class="row dk-sigma-site-title-sm visible-sm visible-xs ">
    <div class="col-sm-12 col-md-12 text-center">
        <img src="${resource(dir: 'images/icons', file: 'SlimSigmaLogo234fromai-outlines.jpg')}" alt="SIGMA logo" />
        SIGMA<strong style="font-weight: 400;color:#406993;">T2D</strong><br>
    </div>
    </div>
    <div class="row" >
        <div class="col-sm-12 col-md-12 text-center">
                <span style="float: right;">
                    <a href='<g:createLink controller="projects" action="sigma" params="[lang:'es']"/>' style="padding-right: 20px">
                        <r:img class="currentlanguage" uri="/images/spanish_black_it.png" alt="Spanish"/></a>
                    <a href='<g:createLink controller="projects" action="sigma" params="[lang:'en']"/>'>
                        <r:img class="currentlanguage" uri="/images/english_black_it.png" alt="English"/></a>
                </span>
        </div>
    </div>

</div>
