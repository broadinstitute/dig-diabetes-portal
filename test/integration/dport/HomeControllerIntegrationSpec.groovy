package dport

import grails.converters.JSON
import grails.test.spock.IntegrationSpec

/**
 *
 */
class HomeControllerIntegrationSpec extends IntegrationSpec {

    HomeController controller


    def setup() {
        controller = new  HomeController()
    }

    def cleanup() {
    }



    void "test the main page of the application.  The first place that everybody goes"() {
        when:
        controller.portalHome()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }



}
