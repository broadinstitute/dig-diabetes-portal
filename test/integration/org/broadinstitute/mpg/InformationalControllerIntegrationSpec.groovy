package org.broadinstitute.mpg

import grails.test.spock.IntegrationSpec

/**
 *
 */
class InformationalControllerIntegrationSpec extends IntegrationSpec {

    InformationalController controller

    def setup() {
        controller = new InformationalController()
    }

    def cleanup() {
    }

    void "test the about page"() {
        when:
        controller.about()

        then: 'verify that we get valid responses back'
        assert controller.response.status == 200

    }

    void "test the data page"() {
        when:
        controller.data()

        then: 'verify that we get valid responses back'
        assert controller.response.status == 200

    }

    void "test the contact page"() {
        when:
        controller.contact()

        then: 'verify that we get valid responses back'
        assert controller.response.status == 200

    }

    void "test the hgat page"() {
        when:
        controller.hgat()

        then: 'verify that we get valid responses back'
        assert controller.response.status == 200

    }
}
