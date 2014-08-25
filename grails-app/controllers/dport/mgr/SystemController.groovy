package dport.mgr

import  dport.SharedToolsService;

import org.codehaus.groovy.grails.commons.GrailsApplication

class SystemController {

    GrailsApplication grailsApplication
    SharedToolsService sharedToolsService


    def index = {
        render "<h1>hi</h1>"
    }

    def mgr = {
        render(view: 'system')
    }

}
