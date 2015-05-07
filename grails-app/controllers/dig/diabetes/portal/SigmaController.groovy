package dig.diabetes.portal

import org.codehaus.groovy.grails.web.util.WebUtils
import org.springframework.web.servlet.support.RequestContextUtils

class SigmaController {

    def index() {
        render(view:'sigmahome',model:[isEnglish: isEnglish(),isSpanish:isSpanish()])
    }

    def isEnglish() {
        return getLanguage().startsWith("en");
    }

    def isSpanish() {
        return getLanguage().startsWith("es");
    }

    def getLanguage() {
        return RequestContextUtils.getLocale(WebUtils.retrieveGrailsWebRequest().currentRequest).toLanguageTag();
    }
}
