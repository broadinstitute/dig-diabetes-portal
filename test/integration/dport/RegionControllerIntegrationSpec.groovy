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



    void "test the search a region by ajax page"() {
        when:
        controller.params.id="chr9:21,940,000-22,190,000"
        controller.regionInfo()
        then: 'verify that we get valid responses back'
        controller.response.status==302
        controller.response.redirectedUrl.contains("launchAVariantSearch")

    }



}

