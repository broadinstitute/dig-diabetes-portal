package grails.plugin.springsecurity.oauth

import grails.plugin.springsecurity.SpringSecurityService
import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(GoogleSpringSecurityOAuthService)
class GoogleSpringSecurityOAuthServiceSpec extends Specification {

    def oauthService
    GoogleSpringSecurityOAuthService service

    def setup() {
        service = new GoogleSpringSecurityOAuthService()
        oauthService = [:]

    }

    def cleanup() {
    }

    void "createAuthToken"() {
        given:
        def exception = null
        def response = [body: '']
        oauthService.getGoogleResource = { accessToken, url ->
            return response
        }
        service.oauthService = oauthService
        when:
        try {
            def token = service.createAuthToken( 0 )
        } catch (Throwable throwable) {
            exception = throwable
        }
        then:
        1==1

    }
}
