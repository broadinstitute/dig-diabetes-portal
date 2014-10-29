package dport

import org.springframework.web.servlet.support.RequestContextUtils



class InformationalController {

    def index() {}
    def about (){
        render (view: 'about')
    }
    def aboutSigma (){
        def locale = RequestContextUtils.getLocale(request)
        render (view:'sigma/homeHolder')

//        if (locale.language == 'en'){
//            render (view:'sigma/en/about')
//        }else if (locale.language == 'es'){
//            render (view:'sigma/es/about')
//        }

    }
    def contact (){
        render (view: 'contact')
    }
    def hgat (){
        render (view: 'hgat')
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

}
