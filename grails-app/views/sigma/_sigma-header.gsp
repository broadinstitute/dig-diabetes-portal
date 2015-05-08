<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>

<div class="row" style="vertical-align: middle;white-space: nowrap">
        <img class="sigmalogoholder col-md-2"
             src="${resource(dir: 'images/icons', file: 'SlimSigmaLogo234fromai-outlines.jpg')}"
             width="100%" alt="SIGMA logo"/>
        <div class="col-md-8">
            <table class="center-block">
                <tr>
                    <td>
                        <h1 style="font-size: 64pt;color:#003D5C">SIGMA</h1>
                    </td>
                    <td>
                        <h1 style="font-size: 64pt;font-weight: 300;color:#406993">T2D</h1>
                    </td>
                </tr>
            </table>

        </div>


        <div class="col-md-2">
            <table>
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td>
                        <g:if test="${!isEnglish}">
                            <g:link params="[lang: 'en']">english</g:link>
                        </g:if>
                        <g:if test="${isEnglish}">
                           english
                        </g:if>
                    </td>
                </tr>
                <tr>
                    <td>
                        <g:if test="${!isSpanish}">
                            <g:link params="[lang: 'es']">español</g:link>
                        </g:if>
                        <g:if test="${isSpanish}">
                            español
                        </g:if>
                    </td>
                </tr>
                <tr><td>data portal</td></tr>
            </table>
        </div>
</div>