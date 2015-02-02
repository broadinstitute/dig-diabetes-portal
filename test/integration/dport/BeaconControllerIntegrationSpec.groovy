package dport

import grails.test.spock.IntegrationSpec
import groovy.json.JsonBuilder
import spock.lang.Unroll

/**
 *
 */
@Unroll
class BeaconControllerIntegrationSpec extends IntegrationSpec {

    BeaconController controller

    def setup() {
        controller = new BeaconController()
    }

    def cleanup() {
    }

    void "test Beacon back-end querying"() {
        given:
            def reqJsonBuilder = new JsonBuilder()
            def reqJson = reqJsonBuilder(
                    dataset: 'PRJEB7898',
                    chromosome: '1',
                    position: '13417',
                    allele: 'CGAGA',
            )

        when:
            controller.request.JSON = reqJson
            controller.beaconVariantQueryAjax()

        then: 'verify that we get valid responses back'
            assert controller.response.status==200

    }
}

