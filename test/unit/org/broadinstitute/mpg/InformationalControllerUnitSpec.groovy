package org.broadinstitute.mpg

import dig.diabetes.portal.NewsFeedService
import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.RestServerService
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(InformationalController)
@TestMixin(GrailsUnitTestMixin)
class InformationalControllerUnitSpec extends Specification {

    RestServerService restServerService = new RestServerService()

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
        setup:
        controller.restServerService = restServerService

        when:
        restServerService.metaClass.retrieveBeanForCurrentPortal = {->null}
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
