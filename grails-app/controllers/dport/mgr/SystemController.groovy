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
        currentApplicationIsSigma:sharedToolsService.applicationName(),
        helpTextLevel:sharedToolsService.getHelpTextSetting()])
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




    def updateHelpTextLevel() {
        String helpTextSetting = params.datatype
        int currentHelpTextSetting = sharedToolsService.getHelpTextSetting ()
        if (helpTextSetting == 'none') {
            if (!(currentHelpTextSetting == 0)) {
                sharedToolsService.setHelpTextSetting(0)
                flash.message = "You have now turned off all help text"
            } else {
                flash.message = "But you had already turned off all help text!"
            }
        } else if (helpTextSetting == 'conditional') {
            if (!(currentHelpTextSetting == 1)) {
                sharedToolsService.setHelpTextSetting(1)
                flash.message = "Help text will now appear only if messages exist to be displayed"
            } else {
                flash.message = "But you had already set the help text to conditional display!"
            }
        } else if (helpTextSetting == 'always') {
            if (!(currentHelpTextSetting == 2)) {
                sharedToolsService.setHelpTextSetting(2)
                flash.message = "Help text question marks will now always appear, even if we don't have text to back them up"
            } else {
                flash.message = "But you had already set the help text to always display!"
            }
        }
        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting()])
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
        } else  if (restServer == 'newdevserver')  {
            if (!(currentServer == 'newdevserver')) {
                restServerService.goWithTheNewDevServer()
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
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting()])
    }

    def switchSigmaT2d(){
       // String restServer = params
        String requestedApplication = params.datatype
        if ( requestedApplication == 'sigma')  {
            sharedToolsService.setApplicationToSigma  ()
            redirect(controller:'home', action:'index')
            return
        }  else if  ( requestedApplication == 't2dgenes')  {
            sharedToolsService.setApplicationToT2dgenes  ()
            redirect(controller:'home', action:'index')
            return
        }  else if  ( requestedApplication == 'beacon')  {
            sharedToolsService.setApplicationToBeacon  ()
            redirect(controller:'beacon', action:'beaconDisplay')
            return
        }   else {
            flash.message = "Internal error: you requested server = ${requestedApplication} which I do not recognize!"
        }

        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting()])
    }


    def switchApplicationToT2dgenes(){
        sharedToolsService.setApplicationToT2dgenes()
        render(view: 'systemMgr', model: [currentRestServer:restServerService.currentRestServer(),
                                          currentApplicationIsSigma:sharedToolsService.applicationName(),
                                          helpTextLevel:sharedToolsService.getHelpTextSetting()])
    }

}
