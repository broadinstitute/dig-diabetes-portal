package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import org.broadinstitute.mpg.GoogleRestService
import spock.lang.Specification
import spock.lang.Unroll

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@Unroll
@TestFor(GoogleRestService)
class GoogleRestServiceUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "buildCallToRetrieveOneTimeCode smoke test"() {
        given:
        grailsApplication.config.oauth.providers.google.secret = 'www.googleapis.com'
        grailsApplication.config.oauth.providers.google.callback =  '/springSecurityOAuth/codeExchange?provider=google'
        when:
        Map results = service.buildCallToRetrieveOneTimeCode('oneTimeCode')
        then:
        results.size()==3
    }
}
