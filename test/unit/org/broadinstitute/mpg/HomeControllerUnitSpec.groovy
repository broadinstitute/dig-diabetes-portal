package org.broadinstitute.mpg

import grails.plugin.mail.MailService
import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(HomeController)
class HomeControllerUnitSpec extends Specification {

    SharedToolsService sharedToolsService = new SharedToolsService()
    MailService mailService = new MailService()

    def setup() {

    }

    def cleanup() {
    }

    void "test index"() {
        setup:
        controller.sharedToolsService = sharedToolsService

        when:
        sharedToolsService.metaClass.getApplicationIsT2dgenes = {->true}
        sharedToolsService.metaClass.getSectionToDisplay = {unused->true}
        controller.index()

        then:
        response.status == 200

        expect:
        grailsApplication != null

    }

    void "test index for beacon"() {
        setup:
        controller.sharedToolsService = sharedToolsService

        when:
        sharedToolsService.metaClass.getApplicationIsT2dgenes = {->false}
        sharedToolsService.metaClass.getApplicationIsBeacon = {->true}
        sharedToolsService.metaClass.getSectionToDisplay = {unused->true}
        controller.index()

        then:
        response.status == 302

    }


    void "test portalHome"() {
        setup:
        sharedToolsService.metaClass.getApplicationIsT2dgenes = {->true}
        sharedToolsService.metaClass.getSectionToDisplay = {unused->true}
        controller.sharedToolsService = sharedToolsService

        when:
        controller.portalHome()

        then:
        response.status == 200
        view == '/home/portalHome'

    }



    void "test empty message for beaconHome"() {
        when:
        controller.beaconHome()

        then:
        response.status == 200

    }



    void "test introVideoHolder"() {
        when:
        controller.introVideoHolder()

        then:
        response.status == 200

    }




}
