/**
 * Created by ben on 8/16/2014.
 */
package org.broadinstitute.mpg

import grails.converters.JSON
import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.VariantInfoController

/**
 *
 */
class VariantInfoControllerIntegrationSpec extends IntegrationSpec {

    VariantInfoController controller


    def setup() {
        controller = new  VariantInfoController()
    }

    def cleanup() {
    }




    void "test the variantInfo page"() {
        when:
        controller.params.id='rs853787'
        controller.variantInfo()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the variantAjax data retrieval"() {
        when:
        controller.params.id='rs853787'
        controller.variantAjax()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200
        def controllerResponse = controller.response.contentAsString
        def jsonResult = JSON.parse(controllerResponse)
        assert jsonResult.size()>0

    }



}

