package org.broadinstitute.mpg


import groovy.json.JsonSlurper
import org.broadinstitute.mpg.diabetes.util.PortalConstants
import org.broadinstitute.mpg.meta.UserQueryContext
import org.codehaus.groovy.grails.web.json.JSONObject

class GaitController {
    RestServerService  restServerService
    WidgetService widgetService

    def index() {
        forward gaitInfo()
    }

    def gaitInfo(){
        String uncharacterizedString = params.id
        UserQueryContext userQueryContext = widgetService.generateUserQueryContext(uncharacterizedString)
        if (userQueryContext.gene){
            render (view: 'gaitInfo', model:[geneName: userQueryContext.originalRequest,allowExperimentChoice: false, allowPhenotypeChoice: true, allowStratificationChoice: true ])
        }
        if (userQueryContext.variant){
            render (view: 'gaitInfo', model:[variantIdentifier: userQueryContext.originalRequest, variantSetId: userQueryContext.originalRequest,allowExperimentChoice: true, allowPhenotypeChoice: true, allowStratificationChoice: false])
        }


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

        // send json response back
        render(status: 200, contentType: "application/json") {sampleCallSpecifics}
    }

}
