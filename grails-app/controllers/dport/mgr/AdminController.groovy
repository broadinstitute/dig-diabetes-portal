package dport.mgr

import  dport.SharedToolsService;

import org.codehaus.groovy.grails.commons.GrailsApplication

class AdminController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService


    def index = {
        java.util.LinkedHashMap variableStrings = [:]
        ["vars": variableStrings]
    }

    def users = {
        String encodedUsers = sharedToolsService.urlEncodedListOfUsers()

        render(view: 'users', model: [encodedUsers:encodedUsers])
    }

}
