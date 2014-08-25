package dport

import org.codehaus.groovy.grails.commons.GrailsApplication

class HomeController {

    GrailsApplication grailsApplication

    def index = {
//        java.util.LinkedHashMap variableStrings = [:]
//         ["vars": variableStrings]
        render(view:'portalHome')
    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [])
    }


}
