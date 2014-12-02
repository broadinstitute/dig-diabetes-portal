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

    def variantUpload() {
        log.debug "Received a request to upload a variant file"
        String variantFileContent
        if (params.myVariantFile){
            variantFileContent = sharedToolsService.convertMultipartFileToString(params.myVariantFile)
        }
//        if (params.myVariantFile){
//            org.springframework.web.multipart.commons.CommonsMultipartFile incomingFile = params.myVariantFile
//            if (incomingFile.empty) {
//                flash.message = 'file cannot be empty'
//                render(view: "dynamicBurdenTest")
//                return
//            }
//            StringBuilder sb = []
//            java.io.InputStream inputStream = incomingFile.getInputStream()
//            try {
//                int temp
//                while((temp=inputStream.read())!=-1)
//                {
//                    sb << ((char)temp).toString()
//                }
//            }catch (Exception ex){
//                log.error('Problem reading input file='+ex.toString()+'.')
//            }
//            log.debug('file content:'+sb.toString()+'.')
//        }
        log.info('file content:'+variantFileContent+'.')
        render(view: "dynamicBurdenTest")
    }


}
