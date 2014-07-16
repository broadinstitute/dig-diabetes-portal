package dport

class InformationalController {

    def index() {}
    def about (){
        render (view: 'about')
    }
    def contact (){
        render (view: 'contact')
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

}
