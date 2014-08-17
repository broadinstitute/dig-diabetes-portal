package dport

import grails.converters.JSON
import grails.test.spock.IntegrationSpec
import spock.lang.*

/**
 *
 */
class GeneControllerIntegrationSpec extends IntegrationSpec {

    GeneController controller


    def setup() {
        controller = new  GeneController()
    }

    def cleanup() {
    }


    void "test engine that returns data for command completion"() {
        given:
        controller.params.query = 'G'

        when:
        controller.index()

        then: 'verify that we get non-null json'
        def controllerResponse = controller.response.contentAsString
        def jsonResult = JSON.parse(controllerResponse)
        assert jsonResult.size()>0

    }


    void "test return of the gene info core page"() {
        given:
        controller.params.id = 'G0S2'

        when:
        controller.geneInfo()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test return of the gene info Ajax content"() {
        given:
        controller.params.geneName = 'G0S2'

        when:
        controller.geneInfoAjax()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200
        def controllerResponse = controller.response.contentAsString
        def jsonResult = JSON.parse(controllerResponse)
        assert jsonResult.size()>0

    }


}
