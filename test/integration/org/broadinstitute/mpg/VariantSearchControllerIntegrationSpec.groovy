package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.VariantSearchController
import spock.lang.Unroll

/**
 *
 */
@Unroll
class VariantSearchControllerIntegrationSpec extends IntegrationSpec {

    VariantSearchController controller


    def setup() {
        controller = new  VariantSearchController()
    }

    def cleanup() {
    }



    void "test variantSearch"() {
        when:
        controller.params.id='rs853787'
       // controller.variantSearch()

        then: 'verify that we get valid responses back'
        controller.params.id=='rs853787'  // placeholder -- replace with real test
       // assert controller.response.status==200

    }


//    void "test the variantAjax data retrieval"() {
//        when:
//        controller.params.id='rs853787'
//        controller.variantAjax()
//
//        then: 'verify that we get valid responses back'
//        assert controller.response.status==200
//        def controllerResponse = controller.response.contentAsString
//        def jsonResult = JSON.parse(controllerResponse)
//        assert jsonResult.size()>0
//
//    }



}

