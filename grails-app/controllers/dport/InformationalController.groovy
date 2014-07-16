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
        String defaultDisplay = 'cohorts'
        render (view: 't2dgenes', model:[specifics:defaultDisplay] )
    }
    def cohorts ()  {
        render (template: "cohorts" )
    }
    def papers ()  {
        render (template: "papers" )
    }
    def project1 ()  {
        render (template: "project1" )
    }
    def project2 ()  {
        render (template: "project2" )
    }
    def project3 ()  {
        render (template: "project3" )
    }
    def people ()  {
        render (template: "people" )
    }

}
