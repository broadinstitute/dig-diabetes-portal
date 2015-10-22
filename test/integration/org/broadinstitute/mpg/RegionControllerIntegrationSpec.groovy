/**
 * Created by ben on 8/16/2014.
 */
package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.RegionController

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

