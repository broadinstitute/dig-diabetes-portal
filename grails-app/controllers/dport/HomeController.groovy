package dport

import org.codehaus.groovy.grails.commons.GrailsApplication

class HomeController {

    GrailsApplication grailsApplication

    def index = {
        java.util.LinkedHashMap variableStrings = [:]
//        String siteVersion =   't2dgenes'   // 'sigma'
        if (grailsApplication.config.site.version == 't2dgenes') {
//            if (siteVersion == 't2dgenes') {
            variableStrings["siteVersion"]  = 't2dgenes'
            variableStrings["siteTitle"]  = 'Type 2 Diabetes Genetics'
            variableStrings["fromEmail"]  = '"type2diabetesgenetics.org" <noreply@type2diabetesgenetics.org>'
            variableStrings["languageCode"]  = 'en'
        }   else if (grailsApplication.config.site.version == 'sigma') {
            variableStrings["siteVersion"]  = 'sigma'
            variableStrings["siteTitle"]  = 'SIGMA T2D'
            variableStrings["fromEmail"]  = '"type2diabetesgenetics.org" <noreply@type2diabetesgenetics.org>'
            variableStrings["titleString"]  = 'es'
        }  else {
            assert('bad SITE_VERSION')
        }
        ["vars": variableStrings]
    }

    def root = {
        render(template: 'portalHomeContent', model: [])
    }

    def portalHome = {
        render(controller: 'home', view: 'portalHome', model: [])
    }


}
