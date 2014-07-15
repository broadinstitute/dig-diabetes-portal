package dport

class InformationalController {

    def index() {}
    def about (){
        render (view: 'about')
    }
    def contact (){
        render (view: 'contact')
    }

}
