package org.broadinstitute.mpg

import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(VariantInfoController)
@Mock([SharedToolsService])
class VariantInfoControllerUnitSpec extends Specification {


    def setup() {
    }

    def cleanup() {
    }


    void "test index"() {
        when:
        controller.index()

        then:
        response.status == 200

    }
    void "test variantInfo with params"() {
        when:
        controller.params.id="1"
        controller.sharedToolsService = Mock(SharedToolsService)
        controller.variantInfo()

        then:
        view=="/variantInfo/variantInfo"
        model.variantToSearch=="1"
        response.status == 200

    }


    void "Test that index renders template for ajax calls"() {
        given:
        request.makeAjaxRequest()
        JSONObject jsonObject = new  JSONObject("{'a':'mockData'}")
        controller.params.id="1"
        controller.restServerService = Mock(RestServerService)
        controller.restServerService.metaClass.retrieveVariantInfoByName = {String x->return jsonObject}

        when:
        controller.variantAjax()

        then:
        response.status == 200
        response.contentAsString.contains('variant')
        response.contentAsString.contains('mockData')
    }
}
