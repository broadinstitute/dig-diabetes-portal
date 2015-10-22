package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec
import org.broadinstitute.mpg.InformationalController

/**
 *
 */
class InformationalControllerIntegrationSpec extends IntegrationSpec {

    InformationalController controller


    def setup() {
        controller = new  InformationalController()
    }

    def cleanup() {
    }



    void "test the about page"() {
        when:
        controller.about()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }



    void "test the contact page"() {
        when:
        controller.contact()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the hgat page"() {
        when:
        controller.hgat()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the t2dgenes page"() {
        when:
        controller.t2dgenes()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the t2dgenesection page"() {
        when:
        controller.params.id='cohorts'
        controller.t2dgenesection()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }



    void "test the got2d page"() {
        when:
        controller.got2d()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


    void "test the got2dsection page"() {
        when:
        controller.params.id='cohorts'
        controller.got2dsection()

        then: 'verify that we get valid responses back'
        assert controller.response.status==200

    }


}
