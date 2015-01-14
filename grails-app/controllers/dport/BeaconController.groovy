package dport

import org.codehaus.groovy.grails.web.json.JSONObject

class BeaconController {

    def index() {}

    def BeaconDisplay (){
        render (view: "beaconDisplay", model:[caller:0
        ])
    }

    def beaconVariantQueryAjax() {
        println params
        String variantToStartWith = params.variants
        String decodedVariants = URLDecoder.decode(variantToStartWith, "UTF-8");
//        if (decodedVariants)      {
//            Lis<String> listOfVariants = sharedToolsService.convertStringToArray(decodedVariants)
//            String drivingJson = sharedToolsService.createDistributedBurdenTestInput(listOfVariants)
//            JSONObject jsonObject =  restServerService.postRestCallBurden (drivingJson, "variant")
//            if (jsonObject){
//                render(status: 200, contentType: "application/json") {
//                    [burdenTestResults: jsonObject]
//                }
//                return
//            }
//        }
//
        // new stuff
        JSONObject jsonObject
        if (decodedVariants)      {
            List<String> variantsInListForm = sharedToolsService.convertStringToArray(decodedVariants)
            String variantsInStringForm = sharedToolsService.convertListToString(variantsInListForm)
            jsonObject =  restServerService.retrieveVariantInfoByName_Experimental ("[" +variantsInStringForm+ "]")
            render(status:200, contentType:"application/json") {
                [variants:jsonObject['variant-info']]
            }
            return
        }

        return
    }
}
