<%@ page import="org.springframework.web.servlet.i18n.SessionLocaleResolver" %>

<div class="row" style="vertical-align: middle;">
        <img class="sigmalogoholder col-md-2"
             src="${resource(dir: 'images/icons', file: 'SlimSigmaLogo234fromai-outlines.jpg')}"
             width="100%" alt="SIGMA logo"/>
        <h1 class="col-md-8 text-center">SIGMA T2D</h1>

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