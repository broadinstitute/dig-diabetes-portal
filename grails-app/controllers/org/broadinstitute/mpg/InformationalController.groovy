package org.broadinstitute.mpg

import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.servlet.support.RequestContextUtils



class  InformationalController {
    RestServerService restServerService

    def index() {}
    def about (){
        String locale = RequestContextUtils.getLocale(request)
        render (view: 'about', model:[locale:locale])
    }
    def aboutBeacon (){
        render (view: 'aboutBeacon')
    }
    def aboutSigma (){
        String defaultDisplay = 'about'
        render (view:'homeHolder', model:[specifics:defaultDisplay])
    }


    // subsidiary pages for  contact
    def aboutSigmaSection(){
        render (template: "sigma/${params.id}" )
    }


    /***
     * Get the contents for the filter drop-down box on the burden test section of the gene info page
     * @return
     */
    def aboutTheDataAjax() {
        String metadataVersion = params.metadataVersion
        String technology = params.technology
        JSONObject jsonObject = restServerService.extractDataSetHierarchy(metadataVersion, technology)

        // send json response back
        render(status: 200, contentType: "application/json") {jsonObject}
    }





//    def contact (){
//        render (view: 'contact')
//    }
    def contactBeacon (){
        render (view: 'contactBeacon')
    }
    def hgat (){
        render (view: 'hgat')
    }
    def ashg (){
        forward(action:'blog')
    }
    def ASHG (){
        forward(action:'blog')
    }

    // the root page for t2dgenes.  This page recruits underlying pages via Ajax calls
    def t2dgenes ()  {
        String defaultDisplay = 'cohorts'
        render (view: 't2dgenes', model:[specifics:defaultDisplay] )
    }
    // subsidiary pages for  t2dgenes
    def t2dgenesection(){
        render (template: "t2dsection/${params.id}" )
    }

    // the root page for got2d.  This page recruits underlying pages via Ajax calls
    def got2d()  {
        String defaultDisplay = 'cohorts'
        render (view: 'got2d', model:[specifics:defaultDisplay] )
    }
    // subsidiary pages for  got2d
    def got2dsection(){
        render (template: "got2dsection/${params.id}" )
    }


    // the AMP ddata sharing policy.  We want a PDF to show up in the user's browser, live if possible, otherwise is download
    def sharingPolicy()  {
            String fileLocation = grailsApplication.mainContext.getResource("/WEB-INF/resources/AMP_KP_DAT_incoming.pdf").file.toString()
            File file = new File(fileLocation)
            response.contentType = "application/pdf"
            response.outputStream << file.getBytes()
            response.outputStream.flush()
    }

    // the root page for contact.  This page recruits underlying pages via Ajax calls
    def contact()  {
        String defaultDisplay = 'consortium'
        render (view: 'contact', model:[specifics:defaultDisplay] )
    }
    // subsidiary pages for  contact
    def contactsection(){
        render (template: "contact/${params.id}" )
    }

    def forum(){
        render (view: "forum" )
    }

    def blog(){
        render (view: "blog" )
    }


    // the root page for contact.  This page recruits underlying pages via Ajax calls
    def policies()  {
        String defaultDisplay = 'dataUse'
        render (view: 'policies', model:[specifics:defaultDisplay] )
    }
    // subsidiary pages for  contact
    def policiessection(){
        render (template: "policies/${params.id}" )
    }



}
