package dport.mgr

import dport.RestServerService
import  dport.SharedToolsService
import dport.people.User;
import org.codehaus.groovy.grails.commons.GrailsApplication

class SystemController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService
    RestServerService restServerService


    def index = {
        render "<h1>hi</h1>"
    }

    def systemManager = {
        render(view: 'systemMgr', model: [])
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
        }
        render(view: 'systemMgr', model: [])
    }

}
