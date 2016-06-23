package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.broadinstitute.mpg.diabetes.MetaDataService
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(InformationalController)
@TestMixin(GrailsUnitTestMixin)
class InformationalControllerUnitSpec extends Specification {

    def setup() {
        controller.metaDataService = Mock(MetaDataService)
    }

    def cleanup() {
    }

    void "test about"() {
        when:
        controller.about()

        then:
        response.status == 200
        view == '/informational/about'
    }

    void "test data"() {
        when:
        controller.data()

        then:
        response.status == 200
        view == '/informational/data'
    }

    void "test contact"() {
        when:
        controller.contact()

        then:
        response.status == 200
        view == '/informational/contact'
    }

    void "test hgat"() {
        when:
        controller.hgat()

        then:
        response.status == 200
        view == '/informational/hgat'
    }
}
