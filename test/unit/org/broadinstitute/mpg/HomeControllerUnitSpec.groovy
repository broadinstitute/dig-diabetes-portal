package org.broadinstitute.mpg

import dig.diabetes.portal.NewsFeedService
import grails.plugin.mail.MailService
import grails.test.mixin.Mock
import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.broadinstitute.mpg.diabetes.bean.PortalVersionBean
import org.codehaus.groovy.grails.web.json.JSONObject
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(HomeController)
@Mock([HtmlTagLib])
class HomeControllerUnitSpec extends Specification {

    SharedToolsService sharedToolsService = new SharedToolsService()
    RestServerService restServerService = new RestServerService()
    MailService mailService = new MailService()

    def setup() {

    }

    def cleanup() {
    }

//    void "test index"() {
//        setup:
//        def newsFeedServiceMock = mockFor(NewsFeedService)
//        newsFeedServiceMock.demand.getCurrentPosts {String type -> return ([posts: []] as JSONObject)}
//        controller.newsFeedService = newsFeedServiceMock.createMock()
//        controller.sharedToolsService = sharedToolsService
//        controller.restServerService = restServerService
//
//        when:
//        sharedToolsService.metaClass.getApplicationIsT2dgenes = {->true}
//        sharedToolsService.metaClass.getSectionToDisplay = {unused->true}
//        restServerService.metaClass.retrieveBeanForAllPortals = {unused-> []}
//        restServerService.metaClass.retrieveBeanForCurrentPortal = {unused->null}
//        controller.index()
//
//        then:
//        response.status == 200
//
//        expect:
//        grailsApplication != null
//
//    }

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


//    void "test portalHome"() {
//        setup:
//        sharedToolsService.metaClass.getApplicationIsT2dgenes = {->true}
//        sharedToolsService.metaClass.getSectionToDisplay = {unused->true}
//        controller.sharedToolsService = sharedToolsService
//        restServerService.metaClass.retrieveBeanForAllPortals = {unused-> []}
//        restServerService.metaClass.retrieveBeanForCurrentPortal = {unused->null}
//        controller.restServerService = restServerService
//
//        def newsFeedServiceMock = mockFor(NewsFeedService)
//        newsFeedServiceMock.demand.getCurrentPosts {String type -> return ([posts: []] as JSONObject)}
//        controller.newsFeedService = newsFeedServiceMock.createMock()
//
//        when:
//        controller.portalHome()
//
//        then:
//        response.status == 200
//        view == '/home/portalHome'
//
//    }



    void "test empty message for beaconHome"() {
        when:
        controller.beaconHome()

        then:
        response.status == 200

    }



    void "test tutorials"() {
        when:
        controller.tutorials()

        then:
        response.status == 200

    }




}
