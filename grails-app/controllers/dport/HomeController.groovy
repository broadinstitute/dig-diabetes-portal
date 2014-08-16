package dport

import org.codehaus.groovy.grails.commons.GrailsApplication

class HomeController {

    GrailsApplication grailsApplication

    def index = {
        // currently not used, but I think the 'you are not logged in screen' will be served here eventually
        java.util.LinkedHashMap variableStrings = [:]
         ["vars": variableStrings]
    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [])
    }


}
