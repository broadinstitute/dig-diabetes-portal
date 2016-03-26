package org.broadinstitute.mpg

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.broadinstitute.mpg.InformationalController
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(InformationalController)
@TestMixin(GrailsUnitTestMixin)
class InformationalControllerUnitSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test about"() {
        when:
        controller.aboutthedata()

        then:
        response.status == 200
        view == '/informational/about'
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


    void "test t2dgenes"() {
        when:
        controller.t2dgenes()

        then:
        response.status == 200
        view == '/informational/t2dgenes'
        model.specifics == 'cohorts'
    }


    void "test t2dgenesection"() {
        when:
        params.id=currentParameter
        controller.t2dgenesection()

        then:
        response.status == 200
        response.text.contains(currentText)

        where:
        label                  | currentText                             | currentParameter
        "cohorts template"     | 'div'                                   | "cohorts"
        "papers template"      | 'div'                                   | "papers"
        "people's template"    | 'div'                                   | "people"
        "project 1"            | 'div'                                   | "project1"
        "project 2"            | 'div'                                   | "project2"
        "project 3"            | 'div'                                   | "project3"

    }



    void "test got2d"() {
        when:
        controller.got2d()

        then:
        response.status == 200
        view == '/informational/got2d'
        model.specifics == 'cohorts'
    }



    void "test got2dsection"() {
        when:
        params.id=currentParameter
        controller.got2dsection()

        then:
        response.status == 200
        response.text.contains(currentText)

        where:
        label                  | currentText                             | currentParameter
        "cohorts template"     | 'div'                                   | "cohorts"
        "exomechip template"   | 'div'                                   | "exomechip"
        "people's template"    | 'div'                                   | "people"
        "project 1"            | 'div'                                   | "papers"

    }



}
