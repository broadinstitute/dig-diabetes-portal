package org.broadinstitute.mpg


class ProjectsController {

    WebRequestLanguageLookupService webRequestLanguageLookupService;


    def sigma() {
        render(view:'sigma/sigmahome',model:[isEnglish: isEnglish(), isSpanish:isSpanish(), locale:getLanguage()])
    }

    def got2d() {
        render(view:'got2d/got2dhome',model:[isEnglish: isEnglish(), isSpanish:isSpanish(), locale:getLanguage()])
    }

    def t2dGenes() {
        render(view:'t2dGenes/t2dGeneshome',model:[isEnglish: isEnglish(), isSpanish:isSpanish(), locale:getLanguage()])
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
