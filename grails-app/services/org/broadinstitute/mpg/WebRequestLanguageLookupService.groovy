package org.broadinstitute.mpg

import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.util.WebUtils
import org.springframework.web.servlet.support.RequestContextUtils

@Transactional
class WebRequestLanguageLookupService {

    def getLanguageForCurrentWebRequest() {
        return RequestContextUtils.getLocale(WebUtils.retrieveGrailsWebRequest().currentRequest).toLanguageTag();
    }
}
