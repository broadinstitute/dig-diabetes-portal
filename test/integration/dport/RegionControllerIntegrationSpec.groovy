/**
 * Created by ben on 8/16/2014.
 */
package dport

import grails.converters.JSON
import grails.test.spock.IntegrationSpec

/**
 *
 */
class RegionControllerIntegrationSpec extends IntegrationSpec {

    RegionController controller


    def setup() {
        controller = new  RegionController()
    }

    def cleanup() {
    }



    void "test the search a region page"() {
        when:
        controller.params.id='chr1:209348715-210349783'
        controller.regionInfo()

        then: 'verify that we get perform a redirection'
        assert controller.response.status==302

    }


    void "test the search a region by ajax page"() {
        when:
        controller.params.id='chr1:209348715-210349783'
        controller.regionAjax()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200
        def controllerResponse = controller.response.contentAsString
        def jsonResult = JSON.parse(controllerResponse)
        assert jsonResult.size()>0

    }



}

