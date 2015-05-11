<div class="container-fluid" style="height: 120px;">
    <div class="row clearfix">
        <!-- todo pull out vertical alignment style -->
        <div class="col-md-2"
             style="float:none;
             display:inline-block;
             vertical-align:middle;">
            <img src="${resource(dir: 'images/icons', file: 'SlimSigmaLogo234fromai-outlines.jpg')}"
                 alt="SIGMA logo"/>
        </div>
        <div class="col-md-7" style="float:none;
            display:inline-block;
            vertical-align:middle;">
            <table class="center-block">
                <tr>
                    <td>
                        <h1 style="font-size: 64pt;color:#003D5C; margin:0;">SIGMA</h1>
                    </td>
                    <td>
                        <h1 style="font-size: 64pt;font-weight: 300;color:#406993; margin:0;">T2D</h1>
                    </td>
                </tr>
            </table>

        </div>


        <div class="col-md-2" style="float:none;
        display:inline-block;
        vertical-align:middle;">
            <table class="language-table">
                <tr>
                    <td>
                        <g:if test="${!isEnglish}">
                            <g:link params="${params + [lang: 'en']}" class="sigma-link">english</g:link>
                        </g:if>
                        <g:if test="${isEnglish}">
                            english
                        </g:if>
                    </td>
                </tr>
                <tr>
                    <td>
                        <g:if test="${!isSpanish}">
                            <g:link params="${params + [lang: 'es']}" class="sigma-link">español</g:link>
                        </g:if>
                        <g:if test="${isSpanish}">
                            español
                        </g:if>
                    </td>
                </tr>
                <tr><td><a href="" class="sigma-link">data portal</a></td></tr>
            </table>
        </div>
    </div>
</div>
