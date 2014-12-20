package dport

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(VariantController)
class VariantControllerUnitSpec extends Specification {


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
//    void "test variantInfo with params"() {
//        when:
//        controller.params.id="1"
//       controller.sharedToolsService = new SharedToolsService()
//       controller.sharedToolsService.metaClass.getSectionToDisplay = {def x->'1';
//       println "closure!";
//       'abc'}
//        controller.variantInfo()
//
//        then:
//        response.view == 'variantInfo'
//
//    }
    void "test variantInfo with no params"() {
        when:
        controller.variantInfo()

        then:
        response.status == 200

    }

    void "Test that index renders template for ajax calls"() {
        given:
        request.makeAjaxRequest()
       // views['/authenticationEvent/_index.gsp'] = 'my template text'

        when:
        controller.variantAjax()

        then:
       // response.contentAsString == 'my template text'
        response.status == 200
    }
}
