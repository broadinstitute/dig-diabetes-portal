package googlesignin

import dport.GoogleRestService
import org.broadinstitute.mpg.SpringManipService
import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.domain.DomainClassUnitTestMixin
import spock.lang.Specification
import uk.co.desirableobjects.oauth.scribe.OauthService

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestFor(SpringSecurityOAuthController)
@TestMixin(DomainClassUnitTestMixin)
class SpringSecurityOAuthControllerUnitSpec extends Specification {

    def setup() {
        String identityJson = '{"a":"b"}'
    }

    def cleanup() {
    }



    void "test failed response from buildCallToRetrieveOneTimeCode"() {
        given:
        controller.googleRestService = Mock(GoogleRestService)
        controller.oauthService = Mock(OauthService)
        controller.springManipService = Mock(SpringManipService)
        grailsApplication.config.oauth.providers.google.secret = 'secretcode'

        when:
        params.code = '47';
        params.provider = 'google';
        controller.googleRestService.metaClass.buildCallToRetrieveOneTimeCode = {->
            return null}
        controller.codeExchange()

        then:
        response.redirectedUrl == '/home/portalHome'

}





void "get to the end of codeExchange with some null values along the way"() {
        given:
        controller.googleRestService = Mock(GoogleRestService)
        controller.oauthService = Mock(OauthService)
        controller.springManipService = Mock(SpringManipService)
        grailsApplication.config.oauth.providers.google.secret = 'secretcode'

        when:
        params.code = '47';
        params.provider = 'google';
        controller.googleRestService.metaClass.buildCallToRetrieveOneTimeCode = {String myCode->
            return [identityInformation:identityJson,
                    accessToken:"4747"]}
        controller.oauthService.metaClass.findSessionKeyForAccessToken = {String authProvider->
            return "accessKey"}
        controller.springManipService.metaClass.forceLogin = {forceLogin, javax.servlet.http.HttpSession session->
            return "accessKey"}
        controller.codeExchange()

        then:
        response.redirectedUrl == '/home/portalHome'

    }




}
