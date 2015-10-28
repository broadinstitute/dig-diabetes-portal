package org.broadinstitute.mpg

class SigmaController {

    WebRequestLanguageLookupService webRequestLanguageLookupService;


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
        return webRequestLanguageLookupService.getLanguageForCurrentWebRequest()
    }
}
