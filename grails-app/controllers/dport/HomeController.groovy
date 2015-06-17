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
        if  ((sharedToolsService.getApplicationIsT2dgenes()) ||
                (sharedToolsService.getApplicationIsSigma())) {
            render(view:'portalHome', model: [ticker:"${sharedToolsService.getWarningText()}",
                                              show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                              show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                              show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                              show_sigma:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma),
                                              newApi              : sharedToolsService.getNewApi()])
        }  else if (sharedToolsService.getApplicationIsBeacon()) {
            redirect(controller:'beacon', action:'beaconDisplay')
        } else {
            log.error ">>>>> Critical internal error!  The application was set to something other than T2dgenes, Sigma, or Beacon.  No home page possible.  <<<<<"
        }

    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [ticker:"${sharedToolsService.getWarningText()}",
                                                               show_gwas:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_gwas),
                                                               show_exchp:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exchp),
                                                               show_exseq:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_exseq),
                                                               show_sigma:sharedToolsService.getSectionToDisplay (SharedToolsService.TypeOfSection.show_sigma),
                                                               newApi              : sharedToolsService.getNewApi()])
    }
    def signAContract = {
        render(controller: 'home', view: 'signAContract')
    }

    def introVideoHolder = {
        render(controller: 'home', view: 'introVideoHolder')
    }


    def analyticsT2d = {
        render "<h1>t2danaltics</h1>"
    }

    def analyticsSigma = {
        render "<h1>sigma</h1>"
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
