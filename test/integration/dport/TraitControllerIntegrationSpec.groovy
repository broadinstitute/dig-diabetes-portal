/**
 * Created by ben on 8/16/2014.
 */
package dport

import grails.converters.JSON
import grails.test.spock.IntegrationSpec

/**
 *
 */
class TraitControllerIntegrationSpec extends IntegrationSpec {

    TraitController controller


    def setup() {
        controller = new  TraitController()
    }

    def cleanup() {
    }



    void "test the traitInfo page"() {
        when:
        controller.params.id='rs853787'
        controller.traitInfo()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the search a trait (and potentially  ignificance) page"() {
        when:
        controller.params.trait="CKD"
        controller.params.significance='5e-8'
        controller.traitSearch()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }

//
//    void "test the search a trait by ajax page"() {
//        when:
//        controller.params.trait="T2D"
//        controller.params.significance='5e-8'
//        controller.phenotypeAjax()
//
//        then: 'verify that we get valid responses back'
//        assert controller.response.status==200
//        def controllerResponse = controller.response.contentAsString
//        def jsonResult = JSON.parse(controllerResponse)
//        assert jsonResult.size()>0
//
//    }

//    void "test the association statistics across 25 traits by ajax page"() {
//        when:
//        controller.params.variantIdentifier='rs853787'
//        controller.ajaxTraitsPerVariant()
//
//        then: 'verify that we get valid responses back'
//        assert controller.response.status==200
//        def controllerResponse = controller.response.contentAsString
//        def jsonResult = JSON.parse(controllerResponse)
//        assert jsonResult.size()>0
//
//    }



    void "test the search a traits across region page"() {
        when:
        controller.params.id="chr1:209348715-210349783"
        controller.regionInfo()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }

    void "test traitVariantCrossAjax"() {
        when:
        controller.params.id='chr1:209348715-210349783'
        controller.traitVariantCrossAjax()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200
        def controllerResponse = controller.response.contentAsString
        def jsonResult = JSON.parse(controllerResponse)
        assert jsonResult.size()>0

    }




}
