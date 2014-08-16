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
        params.identifier = 'rs123'

        when:
        controller.traitInfo()

        then:
        response.status == 200
        view == '/trait/traitsPerVariant'
        model.show_gwas == 1

    }

}
