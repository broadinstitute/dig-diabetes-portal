package dport

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(TraitController)
class TraitControllerUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test traitInfo"() {
        setup:
        params.id = 'TP53'

        when:
        controller.genomeBrowser()

        then:
        response.status == 200
        view == '/trait/genomeBrowser'
        model.geneName == 'TP53'

    }

}
