package dport.mgr

import dport.RestServerService
import  dport.SharedToolsService
import dport.people.User;
import temporary.BuildInfo;
import org.codehaus.groovy.grails.commons.GrailsApplication

class SystemController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    RestServerService restServerService


    def index = {
        render "<h1>hi</h1>"
    }

    def systemManager = {
        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
        currentApplicationIsSigma:sharedToolsService.applicationName()])
    }

    def determineVersion = {
        String jsonVersion  =  """
{"buildHost": "${BuildInfo?.buildHost}",
"buildTime":"${BuildInfo?.buildTime}",
"appVersion":"${BuildInfo?.appVersion}",
"buildNumber":"${BuildInfo?.buildNumber}"
}""".toString()
        render(status:200, contentType:"application/json") {
            [info:jsonVersion]
        }
      }



    def updateRestServer() {
        String restServer = params.datatype
        String currentServer =  restServerService.whatIsMyCurrentServer()
        if (restServer == 'mysql')  {
            if (!(currentServer == 'mysql')) {
                restServerService.goWithTheMysqlServer ()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        }  else  if (restServer == 'bigquery')  {
            if (!(currentServer == 'bigquery')) {
                restServerService.goWithTheBigQueryServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        }   else  if (restServer == 'testserver')  {
            if (!(currentServer == 'testserver')) {
                restServerService.goWithTheTestServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'devserver')  {
            if (!(currentServer == 'devserver')) {
                restServerService.goWithTheDevServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'qaserver')  {
            if (!(currentServer == 'qaserver')) {
                restServerService.goWithTheQaServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        } else  if (restServer == 'prodserver')  {
            if (!(currentServer == 'prodserver')) {
                restServerService.goWithTheProdServer()
                flash.message = "You are now using the ${restServer} server!"
            }  else {
                flash.message = "But you were already using the ${currentServer} server!"
            }
        }
        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName()])
    }

    def switchSigmaT2d(){
       // String restServer = params
        String requestedApplication = params.datatype
        if ( requestedApplication == 'sigma')  {
            sharedToolsService.setApplicationToSigma  ()
        }  else if  ( requestedApplication == 't2dgenes')  {
            sharedToolsService.setApplicationToT2dgenes  ()
        }   else {
            flash.message = "Internal error: you requested server = ${requestedApplication} which I do not recognize!"
        }

        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName()])
    }


    def switchApplicationToT2dgenes(){
        sharedToolsService.setApplicationToT2dgenes()
        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName()])
    }

}
