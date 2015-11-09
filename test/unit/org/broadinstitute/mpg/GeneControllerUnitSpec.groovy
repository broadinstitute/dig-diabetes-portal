package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.broadinstitute.mpg.diabetes.MetaDataService
import spock.lang.Specification
/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */

@TestMixin(GrailsUnitTestMixin)
@TestFor(GeneController)
///@Mock([Shoppable, QueryItem, CartAssay, CartProject])
class GeneControllerUnitSpec extends Specification {
    SharedToolsService sharedToolsService = new  SharedToolsService()
    GeneManagementService geneManagementService = new GeneManagementService()
    def metaDataService = new MetaDataService()
    RestServerService restServerService = new RestServerService()

    def setupSpec() {
        MetaDataService.metaClass.urlEncodedListOfPhenotypes = { ->
            // do something here
        }
        GeneManagementService.metaClass.getRegionSpecificationForGene = { ->
            // do something here
        }
    }

    def setup() {
    }

    def cleanup() {
    }

    void "test geneInfo"() {
        setup:
        controller.geneManagementService = geneManagementService
        controller.sharedToolsService = sharedToolsService
        controller.metaDataService = metaDataService
        metaDataService.metaClass.getSampleGroupList = {->[]}

        when:
         controller.geneInfo()

        then:
       response.status == 200
    }


    void "test geneInfoAjax"() {
        when:
        controller.geneInfoAjax()

        then:
        response.status == 200
    }
}
