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

}

