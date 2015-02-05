package googlesignin

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(SpringSecurityOAuthController)
class SpringSecurityOAuthControllerUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test codeExchange"() {
        when:
            int i=1
        then:
            i==1
    }
}
