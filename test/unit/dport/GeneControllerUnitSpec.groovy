package dport

import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(GeneController)
///@Mock([Shoppable, QueryItem, CartAssay, CartProject])
class GeneControllerUnitSpec extends Specification {
    SharedToolsService sharedToolsService = new  SharedToolsService()
    GeneManagementService geneManagementService = new GeneManagementService()
    RestServerService restServerService = new RestServerService()

    def setup() {
    }

    def cleanup() {
    }

    void "test geneInfo"() {
        setup:
        controller.geneManagementService = geneManagementService
        controller.sharedToolsService = sharedToolsService

        when:
         controller.geneInfo()

        then:
        response.status == 200
    }


    void "test geneAjax"() {
        when:
        params.id=""
        controller.restServerService  = restServerService
        controller.geneAjax()

        then:
        response.status == 200
    }


    void "test geneInfoAjax"() {
        when:
        controller.geneInfoAjax()

        then:
        response.status == 200
    }
}
