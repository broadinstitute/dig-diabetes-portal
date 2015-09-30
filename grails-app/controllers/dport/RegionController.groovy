package dport

import grails.plugin.springsecurity.annotation.Secured
import org.apache.juli.logging.LogFactory
import org.codehaus.groovy.grails.web.json.JSONObject

class RegionController {

    RestServerService   restServerService
    SharedToolsService sharedToolsService

    /***
     * This is where we go to process a region.
     * @return
     */
    def regionInfo() {
        String regionSpecification = params.id
        LinkedHashMap extractedNumbers =  restServerService.extractNumbersWeNeed(regionSpecification)
        List <Gene> identifiedGenes = []
        if ((extractedNumbers)   &&
                (extractedNumbers["startExtent"])   &&
                (extractedNumbers["endExtent"])&&
                (extractedNumbers["chromosomeNumber"]) ){
            boolean encounteredErrors = false
            Long  startExtent  = sharedToolsService.convertRegionString(extractedNumbers["startExtent"])
            Long  endExtent  = sharedToolsService.convertRegionString(extractedNumbers["endExtent"])
            if ((startExtent<0) ||(endExtent<0)) {
                encounteredErrors = true
            }
            if (!encounteredErrors){
                String searchParms = "8=${extractedNumbers["chromosomeNumber"]}^9=${startExtent}^10=${endExtent}^17=T2D[GWAS_DIAGRAM_mdv2]P_VALUE<1^".toString()
                redirect(controller:'variantSearch',action:'launchAVariantSearch', params: [savedValue0: searchParms])
                return
            }

        }

        redirect(controller: 'home', action: 'portalHome') //   We should never get here, but in case the previous parsing fails
        return
    }


}
