package dport

class InformationalController {

    def index() {}
    def about (){
        render (view: 'about')
    }
    def contact (){
        render (view: 'contact')
    }
    def t2dgenes ()  {
        if (params)  {
            println "p=${params.sos}"
        }
        String t2dGenesSpecifics = 'cohorts'
        render (view: 't2dgenes', model:[specifics:t2dGenesSpecifics] )
    }
}
