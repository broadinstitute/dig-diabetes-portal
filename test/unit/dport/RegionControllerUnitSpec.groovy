package dport

import grails.test.mixin.TestFor
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
        params.id=""
        controller.restServerService  = restServerService
        controller.restServerService  = restServerService.metaClass.searchGenomicRegionAsSpecifiedByUsers{-> ""}
        controller.regionAjax()

        then:
        response.status == 200
    }



}
