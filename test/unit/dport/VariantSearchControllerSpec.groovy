package dport

import grails.test.mixin.TestFor
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(VariantSearchController)
class VariantSearchControllerSpec extends Specification {

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



    void "test variantSearch"() {
        given:
        controller.sharedToolsService = Mock(SharedToolsService)

        when:
        params.encParams = '20:1'
        controller.sharedToolsService.metaClass.urlEncodedListOfPhenotypes = {->return "20:1"}
        controller.variantSearch()

        then:
        response.status == 200
        view == '/variantSearch/variantSearch'
        model.encParams == "20:1"
    }


    void "test gene"() {
        given:
        controller.filterManagementService = Mock(FilterManagementService)

        when:
        params["id"] = "name"
        params["filter"] = "filter"
        params["sig"] = "sig"
        params["dataset"] = "dataSet"
        params["region"] = "region"
        controller.gene()

        then:
        response.status == 200

    }

      // This one leaves me stuck on  URLDecoder -- I'm not sure how to mock it
//    void "test variantSearchAjax"() {
//   }


}
