package org.broadinstitute.mpg

import dport.RestServerService
import grails.test.mixin.TestFor
import org.broadinstitute.mpg.RegionController
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(RegionController)
class RegionControllerUnitSpec extends Specification {
    RestServerService restServerService = new RestServerService()


    def setup() {
    }

    def cleanup() {
    }



    void "test regionAjax"() {
        when:
        int i=1
        then:
        i==1
    }



}
