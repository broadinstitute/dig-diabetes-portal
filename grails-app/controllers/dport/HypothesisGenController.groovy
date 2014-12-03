package dport

import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class HypothesisGenController {
    RestServerService   restServerService
    SharedToolsService sharedToolsService
    private static final log = LogFactory.getLog(this)

    def index() {}

    def dynamicBurdenTest (){
        render (view: "dynamicBurdenTest")
    }

    def burdenAjax() {
        String variantToStartWith = params.variant
        if (variantToStartWith)      {
            String testJson = """{
  "variants":["2_98709555_","2_98736047_","2_98737873_","2_98744752_"],
  "covariates": "N/A",
  "samples": "N/A",
  "filters": "N/A"
}""".toString()
            JSONObject jsonObject =  restServerService.postRestCallBurden (testJson.trim(), "variant")
            render(status:200, contentType:"application/json") {
                [variant:jsonObject]
            }
            return;
        }
    }
    def burdenForm() {
        String variantToStartWith = 1
        if (variantToStartWith)      {
            String testJson = """{
  "variants":["2_98709555_","2_98736047_","2_98737873_","2_98744752_"],
  "covariates": "N/A",
  "samples": "N/A",
  "filters": "N/A"
}""".toString()
            JSONObject jsonObject =  restServerService.postRestCallBurden (testJson.trim(), "variant")
            render(view: "dynamicBurdenTest", model:[jsonObject])

        }
        render (view: "dynamicBurdenTest")
    }

    /***
     * Starting with an explicit list of variants, extract what you need and display a page with results
     * @return
     */
    def variantUpload() {
        log.debug "Received a request to upload a variant file"
        if (params.explicitVariants){
            List<String> listOfVariants = sharedToolsService.convertStringToArray(params.explicitVariants)
            String drivingJson = sharedToolsService.createDistributedBurdenTestInput(listOfVariants)
            JSONObject jsonObject =  restServerService.postRestCallBurden (drivingJson, "variant")
            if (jsonObject){
                render(view: "dynamicBurdenTest", model:[jsonObject])
                return
            }
        }
        render(view: "dynamicBurdenTest")
    }

    /***
     * starting with a file, extract its contents, compose a rest query and display a page with results
     * @return
     */
    def variantFileUpload() {
        log.debug "Received a request to upload a variant file"
        if (params.myVariantFile){
            String variantFileContent = sharedToolsService.convertMultipartFileToString(params.myVariantFile)
            List<String> listOfVariants = sharedToolsService.convertMultilineToList(variantFileContent)
            String drivingJson = sharedToolsService.createDistributedBurdenTestInput(listOfVariants)
            JSONObject jsonObject =  restServerService.postRestCallBurden (drivingJson, "variant")
            if (jsonObject){
                render(view: "dynamicBurdenTest", model:[jsonObject])
                return
            }
        }
        render(view: "dynamicBurdenTest")
    }


}
