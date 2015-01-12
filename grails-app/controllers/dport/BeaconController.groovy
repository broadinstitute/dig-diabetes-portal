package dport

class BeaconController {

    def index() {}

    def BeaconDisplay (){
        render (view: "beaconDisplay", model:[caller:0
        ])
    }
}
