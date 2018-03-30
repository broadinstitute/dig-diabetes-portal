package org.broadinstitute.mpg

class GrsController {

    def index() {
        forward grsInfo()
    }


    def grsInfo(){
        render (view: 'grsInfo', model:[])
    }
}
