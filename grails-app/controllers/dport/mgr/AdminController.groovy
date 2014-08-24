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

       // defines a new password?
//    def springSecurityService
//
//    def updateAction() {
//        def person = Person.get(params.id)
//
//        params.salt = person.salt
//        if (person.password != params.password) {
//            params.password = springSecurityService.encodePassword(password, salt)
//            def salt = … // e.g. randomly generated using some utility method
//            params.salt = salt
//        }
//        person.properties = params
//        if (!person.save(flush: true)) {
//            render view: 'edit', model: [person: person]
//            return
//        }
//        redirect action: 'show', id: person.id
//    }

}
