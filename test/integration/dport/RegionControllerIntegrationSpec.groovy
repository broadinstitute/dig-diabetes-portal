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
 int i =1
        then: 'verify that we get valid responses back'
i==1
    }



}

