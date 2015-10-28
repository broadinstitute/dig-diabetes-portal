package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(SigmaController)
class SigmaControllerSpec extends Specification {

    public static final String ENGLISH = "en"
    public static final String SPANISH = "es"
    public static final String SOMETHING_OTHER_THAN_ENGLISH_OR_SPANISH = "fr"

    def webRequestLanguageLookupService = mockFor(WebRequestLanguageLookupService)

    def setup() {

    }

    def cleanup() {
    }

    void "test english"() {
        given:
        webRequestLanguageLookupService.demand.getLanguageForCurrentWebRequest(2) { -> ENGLISH }
        controller.webRequestLanguageLookupService = webRequestLanguageLookupService.createMock()
        expect:
        assertTrue(controller.isEnglish())
        assertFalse(controller.isSpanish())
    }

    void "test spanish"() {
        given:
        webRequestLanguageLookupService.demand.getLanguageForCurrentWebRequest(2) { -> SPANISH }
        controller.webRequestLanguageLookupService = webRequestLanguageLookupService.createMock()
        expect:
        assertFalse(controller.isEnglish())
        assertTrue(controller.isSpanish())
    }

    void "test not spanish and not english"() {
        given:
        webRequestLanguageLookupService.demand.getLanguageForCurrentWebRequest(2) { -> SOMETHING_OTHER_THAN_ENGLISH_OR_SPANISH }
        controller.webRequestLanguageLookupService = webRequestLanguageLookupService.createMock()
        expect:
        assertFalse(controller.isEnglish())
        assertFalse(controller.isSpanish())
    }
}
