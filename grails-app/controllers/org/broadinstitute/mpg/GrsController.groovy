package org.broadinstitute.mpg

import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.codehaus.groovy.grails.web.json.JSONObject

class GrsController {
    RestServerService  restServerService

    def index() {
        forward grsInfo()
    }


    def grsInfo(){
        render (view: 'grsInfo', model:[])
    }

    def getGRSListOfVariantsAjax() {
        String grsName = params.grsName

        // TODO - eventually create new bean to hold all the options and have smarts for double checking validity
        List <String> variantList = restServerService.getGrsVariants()//grsName should be passed in

        if (variantList == null) {
            render(status: 200, contentType: "application/json"){variantInfo:{results:[]}}
            return
        }

        StringBuilder sb = new StringBuilder()
        List <String> recordPerVariants = []
        for (String varId in variantList){
            List <String> idPieces = varId.split("_")
            recordPerVariants << "{\"d\":1,\"dataset\":1,\"pVals\":[{\"count\":\"${idPieces[0]}\",\"level\":\"CHROM\"},"+
                                    "{\"count\":\"${idPieces[1]}\",\"level\":\"POS\"},"+
                                    "{\"count\":\"${idPieces[2]}\",\"level\":\"Reference_Allele\"},"+
                                    "{\"count\":\"${varId}\",\"level\":\"VAR_ID\"},"+
                                    "{\"count\":\"${idPieces[3]}\",\"level\":\"Effect_Allele\"}]}".toString()
        }

        JsonSlurper slurper = new JsonSlurper()
        String codedVariantList = """{"results":[${recordPerVariants.join(",")}]}""".toString()
        JSONObject sampleCallSpecifics = slurper.parseText(codedVariantList)

//        if (sampleCallSpecifics.results) {
//            for (Map result in sampleCallSpecifics.results){
//                for (Map pval in result.pVals){
//                    if ((pval.level == "Consequence")||
//                            (pval.level == "SIFT_PRED")||
//                            (pval.level == "PolyPhen_PRED")){
//                        List<String> consequenceList = pval.count.tokenize(",")
//                        List<String> translatedConsequenceList = []
//                        for (String consequence in consequenceList){
//                            translatedConsequenceList << g.message(code: "metadata." + consequence, default: consequence)
//                        }
//                        pval.count = translatedConsequenceList.join(", ")
//                    }
//                }
//            }
//        }

        // send json response back
        render(status: 200, contentType: "application/json") {sampleCallSpecifics}
    }

}
