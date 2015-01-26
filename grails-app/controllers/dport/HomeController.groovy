package dport

import org.codehaus.groovy.grails.commons.GrailsApplication
import org.apache.juli.logging.LogFactory
import temporary.BuildInfo

class HomeController {
    private static final log = LogFactory.getLog(this)
    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    def mailService

    def index = {
        render(view:'portalHome')
    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                                               show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                                               show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                                               show_sigma:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma)])
    }

    def versionNumber = {
        String version = """{"host":"${BuildInfo?.buildHost}",
"time":"${BuildInfo?.buildTime}",
"appVersion":"${BuildInfo?.appVersion}",
"buildNumber":"${BuildInfo?.buildNumber}",
}""".toString()
        render(status:200, contentType:"application/json") {
            [info:version]
        }
    }


    def beaconHome = {
        render(view: 'beaconDisplay')
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
