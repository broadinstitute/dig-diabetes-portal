package dport

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.domain.DomainClassUnitTestMixin
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(TraitController)
@TestMixin(DomainClassUnitTestMixin)
class TraitControllerUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }


    void "don't crash if you receive no parameters with a traitInfo"() {
        given:
        controller.sharedToolsService = Mock(SharedToolsService)

        when:
        controller.traitInfo()

        then:
        response.status == 200

    }


    void "test traitInfo"() {
        given:
        controller.sharedToolsService = Mock(SharedToolsService)

        when:
        params.id = 'rs560887'
        controller.sharedToolsService.metaClass.urlEncodedListOfPhenotypes = {->return "20:1"}
        controller.traitInfo()

        then:
        response.status == 200
        view == '/trait/traitsPerVariant'
        model.variantIdentifier == 'rs560887'
        model.phenotypeList == '20:1'

    }



//    void "test traitSearch with no phenotype lookup"() {
//        given:
//        controller.sharedToolsService = Mock(SharedToolsService)
//        mockDomain (Phenotype)
//
//        when:
//        Map phenotypeReturn = [name:'name',dataSet:'dataSet']
//        params.trait = 'FastGlu'
//        params.significance = '5e-8'
//        controller.sharedToolsService.metaClass.urlEncodedListOfPhenotypes = {->return "20:1"}
//        Phenotype.metaClass.'static'.findByDatabaseKey() { String query ->
//            return phenotypeReturn
//        }
//        controller.traitSearch()
//
//        then:
//        response.status == 200
//        view == '/trait/phenotype'
//        model.requestedSignificance == '5e-8'
//        model.phenotypeKey == 'FastGlu'
//        model.phenotypeDataSet == ""
//
//    }

//TODO fix when the world is no longer on fire
//    void "test phenotypeAjax"() {
//        given:
//        request.makeAjaxRequest()
//        controller.restServerService = Mock(RestServerService)
//        JSONObject jsonObject = new  JSONObject("{'variants':'mockData'}")
//        params.trait = 'FastGlu'
//        params.significance = '5e-8'
//        controller.sharedToolsService = Mock(SharedToolsService)
//        controller.restServerService.metaClass.searchTraitByName = {String phenotypicTrait,BigDecimal significanceValue->return jsonObject}
//        controller.restServerService.metaClass.getProcessedMetadata = {String phenotypicTrait,BigDecimal significanceValue->return jsonObject}
//
//        when:
//        controller.phenotypeAjax()
//
//        then:
//        response.status == 200
//        response.contentAsString.contains('variant')
//        response.contentAsString.contains('mockData')
//    }




    void "test genomeBrowser"() {
        setup:
        params.id = 'TP53'

        when:
        controller.genomeBrowser()

        then:
        response.status == 200
        view == '/trait/genomeBrowser'
        model.geneName == 'TP53'

    }



//    void "test ajaxTraitsPerVariant"() {
//        given:
//        request.makeAjaxRequest()
//        controller.restServerService = Mock(RestServerService)
//        JSONObject jsonObject = new  JSONObject("{'trait-info':'mockData'}")
//        params.variantIdentifier = 'rs560887'
//        params.significance = '5e-8'
//        controller.restServerService = Mock(RestServerService)
//        controller.restServerService.metaClass.retrieveTraitInfoByVariant = {String variant->return jsonObject}
//
//        when:
//        controller.ajaxTraitsPerVariant()
//
//        then:
//        response.status == 200
//        response.contentAsString.contains('traitInfo')
//        response.contentAsString.contains('mockData')
//    }



    void "test regionInfo"() {
        given:
        controller.sharedToolsService = Mock(SharedToolsService)

        when:
        params.id = 'rs560887'
        controller.sharedToolsService.metaClass.urlEncodedListOfPhenotypes = {->return "20:1"}
        controller.regionInfo()

        then:
        response.status == 200
        view == '/trait/traitVariantCross'
        model.regionSpecification == 'rs560887'
        model.phenotypeList == '20:1'

    }


}
