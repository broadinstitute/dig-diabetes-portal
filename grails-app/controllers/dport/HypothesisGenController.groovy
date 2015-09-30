package dport

import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject
import java.net.URLDecoder;

class HypothesisGenController {
    RestServerService   restServerService
    SharedToolsService sharedToolsService
    FilterManagementService filterManagementService

    private static final log = LogFactory.getLog(this)

    def index() {}

    def dynamicBurdenTest (){
        render (view: "dynamicBurdenTest", model:[caller:0,
                                                  show_gene           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gene),
                                                  show_gwas           : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_gwas),
                                                  show_exchp          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exchp),
                                                  show_exseq          : sharedToolsService.getSectionToDisplay(SharedToolsService.TypeOfSection.show_exseq),
        ])
    }

    def burdenAjax() {
        String variantToStartWith = params.variants
        String decodedVariants = URLDecoder.decode(variantToStartWith, "UTF-8");
        if (decodedVariants)      {
            List<String> listOfVariants = sharedToolsService.convertStringToArray(decodedVariants)
            String drivingJson = sharedToolsService.createDistributedBurdenTestInput(listOfVariants)
            JSONObject jsonObject =  restServerService.postRestCallBurden (drivingJson, "variant")
            if (jsonObject){
                render(status: 200, contentType: "application/json") {
                    [burdenTestResults: jsonObject]
                }
                return
            }
        }
        return
    }
    def burdenForm() {
        String variantToStartWith = 1
        if (variantToStartWith)      {
            String testJson = """{
  "variants":["2_98709555_","2_98736047_","2_98737873_","2_98744752_"],
  "covariates": [],
  "samples": []
}""".toString()
            JSONObject jsonObject =  restServerService.postRestCallBurden (testJson.trim(), "variant")
            render(view: "dynamicBurdenTest", model:[jsonObject])

        }
        render (view: "dynamicBurdenTest")
    }




    def developListOfVariants() {
            Map paramsMap = new HashMap()

            params.each { key, value ->
                paramsMap.put(key, value)
            }
            if (paramsMap) {
                buildVariantListRequest(paramsMap)
            }

    }




    /***
     * Starting with an explicit list of variants, extract what you need and display a page with results
     * @return
     */
    def variantUpload() {
        log.debug "Received a request to upload a variant file"
        if (params.explicitVariants){
            List<String> listOfVariants = sharedToolsService.convertStringToArray(params.explicitVariants)
            buildVariantListRequest([:], listOfVariants)
            return;
        }
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
            buildVariantListRequest([:], listOfVariants)
            return;
        }
    }


    def variantSearch() {
        log.debug "Received a request to search for variant"
        Map paramsMap = new HashMap()

        params.each { key, value ->
            paramsMap.put(key, value)
        }
        if (paramsMap) {
            buildVariantListRequest(paramsMap,[])
        }
    }





}
