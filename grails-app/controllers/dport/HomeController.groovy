package dport

import org.codehaus.groovy.grails.commons.GrailsApplication
import org.apache.juli.logging.LogFactory

class HomeController {
    private static final log = LogFactory.getLog(this)
    GrailsApplication grailsApplication
    def mailService

    def index = {
        render(view:'portalHome')
    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [])
    }
    def setEnglish = {
        render(controller: 'home', view: 'portalHome', model: [])
    }
    def setEspanol = {
        render(controller: 'home', view: 'portalHome', model: [])
    }
    def errorReporter = {
        String errorText = params['errorText']
        log.debug "*** Received error from client reporter. text=${errorText}"
        mailService.sendMail {
            from "t2dPortal@gmail.com"
            to "${grailsApplication.config.site.operator}"
            subject "Error report"
            body "${errorText}"
        }
        render(status: 200)
    }

}
