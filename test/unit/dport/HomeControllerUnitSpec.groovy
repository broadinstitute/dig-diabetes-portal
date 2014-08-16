package dport

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(HomeController)
class HomeControllerUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test index"() {
        when:
        controller.index()

        then:
        response.status == 200

        expect:
        grailsApplication != null

    }


    void "test portalHome"() {
        when:
        controller.portalHome()

        then:
        response.status == 200
        view == '/home/portalHome'

    }
}
